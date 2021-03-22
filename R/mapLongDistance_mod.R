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
            ## Loading the id of the session for this module 
            ns <- session$ns
            
            ## Reactive value to save de data.frame that this module return
            df_output <- reactiveVal(data.frame())
            
            output$map_bd <- renderLeaflet({
                
                ## Only load when we have a vassel name loaded
                shiny::req(vassel_name())
                vassel_type <- isolate(vassel_type$val)
                
                plot_map <- TRUE 
                ## Filter the data by name and type and then use the function
                ## from utils.R to calculate the distances
                df_map <-  calculateDistance(data() %>%
                                                   filter(SHIPNAME == vassel_name(),
                                                          ship_type == vassel_type))
                
                df_output(df_map)
                
                ## Extract the longest distance and the the movement associated 
                ## with it. Create a origin, destination and others data.frames
                ## Chec if the vessel have good data else dont plot.
                dist_aux <- df_map$distance[!is.na(df_map$distance) & df_map$distance != 0]
                if(length(dist_aux)>2){
                    max_distance <- max(df_map$distance, na.rm = T)
                    id_max_distance <- max(which(df_map$distance == max_distance))
                    
                    df_map_longDist_ori <- df_map[c(id_max_distance),]
                    df_map_longDist_des <- df_map[c(id_max_distance+1),]
                    
                    df_map_others <- df_map[-c(id_max_distance,
                                               id_max_distance+1),]
                    
                } else {

                    plot_map <- FALSE
                    max_distance <- 0 
                    id_max_distance <- nrow(df_map)-1
                    df_map_longDist_ori <- df_map[c(id_max_distance),]
                    df_map_longDist_des <- df_map[c(id_max_distance+1),]
                    df_map_others <- df_map[c(id_max_distance-1),]
                }
                
                print(df_map_longDist_ori)
                print(df_map_longDist_des)

                ## Update de information of the card in the top of the map 
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
                
                ## Generate some values tha help to set the view of the map
                ## depending of the data (boundaries and centers)
                mean_lat <- mean(c(df_map_longDist_ori$LAT,df_map_longDist_des$LAT)) 
                mean_lon <- mean(c(df_map_longDist_ori$LON,df_map_longDist_des$LON))
                
                max_lat <- max(c(df_map_longDist_ori$LAT,df_map_longDist_des$LAT)) 
                max_lon <- max(c(df_map_longDist_ori$LON,df_map_longDist_des$LON)) 
                
                min_lat <- min(c(df_map_longDist_ori$LAT,df_map_longDist_des$LAT)) 
                min_lon <- min(c(df_map_longDist_ori$LON,df_map_longDist_des$LON)) 
                
                delta_lat <- max_lat - min_lat
                delta_lon <- max_lon - min_lon
                max_delta <- max(delta_lat, delta_lon)
                

                
                if(!plot_map){return()}
                ## Create de map 
                leaflet(data = df_map_others, 
                        options = leafletOptions(zoomSnap = 0.01,
                                                 zoomControl = FALSE)) %>%
                    setView(lng = mean_lon, lat =  mean_lat, zoom = 9.5) %>%
                    ## Set the view and zoom near the destination and origin points
                    fitBounds(lng1 = min_lon,lng2 = max_lon,
                              lat1 = min_lat-max_delta*6,lat2 = max_lat+max_delta*6) %>% 
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