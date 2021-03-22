readDataShip <- function(){
    ## raw dataset
    df <- data.table::fread("data/ships.csv")
    ## Unique values for the dropdown menu
    df_unique <- unique(df[,c("SHIPNAME", "ship_type")])
    
    return(list(data = shiny::reactive({df}),
                data_filter = shiny::reactive({df_unique}) ))
}

calculateDistance <- function(df_vassel){
    
    
    df <- df_vassel %>% 
        dplyr::mutate(DATETIME = ymd_hms(DATETIME)) %>% 
        select(LAT, LON, DATETIME) %>% 
        dplyr::arrange(DATETIME)%>%
        ## Distance formula from: 
        ## https://www.movable-type.co.uk/scripts/latlong.html
        ## Checked with sf package (slower)
        mutate(R = 6371E3,
               phi1 = LAT*pi/180,
               phi2 = dplyr::lead(LAT*pi/180),
               lat_diff = (phi2-phi1),
               lon_diff = (c(diff(LON*pi/180), NA)),
               const_a = sin(lat_diff/2)^2+
                   cos(phi1)*cos(phi2)*
                   sin(lon_diff/2)^2,
               const_c = 2*atan2(sqrt(const_a), 
                                 sqrt(1-const_a)),
               distance = R*const_c) %>% 
        select(-c(R, phi1, phi2,lat_diff,lon_diff, const_a, const_c))
    
    ## TRASPASAR A TESTING 
    ## LAT _ LON
    # p1 <- c(54.77127, 18.99692)
    # p2 <- c(54.76542, 18.99361)
    # 
    # R = 6371E3
    # phi1 = p1[1]*pi/180
    # phi2 = p2[1]*pi/180
    # delta_phi = (p2[1]-p1[1])*pi/180
    # delta_lambda = (p2[2]-p1[2])*pi/180
    # 
    # a = sin(delta_phi/2) * sin(delta_phi/2) +
    #     cos(phi1) * cos(phi2)*
    #     sin(delta_lambda/2) * sin(delta_lambda/2)
    # c = 2 * atan2(sqrt(a), sqrt(1-a))
    # (d = R*c)
    
    ## Test distance calculation with sf package 
    
    # aux <- sf::st_as_sf(df %>% select(LAT, LON, DATETIME), 
    #                 coords = c("LON", "LAT"))
    # 
    # st_crs(aux) = 4326
    # 
    # 
    # df$distance2 <- 
    #     c(sf::st_distance(x = aux[1:nrow(aux),], 
    #                       y = aux[c(2:nrow(aux),nrow(aux)),], 
    #                       by_element = TRUE))    
    # 
    # df <- df %>% 
    #     select(LAT, LON, DATETIME, distance, distance2)
    # 
    #write.table(df, "distance.csv", sep = ";", row.names = F)
    
    return(df)
}

card_for_map <- function(x){
    return(
        card(style = "border-radius: 1; width: 100%; background: #efefef; margin-top: 0; margin-bottom: 0;",
             div(class = "content", style = "padding: 10px 5px 5px 5px;",
                 x))
    )
}
