library(shinydashboard)
library(shiny)
library(tidyverse)
library(DT)
library(leaflet)

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
                
                box(sliderInput("park_size", "Park Size (Acres):", 0,135, 15),
                    box(selectInput("Accessibility", "Accessibility:", choices = unique(dog_parks$Accessibility))),
                    
                    box(title = "On Leash",
                        radioButtons("on_leash", "Leash Options", choices = c( "On Leash", "Off Leash", "Dog Run"))), #radiobuttons is for radiobuttons
                    
                    box(DT::dataTableOutput("park_data")) 
                ),
                leafletOutput('mymap'),
                p(),
               # actionButton("park"),
                verbatimTextOutput('summary')
              )
      )
      
      )
      
      
      )
    
  )
  



# Define server logic required to draw a histogram
server <- function(input, output, session) {
  
  sliderValues <- reactive({
    
    data.frame(
      Name = c("park_size"),
      Value = as.character(c(input$park_data)),
      stringsAsFactors = FALSE)
    
  })
  
  # points <- eventReactive(input$recalc, {
  #   cbind(rnorm(40) * 2 + 13, rnorm(40) + 48)
  # }, ignoreNULL = FALSE)
  # 
  output$map <- renderLeaflet({
    leaflet() %>%  
      addTiles(options = tileOptions(maxZoom = 5, maxNativeZoom = 5),
               group = 'OSM') %>% 
      addMarkers()
  })
  
  output$park_data <- DT::renderDataTable({
    sliderInput()
    selectInput()
    radioButtons()
    
    
    
  })
}

# Run the application 
shinyApp(ui = ui, server = server)



