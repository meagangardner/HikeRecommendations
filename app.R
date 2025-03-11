# Install required packages if you haven't already
# install.packages(c("shiny", "leaflet", "dplyr"))

library(shiny)
library(leaflet)
library(dplyr)
library(readxl)

# Read in hikes data
hikes <- read_excel('data/Hike_Database.xlsx')

# Create UI
ui <- fluidPage(
  tags$head(
    tags$style(HTML("
      body {
        background-color: #a8d5ba;
      }
    "))
  ),

  titlePanel(tags$div("Greater Vancouver Hiking Map", 
                    style = "text-align: center; 
                             background-color: #a8d5ba; 
                             color: black; 
                             padding: 10px; 
                             font-size: 40px;
                             font-family: 'Montserrat', sans-serif;
                             font-weight: bold;")),
  
  sidebarLayout(
    sidebarPanel(
      sliderInput("distance", "Distance (km)", 
                  min = min(hikes$distance_km), max = max(hikes$distance_km), 
                  value = c(min(hikes$distance_km), max(hikes$distance_km)),
                  step = 0.1),
      sliderInput("elevation", "Elevation Gain (m)", 
                  min = min(hikes$elevation_gain_m), max = max(hikes$elevation_gain_m), 
                  value = c(min(hikes$elevation_gain_m), max(hikes$elevation_gain_m)),
                  step = 10),
      selectInput("difficulty", "Difficulty", 
            choices = c("All", "Easy", "Moderate", "Difficult", "Very Difficult"), 
            selected = "All"),
      #selectInput("difficulty", "Difficulty", 
      #            choices = c("All" = "All", unique(hikes$difficulty)), selected = "All"),
      selectInput("time", "Time (hours)", 
            choices = c("All", "0 – 2", "2 – 4", "4 – 6", "6 – 8", "8+"), 
            selected = "All"),
      #selectInput("season", "Season", 
      #            choices = c("All" = "All", unique(hikes$season)), selected = "All"),
      checkboxGroupInput("season", "Season", 
                   choices = unique(hikes$season), 
                   selected = unique(hikes$season)),

      style = "height: 575px; overflow-y: auto;"
    ),
    
    mainPanel(
      leafletOutput("map", height = "575px")
    )
  )
)

# Server function
server <- function(input, output, session) {
  
  # Filter the data based on user input
  filtered_data <- reactive({
    hikes %>%
      filter(
        (input$difficulty == "All" | difficulty == input$difficulty),
        (input$time == "All" | time_hours == input$time),
        #(input$season == "All" | season == input$season),
        season %in% input$season,
        distance_km >= input$distance[1],
        distance_km <= input$distance[2],
        elevation_gain_m >= input$elevation[1],
        elevation_gain_m <= input$elevation[2]
      )
  })
  
  # Render the map
  output$map <- renderLeaflet({
    # Get the filtered data
    data <- filtered_data()
    
    # Create the leaflet map
    leaflet(data) |>
      addTiles() |>
      setView(lng = -122.2, lat = 49.5, zoom = 9) |>  #lng = -121.5216, lat = 49.85, zoom = 8
      addAwesomeMarkers(~longitude, ~latitude, 
                        icon = awesomeIcons(
                          icon = 'map-marker',
                          library = 'fa', 
                          markerColor = case_when(
                            data$region == "Golden Ears" ~ "red",
                            data$region == "Metro Vancouver" ~ "blue",
                            data$region == "Whistler" ~ "green",
                            data$region == "Fraser Valley" ~ "purple",
                            data$region == "Manning Park" ~ "orange",
                            data$region == "Pemberton" ~ "pink",
                            data$region == "Howe Sound" ~ "beige",
                            TRUE ~ "gray"
                          )
                        ),
                        popup = ~paste0("<b>", hike_name, "</b><br>",
                                    "Distance: ", distance_km, " km<br>",
                                    "Elevation Gain: ", elevation_gain_m, " m<br>",
                                    "Time: ", time_hours, " hours"),
                        layerId = ~hike_name
      )
  })
  # Zoom in based on marker click
  observeEvent(input$map_marker_click, {
    click <- input$map_marker_click
    leafletProxy("map") %>%
      setView(lng = click$lng, lat = click$lat, zoom = 11)
  })

  # Zoom back out when the user clicks anywhere on the map
  observeEvent(input$map_click, {
    leafletProxy("map") %>%
      setView(lng = -121.5216, lat = 49.85, zoom = 8)
  })


}

# Run the app
shinyApp(ui, server)