#
# This is the server logic of the Shiny web application.

library(shiny)
library(datasets)
# load ggplot
library(ggplot2) 

mpgData <- mtcars

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  # Compute the forumla text in a reactive expression since it is 
  # shared by the output$caption and output$mpgPlot expressions
  formulaText <- reactive({
    paste("mpg ~", input$variable)
  })
  
  # Return the formula text for printing as a caption
  output$caption <- renderText({
    formulaText()
  })
  
  predictionText <- reactive({
    paste("Predicted ", input$variable, " from Model Prediction")
  })
  
  # Return the formula text for printing as the prediction model's caption
  output$predText <- renderText({
    predictionText()
  })
  
  output$note <- renderText({
    if (input$variable == "am") {
      "Note: Value greater than 0.5 indicates Manual transmission and value less than 0.5 indicates Automatic transmission."
    }
  })

  modelpred <- reactive({
    mpgInput <- input$sliderMPG
    model <- lm(mtcars[[input$variable]] ~ mpg, data = mtcars)
    predict(model, newdata = data.frame(mpg = mpgInput))
  })
  
  output$mpgPlot <- renderPlot({

    if (input$variable == "am") {
      # am
      mpgData <- data.frame(mpg = mtcars$mpg, var = factor(mtcars[[input$variable]], labels = c("Automatic", "Manual")))
    }
    else {
      # cyl gear and hp
      mpgData <- data.frame(mpg = mtcars$mpg, var = factor(mtcars[[input$variable]]))
    }
        
    p <- ggplot(mpgData, aes(var, mpg)) + 
      geom_boxplot(outlier.size = ifelse(input$outliers, 2, NA)) + 
      xlab(input$variable)
    
    print(p)
    
    
  })
  
  output$predictPlot <- renderPlot({
    
    mpgInput <- input$sliderMPG
    var = mtcars[[input$variable]]
    model <- lm(mtcars[[input$variable]] ~ mpg, data = mtcars)
    minValue = ifelse(input$variable == "am", 0,min(mtcars[[input$variable]]))
    maxValue = ifelse(input$variable == "am", 1,max(mtcars[[input$variable]]))
    
    plot(mtcars$mpg, var, xlab = "Miles Per Gallon",
         ylab = input$variable, bty = "n", pch = 16,
         xlim = c(10, 35), ylim = c(minValue, maxValue))
    abline(model, col = "blue", lwd = 2)
    legend(30, ifelse(input$variable == "am",1,maxValue), c("Model Prediction"), pch = 16,
           col = c("red", "blue"), bty = "n", cex = 1.2)
    points(mpgInput, modelpred(), col = "red", pch = 16, cex = 2)
    
  })

  output$pred <- renderText({
    modelpred()
  })

})
