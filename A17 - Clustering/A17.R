#Assignment 17

library(readxl)
library(readr)
#install.packages("NbClust")
library(NbClust)
library(tidyverse)
#install.packages("rattle")
library(rattle)
#install.packages("cluster")
library(cluster)

##### Reading in Data
url<-"http://im.ft-static.com/content/images/b38c350e-169d-11e5-b07f-00144feabdc0.xls"
read_xls(url)

data<-read_excel("FTGlobal500.xls")

##### Cleaning the data
colnames(data)<-data[4,]
data<-data[-(1:4),]

companies<-data$Company

data <- sapply(data, as.numeric)
data<-as.data.frame(data)
data<-data[, -c(3,4,6)]
data$Company<-companies

data<-na.omit(data)

top_20<- data %>%
  arrange(desc(`Market value $m`))

top_20<-top_20[1:20,]

companies<-top_20$Company

top_20<-top_20[,-12]

rownames(top_20)<-companies

head(top_20)


##### Creating 3 clusters

clusters<-kmeans(top_20, 3)

attributes(clusters)

clusters$centers
clusters$size

##### Graphing the two main components
clusplot(top_20, clusters$cluster, main='2D representation of the Cluster solution',
         color=TRUE, shade=TRUE,
         labels=2, lines=0)


##### Plotting a dendrogram
d <- dist(top_20, method = "euclidean")
H.fit <- hclust(d, method="ward.D")
plot(H.fit, xlab="Company", sub="Clusters", cex=.7, col="purple")           # display dendogram
groups <- cutree(H.fit, k=3)          # cut tree into 5 clusters
rect.hclust(H.fit, k=3, border="red") # draw dendogram with red borders around the 5 clusters

