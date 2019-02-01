# HTTP mirror to support R 3.1
options(repos = c("https://cloud.r-project.org", "http://cloud.r-project.org"))

# Install a package without compilation
install.packages("R6")
library(R6)

# Install a package with compilation
install.packages("BASIX")
library(BASIX)