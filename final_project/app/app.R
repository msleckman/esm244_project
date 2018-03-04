library(shinydashboard)
library(shiny)
library(tidyverse)


# Define UI for application that draws a histogram
ui <- dashboardPage(
  
  # Application title
  dashboardHeader(title = "Dog Parks in Isla Vista and Goleta, California"),
  dashboardSidebar(
    sidebarMenu(
      
      menuItem("Park", tabName = "tab_1")
    )
  ),
  
  # Sidebar with a slider input for number of bins 
  dashboardBody(
    tabItems(
      tabItem(tabName = "tab_1",
              fluidRow(
                box(tableOutput("park_data")),
                
                box(sliderInput("park_size", "Park Size (Acres):", 0,135, 15)
                )))
      
      
      
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  sliderValues <- reactive({
    
    data.frame(
      Name = c("park_size"),
      Value = as.character(c(input$park_data)),
      stringsAsFactors = FALSE)
    
  }) 
  
  output$park_data <- renderTable({
    sliderInput()
    
    
    
  })
}

# Run the application 
shinyApp(ui = ui, server = server)


