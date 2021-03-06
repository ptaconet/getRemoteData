require(usethis)
require(devtools)
require(attachment)
require(pkgdown)
require(magrittr)
## See tutorials here : https://rtask.thinkr.fr/blog/rmd-first-when-development-starts-with-documentation/
## and https://usethis.r-lib.org/articles/articles/usethis-setup.html
## and video here : http://www.user2019.fr/static/pres/t257651.zip

## create the package
usethis::create_package("/home/ptaconet/getremotedata")
## Manual step : Create a dev_history.R file that archives all the package history steps. Then copy it to the package folder.
## Then proceed :
usethis::use_build_ignore("dev_history.R")
usethis::use_git()
usethis::use_gpl3_license()
devtools::check()
usethis::proj_get()

## Manual steps : If not installed, install these packages
# system("brew install libssh2")
# system("brew install libgit2")
# install.packages("git2r")

## Manual step : Fill-in DESCRIPTION file with title and description of the package
## Manual step : If not already done, add a local SSH key following the instructions here : https://help.github.com/en/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent
## Then proceed :
usethis::use_github()
devtools::install()
usethis::use_readme_rmd()

## Manual step : Commit and push

## Document functions and dependencies
attachment::att_to_description()
## Check the package
devtools::check()

## Manual step : Add example dataset in inst/example-data

#usethis::use_vignette("aa-exploration")
# Document functions and dependencies
attachment::att_to_description()
# Check the package
devtools::check()

devtools::install()

### add a config file with username and password to usgs
file.create("config.yml")
usethis::use_build_ignore("config.yml")
usethis::use_git_ignore("config.yml")


  ## To build a website with home and vignettes
usethis::use_package_doc()
usethis::use_tibble()
devtools::document()
pkgdown::build_site()
## Manual step : go to the settings of the package on the github page, then under "github page" put "master branch /docs folder"


grdMetadata_internal <- read.csv("/home/ptaconet/getremotedata/.data_collections.csv",stringsAsFactors =F ) %>% dplyr::arrange(collection)
grdVariables_internal <- read.csv("/home/ptaconet/getremotedata/.variables.csv",stringsAsFactors =F ) %>% dplyr::arrange(collection)

usethis::use_data(grdMetadata_internal,grdVariables_internal,internal = TRUE,overwrite = TRUE)

devtools::build_vignettes()
devtools::install(build_vignettes = TRUE)


