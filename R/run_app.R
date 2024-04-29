run_app <-function(){

  shiny::runApp(system.file("webapp", package = "Enedis"), launch.browser = TRUE)
}
