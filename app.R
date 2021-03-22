ui <- semanticPage(
    useShinyjs(),
    tags$head(
        tags$link(rel = "stylesheet", type = "text/css", href = "css/style.css"),
    ),
    grid(
        grid_template(
            default = list(
                areas = rbind(
                    c("title"),
                    c("info", "map"),
                    c("stats", "map"),
                    c("auth", "map")
                ),
                cols_width = c("400px", "1fr"),
                rows_height = c("50px", "225px", "auto", "100px")
            ),
            mobile = list(
                areas = rbind(
                    "title",
                    "info",
                    "map",
                    "stats",
                    "auth"
                ),
                rows_height = c("50px", "auto", "auto", "auto","auto"),
                cols_width = c("100%")
            )
        ),
        area_styles = list(title = "margin: 20px;", 
                           info = "margin: 20px;",
                           map = "margin: 20px;",
                           stats = "margin: 20px;",
                           auth = "margin: 20px;"),
        title = h1(class="ui header", icon("ship"),
                   div (class = "content", "Shiny ship app!")),
        info = dropdown_mod_ui("dropdown1"),
        map = card(style = "border-radius: 0; width: 100%; background: #efefef; margin-top: 10px; margin-bottom: 10px;",
                   div(class = "content",
                       tabset(list(list(menu = div("Longest distance sailed"), 
                                        content = div(
                                            mapLongDistance_mod_ui("map1")
                                        )), 
                                   list(menu = div("Description of the dataset"), 
                                        content = div(
                                            plotHist_mod_ui("plot1")
                                        ))
                                   ))
                   )
                   ),
        stats = card(style = "border-radius: 0; width: 100%; background: #efefef; margin-top: 10px; margin-bottom: 10px;",
                    stats1_mod_ui("stats1")
        ),
        auth = div(class = "content",
                   style = "margin-left: 20px; margin-top:10px;font-size: 20px;",
                   tags$a("Daniel Huencho", href = "https://www.danielhuencho.com"),
                   tags$a(icon("github"), href = "https://www.danielhuencho.com"))
    )
)

server <- function(input, output, session) {
    data <- readDataShip()
    filters <- dropdown_mod_server("dropdown1", data$data_filter)
    df_distance <- mapLongDistance_mod_server("map1",
                               data$data,
                               filters$vassel_type,
                               filters$vassel_name) 
    plotHist_mod_server("plot1", data$data)
    stats1_mod_server("stats1", df_distance$df_map)
}

shinyApp(ui = ui, server = server)
