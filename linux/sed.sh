#!/bin/sh
# see also `man sed` and `info sed`

printf 'cat\ndog\ntree'
# cat
# dog
# tree

## q command

printf 'cat\ndog\ntree' | sed -e 'q'
# cat

printf 'cat\ndog\ntree' | sed 'q'
# cat

printf 'cat\ndog\ntree' | sed '2q'
# cat
# dog

printf 'cat\ndog\ntree' | sed '/do/q'
# cat
# dog

## p command

printf 'cat\ndog\ntree' | sed 'p'
# cat
# cat
# dog
# dog
# tree
# tree

printf 'cat\ndog\ntree' | sed '2p'
# cat
# dog
# dog
# tree

printf 'cat\ndog\ntree' | sed -n 'p'
# cat
# dog
# tree

printf 'cat\ndog\ntree' | sed -n '2p'
# dog

printf 'cat\ndog\ntree' | sed -n '2,3p'
# dog
# tree

printf 'cat\ndog\ntree' | sed -n '2,$p'
# dog
# tree

printf 'cat\ndog\ntree' | sed -n '$p'
# tree

printf 'cat\ndog\ntree' | sed -n '/dog/,3p'
# dog
# tree

printf 'cat\ndog\ntree' | sed -n '/dog/,/tree/p'
# dog
# tree

printf 'cat\ndog\ntree' | sed -n 'p;2q'
# cat
# dog

printf 'cat\ndog\ntree' | sed -n '2{p;q}'
# dog

## d command

printf 'cat\ndog\ntree' | sed '2d'
# cat
# tree

printf 'cat\ndog\ntree' | sed '2,3d'
# cat

printf 'cat\ndog\ntree' | sed -n '1,2p;2,3d'
# cat
# dog

printf 'cat\ndog\ntree' | sed -n '2,3d;1,2p'
# cat

## s command (most common)

printf 'cat\ndog\ntree' | sed 's/dog/DOG/'
# cat
# DOG
# tree

printf 'cat\ndog\ntree' | sed 's_dog_DOG_'
# cat
# DOG
# tree

printf 'cat dog\ndog\ntree' | sed 's/dog/DOG/'
# cat DOG
# DOG
# tree

printf 'cat\ndog dog\ntree' | sed 's/dog/DOG/'
# cat
# DOG dog
# tree

printf 'cat\ndog dog\ntree' | sed 's/dog/DOG/g'
# cat
# DOG DOG
# tree

printf 'cat\ndog dog dog\ntree' | sed 's/dog/DOG/2'
# cat
# dog DOG dog
# tree

printf 'cat\ndog dog\ntree' | sed 's/dog/DOG/p'
# cat
# DOG dog
# DOG dog
# tree

printf 'cat\ndog dog\ntree' | sed 's/dog/DOG/w /tmp/out.txt'
# cat
# DOG dog
# tree

cat /tmp/out.txt
# DOG dog

printf 'ls /bin/echo' | sed 's/ls/ls -lh/e'
# -rwxr-xr-x 1 root root 31K Feb 18  2016 /bin/echo

# remove trailing spaces
printf 'hello world   	' | sed 's/\s\+$//' && echo '|'
# hello world|

# remove empty lines
printf 'cat\n	 \ntree' | sed '/^\s*$/d'
# cat
# tree
