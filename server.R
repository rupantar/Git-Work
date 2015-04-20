library(shiny)
library(ggplot2)
library(gridExtra)
library(plyr)
library(rCharts)
library(lubridate)

setwd("C:/Users/Rupantar/Desktop/courses in Spring USC/LA city project/App development/Part 2 Data analysis")

shinyServer(
        
        function(input,output){
                
                #datasets
                load("Location_table.rda")
                load("Injury_table.rda")
                load("Collision_table.rda")
                load("datapedbike.rda")
                load("Conditions_table.rda")
                load("Victims_table.rda")
                KSIped<- datapedbike[datapedbike$Involved.With=="Pedestrian" & datapedbike$Highest.Degree.of.Injury %in% c("Fatal","Severe Injury"),]
                KSIbike<- datapedbike[datapedbike$Involved.With=="Bicycle" & datapedbike$Highest.Degree.of.Injury %in% c("Fatal","Severe Injury"),]
               
                data=reactive({
                if(input$var3=="Pedestrian")
                        KSIped
                else if(input$var3=="Bicycle")
                        KSIbike
                })
                
#                 # coltable data cleaning : parsing date as date time variable
#                 attach(data)
#                 data$Collision.date.time<-NULL
#                 data$Collision.date.time<-paste(Collision.date,Collision.Time)
#                 data$Collision.date.time<-parse_date_time(data$Collision.date.time,order="mdy Ims p")              
#                 })
#                 
#                         #                 # creating the reactive function
#                 #                 col<-reactive({
#                 #                         as.numeric(input$var)
#                 #                 })
#                 #                                 data<-reactive({
#                 #                                         as.data.frame(victimstable[victimstable$Victim.Type==input$var1,])
#                 #                                 })
#                 #                 
#                 #                 # rendering the summary table
#                 output$summ<-renderTable({
#                         data<-as.data.frame(data())
#                         names(data)[1]<-paste("Summary")  
#                         summary(data)
#                 })
#                 
#                 
#                 output$myplot<-renderPlot({
#                         #col<-as.numeric(input$var)
#                         #p<-ggplot(data(),aes(x=data()[1]))+geom_bar()
#                         
#                         #data<-as.data.frame(conditionstable[,2])
#                         p<-ggplot(conditionstable,aes_string(x=input$var))+geom_bar()+
#                                 coord_flip()
#                         print(p)
#                         
#                 })
#                 
#                 newcoltable<-reactive({
#                     
#                     
#                         # Extracting date range from the user input
#                         a<-as.POSIXct(input$dates[1]) 
#                         b<-as.POSIXct(input$dates[2]) 
#                         # initializing the new reactive coltab dataframe in R
#                         newcoltab<-subset(coltable,
#                                           coltable$Collision.date.time>a & 
#                                                   coltable$Collision.date.time<b)
#                        
#                         
#                         
#                         newcoltab
#                         
#                         })
#                 output$mycolplot<-renderPlot({
#                         plot(newcoltable()$Collision.Day.of.Week)
# #                         plot1<-ggplot(newcoltable(),aes(x=Collision.Day.of.Week))+geom_bar()
# #                         print(plot1)
#                 })
#                     
# 
#                 peddata<-victimstable[victimstable$Victim.Type=="Pedestrian",]
#                 bycdata<-victimstable[victimstable$Victim.Type=="Bicyclist",]
#                 output$myplot1<-renderPlot({
#                         ovr<-ggplot(victimstable,
#                                     aes_string(x=input$var1))+geom_bar(col="white",fill="#fc8d59")+
#                                 xlab("Overall")+ylab("")
#                         ped<-ggplot(peddata,
#                                     aes_string(x=input$var1))+
#                                 geom_bar(col="white",fill="#998ec3")+
#                                 xlab("Pedestrians")+ylab("Number of collisions")
#                         byc<-ggplot(bycdata,
#                                     aes_string(x=input$var1))+
#                                 geom_bar(col="white",fill="#91cf60")+
#                                 xlab("bicyclist")+ylab("")
#                         print(grid.arrange(ovr,ped,byc))
#                         
#                 })
#                 output$distPlot <- renderPlot({
#                         # Take a dependency on input$goButton
#                         if(input$goButton1==0)
#                                 return()
#                         
#                         
#                         # Use isolate() to avoid dependency on input$obs
#                         
#                         
#                         a<-ddply(locationtable,~Primary.Road,summarise,frq=length(Primary.Road))
#                         head(a)
#                         roads<-arrange(a,desc(frq))[1:10,]
#                         blue.bold.italic.16.text <- element_text(face = "bold.italic", color = "#2b8cbe", size = 16)
#                         hotplot<-ggplot(roads,aes(x=reorder(Primary.Road,frq),y=frq))+
#                                 geom_bar(fill="#756bb1",stat="identity",alpha=0.7)+
#                                 coord_flip()+ylab("Number of collision")+
#                                 xlab("")+
#                                 theme(axis.text = blue.bold.italic.16.text)
#                         print(hotplot)
#                 })
#                 
#                 output$dispmap<-renderLeaflet({
#                         
#                         # leaflet mapping
#                       
#                 
#                         m <- leaflet() %>% addTiles()
#                         m = m %>% setView(lat = 34.01,lng = -118.28, zoom = 13)
#                         # KSI for pedestrian mapping
#                       
#                         p = m%>%addCircles(lat = KSIped$Lat,lng = KSIped$Long,color="red")
#                         b = m%>%addCircles(lat = KSIped$Lat,lng = KSIped$Long,color="blue")
#                         
#                         if(input$goButton2==0)
#                                 return()
#                         print(p)
#                         if(input$goButton3==0)
#                                 return()
#                         print(b)
#                         
#                         
#                         
#                 })
#                         output$dispmap2<-renderLeaflet({
#                                 
#                                 
#                                 attach(datapedbike)
#                                 
#                                 KSIped<- datapedbike[datapedbike$Involved.With=="Pedestrian" & datapedbike$Highest.Degree.of.Injury %in% c("Fatal","Severe Injury"),]
#                                 KSIbike<- datapedbike[datapedbike$Involved.With=="Bicycle" & datapedbike$Highest.Degree.of.Injury %in% c("Fatal","Severe Injury"),]
#                                 
#                                 # leaflet mapping
#                                 
#                                 
#                                 m <- leaflet() %>% addTiles()
#                                 m = m %>% setView(lat = 34.01,lng = -118.28, zoom = 13)
#                                 # KSI for pedestrian mapping
#                                 if(input$goButton2==0)
#                                         return()
#                                 p = m%>%addCircles(lat = KSIped$Lat,lng = KSIped$Long,color="red")
#                                 print(p)
#                                 
#                                 
#                         })
# 
# 
#                 
#                 
#                 output$down<-downloadHandler(
#                         # specify the file name
#                         filename=function(){
#                                 #plot.jpg
#                                 #plot.pdf
#                                 paste("plot",input$var,sep=".")
#                         },
#                         content = function(file){
#                                 # open the device 
#                                 # create the plot
#                                 # close the device
#                                 #png()
#                                 #pdf()
#                                 if(input$var1 == "png")
#                                         png(file)
#                                 else
#                                         pdf(file)
#                                 plot(conditionstable[,col()])
#                                 
#                         })
#                 
