python main.py tests\src.mid %* > tests\src
python jianpu-ly.py tests\src > tests\src.ly
lilypond --pdf tests\src.ly
