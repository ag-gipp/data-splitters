#!/bin/bash

INPUT=$1
OUTPUT=$2

DIRS=$(ls $1)

MINL=3
MAXL=8
#always rounds down
HALFMAXL=$((MAXL/2))
NUMFILES=2000

for DATAD in $DIRS; do
	LANGDIRS=$(ls $INPUT/$DATAD)
	FIRST=$(echo $LANGDIRS | awk '{print $1}')
	FCOUNTER=0

	# create output DIRS
	for OUTD in $LANGDIRS; do
		$(mkdir -p $OUTPUT/$DATAD/$OUTD)
	done

	echo "Processing $INPUT/$DATAD"

	# iterate over all files in first data dir (often en)
	for file in $(ls $INPUT/$DATAD/$FIRST); do
		fileE=${file##*-}
		fileID=${file%-$fileE}

		# if line number is within specified range, copy the files
		LINE=$(wc -l $INPUT/$DATAD/$FIRST/$file | awk '{print $1}')
	  if [[ $LINE -ge $MINL ]] && [[ $LINE -le $MAXL ]] && [[ $FCOUNTER -lt $NUMFILES ]]; then
			for lang in $LANGDIRS; do
				fileN=$fileID-$lang.txt
				$(cp $INPUT/$DATAD/$lang/$fileN $OUTPUT/$DATAD/$lang/)
			done
	    FCOUNTER=$((FCOUNTER+1))
	  fi
	done

	echo "Copied $FCOUNTER files with $MINL and $MAXL lines in $INPUT/$DATAD"

	if [ $FCOUNTER -lt $NUMFILES ]; then
	  echo "Only copied $FCOUNTER files. Filling up the rest with longer files."
	  for file in $(ls $INPUT/$DATAD/$FIRST); do
			fileE=${file##*-}
			fileID=${file%-$fileE}

			# if line number is within specified range, copy the files
			LINE=$(wc -l $INPUT/$DATAD/$FIRST/$file | awk '{print $1}')
	    if (( LINE > MAXL )) &&  ((FCOUNTER < NUMFILES)); then
        SLINE=$((LINE/2 - HALFMAXL + 1))
        ELINE=$((SLINE + MAXL + 1))
				for lang in $LANGDIRS; do
					fileN=$fileID-$lang.txt
					$(sed -n "$SLINE,$ELINE p" $INPUT/$DATAD/$lang/$fileN >> $OUTPUT/$DATAD/$lang/$fileN)
				done
        FCOUNTER=$((FCOUNTER+1))
	      echo "Cut $fileID in $DATAD: lines $SLINE to $ELINE (total lines $LINE)"
			fi
	  done
	fi

	echo "Filled up longer files and reached $FCOUNTER."
done
