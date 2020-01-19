// pch.h: This is a precompiled header file.
// Files listed below are compiled only once, improving build performance for future builds.
// This also affects IntelliSense performance, including code completion and many code browsing features.
// However, files listed here are ALL re-compiled if any one of them is updated between builds.
// Do not add files here that you will be updating frequently as this negates the performance advantage.

#ifndef PCH_H
#define PCH_H

#if defined(_WIN32) || defined(_WIN64)
// add headers that you want to pre-compile here
#include "framework.h"
#endif

#endif //PCH_H

#ifdef __APPLE__
    #ifndef NULL
    #define NULL 0
    #endif

    #ifndef BOOL
    #define BOOL bool
    #endif
#include <string.h>
#endif
