//
// plain_arr.c
//
// Plain array
//

#include <stdio.h>
#include <stdlib.h>

#define LIMIT 100

int a = 0;
int b = 1;

int get(void)
{
    int tmp = a;
    a = b;
    b = tmp + b;
    return tmp;
}

void process(int i)
{
    printf("%d\n", i);
}

int main(int argc, char *argv[])
{
    int i, num;

    int limit = argc < 2 ? LIMIT : atoi(argv[1]);

    int len = 0;
    int cap = 2;
    int *buf = malloc(cap * sizeof(int));

    while ((num = get()) < limit) {
        if (cap <= len) {
            buf = realloc(buf, (cap *= 2) * sizeof(int));
        }
        buf[len++] = num;
    }

    for (i = 0; i < len; ++i) {
        process(buf[i]);
    }

    for (i = len-1; i > 0; --i) {
        buf[i] -= buf[i-1];
    }

    for (i = len-1; i >= 0; --i) {
        process(buf[--len]);
    }

    free(buf);

    return 0;
}
