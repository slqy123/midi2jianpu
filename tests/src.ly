\version "2.18.0"
#(set-global-staff-size 20)

% un-comment the next line to remove Lilypond tagline:
% \header { tagline="" }

\pointAndClickOff

\paper {
  print-all-headers = ##t %% allow per-score headers

  % un-comment the next line for A5:
  % #(set-default-paper-size "a5" )

  % un-comment the next line for no page numbers:
  % print-page-number = ##f

  % un-comment the next 3 lines for a binding edge:
  % two-sided = ##t
  % inner-margin = 20\mm
  % outer-margin = 10\mm

  % un-comment the next line for a more space-saving header layout:
  % scoreTitleMarkup = \markup { \center-column { \fill-line { \magnify #1.5 { \bold { \fromproperty #'header:dedication } } \magnify #1.5 { \bold { \fromproperty #'header:title } } \fromproperty #'header:composer } \fill-line { \fromproperty #'header:instrument \fromproperty #'header:subtitle \smaller{\fromproperty #'header:subsubtitle } } } }
}

\score {
<< \override Score.BarNumber.break-visibility = #center-visible
\override Score.BarNumber.Y-offset = -1
\set Score.barNumberVisibility = #(every-nth-bar-number-visible 5)

%% === BEGIN JIANPU STAFF ===
    \new RhythmicStaff \with {
    \consists "Accidental_engraver" 
    %% Get rid of the stave but not the barlines:
    \override StaffSymbol.line-count = #0 %% tested in 2.15.40, 2.16.2, 2.18.0, 2.18.2, 2.20.0 and 2.22.2
    \override BarLine.bar-extent = #'(-2 . 2) %% LilyPond 2.18: please make barlines as high as the time signature even though we're on a RhythmicStaff (2.16 and 2.15 don't need this although its presence doesn't hurt; Issue 3685 seems to indicate they'll fix it post-2.18)
    }
    { \new Voice="W" {

    \override Beam.transparent = ##f % (needed for LilyPond 2.18 or the above switch will also hide beams)
    \override Stem.direction = #DOWN
    \override Tie.staff-position = #2.5
    \tupletUp

    \override Stem.length-fraction = #0
    \override Beam.beam-thickness = #0.1
    \override Beam.length-fraction = #0.5
    \override Voice.Rest.style = #'neomensural % this size tends to line up better (we'll override the appearance anyway)
    \override Accidental.font-size = #-4
    \override TupletBracket.bracket-visibility = ##t
\set Voice.chordChanges = ##t %% 2.19 bug workaround

    \override Staff.TimeSignature.style = #'numbered
    \override Staff.Stem.transparent = ##t
     \tempo 4=204 \mark \markup{1=C} \time 4/4 #(define (note-nought grob grob-origin context)
  (if (and (eq? (ly:context-property context 'chordChanges) #t)
      (or (grob::has-interface grob 'note-head-interface)
        (grob::has-interface grob 'rest-interface)))
    (begin
      (ly:grob-set-property! grob 'stencil
        (grob-interpret-markup grob
          (make-lower-markup 0.5 (make-bold-markup "0")))))))
  \applyOutput #'Voice #note-nought r4
  \applyOutput #'Voice #note-nought r4   \applyOutput #'Voice #note-nought r4 #(define (note-seven grob grob-origin context)
  (if (and (eq? (ly:context-property context 'chordChanges) #t)
      (or (grob::has-interface grob 'note-head-interface)
        (grob::has-interface grob 'rest-interface)))
    (begin
      (ly:grob-set-property! grob 'stencil
        (grob-interpret-markup grob
          (make-lower-markup 0.5 (make-bold-markup "7")))))))
  \applyOutput #'Voice #note-seven b4-\tweak #'Y-offset #-1.2 -\tweak #'X-offset #0.6 _.
| %{ bar 2: %}
  \applyOutput #'Voice #note-seven b4-\tweak #'Y-offset #-1.2 -\tweak #'X-offset #0.6 _.
\once \override Tie.transparent = ##t \once \override Tie.staff-position = #0 #(define (note-four grob grob-origin context)
  (if (and (eq? (ly:context-property context 'chordChanges) #t)
      (or (grob::has-interface grob 'note-head-interface)
        (grob::has-interface grob 'rest-interface)))
    (begin
      (ly:grob-set-property! grob 'stencil
        (grob-interpret-markup grob
          (make-lower-markup 0.5 (make-bold-markup "4")))))))
  \applyOutput #'Voice #note-four fis'4
 ~ #(define (note-dashfour grob grob-origin context)
  (if (and (eq? (ly:context-property context 'chordChanges) #t)
      (or (grob::has-interface grob 'note-head-interface)
        (grob::has-interface grob 'rest-interface)))
    (begin
      (ly:grob-set-property! grob 'stencil
        (grob-interpret-markup grob
          (make-lower-markup 0.5 (make-bold-markup "–")))))))
  \applyOutput #'Voice #note-dashfour fis'4
#(define (note-three grob grob-origin context)
  (if (and (eq? (ly:context-property context 'chordChanges) #t)
      (or (grob::has-interface grob 'note-head-interface)
        (grob::has-interface grob 'rest-interface)))
    (begin
      (ly:grob-set-property! grob 'stencil
        (grob-interpret-markup grob
          (make-lower-markup 0.5 (make-bold-markup "3")))))))
  \applyOutput #'Voice #note-three e'4
| %{ bar 3: %}
  \applyOutput #'Voice #note-three e'4
\once \override Tie.transparent = ##t \once \override Tie.staff-position = #0   \applyOutput #'Voice #note-four fis'4
 ~   \applyOutput #'Voice #note-dashfour fis'4 #(define (note-five grob grob-origin context)
  (if (and (eq? (ly:context-property context 'chordChanges) #t)
      (or (grob::has-interface grob 'note-head-interface)
        (grob::has-interface grob 'rest-interface)))
    (begin
      (ly:grob-set-property! grob 'stencil
        (grob-interpret-markup grob
          (make-lower-markup 0.5 (make-bold-markup "5")))))))
  \applyOutput #'Voice #note-five g'4
\once \override Tie.transparent = ##t \once \override Tie.staff-position = #0 | %{ bar 4: %}
  \applyOutput #'Voice #note-seven b4-\tweak #'Y-offset #-1.2 -\tweak #'X-offset #0.6 _.
 ~ \once \override Tie.transparent = ##t \once \override Tie.staff-position = #0 #(define (note-dashseven grob grob-origin context)
  (if (and (eq? (ly:context-property context 'chordChanges) #t)
      (or (grob::has-interface grob 'note-head-interface)
        (grob::has-interface grob 'rest-interface)))
    (begin
      (ly:grob-set-property! grob 'stencil
        (grob-interpret-markup grob
          (make-lower-markup 0.5 (make-bold-markup "–")))))))
  \applyOutput #'Voice #note-dashseven b4
 ~ \once \override Tie.transparent = ##t \once \override Tie.staff-position = #0   \applyOutput #'Voice #note-dashseven b4
 ~   \applyOutput #'Voice #note-dashseven b4 | %{ bar 5: %}
  \applyOutput #'Voice #note-nought r4
  \applyOutput #'Voice #note-nought r4   \applyOutput #'Voice #note-nought r4   \applyOutput #'Voice #note-seven b4-\tweak #'Y-offset #-1.2 -\tweak #'X-offset #0.6 _.
#(define (note-two grob grob-origin context)
  (if (and (eq? (ly:context-property context 'chordChanges) #t)
      (or (grob::has-interface grob 'note-head-interface)
        (grob::has-interface grob 'rest-interface)))
    (begin
      (ly:grob-set-property! grob 'stencil
        (grob-interpret-markup grob
          (make-lower-markup 0.5 (make-bold-markup "2")))))))
| %{ bar 6: %}
  \applyOutput #'Voice #note-two d'4
#(define (note-one grob grob-origin context)
  (if (and (eq? (ly:context-property context 'chordChanges) #t)
      (or (grob::has-interface grob 'note-head-interface)
        (grob::has-interface grob 'rest-interface)))
    (begin
      (ly:grob-set-property! grob 'stencil
        (grob-interpret-markup grob
          (make-lower-markup 0.5 (make-bold-markup "1")))))))
  \applyOutput #'Voice #note-one cis'4
  \applyOutput #'Voice #note-one cis'4   \applyOutput #'Voice #note-one cis'4 | %{ bar 7: %}
  \applyOutput #'Voice #note-two d'4
\once \override Tie.transparent = ##t \once \override Tie.staff-position = #0   \applyOutput #'Voice #note-one cis'4
 ~ #(define (note-dashone grob grob-origin context)
  (if (and (eq? (ly:context-property context 'chordChanges) #t)
      (or (grob::has-interface grob 'note-head-interface)
        (grob::has-interface grob 'rest-interface)))
    (begin
      (ly:grob-set-property! grob 'stencil
        (grob-interpret-markup grob
          (make-lower-markup 0.5 (make-bold-markup "–")))))))
  \applyOutput #'Voice #note-dashone cis'4
  \applyOutput #'Voice #note-seven b4-\tweak #'Y-offset #-1.2 -\tweak #'X-offset #0.6 _.
\once \override Tie.transparent = ##t \once \override Tie.staff-position = #0 | %{ bar 8: %}
  \applyOutput #'Voice #note-seven b4-\tweak #'Y-offset #-1.2 -\tweak #'X-offset #0.6 _.
 ~ \once \override Tie.transparent = ##t \once \override Tie.staff-position = #0   \applyOutput #'Voice #note-dashseven b4
 ~ \once \override Tie.transparent = ##t \once \override Tie.staff-position = #0   \applyOutput #'Voice #note-dashseven b4
 ~   \applyOutput #'Voice #note-dashseven b4 | %{ bar 9: %}
  \applyOutput #'Voice #note-nought r4
  \applyOutput #'Voice #note-nought r4   \applyOutput #'Voice #note-nought r4   \applyOutput #'Voice #note-seven b4-\tweak #'Y-offset #-1.2 -\tweak #'X-offset #0.6 _.
| %{ bar 10: %}
  \applyOutput #'Voice #note-seven b4-\tweak #'Y-offset #-1.2 -\tweak #'X-offset #0.6 _.
  \applyOutput #'Voice #note-four fis'4   \applyOutput #'Voice #note-four fis'4   \applyOutput #'Voice #note-three e'4 | %{ bar 11: %}
  \applyOutput #'Voice #note-three e'4
\once \override Tie.transparent = ##t \once \override Tie.staff-position = #0   \applyOutput #'Voice #note-four fis'4
 ~   \applyOutput #'Voice #note-dashfour fis'4   \applyOutput #'Voice #note-five g'4 \once \override Tie.transparent = ##t \once \override Tie.staff-position = #0 | %{ bar 12: %}
  \applyOutput #'Voice #note-seven b4-\tweak #'Y-offset #-1.2 -\tweak #'X-offset #0.6 _.
 ~ \once \override Tie.transparent = ##t \once \override Tie.staff-position = #0   \applyOutput #'Voice #note-dashseven b4
 ~ \once \override Tie.transparent = ##t \once \override Tie.staff-position = #0   \applyOutput #'Voice #note-dashseven b4
 ~   \applyOutput #'Voice #note-dashseven b4 | %{ bar 13: %}
  \applyOutput #'Voice #note-nought r4
  \applyOutput #'Voice #note-nought r4   \applyOutput #'Voice #note-nought r4   \applyOutput #'Voice #note-three e'4 | %{ bar 14: %}
  \applyOutput #'Voice #note-two d'4
  \applyOutput #'Voice #note-one cis'4   \applyOutput #'Voice #note-one cis'4   \applyOutput #'Voice #note-one cis'4 | %{ bar 15: %}
  \applyOutput #'Voice #note-two d'4
\once \override Tie.transparent = ##t \once \override Tie.staff-position = #0   \applyOutput #'Voice #note-one cis'4
 ~   \applyOutput #'Voice #note-dashone cis'4   \applyOutput #'Voice #note-seven b4-\tweak #'Y-offset #-1.2 -\tweak #'X-offset #0.6 _.
\once \override Tie.transparent = ##t \once \override Tie.staff-position = #0 | %{ bar 16: %}
  \applyOutput #'Voice #note-seven b4-\tweak #'Y-offset #-1.2 -\tweak #'X-offset #0.6 _.
 ~ \once \override Tie.transparent = ##t \once \override Tie.staff-position = #0   \applyOutput #'Voice #note-dashseven b4
 ~   \applyOutput #'Voice #note-dashseven b4   \applyOutput #'Voice #note-nought r4 | %{ bar 17: %}
  \applyOutput #'Voice #note-nought r4
  \applyOutput #'Voice #note-seven b4-\tweak #'Y-offset #-1.2 -\tweak #'X-offset #0.6 _.
  \applyOutput #'Voice #note-one cis'4   \applyOutput #'Voice #note-two d'4 | %{ bar 18: %}
  \applyOutput #'Voice #note-three e'4
\once \override Tie.transparent = ##t \once \override Tie.staff-position = #0   \applyOutput #'Voice #note-four fis'4
 ~ \once \override Tie.transparent = ##t \once \override Tie.staff-position = #0   \applyOutput #'Voice #note-dashfour fis'4
 ~   \applyOutput #'Voice #note-dashfour fis'4 | %{ bar 19: %}
  \applyOutput #'Voice #note-nought r4
  \applyOutput #'Voice #note-four fis'4.   \applyOutput #'Voice #note-four fis'4. | %{ bar 20: %}
  \applyOutput #'Voice #note-three e'4
#(define (note-six grob grob-origin context)
  (if (and (eq? (ly:context-property context 'chordChanges) #t)
      (or (grob::has-interface grob 'note-head-interface)
        (grob::has-interface grob 'rest-interface)))
    (begin
      (ly:grob-set-property! grob 'stencil
        (grob-interpret-markup grob
          (make-lower-markup 0.5 (make-bold-markup "6")))))))
  \applyOutput #'Voice #note-six a'4.
  \applyOutput #'Voice #note-four fis'4. | %{ bar 21: %}
  \applyOutput #'Voice #note-three e'4
\once \override Tie.transparent = ##t \once \override Tie.staff-position = #0   \applyOutput #'Voice #note-four fis'4
 ~ ( \once \override Tie.transparent = ##t \once \override Tie.staff-position = #0   \applyOutput #'Voice #note-dashfour fis'4
 ~   \applyOutput #'Voice #note-dashfour fis'4 \once \override Tie.transparent = ##t \once \override Tie.staff-position = #0 | %{ bar 22: %}
  \applyOutput #'Voice #note-four fis'4
 ~ )   \applyOutput #'Voice #note-dashfour fis'4   \applyOutput #'Voice #note-nought r4   \applyOutput #'Voice #note-nought r4 | %{ bar 23: %}
  \applyOutput #'Voice #note-nought r4
  \applyOutput #'Voice #note-one cis'4.   \applyOutput #'Voice #note-two d'4. | %{ bar 24: %}
  \applyOutput #'Voice #note-three e'4
\once \override Tie.transparent = ##t \once \override Tie.staff-position = #0   \applyOutput #'Voice #note-one cis'4
 ~ ( \once \override Tie.transparent = ##t \once \override Tie.staff-position = #0   \applyOutput #'Voice #note-dashone cis'4
 ~   \applyOutput #'Voice #note-dashone cis'4 | %{ bar 25: %}
  \applyOutput #'Voice #note-one cis'4
)   \applyOutput #'Voice #note-seven b4.-\tweak #'Y-offset #-1.2 -\tweak #'X-offset #0.6 _.
  \applyOutput #'Voice #note-six a4.-\tweak #'Y-offset #-1.2 -\tweak #'X-offset #0.6 _.
| %{ bar 26: %}
  \applyOutput #'Voice #note-six a4-\tweak #'Y-offset #-1.2 -\tweak #'X-offset #0.6 _.
\once \override Tie.transparent = ##t \once \override Tie.staff-position = #0   \applyOutput #'Voice #note-four fis'4
 ~ \once \override Tie.transparent = ##t \once \override Tie.staff-position = #0   \applyOutput #'Voice #note-dashfour fis'4
 ~   \applyOutput #'Voice #note-dashfour fis'4 | %{ bar 27: %}
  \applyOutput #'Voice #note-nought r4
  \applyOutput #'Voice #note-four fis'4.   \applyOutput #'Voice #note-four fis'4. | %{ bar 28: %}
  \applyOutput #'Voice #note-three e'4
  \applyOutput #'Voice #note-six a'4.   \applyOutput #'Voice #note-four fis'4. | %{ bar 29: %}
  \applyOutput #'Voice #note-three e'4
\once \override Tie.transparent = ##t \once \override Tie.staff-position = #0   \applyOutput #'Voice #note-four fis'4
 ~ ( \once \override Tie.transparent = ##t \once \override Tie.staff-position = #0   \applyOutput #'Voice #note-dashfour fis'4
 ~   \applyOutput #'Voice #note-dashfour fis'4 \once \override Tie.transparent = ##t \once \override Tie.staff-position = #0 | %{ bar 30: %}
  \applyOutput #'Voice #note-four fis'4
 ~ )   \applyOutput #'Voice #note-dashfour fis'4   \applyOutput #'Voice #note-nought r4   \applyOutput #'Voice #note-one cis'4 | %{ bar 31: %}
  \applyOutput #'Voice #note-one cis'4
  \applyOutput #'Voice #note-three e'4.   \applyOutput #'Voice #note-four fis'4. \once \override Tie.transparent = ##t \once \override Tie.staff-position = #0 | %{ bar 32: %}
  \applyOutput #'Voice #note-two dis'4
 ~ ( \once \override Tie.transparent = ##t \once \override Tie.staff-position = #0 #(define (note-dashtwo grob grob-origin context)
  (if (and (eq? (ly:context-property context 'chordChanges) #t)
      (or (grob::has-interface grob 'note-head-interface)
        (grob::has-interface grob 'rest-interface)))
    (begin
      (ly:grob-set-property! grob 'stencil
        (grob-interpret-markup grob
          (make-lower-markup 0.5 (make-bold-markup "–")))))))
  \applyOutput #'Voice #note-dashtwo dis'4
 ~ \once \override Tie.transparent = ##t \once \override Tie.staff-position = #0   \applyOutput #'Voice #note-dashtwo dis'4
 ~   \applyOutput #'Voice #note-dashtwo dis'4 \once \override Tie.transparent = ##t \once \override Tie.staff-position = #0 | %{ bar 33: %}
  \applyOutput #'Voice #note-two dis'4
 ~ )   \applyOutput #'Voice #note-dashtwo dis'4   \applyOutput #'Voice #note-nought r4   \applyOutput #'Voice #note-three e'4 | %{ bar 34: %}
  \applyOutput #'Voice #note-four fis'4
  \applyOutput #'Voice #note-five gis'4   \applyOutput #'Voice #note-five gis'4   \applyOutput #'Voice #note-five gis'4 | %{ bar 35: %}
  \applyOutput #'Voice #note-four fis'4
  \applyOutput #'Voice #note-five gis'4.   \applyOutput #'Voice #note-six a'4. \once \override Tie.transparent = ##t \once \override Tie.staff-position = #0 | %{ bar 36: %}
  \applyOutput #'Voice #note-five gis'4
 ~ \once \override Tie.transparent = ##t \once \override Tie.staff-position = #0 #(define (note-dashfive grob grob-origin context)
  (if (and (eq? (ly:context-property context 'chordChanges) #t)
      (or (grob::has-interface grob 'note-head-interface)
        (grob::has-interface grob 'rest-interface)))
    (begin
      (ly:grob-set-property! grob 'stencil
        (grob-interpret-markup grob
          (make-lower-markup 0.5 (make-bold-markup "–")))))))
  \applyOutput #'Voice #note-dashfive gis'4
 ~ \once \override Tie.transparent = ##t \once \override Tie.staff-position = #0   \applyOutput #'Voice #note-dashfive gis'4
 ~   \applyOutput #'Voice #note-dashfive gis'4 | %{ bar 37: %}
  \applyOutput #'Voice #note-nought r4
\once \override Tie.transparent = ##t \once \override Tie.staff-position = #0   \applyOutput #'Voice #note-four fis'4
 ~   \applyOutput #'Voice #note-dashfour fis'4   \applyOutput #'Voice #note-three e'4 ( | %{ bar 38: %}
  \applyOutput #'Voice #note-three e'4
)   \applyOutput #'Voice #note-four fis'4.   \applyOutput #'Voice #note-seven b4.-\tweak #'Y-offset #-1.2 -\tweak #'X-offset #0.6 _.
| %{ bar 39: %}
  \applyOutput #'Voice #note-one cis'4
\once \override Tie.transparent = ##t \once \override Tie.staff-position = #0   \applyOutput #'Voice #note-seven b4-\tweak #'Y-offset #-1.2 -\tweak #'X-offset #0.6 _.
 ~ ( \once \override Tie.transparent = ##t \once \override Tie.staff-position = #0   \applyOutput #'Voice #note-dashseven b4
 ~   \applyOutput #'Voice #note-dashseven b4 \once \override Tie.transparent = ##t \once \override Tie.staff-position = #0 | %{ bar 40: %}
  \applyOutput #'Voice #note-seven b4-\tweak #'Y-offset #-1.2 -\tweak #'X-offset #0.6 _.
 ~ )   \applyOutput #'Voice #note-dashseven b4   \applyOutput #'Voice #note-nought r4   \applyOutput #'Voice #note-nought r4 | %{ bar 41: %}
  \applyOutput #'Voice #note-nought r4
  \applyOutput #'Voice #note-nought r4   \applyOutput #'Voice #note-nought r4   \applyOutput #'Voice #note-one cis'4 | %{ bar 42: %}
  \applyOutput #'Voice #note-two dis'4
\once \override Tie.transparent = ##t \once \override Tie.staff-position = #0   \applyOutput #'Voice #note-three e'4
 ~ \once \override Tie.transparent = ##t \once \override Tie.staff-position = #0 #(define (note-dashthree grob grob-origin context)
  (if (and (eq? (ly:context-property context 'chordChanges) #t)
      (or (grob::has-interface grob 'note-head-interface)
        (grob::has-interface grob 'rest-interface)))
    (begin
      (ly:grob-set-property! grob 'stencil
        (grob-interpret-markup grob
          (make-lower-markup 0.5 (make-bold-markup "–")))))))
  \applyOutput #'Voice #note-dashthree e'4
 ~   \applyOutput #'Voice #note-dashthree e'4 | %{ bar 43: %}
  \applyOutput #'Voice #note-nought r4
  \applyOutput #'Voice #note-one cis'4.   \applyOutput #'Voice #note-three e'4. \once \override Tie.transparent = ##t \once \override Tie.staff-position = #0 | %{ bar 44: %}
  \applyOutput #'Voice #note-seven b'4
 ~   \applyOutput #'Voice #note-dashseven b'4   \applyOutput #'Voice #note-seven b'4   \applyOutput #'Voice #note-six a'4 | %{ bar 45: %}
  \applyOutput #'Voice #note-six a'4
  \applyOutput #'Voice #note-five gis'4 \once \override Tie.transparent = ##t \once \override Tie.staff-position = #0   \applyOutput #'Voice #note-four fis'4
 ~   \applyOutput #'Voice #note-dashfour fis'4 \once \override Tie.transparent = ##t \once \override Tie.staff-position = #0 | %{ bar 46: %}
  \applyOutput #'Voice #note-six a'4
 ~ #(define (note-dashsix grob grob-origin context)
  (if (and (eq? (ly:context-property context 'chordChanges) #t)
      (or (grob::has-interface grob 'note-head-interface)
        (grob::has-interface grob 'rest-interface)))
    (begin
      (ly:grob-set-property! grob 'stencil
        (grob-interpret-markup grob
          (make-lower-markup 0.5 (make-bold-markup "–")))))))
  \applyOutput #'Voice #note-dashsix a'4
  \applyOutput #'Voice #note-five gis'4   \applyOutput #'Voice #note-five gis'4 ( \once \override Tie.transparent = ##t \once \override Tie.staff-position = #0 | %{ bar 47: %}
  \applyOutput #'Voice #note-five gis'4
 ~ \once \override Tie.transparent = ##t \once \override Tie.staff-position = #0   \applyOutput #'Voice #note-dashfive gis'4
 ~ \once \override Tie.transparent = ##t \once \override Tie.staff-position = #0   \applyOutput #'Voice #note-dashfive gis'4
 ~   \applyOutput #'Voice #note-dashfive gis'4 \once \override Tie.transparent = ##t \once \override Tie.staff-position = #0 | %{ bar 48: %}
  \applyOutput #'Voice #note-five gis'4
 ~ ) \once \override Tie.transparent = ##t \once \override Tie.staff-position = #0   \applyOutput #'Voice #note-dashfive gis'4
 ~   \applyOutput #'Voice #note-dashfive gis'4   \applyOutput #'Voice #note-nought r4 | %{ bar 49: %}
  \applyOutput #'Voice #note-nought r4
  \applyOutput #'Voice #note-three e'4.   \applyOutput #'Voice #note-four fis'4. | %{ bar 50: %}
  \applyOutput #'Voice #note-five gis'4
\once \override Tie.transparent = ##t \once \override Tie.staff-position = #0   \applyOutput #'Voice #note-seven b'4
 ~   \applyOutput #'Voice #note-dashseven b'4   \applyOutput #'Voice #note-six a'4 ( | %{ bar 51: %}
  \applyOutput #'Voice #note-six a'4
)   \applyOutput #'Voice #note-five gis'4.   \applyOutput #'Voice #note-four fis'4. \once \override Tie.transparent = ##t \once \override Tie.staff-position = #0 | %{ bar 52: %}
  \applyOutput #'Voice #note-six a'4
 ~   \applyOutput #'Voice #note-dashsix a'4   \applyOutput #'Voice #note-six a'4   \applyOutput #'Voice #note-five gis'4 | %{ bar 53: %}
  \applyOutput #'Voice #note-five gis'4
  \applyOutput #'Voice #note-four fis'4.   \applyOutput #'Voice #note-three e'4. | %{ bar 54: %}
  \applyOutput #'Voice #note-nought r4
\once \override Tie.transparent = ##t \once \override Tie.staff-position = #0   \applyOutput #'Voice #note-two dis'4
 ~   \applyOutput #'Voice #note-dashtwo dis'4   \applyOutput #'Voice #note-three e'4 \once \override Tie.transparent = ##t \once \override Tie.staff-position = #0 | %{ bar 55: %}
  \applyOutput #'Voice #note-four fis'4
 ~   \applyOutput #'Voice #note-dashfour fis'4 \once \override Tie.transparent = ##t \once \override Tie.staff-position = #0   \applyOutput #'Voice #note-seven b4-\tweak #'Y-offset #-1.2 -\tweak #'X-offset #0.6 _.
 ~   \applyOutput #'Voice #note-dashseven b4 \once \override Tie.transparent = ##t \once \override Tie.staff-position = #0 | %{ bar 56: %}
  \applyOutput #'Voice #note-seven b'4
 ~ \once \override Tie.transparent = ##t \once \override Tie.staff-position = #0   \applyOutput #'Voice #note-dashseven b'4
 ~ \once \override Tie.transparent = ##t \once \override Tie.staff-position = #0   \applyOutput #'Voice #note-dashseven b'4
 ~   \applyOutput #'Voice #note-dashseven b'4 | %{ bar 57: %}
  \applyOutput #'Voice #note-nought r4
\once \override Tie.transparent = ##t \once \override Tie.staff-position = #0   \applyOutput #'Voice #note-six a'4
 ~   \applyOutput #'Voice #note-dashsix a'4   \applyOutput #'Voice #note-five gis'4 ( | %{ bar 58: %}
  \applyOutput #'Voice #note-five gis'4
) \once \override Tie.transparent = ##t \once \override Tie.staff-position = #0   \applyOutput #'Voice #note-one cis'4
 ~ \once \override Tie.transparent = ##t \once \override Tie.staff-position = #0   \applyOutput #'Voice #note-dashone cis'4
 ~   \applyOutput #'Voice #note-dashone cis'4 \once \override Tie.transparent = ##t \once \override Tie.staff-position = #0 | %{ bar 59: %}
  \applyOutput #'Voice #note-five gis'4
 ~ ( \once \override Tie.transparent = ##t \once \override Tie.staff-position = #0   \applyOutput #'Voice #note-dashfive gis'4
 ~ \once \override Tie.transparent = ##t \once \override Tie.staff-position = #0   \applyOutput #'Voice #note-dashfive gis'4
 ~   \applyOutput #'Voice #note-dashfive gis'4 \once \override Tie.transparent = ##t \once \override Tie.staff-position = #0 | %{ bar 60: %}
  \applyOutput #'Voice #note-five gis'4
 ~ ) \once \override Tie.transparent = ##t \once \override Tie.staff-position = #0   \applyOutput #'Voice #note-dashfive gis'4
 ~ \once \override Tie.transparent = ##t \once \override Tie.staff-position = #0   \applyOutput #'Voice #note-dashfive gis'4
 ~   \applyOutput #'Voice #note-dashfive gis'4 | %{ bar 61: %}
  \applyOutput #'Voice #note-nought r4
\once \override Tie.transparent = ##t \once \override Tie.staff-position = #0   \applyOutput #'Voice #note-four fis'4
 ~   \applyOutput #'Voice #note-dashfour fis'4   \applyOutput #'Voice #note-three e'4 ( | %{ bar 62: %}
  \applyOutput #'Voice #note-three e'4
) \once \override Tie.transparent = ##t \once \override Tie.staff-position = #0   \applyOutput #'Voice #note-one cis'4
 ~ \once \override Tie.transparent = ##t \once \override Tie.staff-position = #0   \applyOutput #'Voice #note-dashone cis'4
 ~   \applyOutput #'Voice #note-dashone cis'4 \once \override Tie.transparent = ##t \once \override Tie.staff-position = #0 | %{ bar 63: %}
  \applyOutput #'Voice #note-five gis'4
 ~ ( \once \override Tie.transparent = ##t \once \override Tie.staff-position = #0   \applyOutput #'Voice #note-dashfive gis'4
 ~ \once \override Tie.transparent = ##t \once \override Tie.staff-position = #0   \applyOutput #'Voice #note-dashfive gis'4
 ~   \applyOutput #'Voice #note-dashfive gis'4 \once \override Tie.transparent = ##t \once \override Tie.staff-position = #0 | %{ bar 64: %}
  \applyOutput #'Voice #note-five gis'4
 ~ ) \once \override Tie.transparent = ##t \once \override Tie.staff-position = #0   \applyOutput #'Voice #note-dashfive gis'4
 ~ \once \override Tie.transparent = ##t \once \override Tie.staff-position = #0   \applyOutput #'Voice #note-dashfive gis'4
 ~   \applyOutput #'Voice #note-dashfive gis'4 | %{ bar 65: %}
  \applyOutput #'Voice #note-nought r4
\once \override Tie.transparent = ##t \once \override Tie.staff-position = #0   \applyOutput #'Voice #note-four fis'4
 ~   \applyOutput #'Voice #note-dashfour fis'4   \applyOutput #'Voice #note-three e'4 ( | %{ bar 66: %}
  \applyOutput #'Voice #note-three e'4
) \once \override Tie.transparent = ##t \once \override Tie.staff-position = #0   \applyOutput #'Voice #note-two dis'4
 ~ ( \once \override Tie.transparent = ##t \once \override Tie.staff-position = #0   \applyOutput #'Voice #note-dashtwo dis'4
 ~   \applyOutput #'Voice #note-dashtwo dis'4 \once \override Tie.transparent = ##t \once \override Tie.staff-position = #0 | %{ bar 67: %}
  \applyOutput #'Voice #note-two dis'4
 ~ \once \override Tie.transparent = ##t \once \override Tie.staff-position = #0   \applyOutput #'Voice #note-dashtwo dis'4
 ~ \once \override Tie.transparent = ##t \once \override Tie.staff-position = #0   \applyOutput #'Voice #note-dashtwo dis'4
 ~   \applyOutput #'Voice #note-dashtwo dis'4 \once \override Tie.transparent = ##t \once \override Tie.staff-position = #0 | %{ bar 68: %}
  \applyOutput #'Voice #note-two dis'4
 ~ ) \once \override Tie.transparent = ##t \once \override Tie.staff-position = #0   \applyOutput #'Voice #note-dashtwo dis'4
 ~ \once \override Tie.transparent = ##t \once \override Tie.staff-position = #0   \applyOutput #'Voice #note-dashtwo dis'4
 ~   \applyOutput #'Voice #note-dashtwo dis'4 | %{ bar 69: %}
  \applyOutput #'Voice #note-nought r4
  \applyOutput #'Voice #note-nought r4   \applyOutput #'Voice #note-nought r4   \applyOutput #'Voice #note-nought r4 \bar "|." } }
% === END JIANPU STAFF ===

>>
\header{
title="CROSSING"
arranger="SL七叶"
}
\layout{} }
\score {
\unfoldRepeats
<< 

% === BEGIN MIDI STAFF ===
    \new Staff { \new Voice="X" { \tempo 4=204 \transpose c c { \key c \major  \time 4/4 r2. b4 | %{ bar 2: %} b4 fis'2 e'4 | %{ bar 3: %} e'4 fis'2 g'4 | %{ bar 4: %} b1 | %{ bar 5: %} r2. b4 | %{ bar 6: %} d'4 cis'4 cis'4 cis'4 | %{ bar 7: %} d'4 cis'2 b4 | %{ bar 8: %} b1 | %{ bar 9: %} r2. b4 | %{ bar 10: %} b4 fis'4 fis'4 e'4 | %{ bar 11: %} e'4 fis'2 g'4 | %{ bar 12: %} b1 | %{ bar 13: %} r2. e'4 | %{ bar 14: %} d'4 cis'4 cis'4 cis'4 | %{ bar 15: %} d'4 cis'2 b4 | %{ bar 16: %} b2. r4 | %{ bar 17: %} r4 b4 cis'4 d'4 | %{ bar 18: %} e'4 fis'2. | %{ bar 19: %} r4 fis'4. fis'4. | %{ bar 20: %} e'4 a'4. fis'4. | %{ bar 21: %} e'4 fis'4  ~ ( fis'2 | %{ bar 22: %} fis'4  ~ ) fis'4 r2 | %{ bar 23: %} r4 cis'4. d'4. | %{ bar 24: %} e'4 cis'4  ~ ( cis'2 | %{ bar 25: %} cis'4 ) b4. a4. | %{ bar 26: %} a4 fis'2. | %{ bar 27: %} r4 fis'4. fis'4. | %{ bar 28: %} e'4 a'4. fis'4. | %{ bar 29: %} e'4 fis'4  ~ ( fis'2 | %{ bar 30: %} fis'4  ~ ) fis'4 r4 cis'4 | %{ bar 31: %} cis'4 e'4. fis'4. | %{ bar 32: %} dis'4  ~ ( dis'2. | %{ bar 33: %} dis'4  ~ ) dis'4 r4 e'4 | %{ bar 34: %} fis'4 gis'4 gis'4 gis'4 | %{ bar 35: %} fis'4 gis'4. a'4. | %{ bar 36: %} gis'1 | %{ bar 37: %} r4 fis'2 e'4 ( | %{ bar 38: %} e'4 ) fis'4. b4. | %{ bar 39: %} cis'4 b4  ~ ( b2 | %{ bar 40: %} b4  ~ ) b4 r2 | %{ bar 41: %} r2. cis'4 | %{ bar 42: %} dis'4 e'2. | %{ bar 43: %} r4 cis'4. e'4. | %{ bar 44: %} b'2 b'4 a'4 | %{ bar 45: %} a'4 gis'4 fis'2 | %{ bar 46: %} a'2 gis'4 gis'4 ( | %{ bar 47: %} gis'1 | %{ bar 48: %} gis'4  ~ ) gis'2 r4 | %{ bar 49: %} r4 e'4. fis'4. | %{ bar 50: %} gis'4 b'2 a'4 ( | %{ bar 51: %} a'4 ) gis'4. fis'4. | %{ bar 52: %} a'2 a'4 gis'4 | %{ bar 53: %} gis'4 fis'4. e'4. | %{ bar 54: %} r4 dis'2 e'4 | %{ bar 55: %} fis'2 b2 | %{ bar 56: %} b'1 | %{ bar 57: %} r4 a'2 gis'4 ( | %{ bar 58: %} gis'4 ) cis'2. | %{ bar 59: %} gis'4  ~ ( gis'2. | %{ bar 60: %} gis'4  ~ ) gis'2. | %{ bar 61: %} r4 fis'2 e'4 ( | %{ bar 62: %} e'4 ) cis'2. | %{ bar 63: %} gis'4  ~ ( gis'2. | %{ bar 64: %} gis'4  ~ ) gis'2. | %{ bar 65: %} r4 fis'2 e'4 ( | %{ bar 66: %} e'4 ) dis'4  ~ ( dis'2 | %{ bar 67: %} dis'1 | %{ bar 68: %} dis'4  ~ ) dis'2. | %{ bar 69: %} r1 } } }
% === END MIDI STAFF ===

>>
\header{
title="CROSSING"
arranger="SL七叶"
}
\midi { \context { \Score tempoWholesPerMinute = #(ly:make-moment 84 4)}} }
