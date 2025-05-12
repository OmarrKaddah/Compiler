#include "val.h"

#ifndef param_h
#define param_h

typedef struct Parameter
{
    char *name;
    val *value;
    struct Parameter *next;

} Parameter;

#endif