library(shiny)
library(shinythemes)
library(rsconnect)
library(plotly)
library(caret)
library(ElemStatLearn)
library(dplyr)
library(ggplot2)
library(gbm)
library(e1071)

shinyUI(fluidPage(
    theme = shinytheme("sandstone"),
    titlePanel("Machine Learning: Tolerance of Echinochloa crus-galli"),
    sidebarLayout(
        sidebarPanel(
            tabsetPanel(type="tabs",
                    tabPanel("Summary",textOutput("Summary1")),
                    tabPanel("Interactive mode of prediction",
                             tabsetPanel(type="tabs",
                                         tabPanel("Your table:",tableOutput("Accuracy2")),
                                         tabPanel("Machine Learning table:",tableOutput("Accuracy1")))
                             )
                    )
        ),
        mainPanel(
            tabsetPanel(type = "tabs",
                    tabPanel("Pre-prediction",plotlyOutput("plot1")),
                    tabPanel("Make your prediction", plotlyOutput("plot3")),
                    tabPanel("Machine Learning prediction", plotlyOutput("plot2")))    
        )
    )
))