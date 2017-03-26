//
// ring.c
//
// Dynamic ring buffer implementation
//
// This is an implementation of a dynamically growing ring buffer. Ring is
// stored as a plain array with an offset value. Array's front and back are
// considered connected as a ring and this offset represent the starting
// position on this ring. Offset value is reset to zero after each
// reallocation.
//
// This structure can be used as a queue or dequeue when the maximum number of
// possible elements is not determined beforehand. Random access in constant
// time is also possible if desired. This is a cache-friendly implementation
// since elements are held in a plain array.
//
// Calculating the actual array position of a given element index is achieved
// with the following formula:
//
//     pos(ind) = (ind + off) % cap
//
// This can be replaced with the following bitmasking operation when the
// capacity is a power of two:
//
//     pos(ind) = (ind + off) & (cap - 1)
//
// Bitmasking is usually more performant than the modulo operator. Hence
// capacities are rounded up to a power of two at all times and bitmasking is
// used to calculate positions in this implementation.
//

#include <stdlib.h>
#include <string.h>

#define RING_INIT_CAP 2
#define RING_GROW_RAT 2

int nextpow2(int);

inline int
nextpow2(int i)
{
    int next = 1;

    while (next < i) {
        next *= 2;
    }

    return next;
}

#define TYPE int

struct ring {
    TYPE *buf;
    int   off;
    int   len;
    int   cap;
};

struct ring *ringnew(void);
struct ring *ringnewcap(int);
void         ringdelete(struct ring *);
int          ringresize(struct ring *, int);
int          ringputb(struct ring *, TYPE);
int          ringputf(struct ring *, TYPE);
TYPE         ringpopb(struct ring *);
TYPE         ringpopf(struct ring *);
TYPE         ringget(struct ring *, int);
void         ringset(struct ring *, int, TYPE);

inline struct ring *
ringnew(void)
{
    return ringnewcap(RING_INIT_CAP);
}

inline struct ring *
ringnewcap(int cap)
{
    struct ring *ring;

    cap = nextpow2(cap);

    if ((ring = malloc(sizeof(struct ring))) == NULL) {
        return NULL;
    }

    if ((ring->buf = malloc(cap * sizeof(TYPE))) == NULL) {
        free(ring);
        return NULL;
    }

    ring->off = 0;
    ring->len = 0;
    ring->cap = cap;

    return ring;
}

inline void
ringdelete(struct ring *ring)
{
    free(ring->buf);
    free(ring);
}

inline int
ringresize(struct ring *ring, int ncap)
{
    TYPE *nbuf;

    ncap = nextpow2(ncap);

    if ((nbuf = malloc(ncap * sizeof(TYPE))) == NULL) {
        return -1;
    }

    int blen = ring->len - ring->off;
    int flen = ring->off;

    memcpy(nbuf, ring->buf + ring->off, blen * sizeof(TYPE));
    memcpy(nbuf + blen, ring->buf, flen * sizeof(TYPE));

    ring->off = 0;
    ring->cap = ncap;
    ring->buf = nbuf;

    return 0;
}

inline int
ringputb(struct ring *ring, TYPE val)
{
    if (ring->cap <= ring->len &&
            ringresize(ring, ring->cap * RING_GROW_RAT) == -1) {
        return -1;
    }

    ring->buf[(ring->off + ring->len) & (ring->cap - 1)] = val;
    ring->len++;

    return 0;
}

inline int
ringputf(struct ring *ring, TYPE val)
{
    if (ring->cap <= ring->len) {
        ringresize(ring, ring->cap * RING_GROW_RAT);
    }

    ++ring->len;
    --ring->off;
    ring->buf[ring->off] = val;

    return 0;
}

inline TYPE
ringpopb(struct ring *ring)
{
    --ring->len;
    return ring->buf[(ring->len + ring->off) & (ring->cap - 1)];
}

inline TYPE
ringpopf(struct ring *ring)
{
    --ring->len;
    ++ring->off;
    return ring->buf[ring->off - 1];
}

inline TYPE
ringget(struct ring *ring, int ind)
{
    return ring->buf[(ind + ring->off) & (ring->cap - 1)];
}

inline void
ringset(struct ring *ring, int ind, TYPE val)
{
    ring->buf[(ind + ring->off) & (ring->cap - 1)] = val;
}

////////////////////////////////////////////////////////////////////////////////

#include <assert.h>

//
// The following scenario is tested where : represents the offset
//
// : | |
// :1| |
// :1|2|
// :1|2|3| |
// | :2|3| |
// | :2|3|4|
// |5:2|3|4|
// :2|3|4|5|6| | | |
//

int main(void)
{
    struct ring *ring = ringnew();

    ringputb(ring, 1);
    ringputb(ring, 2);
    ringputb(ring, 3);

    assert(ring->len == 3);

    assert(ringget(ring, 0) == 1);
    assert(ringget(ring, 1) == 2);
    assert(ringget(ring, 2) == 3);

    ringpopf(ring);

    assert(ring->len == 2);

    assert(ringget(ring, 0) == 2);
    assert(ringget(ring, 1) == 3);

    ringputb(ring, 4);
    ringputb(ring, 5);
    ringputb(ring, 6);

    assert(ring->len == 5);

    assert(ringget(ring, 0) == 2);
    assert(ringget(ring, 1) == 3);
    assert(ringget(ring, 2) == 4);
    assert(ringget(ring, 3) == 5);
    assert(ringget(ring, 4) == 6);

    return 0;
}
