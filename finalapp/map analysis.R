datapedbike<-read.csv("Datapedsandbikesall.csv")

names(datapedbike)

attach(datapedbike)

KSIpedbike<- datapedbike[datapedbike$Highest.Degree.of.Injury %in% c("Fatal","Severe Injury"),]
# leaflet mapping
attach(KSIpedbike)
m <- leaflet() %>% addTiles()
m = m %>% setView(lat = 34.01,lng = -118.28, zoom = 13)
m = m%>%addCircles(lat = KSIpedbike$Lat,lng = KSIpedbike$Long,)
print(m)

contrast(datapedbike$Highest.Degree.of.Injury)

# 
ggplot(KSIpedbike[KSIpedbike$Involved.With=="Bicycle",],aes(x=Collision.Type))+geom_bar()


a<-ddply(locationtable,~Primary.Road,summarise,frq=length(Primary.Road))
head(a)
roads<-arrange(a,desc(frq))[1:10,]
blue.bold.italic.16.text <- element_text(face = "bold.italic", color = "#2b8cbe", size = 16)
hotplot<-ggplot(roads,aes(x=reorder(Primary.Road,frq),y=frq))+
        geom_bar(fill="#756bb1",stat="identity",alpha=0.7)+
        coord_flip()+ylab("Number of collision")+
        xlab("")+
        theme(axis.text = blue.bold.italic.16.text)
print(hotplot)