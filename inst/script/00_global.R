#####################################################
# Nom script: Global.R
# Auteur: Insaf Mahdoui
# Objectif: installer des packages et faire des tests
# Date mise à jour: 28/04/2024
#####################################################



# Packages à installer ----------------------------------------------------


# install.packages("httr2")
# install.packages("tidyverse")
# install.packages("shiny")
# install.packages("bslib")
# install.packages("DT")
# install.packages("plotly")
# install.packages("usethis")
# install.packages("remotes")
# install.packages("devtools")


# Chemin dossier ----------------------------------------------------------

data_source=paste0("inst/data_source/")

# Packages ----------------------------------------------------------------

library(httr2)
library(tidyverse)
library(httr)
devtools::load_all()

