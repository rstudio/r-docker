library(testpkg)

stopifnot(add_it(1, 2) == 3)
stopifnot(subtract_it(1, 2) == -1)
stopifnot(square_it(3) == 9)
