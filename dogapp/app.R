#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shinydashboard)
library(shiny)
library(tidyverse)
library(DT)
 
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
                
                box(sliderInput("park_size", "Park Size (Acres):", 0,135, 15)),
                box(selectInput("Accessibility", "Accessibility:", choices = unique(dog_parks$Accessibility))),
                
                box(title = "On Leash",
                    radioButtons("on_leash", "Leash Options", choices = unique(dog_parks$onleash)),
                    radioButtons("run", "Dog Run", choices = unique(dog_parks$run))),#radiobuttons is for radiobuttons
                
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
  
)


# Define server logic required to draw a histogram
server <- function(input, output,session) {
  
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

}

    
    
    



# Run the application 
shinyApp(ui = ui, server = server)

