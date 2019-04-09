# Decisions Trees Notes

#install.packages("glue")

library(tidyverse)
library(rpart)
#install.packages("rpart.plot")
library(rpart.plot)
library(readr)
library(ggplot2)
library(reshape2)

#################### Reading & Cleaning Data ########################
url <- "http://www.richardtwatson.com/data/manheim.csv"
t <- read_csv(url)

##### Fit a tree
tree <- rpart(price ~ model+miles+sale,
             data=t,
             method="anova")
rpart.plot(tree,type=4)

##### Predict with Decision Tree
t$predicted<-predict(tree, t, type ="vector")
colnames(t)[2]<-"actual_price"

##### Reformatting Data and Graphing
t<- t %>%
  arrange(actual_price)
t$case<- seq.int(nrow(t))

ggplot(t) +
  geom_point(aes(actual_price, case)) +
  geom_point(aes(predicted, case, color=predicted)) +
  xlab("Actual Price") + ylab("Car") +
  coord_flip() +
  ggtitle("Predicted vs. Actual Price per Car",
          subtitle = "Organized by Car") +
  scale_color_continuous(name="Predicted\nPrice")
