description_mod_ui <- function(id){
    ns <- NS(id)
    tagList(
        div(class="content",
            style = "padding-top: 10px"),
        DTOutput(ns("str_data"))
    )
}
description_mod_server <- function(id, data){
    moduleServer(
        id,
        function(input, output, session){
            output$str_data <- renderDT({
                ## Description of the dataset 
               return(datatable(data(), rownames = FALSE,
                                options = list(
                                    autoWidth = TRUE
                                )))
            })

        }
    )
}