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
              fluidPage(
                fluidRow(
                  leafletOutput("mymap"),
                  #actionButton("park"),
                  #verbatimTextOutput('summary')),
                  DTOutput('table1'),
                  box(sliderInput("park_size", "Park Size (Acres):", 0,135, 15)),
                  box(selectInput("Accessibility", "Accessibility:", choices = c("Paved", "Unpaved", "Not Accessible")))),
                
                box(title = "On Leash",
                    radioButtons("on_leash", "Leash Options", choices = c("On Leash Only", "Off Leash"))),
                box(title = "Dog Run",
                    radioButtons("run", "Dog Run", choices = "Dog Run"))),#radiobuttons is for radiobuttons
              
              DT::renderDT({
                datatable(table1) %>% 
                  formatStyle(
                    'park_size',
                    'accessibility',
                    'on_leash'
                  )
                
                
              })
              
      )
    )
  ))


# Define server logic required to draw a histogram
server <- function(input, output, session) {
  
  output$mymap <- renderLeaflet({
    leaflet() %>%  
      addProviderTiles("OpenStreetMap")%>% 
      #addTiles(urlTemplate = "https://mts1.google.com/vt/lyrs=s&hl=en&src=app&x={x}&y={y}&z={z}&s=G",
      #         attribution = 'Google') %>% 
      setView(lng = -119.8, lat = 34.4, zoom = 11) %>% 
      addMarkers(lat = dog_parks_updated$`latitude-decimal`, 
                        lng = dog_parks_updated$`longitude-decimal`,
                        #clusterOptions = markerClusterOptions(),
                        popup = as.character(dog_parks_updated$park_name))
})
  
  output$table1 = renderDT(
    dog_parks_updated
  )
}


# Run the application 
shinyApp(ui = ui, server = server)