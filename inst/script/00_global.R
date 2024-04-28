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
# devtools::install_github("insafmahdoui/Enedis")
# devtools::install_github("MaelTheuliere/COGiter")

# Chemin dossier ----------------------------------------------------------

data_source=paste0("inst/data_source/")

# Packages ----------------------------------------------------------------

library(tidyverse) #traitement de données
library(httr2) #Requete via Api
library(COGiter) #gère les référentiels de géographie
library(Enedis)

devtools::load_all()

# charger les tables département et région pour corriger les noms départements/régions
data("departements")
data("regions")
