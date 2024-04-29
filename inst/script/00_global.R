# Informations script -----------------------------------------------------

# Nom script: 00_global.R
# Auteur: Insaf Mahdoui
# Objectif: Paramètrage et lancement du workflow de traitement de données
# Date mise à jour: 28/04/2024




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
# install.packages("shinyWidgets")
# install.packages("bsicons")
# install.packages("leaflet")
# devtools::install_github("pascalirz/tod")
# install.packages("sf")
# install.packages("rgdal")

# Chemin dossier ----------------------------------------------------------


data_source=paste0("inst/data_source/")
data_save=paste0("inst/webapp/www/data_save/")
script=paste0("inst/script/")
# Packages ----------------------------------------------------------------

library(tidyverse) #traitement de données
library(httr2) #Requete via Api
library(COGiter) #gère les référentiels de géographie
library(sf)
library(leaflet)
library(Enedis)

#devtools::load_all()

# charger les tables département et région pour corriger les noms départements/régions
data("departements")
data("regions")

pal <- colorNumeric(scales::seq_gradient_pal(low = "yellow", high = "red",
                                             space = "Lab"), domain = as.numeric(dpt2$DEP))

dpt2 <- st_transform(COGiter::departements_geo, crs = 4326)

m <- leaflet() %>% addTiles() %>%
  addPolygons(data = dpt2,color=~pal(as.numeric(dpt2$DEP)),fillOpacity = 0.6,
              stroke = TRUE,weight=1)
m
# Lancer traitement de données --------------------------------------------

source(paste0(script,"01_traitement.R"))
