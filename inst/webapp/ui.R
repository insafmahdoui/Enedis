

ui <- page_navbar(tags$head(tags$style(HTML(".shiny-output-error {
                                            display: none !important;
}"))),
  title = "Production et consommation d'électricité",
  id="nav",
  sidebar = sidebar(conditionalPanel(condition = "['Vue d\\'ensemble','Evolution'].includes(input.nav)",pickerInput(
    inputId = "type",
    label="Type",
    choices = c("Production","Consommation")

  ),
  conditionalPanel(
    condition = "input.nav === 'Vue d\\'ensemble'",
    uiOutput("annee")
  ),
  pickerInput(
    inputId = "maille",
    label="Maille",
    choices = c("Nationale","Région","Département")

  ),
  conditionalPanel(
    condition = "input.maille === 'Région'",
    uiOutput("region")
  ),
  conditionalPanel(
    condition = "input.maille === 'Département'",
    uiOutput("departement")
  ))),
  nav_panel("Vue d'ensemble",
  layout_columns(uiOutput("prod_conso_tot"),uiOutput("nb_site"),uiOutput("prod_conso_moy")),
  layout_columns(card(card_header(textOutput("titre_treemap")),plotlyOutput("prod_conso_filiere", height = "90vh")),
                 card(card_header(textOutput("titre_map")),leafletOutput("map")), height = 800)
  ),
  nav_panel("Evolution",
            card(
            )),
  nav_panel("Source de données",
            card(
            )),
  nav_spacer(),
  nav_item(a(img(src="Logo_enedis_header.png",title="logo",height="30px")))
)
