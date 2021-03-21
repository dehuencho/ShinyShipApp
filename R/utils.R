readDataShip <- function(){
    df <- data.table::fread("data/ships.csv")
    df_unique <- unique(df[,c("SHIPNAME", "ship_type")])
    
    return(list(data = shiny::reactive({df}),
                data_filter = shiny::reactive({df_unique}) ))
}

calculateDistance <- function(df_vassel){
    
}

# 
# library(plotly)
# 
# quakes = read.csv('https://raw.githubusercontent.com/plotly/datasets/master/earthquakes-23k.csv')
# 
# fig <- quakes 
# fig <- fig %>%
#     plot_ly(
#         type = 'densitymapbox',
#         lat = ~Latitude,
#         lon = ~Longitude,
#         coloraxis = 'coloraxis',
#         radius = 10) 
# fig <- fig %>%
#     layout(
#         mapbox = list(
#             style="stamen-terrain",
#             center= list(lon=180)), coloraxis = list(colorscale = "Viridis"))
# 
# fig