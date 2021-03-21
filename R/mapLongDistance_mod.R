mapLongDistance_mod_ui <- function(id){
    ns <- NS(id)
    tagList(
        div(style = "padding-top: 10px"),
        leafletOutput(ns("map_bd"), height = "500px"),
        div(style = "padding-top: 10px")
    )
}
mapLongDistance_mod_server <- function(id, data, vassel_type, vassel_name){
    moduleServer(
        id,
        function(input, output, session){
            ## Loading the id of the session of this module 
            ns <- session$ns
            
            plot_points <- reactive({
                print(vassel_type())
                print(vassel_name())
                df <- data() %>% filter(SHIPNAME == vassel_name())
                print(nrow(df))
                return(as.data.frame(df))
            })
            
            output$map_bd <- renderLeaflet({
                shiny::req(vassel_name())
                plot_points()
                leaflet(data.frame(), 
                        options = leafletOptions(zoomSnap = 0.01,
                                                 zoomControl = FALSE)) %>%
                    setView(lng = 20.51799, lat =  57.45748, zoom = 5) %>% 
                    addProviderTiles(providers$CartoDB.Positron,
                                     options = providerTileOptions(noWrap = TRUE))
            })
            
        })}