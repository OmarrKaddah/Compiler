// quadruples.h
#ifndef QUADRUPLES_H
#define QUADRUPLES_H

#define MAX_QUADS 1000

typedef struct {
    char op[10];
    char arg1[50];
    char arg2[50];
    char result[50];
} Quadruple;

extern Quadruple quads[MAX_QUADS];
extern int quad_count;

void add_quad(const char *op, const char *arg1, const char *arg2, const char *result);

void print_quads();

#endif
