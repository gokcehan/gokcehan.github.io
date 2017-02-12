//
// dyn_arr.c
//
// Dynamic array
//

#include <assert.h>
#include <stdlib.h>

#define ARR_INIT_CAP 2
#define ARR_GROW_RAT 2

#define TYPE int

struct arr {
    TYPE *buf;
    int   len;
    int   cap;
};

struct arr *arrnew(void);
struct arr *arrnewcap(int);
void        arrdelete(struct arr *);
int         arrappend(struct arr *, TYPE);
int         arrresize(struct arr *, int);
TYPE        arrremove(struct arr *);

inline struct arr *
arrnew(void)
{
    return arrnewcap(ARR_INIT_CAP);
}

inline struct arr *
arrnewcap(int cap)
{
    struct arr *arr;

    if ((arr = malloc(sizeof(struct arr))) == NULL) {
        return NULL;
    }

    if ((arr->buf = malloc(cap * sizeof(TYPE))) == NULL) {
        free(arr);
        return NULL;
    }

    arr->len = 0;
    arr->cap = cap;

    return arr;
}

inline void
arrdelete(struct arr *arr)
{
    free(arr->buf);
    free(arr);
}

inline int
arrappend(struct arr *arr, TYPE val)
{
    if (arr->cap <= arr->len && arrresize(arr, arr->cap * ARR_GROW_RAT) == -1) {
        return -1;
    }

    arr->buf[arr->len++] = val;

    return 0;
}

inline int
arrresize(struct arr *arr, int ncap)
{
    TYPE *nbuf;

    if ((nbuf = realloc(arr->buf, ncap * sizeof(TYPE))) == NULL) {
        return -1;
    }

    arr->cap = ncap;
    arr->buf = nbuf;

    return 0;
}

inline TYPE
arrremove(struct arr *arr)
{
    return arr->buf[--arr->len];
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

    struct arr *arr = arrnew();

    while ((num = get()) < limit) {
        arrappend(arr, num);
    }

    for (i = 0; i < arr->len; ++i) {
        process(arr->buf[i]);
    }

    for (i = arr->len-1; i > 0; --i) {
        arr->buf[i] -= arr->buf[i-1];
    }

    for (i = arr->len-1; i >= 0; --i) {
        process(arrremove(arr));
    }

    arrdelete(arr);

    return 0;
}
