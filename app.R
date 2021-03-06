
version <- 1.2

## Dependencies
scripts <- grep(".R$", list.files(paste0(getwd(), "/scripts/")), value = TRUE)
if (length(scripts) > 0) {
  for (func in scripts)
    source(paste0(getwd(), "/scripts/", func))
}

path <- c(data = "F:/Work/")
warcStyle()
regions <- c("Global", "Africa", "Asia-Pacific", "Europe", )

packages <- c("shiny", "plotly", "shinydashboard", "shinyWidgets")

reqPackages(packages)

library(shiny)
library(shinydashboard)
library(plotly)
library(shinyWidgets)

# Load data
loadAdspendDB()

## UI
ui <- dashboardPage(title = paste("Adspend Dashboard", version),
  dashboardHeader(),
  dashboardSidebar(sliderInput("year", "Select Time Period",
                               min = 1980, max = 2017,
                               value = c(2007, 2017),
                               sep = ""),
                   
                   radioButtons("currency", "Select Currency",
                                choices = c("USD", "EUR" ,"PPP")),
                   
                   radioButtons("metric", "Select Metric",
                                choices = c("Current prices",
                                           "Constant prices")),
                   
                   checkboxInput("growth", "Show YoY Growth"),
                   
                   dropdownButton(checkboxGroupButtons())
                   ),
  dashboardBody(textOutput("test"))
)

## Server

server <- function(input, output, session) {
  
  output$test <- renderText("Hulloooo")
  
  output$plot <- renderPlotly({
    
    data <- chartData(df, mf, input$year, input$currency, input$metric, input$growth)
    
    ggplotly(
      ggplot(data, aes(Year, value, fill = forcats::fct_rev(variable))) +
        geom_bar(stat = "identity", width = .7) +
        labs(x = meta$x.axis, y = meta$y.axis) +
        ## WARC Styling
        scale_fill_manual(values = rev(unlist(styles$col, use.names = FALSE)),
                          name = meta$legend) +
        theme(text=element_text(family = "Aktiv Grotesk Medium",
                                colour = styles$col$main$col1))
    )
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)

