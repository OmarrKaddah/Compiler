// quadruples.c
#include <stdio.h>
#include <string.h>
#include "quadruples.h"

Quadruple quads[MAX_QUADS];
int quad_count = 0;

void add_quad(const char *op, const char *arg1, const char *arg2, const char *result) {
    if (quad_count >= MAX_QUADS) {
        fprintf(stderr, "Too many quadruples\n");
        return;
    }
    strncpy(quads[quad_count].op, op, sizeof(quads[quad_count].op));
    strncpy(quads[quad_count].arg1, arg1, sizeof(quads[quad_count].arg1));
    strncpy(quads[quad_count].arg2, arg2, sizeof(quads[quad_count].arg2));
    strncpy(quads[quad_count].result, result, sizeof(quads[quad_count].result));
    quad_count++;
}

void print_quads() {
    printf("\n=== Generated Quadruples ===\n");
    for (int i = 0; i < quad_count; i++) {
        printf("(%s, %s, %s, %s)\n",
               quads[i].op,
               quads[i].arg1[0] ? quads[i].arg1 : "_",
               quads[i].arg2[0] ? quads[i].arg2 : "_",
               quads[i].result[0] ? quads[i].result : "_");
    }
}
