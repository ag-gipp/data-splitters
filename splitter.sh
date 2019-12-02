#!/bin/bash

INPUT=$1
OUTPUT=$2

DIRS=$(ls $1)

MINL=3
MAXL=8
#always rounds down
HALFMAXL=$((MAXL/2))
NUMFILES=2000

for d in $DIRS; do
	for id in $(ls $1/$d); do
		FCOUNTER=0
		
		$(mkdir -p $2/$d/$id)
		echo "Split $1/$d/$id"
		
		for f in $(ls $1/$d/$id); do
			LINE=$(wc -l $1/$d/$id/$f | awk '{print $1}')
			if [[ $LINE -ge $MINL ]] && [[ $LINE -le $MAXL ]] && [[ $FCOUNTER -lt $NUMFILES ]]; then
				$(cp $1/$d/$id/$f $2/$d/$id/$f)
				FCOUNTER=$((FCOUNTER+1))
				#echo "Copied $id/$f"
			fi
		done

		if [ $FCOUNTER -lt $NUMFILES ]; then
			echo "Only copied $FCOUNTER files. Filling up the rest with longer files."
			for f in $(ls $1/$d/$id); do
				LINE=$(wc -l $1/$d/$id/$f | awk '{print $1}')
				if [[ $LINE -gt $MAXL ]] && [[ $FCOUNTER -lt $NUMFILES ]]; then
                                	SLINE=$((LINE/2 - HALFMAXL))
                                	ELINE=$((SLINE + MAXL))
                        	        $(sed -n "$SLINE,$ELINE p" $1/$d/$id/$f >> $2/$d/$id/$f)
                	                FCOUNTER=$((FCOUNTER+1))
					echo "Cut $id/$f lines $SLINE to $ELINE (total lines $LINE)"
	                        fi
			done
		fi
		echo "Done generating $FCOUNTER files in $1/$d/$id"
	done
done

