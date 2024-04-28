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



# Packages ----------------------------------------------------------------

library(httr2)
library(tidyverse)
library(httr)
devtools::load_all()

# API Enedis --------------------------------------------------------------

data_id="production-electrique-par-filiere-a-la-maille-departement"

info_dataset=get_info_dataset(data_id=data_id)

# formater la table production-electrique

#colonnes=info_dataset$nom_colonnes[-c(19:20)]

#glue::glue('{colonnes}=pluck(.x,"{colonnes}"),')


data_departement=get_row_dataset_api_enedis(data_id=data_id,nb_ligne=info_dataset$nb_ligne) %>%
  map_dfr(~tibble(annee=pluck(.x,"annee"),
                              nom_departement=pluck(.x,"nom_departement"),
                                code_departement=pluck(.x,"code_departement"),
                                nom_region=pluck(.x,"nom_region"),
                                code_region=pluck(.x,"code_region"),
                                domaine_de_tension=pluck(.x,"domaine_de_tension"),
                                nb_sites_photovoltaique_enedis=pluck(.x,"nb_sites_photovoltaique_enedis"),
                                energie_produite_annuelle_photovoltaique_enedis_mwh=pluck(.x,"energie_produite_annuelle_photovoltaique_enedis_mwh"),
                                nb_sites_eolien_enedis=pluck(.x,"nb_sites_eolien_enedis"),
                                energie_produite_annuelle_eolien_enedis_mwh=pluck(.x,"energie_produite_annuelle_eolien_enedis_mwh"),
                                nb_sites_hydraulique_enedis=pluck(.x,"nb_sites_hydraulique_enedis"),
                                energie_produite_annuelle_hydraulique_enedis_mwh=pluck(.x,"energie_produite_annuelle_hydraulique_enedis_mwh"),
                                nb_sites_bio_energie_enedis=pluck(.x,"nb_sites_bio_energie_enedis"),
                                energie_produite_annuelle_bio_energie_enedis_mwh=pluck(.x,"energie_produite_annuelle_bio_energie_enedis_mwh"),
                                nb_sites_cogeneration_enedis=pluck(.x,"nb_sites_cogeneration_enedis"),
                                energie_produite_annuelle_cogeneration_enedis_mwh=pluck(.x,"energie_produite_annuelle_cogeneration_enedis_mwh"),
                                nb_sites_autres_filieres_enedis=pluck(.x,"nb_sites_autres_filieres_enedis"),
                                energie_produite_annuelle_autres_filieres_enedis_mwh=pluck(.x,"energie_produite_annuelle_autres_filieres_enedis_mwh")))


str(data_res)
