add_map <- function(data,.var,.zone,countour="reg",type="Production") {

  var=enquo(.var)
  zone=enquo(.zone)

  data_map=data %>%
    mutate(variable:=!!var,
           label:=!!zone)

  if(countour=="reg"){

    data_map=data_map%>%
      inner_join(st_transform(COGiter::regions_metro_geo%>% select(-AREA), crs = 4326),by=c("code_region"="REG"))
  }else{

    data_map=data_map%>%
      inner_join(st_transform(COGiter::departements_metro_geo%>% select(-AREA), crs = 4326),by=c("Code_Departement"="DEP"))
  }

  labs <- lapply(seq(nrow(data_map)), function(i) {
    paste0(data_map[i, "label"], '<br>',
            type, ': ',
            as.character(format(round(data_map[i, "variable"]/1000),big.mark=" "))," Twh")
  })


  pal <- colorNumeric(scales::seq_gradient_pal(low = "#F0F0F0", high = "#004755",
                                               space = "Lab"), domain = data_map$variable/1000)
  m <- leaflet() %>% addTiles() %>%
    addPolygons(data = data_map$geometry,color=pal(data_map$variable/1000),fillOpacity = 0.6,
                stroke = TRUE,weight=1,label=lapply(labs, htmltools::HTML),

                highlightOptions = highlightOptions(color = "black", weight = 3,bringToFront = TRUE)) %>%
    addLegend(
      title = paste0(type," (Twh)"),
      pal = pal, values = sort(round(data_map$variable/1000)))
  m

}
