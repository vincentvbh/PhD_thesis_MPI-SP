#ifndef CDECL_H
#define CDECL_H

#if defined(__WIN32__) || defined(__APPLE__)
#define decorate(s) _##s
#define cdecl2(s) decorate(s)
#define cdecl(s) cdecl2(s)
#else
#define cdecl(s) s
#endif

#endif

