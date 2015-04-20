# Loading the required packages
library(shiny)
library(ggplot2)
library(gridExtra)
library(plyr)
library(rCharts)
library(lubridate)

# set the working directory 
#setwd("C:/Users/Rupantar/Desktop/courses in Spring USC/LA city project/App development/Part 2 Data analysis")
# shiny server integration
shinyServer(
        
        function(input,output){
                
                #load datasets
                load("Location_table.rda")
                load("Injury_table.rda")
                load("Collision_table.rda")
                load("datapedbike.rda")
                load("Conditions_table.rda")
                load("Victims_table.rda")
                              
                # coltable data cleaning : parsing date as date time variable
                #                 attach(coltable)
                #                 coltable$Collision.date.time<-NULL
                #                 coltable$Collision.date.time<-paste(Collision.date,Collision.Time)
                #                 coltable$Collision.date.time<-parse_date_time(coltable$Collision.date.time,order="mdy Ims p")              
               
                #convertion of the date field
                
                datapedbike$Collision.date=mdy(datapedbike$Collision.date)
                
                #making a reactive data frame based on the user input
                
                data<-reactive({
                        
                        data<-subset(datapedbike,datapedbike$Involved.With==input$var3 & datapedbike$Highest.Degree.of.Injury %in% c("Fatal","Severe Injury"))
                        
                        data
                })
               
                # new reactive data frame that is based on the date input by the user
                
                newdata<-reactive({
                        
                        # Extracting date range from the user input
                        a<-as.POSIXct(input$dates[1]) 
                        b<-as.POSIXct(input$dates[2]) 
                        # initializing the new reactive coltab dataframe in R
                        newd<-subset(data(),
                                     data()$Collision.date>a & 
                                             data()$Collision.date<b)
                        
                       newd
                        })
                
                output$summ2<-renderTable({
                        data<-as.data.frame(data()[,input$var])
                        names(data)[1]<-paste("Summary")  
                        summary(data)
                })
                
                # The data frame below is being created for the purpose of 
                #  sorting the data to be plotted
                df<-reactive({
                        datanew<-as.data.frame(table(newdata()[,input$var]))
                        datanew<-datanew[datanew[,2]>0,]
                datanew
                })

                output$myplot<-renderPlot({
                 
                        blue.bold.italic.16.text <- element_text(face = "bold.italic", color = "black", size = 16)
                        p<-ggplot(df(),aes(x=reorder(Var1,Freq),y=Freq))+
                                geom_bar(stat="identity",fill="firebrick4")+coord_flip()+ylab("Number of Killed or Severely injured")+
                                theme_bw()+ theme(axis.text = blue.bold.italic.16.text)+
                                theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),   
                                      panel.background = element_blank(), axis.line = element_line(colour = "black"))+xlab(input$var)
                        print(p)
                         })
                
                # Will work on this later
#                 output$mycolplot<-renderPlot({
#                       
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
                output$distPlot1 <- renderPlot({
                        # Take a dependency on input$goButton
                        if(input$goButton1==0)
                                return()
                        
                        # Use isolate() to avoid dependency on input$obs
                        # using ddply to create a pivoted table 
                        a<-ddply(newdata(),~Primary.Road,summarise,frq=length(Primary.Road))
                        head(a)
                        # Only display the top ten roads
                        roads<-arrange(a,desc(frq))[1:10,]
                        blue.bold.italic.16.text <- element_text(face = "bold.italic", color = "black", size = 16)
                        hotplot<-ggplot(roads,aes(x=reorder(Primary.Road,frq),y=frq))+
                                geom_bar(fill="firebrick4",stat="identity")+
                                coord_flip()+ylab("Number of Killed or severely injured")+
                                xlab("")+
                                theme(axis.text = blue.bold.italic.16.text)
                        hotplot<-hotplot+theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
                                               panel.background = element_blank(), axis.line = element_line(colour = "black"))
                        print(hotplot)
                        
                })
                # sameabove code for secondary hotspot display
                output$distPlot2 <- renderPlot({
                        if(input$goButton2==0)
                                return()
                        
                        # Use isolate() to avoid dependency on input$obs
                        
                        a<-ddply(newdata(),~Secondary.Road,summarise,frq=length(Secondary.Road))
                        head(a)
                        roads<-arrange(a,desc(frq))[1:10,]
                        blue.bold.italic.16.text <- element_text(face = "bold.italic", color = "black", size = 16)
                        hotplot<-ggplot(roads,aes(x=reorder(Secondary.Road,frq),y=frq))+
                                geom_bar(fill="firebrick4",stat="identity")+
                                coord_flip()+ylab("Number of Killed or Severely injured")+
                                xlab("")+
                                theme(axis.text = blue.bold.italic.16.text)
                        hotplot<-hotplot+theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
                                               panel.background = element_blank(), axis.line = element_line(colour = "black"))
                        print(hotplot)
                })

                output$dispmap1<-renderLeaflet({
                        
                        # leaflet normal mapping
                        
                        
                        m <- leaflet() %>% addTiles()
                        m = m %>% setView(lat = 34.01,lng = -118.28, zoom = 10)
                        # KSI for pedestrian mapping
                        
                        p = m%>%addCircles(lat = newdata()$Lat,lng = newdata()$Long,color="blue")
                  
                        print(p)
                        
                        
                        
                        
                })
                
                
                output$dispmap2<-renderLeaflet({
                        
                        # leaflet satellite mapping
                        
                        
                        m <- leaflet() %>% addTiles(urlTemplate="http://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}")
                        m = m %>% setView(lat = 34.0205,lng = -118.2856, zoom = 10)
                        # KSI for pedestrian mapping
                        
                        p = m%>%addCircles(lat = newdata()$Lat,lng = newdata()$Long,color="red")
                   
                        print(p)
                        
                        
                        
                        
                        
                })
                
                
                # download option
                
                output$down<-downloadHandler(
                        # specify the file name
                        filename=function(){
                                #plot.jpg
                                #plot.pdf
                                paste("plot",input$var,sep=".")
                        },
                        content = function(file){
                                # open the device 
                                # create the plot
                                # close the device
                                #png()
                                #pdf()
                                if(input$var2 == "png")
                                        png(file)
                                else
                                        pdf(file)
                                plot(conditionstable[,col()])
                                
                        })
                
        })