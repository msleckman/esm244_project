#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

#mymap<-"dog_parks_updated"

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
                DTOutput('table1'),
                
                leafletOutput('mymap')),
                #actionButton("park"),
                #verbatimTextOutput('summary')),
                
                box(sliderInput("park_size", "Park Size (Acres):", 0,135, 15)),
                box(selectInput("Accessibility", "Accessibility:", choices = unique(dog_parks_updated$Accessibility))),
                
                box(title = "On Leash",
                    radioButtons("on_leash", "Leash Options", choices = unique(dog_parks_updated$onleash)),
                    radioButtons("run", "Dog Run", choices = unique(dog_parks_updated$run))),#radiobuttons is for radiobuttons
                
                
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
    
)
  


# Define server logic required to draw a histogram
server <- function(input, output,session) {
  
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
  
datasetInput<- reactive({
  switch(input$dataset,
          "OnLeash" = on_leash,
         "Accessible" = Accessibility,
         "Dog Run" = run,
         "Acres" = park_size
  )
})
 
output$nrows <- reactive({
  nrow(datasetInput())
})        
    
outputOptions(output, "nrows", suspendWhenHidden = FALSE)


output$summary <- renderPrint({
  print(input$mydata)
  print(leafletProxy('map')$id)
})

}


# Run the application 
shinyApp(ui = ui, server = server)

