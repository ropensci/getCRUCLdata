# vignettes that depend on internet access need to be precompiled and take a
# while to run
knitr::knit("vignettes/getCRUCLdata.Rmd.orig", "vignettes/getCRUCLdata.Rmd")

# remove file path such that vignettes will build with figures
replace <- readLines("vignettes/getCRUCLdata.Rmd")
replace <- gsub("<img src=\"vignettes/", "<img src=\"", replace)
fileConn <- file("vignettes/getCRUCLdata.Rmd")
writeLines(replace, fileConn)
close(fileConn)

# build vignettes
devtools::build_vignettes()

# move resource files to /doc
resources <-
  list.files("vignettes/", pattern = ".png$", full.names = TRUE)
file.copy(from = resources,
          to = "doc",
          overwrite =  TRUE)


