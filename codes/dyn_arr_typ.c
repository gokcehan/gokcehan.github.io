//
// dyn_arr_typ.c
//
// Dynamic array (types)
//

#include <stdlib.h>

#define ARR_INIT_CAP 2
#define ARR_GROW_RAT 2

#define arr(type) struct {                                                     \
    type *buf;                                                                 \
    int   len;                                                                 \
    int   cap;                                                                 \
}

#define arrnew(arr) arrnewcap(arr, ARR_INIT_CAP)

#define arrnewcap(arr, ncap) do {                                              \
    arr.buf = malloc(ncap * sizeof(arr.buf[0]));                               \
    arr.len = 0;                                                               \
    arr.cap = ncap;                                                            \
} while (0)

#define arrdelete(arr) do {                                                    \
    free(arr.buf);                                                             \
} while (0)

#define arrappend(arr, val) do {                                               \
    if (arr.cap <= arr.len) {                                                  \
        arrresize(arr, arr.cap * ARR_GROW_RAT);                                \
    }                                                                          \
    arr.buf[arr.len++] = val;                                                  \
} while (0)

#define arrresize(arr, ncap) do {                                              \
    arr.buf = realloc(arr.buf, ncap * sizeof(arr.buf[0]));                     \
    arr.cap = ncap;                                                            \
} while (0)

#define arrremove(arr) (arr.buf[--arr.len])

////////////////////////////////////////////////////////////////////////////////

#include <stdio.h>

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

    // int

    arr(int) arr;

    arrnew(arr);

    while ((num = get()) < limit) {
        arrappend(arr, num);
    }

    for (i = 0; i < arr.len; ++i) {
        process(arr.buf[i]);
    }

    for (i = arr.len-1; i > 0; --i) {
        arr.buf[i] -= arr.buf[i-1];
    }

    for (i = arr.len-1; i >= 0; --i) {
        process(arrremove(arr));
    }

    arrdelete(arr);

    // char *

    arr(char *) words;

    arrnew(words);

    arrappend(words, "one");
    arrappend(words, "two");
    arrappend(words, "three");

    for (i = 0; i < words.len; ++i) {
        puts(words.buf[i]);
    }

    arrdelete(words);

    return 0;
}
