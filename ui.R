library(shiny)
library(leaflet)
library(ggplot2)
library(gridExtra)
library(plyr)
library(lubridate)

setwd("C:/Users/Rupantar/Desktop/courses in Spring USC/LA city project/App development/Part 2 Data analysis")
# define UI for the application
# loading the data set location

shinyUI(fluidPage(
        #Header or Title Panel
        titlePanel(title = h2("Visual Data Analytics",align = "center")),
        sidebarLayout(
                #Sidebar Panel
                sidebarPanel(
                        selectInput("var3","1. Select the victim type",
                                    choices=c("Pedestrian","Bicycle")),
                        selectInput("var","1. Select the condition you want to analyze",
                                    choices=c("Weather","Road.Surface.Condition","Lighting")),
                        selectInput("var1","2. Select the victim variable you want to analyze",
                                    choices=names(victimstable)[c(-1,-2,-3,-4)]),
                        textInput("var2","3.Enter the Accident ID "),
                        dateRangeInput("dates",label=h3("Enter the date range"),
                                       min="2008-01-01",max="2008-12-31",start="2008-01-01",end="2008-12-31"),
                        actionButton("goButton1", "Display Primary Hotspots"),
                        actionButton("goButton2", "Display the pedestrian KSI"),
                        actionButton("goButton3","Display the bicycle KSI")),
                
                #main Panel
                mainPanel(
                        #                 
                        tabsetPanel(type="tab",
                                    tabPanel("Summary",tableOutput("summ")),
                                    tabPanel("Conditions Plot",plotOutput("myplot")),
                                    tabPanel("Collisions Plot",plotOutput("mycolplot")),
                                    tabPanel("Victims Plot",plotOutput("myplot1"),
                                             downloadButton(outputId = "down",label = "Download the plot"),
                                             radioButtons("var2",label = " Select the file type",choice=list("png","pdf"))),
                                    tabPanel("Hotspots",plotOutput("distPlot")),
                                    tabPanel("Maps",leafletOutput('dispmap'))
                        )
                        
                )))
)
