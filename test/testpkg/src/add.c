#include <R.h>
#include <Rinternals.h>

SEXP add(SEXP a, SEXP b)
{
  SEXP result = PROTECT(allocVector(REALSXP, 1));
  REAL(result)[0] = asReal(a) + asReal(b);
  UNPROTECT(1);
  return result;
}
