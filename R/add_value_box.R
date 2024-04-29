add_value_box <- function(dataN,dataN1,annee,nom,.var,icon_lb,scale=1,suffix="",dec=0){

  var= enquo(.var)

  data=dataN %>%
    select(!!var) %>%
    mutate(variableN:=!!var) %>%
    select(variableN) %>%
    bind_cols(dataN1 %>%
                select(!!var) %>%
                mutate(variableN1:=!!var)%>%
                select(variableN1) )  %>%
    mutate(evol=variableN/variableN1-1)

  value_box(
    title = nom,
    value = p(paste0(format(round(data$variableN/scale,dec),big.mark = " "),suffix)),
    showcase = bs_icon(icon_lb),
    p(paste0("Evol vs ",annee,": ",percent(data$evol)))

  )
}
