#!/bin/bash
if [[ $# < 3 ]]; then
  me=`basename "$0"`
  echo "$me <radar> <yyyy/mm> <localpath>"
  echo "copies a radar month of NEXRAD level 2 data, night only, 8 min minimum interval"
  exit
fi
days=`radls $2`

mkdir -p $3/$1/$2

for day in $days
do
  mkdir -p $3/$1/$2/$day
  echo "copying $2/$day for $1 ..."
  cd $3/$1/$2/$day
  radcp.py -r $1 -d $2/${day:0:2} --night --step 8
  cd ../../../..
done
