#Assignment 15

library(flexdashboard)
library(Quandl)
library(readr)
library(dygraphs)
library(stats)
library(ggplot2)
url<-"http://www.richardtwatson.com/data/manheim.csv"
manheim<-read_csv(url)

# creating table
tab<-xtabs(~model + sale, data=manheim)
ftable(tab)

#creating boxplot
ggplot(manheim,aes(model,price)) +
  geom_boxplot(outlier.colour='red') +
  xlab("Model") + ylab("Price $")

#creating scatterplot - miles by price for each model
ggplot(manheim,aes(miles,price,color=model)) +
  geom_point() +
  xlab("Miles") + ylab("Price $")

#scatterplot - miles by price for each sale
ggplot(manheim,aes(miles,price,color=sale)) +
  geom_point() +
  xlab("Miles") + ylab("Price $")