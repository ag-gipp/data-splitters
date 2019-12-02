# Splitter.sh
The `splitter.sh` expects to arguments, the input and output folder.
For example, if your data is in `data` and you want to put into `out`:
```sh
./splitter data out
```

The `data` directory should have the structure:
```
- data
   |- dataset1
   |    |- lang1
   |    |- lang2
   |- dataset2
   |    |- lang1
   |    |- lang2
   . . .
   . . .
   . . .
```

### What's going on?
The `splitter.sh` takes all files with a line count between 3 and 8 and copies
them to the output folder. If the final output contains less than 2000 files, it
fills up the output folder (until 2000 files are copied) by considering longer
files (longer than 8 lines).

If the input file is longer than 8 lines, it takes 8 lines from the center of
the file (e.g., file with 100 lines will extract lines 46 to 54).

This is happening for all languages. If you want to change the settings (min
  line count, max line count, copy number of files) change the parameters
  in the script:
```sh
MINL=3        # <- minimum line count
MAXL=8        # <- maximum line count
NUMFILES=2000 # <- number of files to copy
```
