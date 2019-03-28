# HTTP mirror to support R 3.1
options(repos = c("https://cloud.r-project.org", "http://cloud.r-project.org"))

# Install a package without compilation
install.packages("R6")
library(R6)

# Install a package with compilation
install.packages("BASIX")
library(BASIX)

# Check that the time zone database is present
# https://stat.ethz.ch/R-manual/R-devel/library/base/html/timezones.html
if (length(OlsonNames()) == 0) {
  stop("Time zone database not found")
}

# Check that built-in packages can be loaded
for (pkg in rownames(installed.packages(priority = c("base", "recommended")))) {
  if (!require(pkg, character.only = TRUE)) {
    stop(sprintf("failed to load built-in package %s", pkg))
  }
}

# Show capabilities. Warnings are returned on missing libraries.
tryCatch(capabilities(), warning = function(w) {
  print(capabilities())
  stop(sprintf("missing libraries: %s", w$message))
})

# Check graphics devices
for (dev in c("png", "jpeg", "tiff", "svg", "bmp", "pdf")) {
  tryCatch(do.call(dev, args = list()), warning = function(w) {
    stop(sprintf("graphics device %s failed: %s", dev, w$message))
  })
}
