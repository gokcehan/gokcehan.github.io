//
// fat_arr.c
//
// Fat pointer array
//

#include <stdio.h>
#include <stdlib.h>

#define ARR_INIT_CAP 2
#define ARR_GROW_RAT 2

#define TYPE int

typedef TYPE *ARR;

ARR  arrnew(void);
ARR  arrnewcap(int);
void arrdelete(ARR);
ARR  arrappend(ARR, TYPE);
ARR  arrresize(ARR, int);
TYPE arrremove(ARR);
int  arrlen(ARR);
int  arrcap(ARR);

inline ARR
arrnew(void)
{
    return arrnewcap(ARR_INIT_CAP);
}

inline ARR
arrnewcap(int cap)
{
    int *buf;

    if ((buf = malloc(cap * sizeof(TYPE) + 2 * sizeof(int))) == NULL) {
        return NULL;
    }

    buf[0] = 0;
    buf[1] = cap;

    return (ARR)(buf + 2);
}

inline void
arrdelete(ARR arr)
{
    free((int *)arr - 2);
}

inline ARR
arrappend(ARR arr, TYPE val)
{
    int *buf, len, cap;

    buf = (int *)arr - 2;
    len = buf[0];
    cap = buf[1];

    if (cap <= len && (arr = arrresize(arr, cap * ARR_GROW_RAT)) == NULL) {
        return NULL;
    }

    buf = (int *)arr - 2;
    arr[buf[0]++] = val;

    return arr;
}

inline ARR
arrresize(ARR arr, int ncap)
{
    int *buf, len;

    buf = (int *)arr - 2;
    len = buf[0];

    if ((buf = realloc(buf, ncap * sizeof(TYPE) + 2 * sizeof(int))) == NULL) {
        return NULL;
    }

    buf[0] = len;
    buf[1] = ncap;

    return (ARR)(buf + 2);
}

inline TYPE
arrremove(ARR arr)
{
    return arr[--((int *)arr - 2)[0]];
}

inline int
arrlen(ARR arr)
{
    return ((int *)arr - 2)[0];
}

inline int
arrcap(ARR arr)
{
    return ((int *)arr - 2)[1];
}

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

    int *arr = arrnew();

    while ((num = get()) < limit) {
        arr = arrappend(arr, num);
    }

    for (i = 0; i < arrlen(arr); ++i) {
        process(arr[i]);
    }

    for (i = arrlen(arr)-1; i > 0; --i) {
        arr[i] -= arr[i-1];
    }

    for (i = arrlen(arr)-1; i >= 0; --i) {
        process(arrremove(arr));
    }

    arrdelete(arr);

    return 0;
}
