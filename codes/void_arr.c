//
// void_arr.c
//
// Void pointer array
//

#include <stdlib.h>

#define ARR_INIT_CAP 2
#define ARR_GROW_RAT 2

#define TYPE void *

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

void reset(void)
{
    a = 0;
    b = 1;
    puts("--");
}

void process_int(int i)
{
    printf("%d\n", i);
}

void process_intp(int *ip)
{
    printf("%d\n", *ip);
}

void process_charp(char *cp)
{
    printf("%s\n", cp);
}

int main(int argc, char *argv[])
{
    int i, *ip, num;
    struct arr *arr;

    int limit = argc < 2 ? LIMIT : atoi(argv[1]);

    printf("sizeof(int)    = %zu\n", sizeof(int));
    printf("sizeof(int *)  = %zu\n", sizeof(int *));
    printf("sizeof(void *) = %zu\n", sizeof(char *));

    // int (wrong)

    arr = arrnew();

    while ((num = get()) < limit) {
        // warning: passing argument 2 of ‘arrappend’ makes pointer from integer without a cast [-Wint-conversion]
        //          arrappend(arr, num);
        //                         ^
        // note: expected ‘void *’ but argument is of type ‘int’
        //  arrappend(struct arr *arr, TYPE val)
        //  ^
        // arrappend(arr, num);

        // warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
        //          arrappend(arr, (void *)num);
        //                         ^
        arrappend(arr, (void *)num);
    }

    for (i = 0; i < arr->len; ++i) {
        process_int(arr->buf[i]);
    }

    for (i = arr->len-1; i > 0; --i) {
        arr->buf[i] -= arr->buf[i-1];
    }

    for (i = arr->len-1; i >= 0; --i) {
        process_int(arrremove(arr));
    }

    arrdelete(arr);

    // int *

    reset();

    arr = arrnew();

    while ((num = get()) < limit) {
        ip = malloc(sizeof(int));
        *ip = num;
        arrappend(arr, ip);
    }

    for (i = 0; i < arr->len; ++i) {
        process_intp(arr->buf[i]);
    }

    for (i = arr->len-1; i > 0; --i) {
        *(int *)(arr->buf[i]) -= *(int *)(arr->buf[i-1]);
    }

    for (i = arr->len-1; i >= 0; --i) {
        process_intp(arrremove(arr));
        free(arr->buf[arr->len]);
    }

    arrdelete(arr);

    // char *

    arr = arrnew();

    arrappend(arr, "one");
    arrappend(arr, "two");
    arrappend(arr, "three");

    for (i = 0; i < arr->len; ++i) {
        process_charp(arr->buf[i]);
    }

    arrdelete(arr);

    return 0;
}
