#
# This is the user-interface definition of a Shiny web application.
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Predict Cylinders, Horse Power, Transmission, and Gears from Miles Per Gallon"),
  
  # Sidebar with controls to select the variable to plot against mpg
  # to specify whether outliers should be included
  # and to select the mpg value to predict
  sidebarPanel(
    
    p("Please choose a car feature and select an MPG value to predict a feature value from Miles per Gallon."),
    br(),
    selectInput("variable", "Features:",
                list("Cylinders" = "cyl", 
                     "Horse Power" = "hp", 
                     "Transmission" = "am", 
                     "Gears" = "gear")),
    checkboxInput("outliers", "Show outliers", FALSE),
    br(),
    sliderInput("sliderMPG", "Select the MPG of the car:", 10, 35, value = 15)
  ),
  
  # Show the caption and plot of the requested variable against mpg
  mainPanel(
    h3(textOutput("caption")),
    plotOutput("mpgPlot"),
    plotOutput("predictPlot"),
    h3(textOutput("predText")),
    textOutput("pred"),
    h5(textOutput("note"))
  )
  
))
