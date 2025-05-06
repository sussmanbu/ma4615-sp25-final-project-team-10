
library(shiny)
library(tidyverse)
library(here)

# Load filtered data
exoneration_data <- read_rds("exoneration_data_cook.rds")
crime_data <- read_rds("crime_data_shiny.rds")

ui <- fluidPage(
  titlePanel("Cook County Crimes and Exonerations"),
  
  sidebarLayout(
    sidebarPanel(
      conditionalPanel(
        condition = "input.tabs == 'Crime Trend'",
        selectInput("crime_type", "Choose a Crime Type:", 
                    choices = unique(crime_data$`Primary Type`),
                    selected = "THEFT")
      ),
      conditionalPanel(
        condition = "input.tabs == 'Exoneration Rates'",
        selectInput("exon_crime_type", "Choose Exonerated Crime Type:",
                    choices = unique(exoneration_data$Worst_Crime_Display),
                    selected = "Murder")
      ),
      sliderInput("year_range", "Select Year Range:",
                  min = 2000, max = 2023, value = c(2010, 2023), sep = "")
    ),
    
    mainPanel(
      tabsetPanel(id = "tabs",
                  tabPanel("Crime Trend", plotOutput("crimePlot")),
                  tabPanel("Exoneration Rates", plotOutput("exonPlot"))
      )
    )
  )
)

server <- function(input, output) {
  
  # Plot rendering logic
  output$crimePlot <- renderPlot({
    crime_data %>%
      filter(`Primary Type` == input$crime_type,
             Year >= input$year_range[1],
             Year <= input$year_range[2]) %>%
      ggplot(aes(x = Year)) +
      geom_bar(fill = "steelblue") +
      labs(title = paste("Number of", input$crime_type, "Cases by Year"),
           x = "Year",
           y = "Number of Cases")
  })
  
  
  output$exonPlot <- renderPlot({
    req(input$exon_crime_type)
    selected_crime <- input$exon_crime_type
    
    exoneration_data %>%
      filter(
        County == "Cook",
        Race %in% c("Black", "White", "Hispanic", "Asian", "Other", "Don't Know"),
        Worst_Crime_Display == selected_crime
      ) %>%
      group_by(Exonerated, Race) %>%
      summarise(Exonerations = n(), .groups = "drop") %>%
      filter(Exonerated >= input$year_range[1], Exonerated <= input$year_range[2]) %>%
      ggplot(aes(x = Exonerated, y = Exonerations, color = Race)) +
      geom_line(size = 1.2, na.rm = TRUE) +
      labs(
        title = paste("Exonerations Over Time –", selected_crime),
        x = "Year of Exoneration",
        y = "Number of Exonerations",
        color = "Race"
      ) +
      theme_minimal()
  })
}

shinyApp(ui = ui, server = server)
