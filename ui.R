# Coursera Johns Hopkins Data Science Capstone Project
# Vincent's submission, March 2019
# This shiny app accepts words as inputs and tries to predict the next word.

#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Next word predictor"),
  
  sidebarLayout(
    sidebarPanel(
      tabsetPanel(
        
        # First tab (English words input)
        tabPanel(HTML("<font color=black>English</font>"),
                 textInput("inputwords", NULL,
                           placeholder = "Please enter the first words here:")),
        
        # Second tab (Instructions)
        tabPanel(HTML("<font color=black>Instructions</font>"),
                 HTML("<br/><b>Instructions</b><br/>
                      This application predicts the next word from the words given as input.<br/>
                      Just enter a few words in the input box to see predictions for the next word.")))
      
      ,width=4
    ),
    
    
    # Show a plot of the generated distribution
    mainPanel(
      HTML("<font size=5 color=green>Best guess</font><br/>"),
      tags$style(type='text/css', '#best {size = 7; color: green;}'), 
      htmlOutput("best"),
      HTML("<br/><br/>"),
      HTML("<font size=5 color=grey>Alternatives</font><br/>"),
      tags$style(type='text/css', '#alternatives {size = 5; color: grey;}'),
      htmlOutput("alternatives")
    )
    )
))
