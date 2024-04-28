#' get_info_dataset
#'
#' Récuperer le nombre de lignes et les noms de colonnes d'une dataset opendata Enedis
#' @param url character: url de l'api explore/v2.1/catalog de Enedis
#' @param data_id character: Identifiant du dataset
#'
#' @return list avec 2 elements
#' nb_ligne: nombres de lignes dans la dataset
#' nom_colonnes: les noms de colonnes dans la dataset
#' @export
#'
#' @examples
#' get_info_dataset(url="https://data.enedis.fr/api/explore/v2.1/catalog/",data_id="production-electrique-par-filiere-a-la-maille-departement")
get_info_dataset=function(url="https://data.enedis.fr/api/explore/v2.1/catalog/",
                          data_id="production-electrique-par-filiere-a-la-maille-departement"){

  req <- request(paste0(url,'datasets/',data_id,"/records?limit=1")) %>% req_perform()
  results=req %>%  resp_body_json() %>% pluck("results")


  list(nb_ligne=req %>%  resp_body_json() %>% pluck("total_count"),nom_colonnes=names(results[[1]]))

}
