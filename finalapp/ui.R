# Loadnig the required packages
library(shiny)
library(leaflet)
library(ggplot2)
library(gridExtra)
library(plyr)
library(lubridate)

# set the path
#setwd("C:/Users/Rupantar/Desktop/courses in Spring USC/LA city project/App development/Part 2 Data analysis")
# define UI for the application

shinyUI(fluidPage(
        #Header or Title Panel
        titlePanel(title = h4("LA City Traffic explorer : An attempt to explore the safety of pedestrian and bicyclists in  Los Angeles",align = "center")),
        sidebarLayout(
                #Sidebar Panel
                sidebarPanel(
                        # User input values to be used
                        selectInput("var3","1. Select the victim type",
                                    choices=c("Pedestrian","Bicycle")),
                        selectInput("var","2. Select the condition you want to analyze",
                                    choices=c("Weather","Road.Surface.Condition","Lighting","Collision.Day.of.Week",
                                              "Primary.Collision.Factor","Collision.Type","Pedestrian.Action",
                                           "Intersection.Accident","Direction")),
                        #Still to  figure the victim comparision part below
#                         selectInput("var1","3. Select the victim variable you want to analyze",
#                                     choices=names(victimstable)[c(-1,-2,-3,-4)]),
#                       # Date range input
                        dateRangeInput("dates",label=h3("Enter the date range"),
                                       min="2008-04-01",max="2012-03-31",start="2008-04-01",end="2012-03-31"),
                        actionButton("goButton1","Display Primary Hotspots"),
                        actionButton("goButton2","Display Secondary Hotspots")),
                
                #main Panel
                mainPanel(
                        # Main Panel tabs                 
                        tabsetPanel(type="tab",
                                    tabPanel("Summary",tableOutput("summ2")),
                                     # Download option in the plot below
                                    tabPanel("Conditions Plot",plotOutput("myplot")), #downloadButton(outputId = "down",label = "Download the plot"),
                                        # radioButtons("var2",label = " Select the file type",choice=list("png","pdf"))),
#                                     tabPanel("Victims Plot",plotOutput("myplot1"),
#                                              downloadButton(outputId = "down",label = "Download the plot"),
#                                              radioButtons("var2",label = " Select the file type",choice=list("png","pdf"))),
                                    tabPanel("Primary Hotspots",plotOutput("distPlot1")),
                                    tabPanel("Secondary Hotspots",plotOutput("distPlot2")),
                                    tabPanel("Normal Map",leafletOutput('dispmap1')),
                                    tabPanel("Satellite Map",leafletOutput('dispmap2'))
                        )
                        
                )))
)
