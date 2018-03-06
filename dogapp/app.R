library(shinydashboard)
library(shiny)
library(tidyverse)
library(DT)
library(leaflet)
library(dplyr)


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
                  
##Map input at top of page
                  leafletOutput("mymap"),
                  #actionButton("park"),
                  #verbatimTextOutput('summary')),

##Table input below map                  
                  DTOutput('table1'),
                  
##Widgets
                  box(sliderInput("park_size", "Park Size (Acres):", 0,135, 15)),
                  box(selectInput("Accessibility", "Accessibility:", choices = unique(dog_parks_updated$Accessibility))),
                  box(title = "On Leash",
                      radioButtons("onleash", "Leash Options", choices = unique(dog_parks_updated$onleash)),#radiobuttons is for radiobuttons
                      radioButtons("run", "Dog Run", choices = unique(dog_parks_updated$run))),
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
      )
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$mymap <- renderLeaflet({
      dog_onleash<-dog_parks_updated$onleash %>% 
        filter(onleash == "y")
    leaflet(dog_onleash) %>%  
      addProviderTiles("OpenStreetMap")%>% 
      #addTiles(urlTemplate = "https://mts1.google.com/vt/lyrs=s&hl=en&src=app&x={x}&y={y}&z={z}&s=G",
      #         attribution = 'Google') %>% 
      setView(lng = -119.8, lat = 34.4, zoom = 11) %>% 
      addMarkers(lat = dog_parks_updated$`latitude-decimal`, 
                        lng = dog_parks_updated$`longitude-decimal`,
                        #clusterOptions = markerClusterOptions(),
                        popup = as.character(dog_parks_updated$park_name))
})
  
    df<- dog_parks_updated
    df_subset<- reactive({
      a<- subset(df, size_acre == input$park_size, onleash == input$onleash, run == input$run)
      return(a)
      
    })
    
    output$table1 = renderDT(
    dog_parks_updated
  )
}



# Run the application 
shinyApp(ui = ui, server = server)
  
 
  # output$table1 <- DT::renderDataTable({
  #   DT::datatable(df_subset)
  # })





