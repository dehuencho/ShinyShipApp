context("distance_calculate")

test_that("Distance formula working", {
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
    
    
    df <- data.frame(LAT = c(54.77127, 54.76542),
               LON = c(18.99692, 18.99361),
               DATETIME = c("2016-01-01 12:00:00", "2016-01-01 12:01:00"))
    
    df <- calculateDistance(df)
    ## Test distance calculation with sf package 
    
    aux <- sf::st_as_sf(df %>% select(LAT, LON), 
                     coords = c("LON", "LAT"))

    st_crs(aux) = 4326


    df$distance2 <-
        c(sf::st_distance(x = aux[1:nrow(aux),],
                          y = aux[c(2:nrow(aux),nrow(aux)),],
                          by_element = TRUE))

    df <- df %>%
        select(LAT, LON, distance, distance2)
    
    difference <- as.numeric(df$distance2)[1] - df$distance[1]  > 5

    expect_false(difference)
})