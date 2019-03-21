

###Dashboards
#Bryana Benson
#Conner Bryan

###Libraries
library(RMySQL)
library(shiny)
library(shinydashboard)
library(quantmod) # Provides current stock prices
library(dygraphs)
library(instalr)

###Build a dashboard to report revenue and orders for ClassicModels for a given year and month.

#Import Classic Models Database
conn <- dbConnect(RMySQL::MySQL(), "richardtwatson.com", dbname="ClassicModels", user="student", password="student")

#Get payments table
rev <- dbGetQuery(conn, "SELECT * FROM Payments WHERE paymentDate between '2005-04-01' and '2005-04-31'  ;")
head(rev)

#Get 
ord <- dbGetQuery(conn, "SELECT * FROM Orders WHERE shippedDate between '2005-04-01' and '2005-04-31' ;")
head(ord)

#Basic Dashboard Layout
header <- dashboardHeader(title = 'Orders and Revenue')
sidebar <- dashboardSidebar()
body <- dashboardBody()
ui <-dashboardPage(header,sidebar,body)

#Creating Dashboard sidebar
menuRev <-  menuItem("Revenue", tabName = "Revenue", icon = icon("dashboard"))
menuOrd <- menuItem("Orders", tabName = "Orders", icon = icon("dashboard"))
sidebar <- dashboardSidebar(sidebarMenu(menuRev, menuOrd))

boxControl <- box(title = "Controls", sliderInput("slider", "Months:", 1, 12, 4), sliderInput("slider", "Year:",as.numeric(substring(min(rev$paymentDate),1,4)),as.numeric(substring(max(rev$paymentDate),1,4)), 2005))

#Creating Dashboard Body
boxLatest <- box(title = 'Latest price: ',rev$Last, background = 'blue' )
boxChange <-  box(title = 'Change ',getQuote('AAPL')$Change, background = 'red' )
row1 <- fluidRow(boxLatest,boxChange)
boxOld <- box(title='Oldest Price: ',getQuote('AAPL')$First, background='olive')
boxReallyOld <-box(title='Really Oldest Price', getQuote('AAPL')$First, footer='this stat sucks', background='light-blue')
row2 <- fluidRow(boxOld,boxReallyOld)
tabRev <-  tabItem(tabName = "Revenue", getQuote('AAPL')$Last)
tabOrd <-  tabItem(tabName = "Orders", getQuote('GOOG')$Last)
tabs <-  tabItems(tabRev,tabOrd)
body <- dashboardBody(tabs, row1, row2)

#Creating Dashboard Page
ui <- dashboardPage(header,sidebar,body)

#Run dashboard
server <- function(input, output){}
shinyApp(ui, server)


###Save as an R script rather than markdown

####Submit a pdf of the code and the dashboard April 2005.