from dataclasses import dataclass
from enum import Enum
from pathlib import Path
from typing import List, Union

import click
import mido

TICKS_PER_BEAT = 480
# TIME_SIG = (3, 4)
# INSERT_ZERO = 480
SEP = None

NOTE_NAME = ['1', '#1', '2', '#2', '3', '4', '#4', '5', '#5', '6', '#6', '7']


BEAT4 = TICKS_PER_BEAT
BEAT8 = TICKS_PER_BEAT // 2
BEAT16 = TICKS_PER_BEAT // 4


class NoteTimeValue(Enum):
    CROTCHET = ''
    QUAVER = 'q'
    SEMIQUAVER = 's'


@dataclass
class Note:
    tone: int
    length: int
    time: NoteTimeValue
    dotted: int = 0
    dash: int = 0
    slur: str = ''

    def __repr__(self) -> str:
        offset, index = (
            ((self.tone - 60) // 12, (self.tone - 60) % 12)
            if self.tone != 0
            else (0, None)
        )

        oct = abs(offset) * ("'" if offset > 0 else ',')
        note_name = NOTE_NAME[index] if index is not None else '0'

        res = (
            self.time.value
            + note_name
            + oct
            + ('.' * self.dotted)
            + (f' {self.slur}' if self.tone != 0 and self.slur else '')
            + (' -' * self.dash)
        )

        if note_name == '0':
            res = res.replace('-', '0').replace('(', '').replace(')', '')

        return res


class NoteGroup:
    def __init__(self, notes: List[Union[Note, 'NoteGroup']]) -> None:
        self.notes = []
        for note in notes:
            if isinstance(note, NoteGroup):
                self.notes.extend(note.notes)
            else:
                self.notes.append(note)
        self.set_slurs()

    def set_slurs(self):
        if len(self.notes) < 2:
            return
        self.notes[0].slur = '('
        self.notes[-1].slur = ')'
        for note in self.notes[1:-1]:
            note.slur = ''

    def __repr__(self) -> str:
        return ' '.join([str(i) for i in self.notes])


def process_message(tone: int, length: int, limit: int = None):
    if limit is not None and length > limit:
        return NoteGroup(
            [
                process_message(tone, limit),
                process_message(tone, length - limit, SEP),
            ]
        )

    if length == 0:
        return NoteGroup([])
    assert length % BEAT16 == 0
    dotted = 0
    match length // BEAT16:
        case 1:
            time = NoteTimeValue.SEMIQUAVER
        case 2:
            time = NoteTimeValue.QUAVER
        case 3:
            time = NoteTimeValue.QUAVER
            dotted = 1
        case 4:
            time = NoteTimeValue.CROTCHET
        case 5:
            return NoteGroup(
                [process_message(tone, BEAT4), process_message(tone, BEAT16)]
            )
        case 6:
            time = NoteTimeValue.CROTCHET
            dotted = 1
        case 7:
            # jianpu-ly 貌似不支持多个附点音符
            return NoteGroup(
                [
                    process_message(tone, BEAT4 + BEAT8),
                    process_message(tone, BEAT16),
                ]
            )
            # time = NoteTimeValue.CROTCHET
            # dotted = 2
        case _:  # val >= 8
            extra = length % BEAT4
            dash = (length - extra) // BEAT4 - 1
            n = process_message(tone, BEAT4 + extra)
            if isinstance(n, NoteGroup):
                n.notes[0].dash = dash
                n.notes[0].length += dash * BEAT4
                assert sum([i.length for i in n.notes]) == length
            else:
                n.dash = dash
                n.length += dash * BEAT4
            # n.dash = dash
            # n.length += dash * BEAT4
            return n

    return Note(tone, length, time, dotted)


# track
# t = 0
# for note in NoteGroup(track).notes:
#     print(note)
#     t += note.length
#     if t == SEP:
#         print('------')
#         t = 0
#         continue
#     if t > SEP:
#         raise

# from pyperclip import copy
# copy(' '.join(str(i) for i in NoteGroup(track).notes))


@click.command()
@click.argument(
    'midi_path', type=click.Path(exists=True, dir_okay=False, path_type=Path)
)
@click.option('--title', '-t', type=str, default='Default Title')
@click.option('--author', '-a', type=str, default='Default Author')
@click.option('--sig', '-s', type=str, default=None, help='formats like 4/4')
@click.option('--bpm', '-b', type=str, default=None)
@click.option(
    '--insert-zero',
    '-z',
    type=int,
    default=0,
    help='By default, the initial empty time will be dropped, you can add it manually, input 4 for a beat',
)
def main(
    midi_path: Path,
    title: str,
    author: str,
    bpm: str | None,
    sig: str | None,
    insert_zero: int,
):
    global SEP
    midi = mido.MidiFile(midi_path)
    assert midi.ticks_per_beat == TICKS_PER_BEAT

    if sig is not None:
        assert sig[1] == '/'
        TIME_SIG = (int(sig[0]), int(sig[2]))
    else:
        for m in midi.tracks[0]:
            if m.type == 'time_signature':
                TIME_SIG = (m.numerator, m.denominator)
                break
        else:
            raise Exception('no time signature')

    match TIME_SIG[1]:
        case 4:
            SEP = BEAT4 * TIME_SIG[0]
        case 8:
            SEP = BEAT8 * TIME_SIG[0]
        case 16:
            SEP = BEAT16 * TIME_SIG[0]
        case _:
            raise

    if bpm is None:
        for m in midi.tracks[0]:
            if m.type == 'set_tempo':
                bpm = int(mido.tempo2bpm(m.tempo, TIME_SIG))
                break
        else:
            raise Exception('no tempo')

    track = []

    sep = -insert_zero * 120
    for i in range(len(midi.tracks[0]) - 2):
        msg1: mido.messages.messages.Message = midi.tracks[0][i]
        msg2: mido.messages.messages.Message = midi.tracks[0][i + 1]
        note_time: int = msg2.time
        note_type: str = msg1.type
        if note_type != 'note_on':
            continue
        if note_time < BEAT16:
            continue
        if msg1.velocity == 0:
            msg1.note = 0

        left_time = (sep - BEAT16) % SEP + BEAT16
        track.append(process_message(msg1.note, note_time, left_time))
        sep -= note_time
    track.insert(0, process_message(0, insert_zero, SEP))
    track.append(process_message(0, (sep - BEAT16) % SEP + BEAT16, SEP))

    res = []
    for note in track:
        if isinstance(note, NoteGroup):
            for i in note.notes:
                res.append(str(i))
        else:
            res.append(note)
    res_out = '\n'.join(
        [
            f'%% tempo: 4={bpm}',
            f'title={title}',
            f'arranger={author}',
            '1=C',
            f'{TIME_SIG[0]}/{TIME_SIG[1]}',
        ]
    )
    res_out += '\n\n' + ' '.join(str(i) for i in res)
    click.echo(res_out)


if __name__ == '__main__':
    main()
