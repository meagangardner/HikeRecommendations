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
  titlePanel("Hiking Map"),
  
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
                  choices = c("All" = "All", unique(hikes$difficulty)), selected = "All"),
      selectInput("time", "Time (hours)", 
                  choices = c("All" = "All", unique(hikes$time_hours)), selected = "All"),
      selectInput("season", "Season", 
                  choices = c("All" = "All", unique(hikes$season)), selected = "All")
    ),
    
    mainPanel(
      leafletOutput("map")
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
        (input$season == "All" | season == input$season),
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
      setView(lng = -121.5216, lat = 49.727, zoom = 8) |>
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
                                    "Time: ", time_hours, " hours")
      )
  })
  
}

# Run the app
shinyApp(ui, server)