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
        title = h1(class="ui header",
                   icon("ship",style="display: inline-block;vertical-align:top;"),
                   div (class = "content", 
                        style="display: inline-block;vertical-align:top;",
                        "Shiny ship app!"
                   ),
                   div(id = "information2",
                       style="display: inline-block;vertical-align:top;",
                       shiny::icon("info", 
                            style = "background: transparent; font-size: 10px; color: black;vertical-align:top;",
                            id = "logoInfo"),
                       div(class = "content",
                           style="display: inline-block;vertical-align:top;",
                           HTML(information))
                   )),
        info = dropdown_mod_ui("dropdown1"),
        map = card(style = "border-radius: 0; width: 100%; background: #efefef; margin-top: 10px; margin-bottom: 10px;",
                   div(class = "content",
                       tabset(list(list(menu = div("Longest distance sailed"), 
                                        content = div(
                                            mapLongDistance_mod_ui("map1")
                                        )), 
                                   list(menu = div("Description of the raw dataset"), 
                                        content = div(
                                            description_mod_ui("plot1")
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
    ## Read the data with data.table
    data <- readDataShip()
    ## Manage the drop down information
    filters <- dropdown_mod_server("dropdown1", data$data_filter)
    ## Create the map and the cards for the longest distance info.
    ## On this module the dataset is filtered and the distance is calculated. 
    df_distance <- mapLongDistance_mod_server("map1",
                               data$data,
                               filters$vassel_type,
                               filters$vassel_name)
    ## Show a descriptive summary of the dataset with str function
    description_mod_server("plot1", data$data)
    ## Generate statistic and plot for the distance through time. 
    stats1_mod_server("stats1", df_distance$df_map)
}

shinyApp(ui = ui, server = server)
