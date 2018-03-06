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
                 
                  
                  box(sliderInput("park_size", "Park Size (Acres):", 0,135, 15))),
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

    


# Define server logic required to draw a histogram
server <- function(input, output) {
  
  df<- dog_parks_updated
 
  df_subset<- reactive({
    a<- subset(df, size_acre == input$park_size, onleash == input$onleash, run == input$run)
  return(a)
    
  })
  
  output$table1 <- DT::renderDataTable({
    DT::datatable(df_subset)
  }  )
  
  
  
  
  
  
  
  
  
}

# Run the application 
shinyApp(ui = ui, server = server)





