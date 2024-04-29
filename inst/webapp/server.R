library(Enedis)

server <- function(input, output) {

  observe({
    if (input$close > 0) stopApp()                             # stop shiny
  })

  Annee_comparaison <- reactiveVal(0)

output$region <- renderUI({
  pickerInput(
    inputId = "region",
    label="Région",
    choices = list_region$NOM_REG

  )

})

output$departement <- renderUI({
  pickerInput(
    inputId = "departement",
    label="Département",
    choices = list_departement$NOM_DEP

  )

})

output$annee <- renderUI({
  pickerInput(
    inputId = "annee",
    label="Année",
    choices = list_annee$Annee

  )

})

observe({
  Annee_comparaison(if_else((as.numeric(input$annee))==min(list_annee$Annee),as.numeric(input$annee),as.numeric(input$annee)-1))

})


data_map <- reactive({



  data_map=data_conso_prod %>% filter(Annee==input$annee) %>%
    select(Annee,Code_Departement,NOM_DEP,code_region,NOM_REG,maille,starts_with(input$type))

  if(input$maille=="Nationale"){

    data_map %>% filter(maille=="Région")

  }else if(input$maille=="Région"){
    data_map %>% filter(NOM_REG==input$region,maille=="Département")
  }else{
    data_map%>% filter(NOM_DEP==input$departement,maille=="Département")

  }
})

data_vue_N <- reactive({



  data_prod_conso=data_conso_prod %>% filter(Annee==input$annee,maille==input$maille) %>%
    select(Annee,Code_Departement,NOM_DEP,code_region,NOM_REG,starts_with(input$type))

  if(input$maille=="Région"){

    data_prod_conso %>% filter(NOM_REG==input$region)

  }else if(input$maille=="Département"){
    data_prod_conso %>% filter(NOM_DEP==input$departement)
  }else{
    data_prod_conso

  }
})



data_vue_N1 <- reactive({

  #print(Annee_comparaison)
  data_prod_conso=data_conso_prod %>% filter(Annee==Annee_comparaison(),maille==input$maille) %>%
    select(Annee,Code_Departement,NOM_DEP,code_region,NOM_REG,starts_with(input$type))

  if(input$maille=="Région"){

    data_prod_conso %>% filter(NOM_REG==input$region)

  }else if(input$maille=="Département"){
    data_prod_conso %>% filter(NOM_DEP==input$departement)
  }else{
    data_prod_conso

  }
})


data_filiere<- reactive({

  data_prod_conso_by_filiere=data_conso_prod %>%
    select(maille,Annee, Code_Departement, NOM_DEP ,code_region ,NOM_REG,starts_with("Production_energie")) %>%
    pivot_longer(cols=starts_with("Production_energie")) %>%
    mutate(label=if_else(str_detect(name,"photovoltaique"),"Photovoltaique",
                         if_else(str_detect(name,"eolien"),"Eolien",
                                 if_else(str_detect(name,"hydraulique"),"Hydraulique",
                                         if_else(str_detect(name,"bio_energie"),"Bio energie",
                                                 if_else(str_detect(name,"cogeneration"),"Cogeneration",
                                                         if_else(str_detect(name,"autres_filieres"),"Autres filières","Autres"))))))) %>%
    group_by(maille,Annee, Code_Departement, NOM_DEP ,code_region ,NOM_REG) %>%
    mutate(pct=value /sum(value )) %>%
    ungroup()%>%
    mutate(type="Production") %>% bind_rows(

      data_conso_prod %>%
        select(maille,Annee, Code_Departement, NOM_DEP ,code_region ,NOM_REG,starts_with("Consommation_totale_MWh_")) %>%
        pivot_longer(cols=starts_with("Consommation_totale_MWh_")) %>%
        mutate(label=if_else(str_detect(name,"_ENT"),"Entreprise",
                             if_else(str_detect(name,"RES-PRO"),"Petits professionnels et entreprises non distingués",
                                     if_else(str_detect(name,"_PRO"),"Petits professionnels",
                                             if_else(str_detect(name,"_RES"),"Résidentiel",
                                                     if_else(str_detect(name,"_X"),"Professionnel non affecté","Autres")))))) %>%
        group_by(maille,Annee, Code_Departement, NOM_DEP ,code_region ,NOM_REG) %>%
        mutate(pct=value /sum(value )) %>%
        ungroup()%>%
        mutate(type="Consommation"))%>% filter(Annee==input$annee,maille==input$maille,
                                               type==input$type)

  if(input$maille=="Région"){

    data_prod_conso_by_filiere %>% filter(NOM_REG==input$region)

  }else if(input$maille=="Département"){
    data_prod_conso_by_filiere %>% filter(NOM_DEP==input$departement)
  }else{
    data_prod_conso_by_filiere

  }
})



output$prod_conso_tot <- renderUI({



  if(input$type=="Production"){
    nom="Production Total"
    add_value_box(data_vue_N(),data_vue_N1(),Annee_comparaison(),nom,Production_totale_mwh,"battery-charging",scale=1000,suffix=" Twh",dec=1)

  }else{



  nom="Consommation Total"

  add_value_box(data_vue_N(),data_vue_N1(),Annee_comparaison(),nom,Consommation_totale_MWh,"battery-charging",scale=1000,suffix=" Twh",dec=1)

  }
  })

output$nb_site <- renderUI({


  if(input$type=="Production"){
    nom="Nombre de sites"
    add_value_box(data_vue_N(),data_vue_N1(),Annee_comparaison(),nom,Production_nb_sites_totale,"houses-fill",scale=1,suffix="",dec=0)

  }else{



    nom="Nombre de sites"

    add_value_box(data_vue_N(),data_vue_N1(),Annee_comparaison(),nom,Consommation_Nb_sites_totale,"houses-fill",scale=1000,suffix="K",dec=1)

  }
})


output$prod_conso_moy <- renderUI({



  if(input$type=="Production"){
    nom="Production moyenne"
    add_value_box(data_vue_N(),data_vue_N1(),Annee_comparaison(),nom,Production_moyenne_mwh,"battery-half",scale=1,suffix=" Mwh",dec=1)

  }else{



    nom="Consommation moyenne"

    add_value_box(data_vue_N(),data_vue_N1(),Annee_comparaison(),nom,Consommation_moyenne_MWh,"battery-half",scale=1,suffix=" Mwh",dec=1)

  }
})


output$prod_conso_filiere <- renderPlotly({



  add_treemap(data_filiere())

})


output$titre_map <- renderText({


    if(input$maille=="Nationale"){

      paste0(input$type," par région")

    }else if(input$maille=="Région"){

      paste0(input$type," par départment")

    }else{
      input$type
      }



})

output$titre_treemap <- renderText({


  if_else(input$type=="Production","Production par filière","Consommation par catégorie")



})

output$map <- renderLeaflet({

  if(input$type=="Production"){
    type="Production"

  if(input$maille=="Nationale"){

    add_map(data_map(),Production_totale_mwh,NOM_REG,countour="reg",type)

  }else{

    add_map(data_map(),Production_totale_mwh,NOM_DEP,countour="dep",type)

  }
  }else{

    type="Consommation"
    if(input$maille=="Nationale"){

      add_map(data_map(),Consommation_totale_MWh,NOM_REG,countour="reg",type)

    }else{

      add_map(data_map(),Consommation_totale_MWh,NOM_DEP,countour="dep",type)

    }

  }

})

}
