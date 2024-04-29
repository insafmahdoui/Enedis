
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Enedis

<!-- badges: start -->
<!-- badges: end -->

Explorer les données open source d’Enedis

## Installation

``` r
# install.packages("devtools")
devtools::install_github("insafmahdoui/Enedis")
```

## Example

``` r
library(httr2)
library(tidyverse)
library(httr)
library(Enedis)

get_info_dataset(url="https://data.enedis.fr/api/explore/v2.1/catalog/",data_id="production-electrique-par-filiere-a-la-maille-departement")
#> $nb_ligne
#> [1] 3384
#> 
#> $nom_colonnes
#>  [1] "annee"                                               
#>  [2] "nom_departement"                                     
#>  [3] "code_departement"                                    
#>  [4] "nom_region"                                          
#>  [5] "code_region"                                         
#>  [6] "domaine_de_tension"                                  
#>  [7] "nb_sites_photovoltaique_enedis"                      
#>  [8] "energie_produite_annuelle_photovoltaique_enedis_mwh" 
#>  [9] "nb_sites_eolien_enedis"                              
#> [10] "energie_produite_annuelle_eolien_enedis_mwh"         
#> [11] "nb_sites_hydraulique_enedis"                         
#> [12] "energie_produite_annuelle_hydraulique_enedis_mwh"    
#> [13] "nb_sites_bio_energie_enedis"                         
#> [14] "energie_produite_annuelle_bio_energie_enedis_mwh"    
#> [15] "nb_sites_cogeneration_enedis"                        
#> [16] "energie_produite_annuelle_cogeneration_enedis_mwh"   
#> [17] "nb_sites_autres_filieres_enedis"                     
#> [18] "energie_produite_annuelle_autres_filieres_enedis_mwh"
#> [19] "geom"                                                
#> [20] "geo_point_2d"
```

## Webapp Production et consommation d’électricité

``` r
library(Enedis)

run_app()
```

![](https://raw.githubusercontent.com/insafmahdoui/Enedis/main/inst/webapp/exemple.PNG)
