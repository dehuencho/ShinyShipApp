ui <- semanticPage(
    useShinyjs(),
    tags$head(
        tags$link(rel = "stylesheet", type = "text/css", href = "css/style.css"),
    ),
    grid(
        myGridTemplate,
        area_styles = list(title = "margin: 20px;", 
                           info = "margin: 20px;",
                           map = "margin: 20px;",
                           user = "margin: 20px;"),
        title = h1(class="ui header", icon("ship"),
                   div (class = "content", "Shiny ship app!")),
        info = dropdown_mod_ui("dropdown1"),
        map = card(style = "border-radius: 0; width: 100%; background: #efefef; margin-top: 10px; margin-bottom: 10px;",
                   div(class = "content",
                       tabset(list(list(menu = div("Longest distance sailed"), 
                                        content = div(
                                            mapLongDistance_mod_ui("map1")
                                        )), 
                                   list(menu = div("Distance by datetime"), 
                                        content = div(
                                            plotHist_mod_ui("plot1")
                                        ))
                                   ))
                   )
                   ),
        user = card(style = "border-radius: 0; width: 100%; background: #efefef; margin-top: 10px; margin-bottom: 10px;",
                    stats1_mod_ui("stats1")
        )
    )
)

server <- function(input, output, session) {
    data <- readDataShip()
    filters <- dropdown_mod_server("dropdown1", data$data_filter)
    mapLongDistance_mod_server("map1",
                               data$data,
                               filters$vassel_type,
                               filters$vassel_name) 
    plotHist_mod_server("plot1")
    stats1_mod_server("stats1")
}

shinyApp(ui = ui, server = server)
