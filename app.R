ui <- semanticPage(
    tags$head(
        tags$link(rel = "stylesheet", type = "text/css", href = "css/style.css"),
    ),
    grid(
        myGridTemplate,
        area_styles = list(title = "margin: 20px;", info = "margin: 20px;", user = "margin: 20px;"),
        title = h1(class="ui header", icon("ship"), div (class = "content", "Shiny ship app!")),
        info = dropdown_mod_ui("dropdown1"),
        map = card(style = "border-radius: 0; width: 100%; background: #efefef",
                   div(class = "content",
                       tabset(list(list(menu = div("First link"), 
                                        content = div(
                                            h3("leaflet plot")
                                        )), 
                                   list(menu = div("Second link"), 
                                        content = div(
                                            plotHist_mod_ui("plot1")
                                        )),
                                   list(menu = div("Third link"), 
                                        content = div("Third content nose")),
                                   list(menu = div("Second link"), 
                                        content = div("Second content"))
                                   
                                   ))
                   )
                   ),
        user = div(
            h1("User grid part")
        )
    )
)

server <- function(input, output, session) {
    plotHist_mod_server("plot1")
}

shinyApp(ui = ui, server = server)
