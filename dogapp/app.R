
library(shinydashboard)
library(shiny)
library(tidyverse)
library(DT)
library(leaflet)
library(dplyr)
library(shinyjs)




# Define UI for application that draws a histogram
ui <- dashboardPage(skin = "green",
                    
                    # Application title
                    dashboardHeader(title = "Dog Parks in Isla Vista and Goleta, California"),
                    dashboardSidebar(
                      sidebarMenu(
                        menuItem("Park Selection", tabName = "tab_1", icon = icon("map-marker")),
                        menuItem("Data Information", tabName = "tab_top", icon = icon("question-circle"))
                        
                        
                        
                      )
                    ),
                    
                    # Sidebar with a slider input for number of bins 
                    dashboardBody(
                      tabItems(
                        tabItem(tabName = "tab_1",
                                fluidPage(
                                  fluidRow(
                                    useShinyjs(),
                                    div(
                                      id="form",
                                      box(sliderInput("park_size", "Park Size (Acres):", 0,135, 30),
                                          selectInput("Accessibility", "Accessibility:", c("Unpaved" = "u", "Paved" = "p", "Nonaccessible" = "n"))),
                                      # choices = unique(dog_parks_updated$Accessibility)), label=,
                                      #box(checkboxGroupInput("onleash", "Leash Rules:",
                                      #choices = list("On Leash" = "y",
                                      #"Off Leash" = "n"),
                                      #selected = "y"),
                                      # checkboxGroupInput("run", "Dog Run?",
                                      #choices = list("Dog Run?" = "y"),
                                      #selected = "n")),
                                      
                                      
                                      box(radioButtons("onleash", "Leash Rules", c("On Leash" = "y", "Off Leash" = "n")),
                                          #radiobuttons is for radiobuttons
                                          radioButtons("run", "Dog Run?", c("Dog Run" = "y", "No Dog Run" = "n")),
                                          actionButton("resetAll", "Reset all")
                                      )),
                                    
                                    
                                    ##Map input at top of page
                                    leafletOutput("mymap"),
                                    #actionButton("park"),
                                    #verbatimTextOutput('summary')),
                                    
                                    ##Table input below map                  
                                    DTOutput('table1'),
                                    
                                    ##Widgets
                                    
                                    DT::renderDT({
                                      datatable(table1) %>%
                                        formatStyle(
                                          'park_size',
                                          'accessibility',
                                          'onleash',
                                          'run'
                                          
                                          
                                          
                                        )
                                      
                                      
                                    })
                                    
                                  )
                                )
                        ),
                        tabItem(tabName = "tab_top",
                                fluidPage(
                                  fluidRow(
                                    box( title = "About The App",
                                         width = 10,
                                         "This application was created to provide information for dog owners. Isla Vista has recently experienced several negative dog intereactions, causing many community members to worry about off leash dogs. This app is intended to be used by dog owners to find parks that best suit their needs - accessibility, with or without dog runs, and on or off leash areas. The parks in this application do not represent all parks in Goleta and Isla Vista, but rather show those most popular with dog owners."
                                    ),
                                    box( title = "About the Data",
                                         width = 10,
                                         "Data was collected by Lauren Krohmer and Margaux Sleckman. Collection techniques include literature review, field observations, and prior knowledge of the parks in Goleta and Isla Vista. "
                                    ),
                                    box( title = "Data Sources", 
                                         width = 10,
                                         "Santa Barbara County, City of Goleta, Environmental Defense Center"
                                    ), HTML('<p><img src="dogs.png"/></p>'), align = "left")
                                  
                                  
                                  
                                  #textInput("intro", h2("About This Data"),
                                  #textInput("parkinfo",  h1("This study was conducted to provide information for dog owners. Isla Vista has recently experienced several negative dog intereactions, causing many community members to worry about off leash dogs. This app is intended to be used by dog owners to find parks that best suit their needs - accessibility, with or without dog runs, and on or off leash areas.")),
                                  #verbatimTextOutput("parkinfo"))
                                )
                        )
                      )))


# Define server logic required to draw a histogram
server <- function(input, output, session) {
  
  observeEvent(input$resetAll, {
    updateSliderInput(session, "park_size",value=135)
    #updateRadioButtons(session, "onleash", value="on leash")
    #updateCheckboxGroupInput(session, "onleash", value="on leash")
    
  })
  
  
  output$mymap <- renderLeaflet({
    
    sub_map<-dog_parks_updated %>% 
      filter(onleash == input$onleash & run == input$run & Accessibility == input$Accessibility & size_acre <= input$park_size) 
    
    leaflet(sub_map)%>%
      addProviderTiles("OpenStreetMap")%>% 
      #addTiles(urlTemplate = "https://mts1.google.com/vt/lyrs=s&hl=en&src=app&x={x}&y={y}&z={z}&s=G",
      #         attribution = 'Google') %>% 
      setView(lng = -119.8, lat = 34.4, zoom = 11) %>% 
      addMarkers(lat = sub_map$`latitude-decimal`, 
                 lng = sub_map$`longitude-decimal`,
                 #clusterOptions = markerClusterOptions(),
                 popup = as.character(sub_map$park_name))
  })
  
  # df<- dog_parks_updated
  # df_subset<- reactive({
  #   a<- subset(df, size_acre == input$park_size, onleash == input$onleash, run == input$run)
  #   return(a)
  #   
  # })
  # 
  
  output$table1 = renderDT(
    sub_table<-dog_parks_updated %>%
      filter(onleash == input$onleash & run == input$run & Accessibility == input$Accessibility & size_acre <= input$park_size) %>% 
      select("park_name", "size_acre", "address") %>% 
      rename( "Park Name" = "park_name", "Park Size (Acre)" = "size_acre", " Park Address" = "address"))
  
  
  
}









# Run the application 
shinyApp(ui = ui, server = server)


# output$table1 <- DT::renderDataTable({
#   DT::datatable(df_subset)
# })

#prev_row <- reactiveVal()

#my_icon<- makeAwesomeIcon(icon = 'flag', markerColor = "red", iconColor = "white")

#observeEvent(input$table1_rows_selected, {
# row_selected = qSub()[input$table1_rows_selected,]
#proxy<- leafletProxy(mymap)
#print(row_selected)
#proxy %>% 
# addAwesomeMarkers(popup = as.character(row_selected$park_name),
#                  layerId = as.character(row_selected$park_name),
#                 lng=row_selected$longtitude_decimal,
#               lat = row_selected$latitude_decimal,
#                icon = my_icon)

#if(!is.null(prev_row()))
# {
# proxy %>%
# addMarkers(popup=as.character(prev_row()$park_name), 
#   layerId = as.character(prev_row()$park_name),
#  lng=prev_row()$longtitude_decimal, 
# lat=prev_row()$latitude_decimal)
#}
# set new value to reactiveVal 
#prev_row(row_selected)
#})

# map
#output$mymap <- renderLeaflet({
# pal <- colorNumeric("YlOrRd", domain=c(min(dog_parks_updated$park_name), max(dog_parks_updated$park_name)))
#qMap <- leaflet(data = dog_parks_updated) %>% 
# addTiles() %>%
#addMarkers(popup=~as.character(park_name), layerId = as.character(dog_parks_updated$park_name)) 
#})

#observeEvent(input$mymap_marker_click, {
# clickId <- input$mymap_marker_click$park_name
#dataTableProxy("table1") %>%
# selectRows(which(dog_parks_updated$park_name == clickId)) %>%
#selectPage(which(input$table1_rows_all == clickId) %/% input$table1_state$length + 1)
#})

