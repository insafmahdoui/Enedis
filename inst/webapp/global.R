#####################################################
# Nom script: global.R
# Auteur: Insaf Mahdoui
# Objectif: installer des packages et faire des tests
# Date mise à jour: 28/04/2024
#####################################################


# Chemin dossier ----------------------------------------------------------


data_save=paste0("www/data_save/")

# Packages ----------------------------------------------------------------
library(shiny)
library(bslib)
library(shinyWidgets)
library(scales)
library(bsicons)
library(plotly)
library(tidyverse) #traitement de données
library(Enedis)
library(leaflet)
library(COGiter)
library(sf)



# chargement des données --------------------------------------------------

data_conso_prod_dep=readRDS(paste0(data_save,"data_conso_prod_dep.rds"))

list_region=data_conso_prod_dep %>% distinct(NOM_REG) %>% arrange(NOM_REG)
list_departement=data_conso_prod_dep %>% distinct(NOM_DEP) %>% arrange(NOM_DEP)
list_annee=data_conso_prod_dep %>% distinct(Annee) %>% arrange(desc(Annee))


data_conso_prod=data_conso_prod_dep %>%
  mutate(maille="Département") %>%
  bind_rows(data_conso_prod_dep %>%
              mutate(Code_Departement="Région",NOM_DEP="Région") %>%
              group_by(Annee,Code_Departement,NOM_DEP,code_region,NOM_REG) %>%
              summarise_all(sum)%>%
              mutate(maille="Région"),
            data_conso_prod_dep %>%
              mutate(Code_Departement="Nationale",NOM_DEP="Nationale",
                     code_region="Nationale",NOM_REG="Nationale") %>%
              group_by(Annee,Code_Departement,NOM_DEP,code_region,NOM_REG) %>%
              summarise_all(sum)%>%
              mutate(maille="Nationale")) %>%
  mutate(Consommation_moyenne_MWh=Consommation_totale_MWh/Consommation_Nb_sites_totale,
         Production_moyenne_mwh=Production_totale_mwh/Production_nb_sites_totale)

rm("data_conso_prod_dep")


