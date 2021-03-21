dropdown_mod_ui <- function(id){
    ns <- NS(id)
    tagList(
        div(class="ui left aligned header",
            style = "padding-top: 10px",
            "Histogram Normal Distribution"),
        selectInput(ns("dropdown1"),label = "Label dd:",
                    choices = c(letters))
        #h2("Histogram Normal Distribution"),
        #plotOutput(ns("plot1"),width = "500px", height = "300px")
    )
}
dropdown_mod_server <- function(id){
    moduleServer(
        id,
        function(input, output, session){

        }
    )
}