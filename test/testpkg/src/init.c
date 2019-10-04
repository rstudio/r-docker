#include <R.h>
#include <Rinternals.h>
#include <R_ext/Rdynload.h>

#define CALLDEF(name, n)  {#name, (DL_FUNC) &name, n}
#define FDEF(name)  {#name, (DL_FUNC) &F77_SUB(name), sizeof(name ## _t)/sizeof(name ## _t[0]), name ##_t}

extern SEXP add(SEXP, SEXP);
extern SEXP subtract(SEXP, SEXP);

void F77_SUB(square)(int *n, int *answer);

static R_NativePrimitiveArgType square_t[] = {
    INTSXP,
    INTSXP
};

static const R_CallMethodDef CallEntries[] = {
    CALLDEF(add, 2),
    CALLDEF(subtract, 2),
    {NULL, NULL, 0}
};

static const R_FortranMethodDef fMethods[] = {
    FDEF(square),
    {NULL, NULL, 0}
};

void R_init_testpkg(DllInfo *dll)
{
    R_registerRoutines(dll, NULL, CallEntries, fMethods, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
