dropdown_mod_ui <- function(id){
    ns <- NS(id)
    tagList(
        uiOutput(ns("selectInp1")),
    )
}
dropdown_mod_server <- function(id , df_data_filter){
    moduleServer(
        id,
        function(input, output, session){
            
            ## Loading the id of the session of this module 
            ns <- session$ns
            
            ## This reactive value save the information of the vessel type,
            ## and help to communicate this information with other modules 
            ## without the extra loading of sharing the input directly 
            vessel_type = reactiveValues()
            
            ## Loading data for the first time, create UI after data is loaded
            ## Create both dropdown menus for type and vessel.
            output$selectInp1 <- renderUI({
                ## Help to create UI after data is loaded 
                shiny::req(df_data_filter())
                
                grid(
                    grid_template = grid_template(default = list(
                        areas = rbind(
                            c("vessel_filter")
                        ),
                        cols_width = c("100%"),
                        rows_height = c("225px")
                    )),
                    area_styles = list(vessel_filter = "padding-top: 10px"),
                    vessel_filter = card(
                        style = "border-radius: 0; width: 100%; height: 200px; background: #efefef",
                        div(class = "content",
                            div(class = "header",
                                style = "margin-bottom: 10px",
                                "Select vessel"),
                            div(class = "description", 
                                selectInput(ns("id1"),
                                            label = "Type",
                                            choices = unique(df_data_filter()$ship_type)),
                                selectInput(ns("id2"),
                                            label = "Name",
                                            choices = unique(df_data_filter()$SHIPNAME)))
                        )
                    )
                )
                
            })
            
            ## Each time the vessel type change, update the vessel availables.
            ## update the select input associated and save the vessel type
            observeEvent(input$id1,{
                shiny::req(df_data_filter())
                
                ## Vessels availables 
                Shipnames <- unique((as.data.frame(df_data_filter()) %>% 
                    filter(ship_type == input$id1))$SHIPNAME)
                
                updateSelectInput(session, "id2", choices =  Shipnames)
                vessel_type$val = input$id1
            })
            
            return(list(vassel_type = vessel_type,
                        vassel_name = reactive({input$id2})))
            
            

        }
    )
}