mapLongDistance_mod_ui <- function(id){
    ns <- NS(id)
    tagList(
        div(style = "padding-top: 10px"),
        # fluidRow(
        #     icon("circle", id = "circle_origin"),
        #     h2("Origin"),
        #     icon("circle", id = "circle_destination"),
        #     h2("Origin")
        # ),
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
                df <- data() %>% filter(SHIPNAME == vassel_name())
                print(vassel_name())
                print(nrow(df))
                return(as.data.frame(df))
            })
            
            output$map_bd <- renderLeaflet({
                shiny::req(vassel_name())
                
                df_map <- calculateDistance(plot_points())
                
                max_distance <- max(df_map$distance, na.rm = T)
                id_max_distance <- max(which(df_map$distance == max_distance))
                
                
                df_map_longDist_ori <- df_map[c(id_max_distance),]
                df_map_longDist_des <- df_map[c(id_max_distance+1),]
                df_map_others <- df_map[-c(id_max_distance,
                                           id_max_distance+1),]
                
                mean_lat <- mean(c(df_map_longDist_ori$LAT,df_map_longDist_des$LAT)) 
                mean_lon <- mean(c(df_map_longDist_ori$LON,df_map_longDist_des$LON)) 
                
                print(df_map_longDist_ori)
                print(df_map_longDist_des)
                leaflet(data = df_map_others, 
                        options = leafletOptions(zoomSnap = 0.01,
                                                 zoomControl = TRUE)) %>%
                    setView(lng = mean_lon, lat =  mean_lat, zoom = 9.5) %>% 
                    #setView(lng = 20.51799, lat =  57.45748, zoom = 5) %>% 
                    addProviderTiles(providers$CartoDB.Positron,
                                     options = providerTileOptions(noWrap = TRUE)) %>% 
                    addCircleMarkers(lng =~LON, lat =~LAT,
                                     radius = 1.5,weight = 0,fillColor = "blue", 
                                     opacity = 0.08, fillOpacity = 0.08) %>% 
                    addCircleMarkers(data =  df_map_longDist_ori,lng =~LON, lat =~LAT,
                                     radius = 6,weight = 1,fillColor = "darkred",
                                     color = "darkred",
                                     opacity = 1, fillOpacity = 1)%>% 
                    addCircleMarkers(data =  df_map_longDist_des,lng =~LON, lat =~LAT,
                                     radius = 6,weight = 1,
                                     fillColor = "forestgreen",
                                     color = "forestgreen",
                                     opacity = 1, fillOpacity = 1)
            })
            
        })}