//
// dyn_arr_cat.c
//
// Dynamic array (concatenation)
//

#include <stdlib.h>

#define ARR_INIT_CAP 2
#define ARR_GROW_RAT 2

#define DEFINE_ARR(TYPE, TAIL)                                                 \
                                                                               \
struct arr_##TAIL {                                                            \
    TYPE *buf;                                                                 \
    int   len;                                                                 \
    int   cap;                                                                 \
};                                                                             \
                                                                               \
struct arr_##TAIL *arrnew_##TAIL(void);                                        \
struct arr_##TAIL *arrnewcap_##TAIL(int);                                      \
void               arrdelete_##TAIL(struct arr_##TAIL *);                      \
int                arrappend_##TAIL(struct arr_##TAIL *, TYPE);                \
int                arrresize_##TAIL(struct arr_##TAIL *, int);                 \
TYPE               arrremove_##TAIL(struct arr_##TAIL *);                      \
                                                                               \
inline struct arr_##TAIL *                                                     \
arrnew_##TAIL(void)                                                            \
{                                                                              \
    return arrnewcap_##TAIL(ARR_INIT_CAP);                                     \
}                                                                              \
                                                                               \
inline struct arr_##TAIL *                                                     \
arrnewcap_##TAIL(int cap)                                                      \
{                                                                              \
    struct arr_##TAIL *arr;                                                    \
                                                                               \
    if ((arr = malloc(sizeof(struct arr_##TAIL))) == NULL) {                   \
        return NULL;                                                           \
    }                                                                          \
                                                                               \
    if ((arr->buf = malloc(cap * sizeof(TYPE))) == NULL) {                     \
        free(arr);                                                             \
        return NULL;                                                           \
    }                                                                          \
                                                                               \
    arr->len = 0;                                                              \
    arr->cap = cap;                                                            \
                                                                               \
    return arr;                                                                \
}                                                                              \
                                                                               \
inline void                                                                    \
arrdelete_##TAIL(struct arr_##TAIL *arr)                                       \
{                                                                              \
    free(arr->buf);                                                            \
    free(arr);                                                                 \
}                                                                              \
                                                                               \
inline int                                                                     \
arrappend_##TAIL(struct arr_##TAIL *arr, TYPE val)                             \
{                                                                              \
    if (arr->cap <= arr->len &&                                                \
            arrresize_##TAIL(arr, arr->cap * ARR_GROW_RAT) == -1) {            \
        return -1;                                                             \
    }                                                                          \
                                                                               \
    arr->buf[arr->len++] = val;                                                \
                                                                               \
    return 0;                                                                  \
}                                                                              \
                                                                               \
inline int                                                                     \
arrresize_##TAIL(struct arr_##TAIL *arr, int ncap)                             \
{                                                                              \
    TYPE *nbuf;                                                                \
                                                                               \
    if ((nbuf = realloc(arr->buf, ncap * sizeof(TYPE))) == NULL) {             \
        return -1;                                                             \
    }                                                                          \
                                                                               \
    arr->cap = ncap;                                                           \
    arr->buf = nbuf;                                                           \
                                                                               \
    return 0;                                                                  \
}                                                                              \
                                                                               \
inline TYPE                                                                    \
arrremove_##TAIL(struct arr_##TAIL *arr)                                       \
{                                                                              \
    return arr->buf[--arr->len];                                               \
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

DEFINE_ARR(int, int)
DEFINE_ARR(char *, charp)

int main(int argc, char *argv[])
{
    int i, num;

    int limit = argc < 2 ? LIMIT : atoi(argv[1]);

    // int

    struct arr_int *arr = arrnew_int();

    while ((num = get()) < limit) {
        arrappend_int(arr, num);
    }

    for (i = 0; i < arr->len; ++i) {
        process(arr->buf[i]);
    }

    for (i = arr->len-1; i > 0; --i) {
        arr->buf[i] -= arr->buf[i-1];
    }

    for (i = arr->len-1; i >= 0; --i) {
        process(arrremove_int(arr));
    }

    arrdelete_int(arr);

    // char *

    struct arr_charp *words = arrnew_charp();

    arrappend_charp(words, "one");
    arrappend_charp(words, "two");
    arrappend_charp(words, "three");

    for (i = 0; i < words->len; ++i) {
        puts(words->buf[i]);
    }

    arrdelete_charp(words);

    return 0;
}
