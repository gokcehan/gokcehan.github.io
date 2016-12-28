//
// rd.c
//
// Recursive descent parser for simple expressions
//
// The expression grammar is as follows:
//
//     E ::= T {+ T}
//     T ::= F {* F}
//     F ::= ( E ) | Int
//
// Expressions are parsed and evaluated on the fly.


#include <stdio.h>
#include <ctype.h>

#define MAXLINE 1000

int expr(void);
int term(void);
int fact(void);
int scan(char *s, int lim);

char *curr;

// E ::= T {+ T}
int expr(void)
{
    int result = term();
    while (*curr == '+') {
        ++curr;
        result += term();
    }
    return result;
}

// T ::= F {* F}
int term(void)
{
    int result = fact();
    while (*curr == '*') {
        ++curr;
        result *= fact();
    }
    return result;
}

// F ::= ( E ) | Int
int fact(void)
{
    int result;

    if (*curr == '(') {
        ++curr;
        result = expr();
        if (*curr == ')') {
            ++curr;
        } else {
            printf("error: expected ')'\n");
            return 0;
        }
        return result;
    } else if (isdigit(*curr)) {
        result = *curr - '0';
        ++curr;
        while (isdigit(*curr)) {
            result = result * 10 + (*curr - '0');
            ++curr;
        }
        return result;
    } else {
        printf("error: expected a parenthesis or a number at: %c\n", *curr);
        return 0;
    }
}

int scan(char *s, int lim)
{
    int i, c;

    i = 0;
    while (--lim > 0 && (c = getchar()) != EOF && c != '\n') {
        if (!isspace(c)) {
            s[i++] = c;
        }
    }
    if (c == '\n') {
        s[i++] = c;
    }
    s[i] = '\0';
    return i;
}

int main(void)
{
    char line[MAXLINE];

    printf("> ");
    while (scan(line, MAXLINE)) {
        curr = line;
        printf("= %d\n> ", expr());
    }
    return 0;
}
