readDataShip <- function(){
    df <- data.table::fread("data/ships.csv")
    df_unique <- unique(df[,c("SHIPNAME", "ship_type")])
    
    return(list(data = shiny::reactive({df}),
                data_filter = shiny::reactive({df_unique}) ))
}
