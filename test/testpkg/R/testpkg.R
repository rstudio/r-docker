#' @useDynLib testpkg, .registration = TRUE
"_PACKAGE"

#' Add it together
#'
#' @param a Number
#' @param b Number
#' @return Sum of numbers
#' @export
add_it <- function(a, b) {
  .Call("add", a, b)
}

#' Subtract it
#'
#' @param a Number
#' @param b Number
#' @return Difference of numbers
#' @export
subtract_it <- function(a, b) {
  .Call("subtract", a, b)
}

#' Square it up
#'
#' @param n Integer
#' @return Square
#' @export
square_it <- function(n) {
  result <- .Fortran("square", n = as.integer(n), answer = as.integer(1))
  result$answer
}
