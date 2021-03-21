dropdown_mod_ui <- function(id){
    ns <- NS(id)
    tagList(
        # div(class="ui left aligned header",
        #     style = "padding-top: 10px",
        #     "Histogram Normal Distribution"),
        uiOutput(ns("selectInp1")),
        # selectInput(ns("dropdown1"),label = "Label dd:",
        #             choices = c(letters))
        #h2("Histogram Normal Distribution"),
        #plotOutput(ns("plot1"),width = "500px", height = "300px")
    )
}
dropdown_mod_server <- function(id , df_data_filter){
    moduleServer(
        id,
        function(input, output, session){
            
            ## Loading the id of the session of this module 
            ns <- session$ns
            
            ## Loading data for the first time 
            output$selectInp1 <- renderUI({
                print("Cargamos data")
                shiny::req(df_data_filter())
                
                grid(
                    grid_template = grid_template(default = list(
                        areas = rbind(
                            c("vessel_filter"),
                            c("vessel_stats")
                        ),
                        cols_width = c("100%"),
                        rows_height = c("300px", "300px")
                    )),
                    area_styles = list(vessel_filter = "padding-top: 10px",
                                       vessel_stats = "padding-top: 10px"),
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
                    ),
                    vessel_stats = card(
                        style = "border-radius: 0; width: 100%; height: 300px; background: #efefef",
                        div(class = "content",
                            div(class = "header", style = "margin-bottom: 10px", "STATS"),
                            div(class = "description", h1("stats go here"))
                        )
                    )
                )
            })
            
            observeEvent(input$id1,{
                print("Cambio id1")
                
                shiny::req(df_data_filter())
                
                Shipnames <- unique((as.data.frame(df_data_filter()) %>% 
                    filter(ship_type == input$id1))$SHIPNAME)
                
                print(length(Shipnames))
                updateSelectInput(session, "id2", choices =  Shipnames)
            })
            
            return(list(vassel_type = reactive({input$id1}),
                        vassel_name = reactive({input$id2})))
            
            

        }
    )
}