#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <stdbool.h>

#ifndef val_h
#define val_h

typedef enum
{
    TYPE_INT,
    TYPE_FLOAT,
    TYPE_STRING,
    TYPE_BOOL,
    TYPE_VOID,

} Type;

typedef struct
{
    Type type;

    union
    {
        int i;
        float f;
        char *s;
        int b;
    } data;

    char *place;

    bool is_constant;

} val;

#endif