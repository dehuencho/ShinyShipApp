stats1_mod_ui <- function(id){
    ns <- NS(id)
    tagList(
        grid(grid_template = 
                 grid_template(
                     default = list(
                         areas = rbind(
                             c("numb1", "numb2"),
                             c("plotHist")
                         ),
                         cols_width = c("auto", "auto"),
                         rows_height = c("50px", "200px")
                     )
                 ),
             area_styles = list(
                 numb1 = "margin: 20px;", 
                 numb2 = "margin: 20px;",
                 plotHist = "margin: 20px;"
             ),
             numb1 = uiOutput(ns("numb1")),
             numb2 = uiOutput(ns("numb2")),
             plotHist = uiOutput(ns("plotHist"))
        )
        
    )
}
stats1_mod_server <- function(id){
    moduleServer(
        id,
        function(input, output, session){
            output$numb1 <- renderUI({
                h3(class = "ui header", icon("list"),
                   "nrow: ")
            })
            output$numb2 <- renderUI({
                h3(class = "ui header",
                   "AVG:")
            })
            output$plotHist <- renderUI({
                div(class = "content",
                    "PLOT")
            })
        }
    )
}