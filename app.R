
version <- 1.1

## Dependencies
scripts <- grep(".R$", list.files(paste0(getwd(), "/scripts/")), value = TRUE)
if (length(scripts) > 0) {
  for (func in scripts)
    source(paste0(getwd(), "/scripts/", func))
}

path <- c(data = "F:/Work/")

packages <- c("shiny", "plotly", "shinydashboard")

reqPackages(packages)

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
                   
                   checkboxInput("growth", "Show YoY Growth")
                   ),
  dashboardBody(textOutput("test"))
)

## Server

server <- function(input, output, session) {
  
  output$test <- renderText("Hulloooo")
  
}

# Run the application 
shinyApp(ui = ui, server = server)

