#!/bin/sh
# see also `man sed`

echo -e 'cat\ndog\ntree'
# cat
# dog
# tree

## q command

echo -e 'cat\ndog\ntree' | sed -e 'q'
# cat

echo -e 'cat\ndog\ntree' | sed 'q'
# cat

echo -e 'cat\ndog\ntree' | sed '2q'
# cat
# dog

echo -e 'cat\ndog\ntree' | sed '/do/q'
# cat
# dog

## p command

echo -e 'cat\ndog\ntree' | sed 'p'
# cat
# cat
# dog
# dog
# tree
# tree

echo -e 'cat\ndog\ntree' | sed '2p'
# cat
# dog
# dog
# tree

echo -e 'cat\ndog\ntree' | sed -n 'p'
# cat
# dog
# tree

echo -e 'cat\ndog\ntree' | sed -n '2p'
# dog

echo -e 'cat\ndog\ntree' | sed -n '2,3p'
# dog
# tree

echo -e 'cat\ndog\ntree' | sed -n '2,$p'
# dog
# tree

echo -e 'cat\ndog\ntree' | sed -n '$p'
# tree

echo -e 'cat\ndog\ntree' | sed -n '/dog/,3p'
# dog
# tree

echo -e 'cat\ndog\ntree' | sed -n '/dog/,/tree/p'
# dog
# tree

echo -e 'cat\ndog\ntree' | sed -n 'p;2q'
# cat
# dog

echo -e 'cat\ndog\ntree' | sed -n '{p;2q}'
# cat
# dog

## d command

echo -e 'cat\ndog\ntree' | sed '2d'
# cat
# tree

echo -e 'cat\ndog\ntree' | sed '2,3d'
# cat

echo -e 'cat\ndog\ntree' | sed -n '1,2p;2,3d'
# cat
# dog

echo -e 'cat\ndog\ntree' | sed -n '2,3d;1,2p'
# cat

## s command (common)

echo -e 'cat\ndog\ntree' | sed 's/dog/DOG/'
# cat
# DOG
# tree

echo -e 'cat\ndog\ntree' | sed 's_dog_DOG_'
# cat
# DOG
# tree

echo -e 'cat dog\ndog\ntree' | sed 's/dog/DOG/'
# cat DOG
# DOG
# tree

echo -e 'cat\ndog dog\ntree' | sed 's/dog/DOG/'
# cat
# DOG dog
# tree

echo -e 'cat\ndog dog\ntree' | sed 's/dog/DOG/g'
# cat
# DOG DOG
# tree

echo -e 'cat\ndog dog dog\ntree' | sed 's/dog/DOG/2'
# cat
# dog DOG dog
# tree

echo -e 'cat\ndog dog\ntree' | sed 's/dog/DOG/p'
# cat
# DOG dog
# DOG dog
# tree

echo -e 'cat\ndog dog\ntree' | sed 's/dog/DOG/w /tmp/out.txt'
# cat
# DOG dog
# tree

cat /tmp/out.txt
# DOG dog

echo 'ls /bin/echo' | sed 's/ls/ls -lh/e'
# -rwxr-xr-x 1 root root 31K Feb 18  2016 /bin/echo

# remove trailing spaces
echo -n 'hello world   	' | sed 's/\s*$//' && echo '|'
# hello world|

# remove empty lines
echo -e 'cat\n	 \ntree' | sed '/^\s*$/d'
# cat
# tree
