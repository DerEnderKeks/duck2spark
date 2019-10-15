#!/usr/bin/env bash

if [ "$1" == "-h" ]; then
  echo "Usage: $0 [<input> [output]]"
  echo -e "Use \e[34m\$DUCKLANG\e[0m to set the keyboard language (default: \e[34mde\e[0m)."
  exit 0
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if [ -z "$DUCKLANG" ]; then
  DUCKLANG="de"
fi


if [ -z "$1" ]; then
  INFILE="spark.duck"
else
  INFILE="$1"
fi

if [ -z "$2" ]; then
  OUTFILE="spark.ino"
else
  OUTFILE="$2"
fi

echo -e "Converting \e[34m$INFILE\e[0m"
echo -e "        to \e[34m$OUTFILE\e[0m\n"

TMPBINFILE=$(mktemp $TEMP/spark.bin.XXXXXX)

check_error () {
  if [ "$2" != "0" ]; then
    echo "$1 failed! (exit code $2)"
	exit "$2"
  fi
}

java -jar "$DIR/encoder.jar" -i "$INFILE" -o "$TMPBINFILE" -l "$DUCKLANG"
check_error "Encoder" $?

python "$DIR/duck2spark.py" -i "$TMPBINFILE" -f 0 -o "$OUTFILE"
check_error "duck2spark" $?

rm "$TMPBINFILE" 

echo "Done."
exit 0
