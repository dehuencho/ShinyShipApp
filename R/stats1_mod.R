stats1_mod_ui <- function(id){
    ns <- NS(id)
    tagList(
        uiOutput(ns("statistics"))
    )
}
stats1_mod_server <- function(id, df_distance){
    moduleServer(
        id,
        function(input, output, session){
            
            ns <- session$ns
            
            ## Check if the vessel have good information else return zeros and
            ## dont plot
            dist <- reactive({

                dist <- df_distance()$distance 

                dist <- dist[!is.na(dist)]

                if (length(dist)<2) { dist <- c(0,0)}
                
                return(dist)
                })
            
            
            ## Generate the information about the number of rows and the number of 
            ## samples that have a distance equal to zero, for a particual vessel.  
            numb1 <- renderUI({

                return(h3(class = "ui center aligned header", icon("list"),
                   paste0(nrow(df_distance()), " rows  -  ",
                          sum(dist()==0,
                              na.rm = T), " zero distance")))
                
            })
            ## Generate information of the average distance for all the samples for
            ## a particular vessel 
            numb3 <- renderUI({

                return(h2(class = "ui center aligned header",
                   "Avg. distance ", round(mean(dist(),
                                            na.rm = T),1), " m"))
                
            })
            ## Histogram rendering 
            plotHist <- renderUI({
                div(class = "content",
                    plotlyOutput(ns("plotly_histogram"), height = "190px"))
            })
            
            output$statistics <- renderUI({
                grid(grid_template = 
                         grid_template(
                             default = list(
                                 areas = rbind(
                                     c("numb1"),
                                     c("numb3"),
                                     c("plotHist")
                                 ),
                                 cols_width = c("auto", "auto"),
                                 rows_height = c("40px", "50px","220px")
                             )
                         ),
                     area_styles = list(
                         numb1 = "margin: 15px;", 
                         numb3 = "margin: 15px;",
                         plotHist = "margin: 15px;"
                     ),
                     numb1 = numb1,
                     numb3 = numb3,
                     plotHist = plotHist
                )
            })
            
            ## Create de histogram with plotly for the distances of a particular vessel that 
            ## are different of zero 
            output$plotly_histogram <- renderPlotly({
                
                dist_local <- dist()
                dist_local <-dist_local[!is.na(dist_local)]  
                
                
                if (all(dist()==0)) {
                    return()
                }
                
                
                axis_y <- list(showticklabels = FALSE,
                               ticks = "",
                               title = "")
                axis_x <- list(title = "Meters")
                
                plot_ly(alpha = 0.6) %>% 
                    add_histogram(x = dist_local)%>% 
                    layout(xaxis = axis_x, yaxis = axis_y) %>% 
                    layout(plot_bgcolor='transparent') %>% 
                    layout(paper_bgcolor='transparent',
                           margin = list(l = 10),
                           title = list(text = "Histogram: Distances without zeros"))
                
            })
        }
    )
}