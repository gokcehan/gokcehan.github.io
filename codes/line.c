//
// line.c
//
// Lines of fixed length
//

#include <stdio.h>
#include <stdlib.h>

#define MAXLINE 1000

void process(char *line)
{
    puts(line);
}

int main(void)
{
    char line[MAXLINE];
    while (fgets(line, MAXLINE, stdin)) {
        process(line);
    }

    return 0;
}
