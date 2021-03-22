mapLongDistance_mod_ui <- function(id){
    ns <- NS(id)
    tagList(
        div(style = "padding-top: 10px"),
        grid(
            grid_template = grid_template(
                default = list(
                    areas = rbind(
                        c("Distancia",
                          "Origen",
                          "Destino"),
                        c("mapa")
                    ),
                    cols_width = rep("auto", 3),
                    rows_height = c("60px", "auto")
                ), 
                mobile = list(
                    areas = rbind(
                        "Distancia",
                        "Origen",
                        "Destino",
                        "mapa"
                    ),
                    cols_width = c("100%"),
                    rows_height = c("60px", "60px", "60px", "auto")
                )
            ),
            area_styles = list(Distancia = "margin: 5px;", 
                               Origen = "margin: 5px;",
                               Destino = "margin: 5px;"),
            # Distancia = h3(class = "ui header", icon("ruler") ,
            #                textOutput(ns("distance"),inline = TRUE)),
            Distancia = uiOutput(ns("distance")),
            Origen = uiOutput(ns("fecha_o")),
            Destino = uiOutput(ns("fecha_d")),
            mapa = leafletOutput(ns("map_bd"), height = "460px")
        ),
        div(style = "padding-bottom: 10px")
    )
}
mapLongDistance_mod_server <- function(id, data, vassel_type, vassel_name){
    moduleServer(
        id,
        function(input, output, session){
            ## Loading the id of the session of this module 
            ns <- session$ns
            
            df_output <- reactiveVal(data.frame())
            
            output$map_bd <- renderLeaflet({
                shiny::req(vassel_name())
                
                vassel_type <- isolate(vassel_type$val)
                df_map <-  calculateDistance(data() %>%
                                                   filter(SHIPNAME == vassel_name(),
                                                          ship_type == vassel_type))
                df_output(df_map)
                max_distance <- max(df_map$distance, na.rm = T)
                id_max_distance <- max(which(df_map$distance == max_distance))
                
                
                df_map_longDist_ori <- df_map[c(id_max_distance),]
                df_map_longDist_des <- df_map[c(id_max_distance+1),]
                df_map_others <- df_map[-c(id_max_distance,
                                           id_max_distance+1),]
                
                output$distance <- renderUI({
                    card_for_map(
                        h3(class = "ui center aligned header", icon("ruler", style = "color: black !important;") ,
                           paste0("Distance :  ", format(round(max_distance),
                                                         big.mark = ","),
                                  " meters"),
                           style = "color: #9c9c9c;")  
                    )
                })
                output$fecha_o <- renderUI({
                    card_for_map(
                        h3(class = "ui center aligned header", icon("circle",
                                                     style = "color: #00a30b;") ,
                           paste0("Origin :  ", format(df_map_longDist_ori$DATETIME,
                                                       "%Y-%m-%d %H:%M")),
                           style = "color: #9c9c9c;")
                    )
                })
                output$fecha_d <- renderUI({
                    card_for_map(
                        h3(class = "ui center aligned header", icon("circle",
                                                     style = "color: #a30000;") ,
                           paste0("Destination :  ",format(df_map_longDist_des$DATETIME,
                                                           "%Y-%m-%d %H:%M")),
                           style = "color: #9c9c9c;")
                    )
 
                })
                
                mean_lat <- mean(c(df_map_longDist_ori$LAT,df_map_longDist_des$LAT)) 
                mean_lon <- mean(c(df_map_longDist_ori$LON,df_map_longDist_des$LON))
                
                max_lat <- max(c(df_map_longDist_ori$LAT,df_map_longDist_des$LAT)) 
                max_lon <- max(c(df_map_longDist_ori$LON,df_map_longDist_des$LON)) 
                
                min_lat <- min(c(df_map_longDist_ori$LAT,df_map_longDist_des$LAT)) 
                min_lon <- min(c(df_map_longDist_ori$LON,df_map_longDist_des$LON)) 
                
                delta_lat <- max_lat - min_lat
                
                
                
                leaflet(data = df_map_others, 
                        options = leafletOptions(zoomSnap = 0.01,
                                                 zoomControl = FALSE)) %>%
                    setView(lng = mean_lon, lat =  mean_lat, zoom = 9.5) %>%
                    fitBounds(lng1 = min_lon,lng2 = max_lon,
                              lat1 = min_lat-delta_lat*8,lat2 = max_lat+delta_lat*8) %>% 
                    #setView(lng = 20.51799, lat =  57.45748, zoom = 5) %>% 
                    addProviderTiles(providers$CartoDB.Positron,
                                     options = providerTileOptions(noWrap = TRUE)) %>% 
                    addCircleMarkers(lng =~LON, lat =~LAT,
                                     radius = 1.5,weight = 0,fillColor = "blue", 
                                     opacity = 0.08, fillOpacity = 0.08) %>% 
                    addCircleMarkers(data =  df_map_longDist_ori,lng =~LON, lat =~LAT,
                                     radius = 6,weight = 1,fillColor = "#00a30b",
                                     color = "#00a30b",
                                     opacity = 1, fillOpacity = 1)%>% 
                    addCircleMarkers(data =  df_map_longDist_des,lng =~LON, lat =~LAT,
                                     radius = 6,weight = 1,
                                     fillColor = "#a30000",
                                     color = "#a30000",
                                     opacity = 1, fillOpacity = 1)
            })
            return(list(df_map = df_output))
        })}