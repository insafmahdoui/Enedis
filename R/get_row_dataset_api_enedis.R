#' get_row_dataset_api_enedis
#'
#' Récuperer des lignes d'une dataset open data Enedis
#' @param url character : url de l'api records/1.0/search de Enedis
#' @param data_id character: Identifiant du dataset
#' @param debut_ligne integer: Index du premier résultat renvoyé
#' @param nb_ligne integer: Nombre de lignes de résultat
#'
#' @return list avec une partie du dataset
#' @export
#'
#' @examples
#' get_row_dataset_api_enedis(url="https://data.enedis.fr/api/records/1.0/search/",data_id="production-electrique-par-filiere-a-la-maille-departement",debut_ligne=0,nb_ligne=10)
get_row_dataset_api_enedis=function(url="https://data.enedis.fr/api/records/1.0/search/",
                                    data_id="production-electrique-par-filiere-a-la-maille-departement",
                                    debut_ligne=0,nb_ligne=10){

  req <- request(paste0(url,'?dataset=',data_id,"&q=&rows=",nb_ligne,"&start=",debut_ligne)) %>% req_perform()

  data_req= req %>%  resp_body_json() %>% pluck("records")%>%
    map(~pluck(.x,"fields"))


  data_req


}
