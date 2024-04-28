#####################################################
# Nom script: Global.R
# Auteur: Insaf Mahdoui
# Objectif: Préparation des données pour l'analyse
# Date mise à jour: 28/04/2024
#####################################################




# Préparation données Production electrique par departement-------------------------------------------



data_id="production-electrique-par-filiere-a-la-maille-departement"

info_dataset=get_info_dataset(data_id=data_id)

# formater la table production-electrique

#colonnes=info_dataset$nom_colonnes[-c(19:20)]

#glue::glue('{colonnes}=pluck(.x,"{colonnes}"),')


data_production=get_row_dataset_api_enedis(data_id=data_id,nb_ligne=info_dataset$nb_ligne) %>%
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


#str(data_production)

#data_production %>% count(annee)


data_production_dep=data_production %>% group_by(annee,nom_departement,code_departement,nom_region,code_region) %>%
  summarise_if(is.numeric,sum) %>% ungroup() %>%
  mutate(annee=as.numeric(annee))

#data_production_dep %>% count(annee)



# Préparation Données consoammation electrique par departement---------------------------------------------------



data_consommation0=data.table::fread(paste0(data_source,"consommation-annuelle-d-electricite-et-gaz-par-departement@agenceore.csv")) %>%
  select("Année","Code Département","Nom Département","CODE CATEGORIE CONSOMMATION","Nb sites", "Conso totale (MWh)","Conso moyenne (MWh)")

names(data_consommation0)=c("Annee","Code_Departement","Nom_Departement","CODE_CATEGORIE_CONSOMMATION","Nb_sites", "Conso_totale_MWh","Conso_moyenne_MWh")


data_consommation=data_consommation0 %>%
  mutate(Code_Departement=if_else(Code_Departement%in%c("2A","2B"),"20",Code_Departement)) %>%
  filter(!is.na(Nom_Departement),!is.na(Code_Departement),Nom_Departement!='',Code_Departement!='',
         nchar(Code_Departement)<3) %>%
  mutate(Code_Departement=if_else(as.numeric(Code_Departement)<10,paste0("0",as.numeric(Code_Departement)),
                                  Code_Departement)) %>%
  filter(Code_Departement!="20")

data_consommation_departement_categ=data_consommation %>%
  group_by(Annee,Code_Departement,CODE_CATEGORIE_CONSOMMATION) %>%
  summarise(Conso_totale_MWh=sum(Conso_totale_MWh,na.rm=TRUE),
            Nb_sites=sum(Nb_sites,na.rm=TRUE)) %>% ungroup() %>%
  mutate(Conso_moyenne_MWh=Conso_totale_MWh/Nb_sites)

data_consommation_departement=data_consommation %>%
  group_by(Annee,Code_Departement) %>%
  summarise(Conso_totale_MWh=sum(Conso_totale_MWh,na.rm=TRUE),
            Nb_sites=sum(Nb_sites,na.rm=TRUE)) %>% ungroup()%>%
  mutate(Conso_moyenne_MWh=Conso_totale_MWh/Nb_sites)



# Préparation de la table finale ------------------------------------------

#Jointure entre la table consoammation et production

data_conso_prod_dep=data_consommation_departement %>%
  inner_join(data_production_dep,by=c("Annee"="annee","Code_Departement"="code_departement")) %>%
  mutate(Prod_totale=rowSums(across(starts_with("energie_produite_annuelle")),na.rm=TRUE)) %>%
  mutate_if(is.numeric,replace_na,0)
