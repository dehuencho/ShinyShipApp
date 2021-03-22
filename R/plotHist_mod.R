plotHist_mod_ui <- function(id){
    ns <- NS(id)
    tagList(
        div(class="ui left aligned header",
            style = "padding-top: 10px",
            "'str' function: Each row show a column, the type of variable of the column and the first elements of it."),
        #h2("Histogram Normal Distribution"),
        verbatimTextOutput(ns("str_data"))
    )
}
plotHist_mod_server <- function(id, data){
    moduleServer(
        id,
        function(input, output, session){
            output$str_data <- renderPrint({
                str(data())
            })

        }
    )
}