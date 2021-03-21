plotHist_mod_ui <- function(id){
    ns <- NS(id)
    tagList(
        div(class="ui left aligned header",
            style = "padding-top: 10px",
            "Histogram Normal Distribution"),
        #h2("Histogram Normal Distribution"),
        plotOutput(ns("plot1"),width = "500px", height = "300px")
    )
}
plotHist_mod_server <- function(id){
    moduleServer(
        id,
        function(input, output, session){
            output$plot1 <- renderPlot({
                x = rnorm(1000)
                ggplot2::ggplot(data.frame(x)) + 
                    ggplot2::geom_histogram(aes(x=x), bins = 40)  
            })
        }
    )
}