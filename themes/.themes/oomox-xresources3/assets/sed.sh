#!/bin/sh
sed -i \
         -e 's/#cbc8c9/rgb(0%,0%,0%)/g' \
         -e 's/#31252a/rgb(100%,100%,100%)/g' \
    -e 's/#31252a/rgb(50%,0%,0%)/g' \
     -e 's/#c27892/rgb(0%,50%,0%)/g' \
     -e 's/#cbc8c9/rgb(50%,0%,50%)/g' \
     -e 's/#31252a/rgb(0%,0%,50%)/g' \
	$@
