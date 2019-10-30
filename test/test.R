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

# Check that TZ is configured properly
# https://github.com/rstudio/r-docker/issues/46
tryCatch(Sys.timezone(), warning = function(w) {
  stop("Sys.timezone() returned warning: ", w)
})
if (!identical(Sys.timezone(), "UTC")) {
  stop("TZ not set to UTC")
}

# Check that we're in a UTF-8 native locale (e.g. LANG=C.UTF-8 or LANG=en_US.UTF-8)
# https://stat.ethz.ch/R-manual/R-devel/library/base/html/locales.html
if (!l10n_info()[["UTF-8"]]) {
  stop("not in a UTF-8 native locale")
}

# Check iconv support
if (!capabilities("iconv") || !all(c("ASCII", "LATIN1", "UTF-8") %in% iconvlist())) {
  stop("missing iconv support")
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
# https://stat.ethz.ch/R-manual/R-devel/library/grDevices/html/Devices.html
for (dev_name in c("png", "jpeg", "tiff", "svg", "bmp", "pdf", "postscript",
                   "xfig", "pictex", "cairo_pdf", "cairo_ps")) {
  # Skip unsupported graphics devices (e.g. tiff in R >= 3.3 on CentOS 6)
  if (dev_name %in% names(capabilities()) && capabilities(dev_name) == FALSE) {
    next
  }
  dev <- getFromNamespace(dev_name, "grDevices")
  tryCatch({
    file <- tempfile()
    on.exit(unlink(file))
    if (dev_name == "xfig") {
      # Suppress warning from xfig when onefile = FALSE (the default)
      dev(file, onefile = TRUE)
    } else {
      dev(file)
    }
    plot(1)
    dev.off()
  }, warning = function(w) {
    # Catch errors which manifest as warnings (e.g. "failed to load cairo DLL")
    stop(sprintf("graphics device %s failed: %s", dev_name, w$message))
  })
}

# Check for unexpected output from graphics/text rendering.
# Run externally to capture output from external processes.
# For example, "Pango-WARNING **: failed to choose a font, expect ugly output"
# messages when rendering text without any system fonts installed.
output <- system2(R.home("bin/Rscript"), "-e 'png(tempfile()); plot(1)'", stdout = TRUE, stderr = TRUE)
if (length(output) > 0) {
  stop(sprintf("unexpected output returned from plotting:\n%s", paste(output, collapse = "\n")))
}

# Check download methods: libcurl (supported in R >= 3.2) and internal (based on libxml)
if ("libcurl" %in% names(capabilities())) {
  download.file("https://cloud.r-project.org", tempfile(), "libcurl")
}
tmpfile <- tempfile()
write.csv("test", tmpfile)
download.file(sprintf("file://%s", tmpfile), tempfile(), "internal")

# Check that a pager is configured and help pages work
# https://stat.ethz.ch/R-manual/R-devel/library/base/html/file.show.html
output <- system2(R.home("bin/Rscript"), "-e 'help(stats)'", stdout = TRUE)
if (length(output) == 0) {
  stop("failed to display help pages; check that a pager is configured properly")
}

# Smoke test BLAS/LAPACK functionality. R may start just fine with an incompatible
# BLAS/LAPACK library, and only fail when calling a BLAS or LAPACK routine.
stopifnot(identical(crossprod(matrix(1)), matrix(1)))
stopifnot(identical(chol(matrix(1)), matrix(1)))
