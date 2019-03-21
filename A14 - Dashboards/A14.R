
#Shiny Dashboard
##Authors:
###Bryana Benson
###Conner Bryan

###Libraries
library(RMySQL)
library(shiny)
library(shinydashboard)
library(dygraphs)
#library(instalr)

###Dashobard Header
header <- dashboardHeader(title = 'Classic Models Revenue and Orders Dashboard')
###Dashobard Sidebar
sidebar <- dashboardSidebar()

###Month Dropdown
boxMonth <- box(selectInput("Month", label = "Month",choices = c("January" = 01,"February" = 02, "March" = 03, "April" = 04, "May" =
                                                                            05,"June" = 06, "July" = 07, "August" = 08, "September" = 09,"October" = 10,"November" = 11, "December" = 12), selected = 04))
###Year Dropdown
boxYear <- box(selectInput("Year", label = "Year", choices = c(2003, 2004, 2005), selected = 2005))

###Row for Year and Month Dropdowns
row1 <- fluidRow(width=5,boxYear, boxMonth)

###Revenue Box
boxRev <- box(title = "Revenue", width = 6, background = "green", textOutput("Revenue"))

<<<<<<< HEAD
###Orders Box
boxOrd <- box(title = "Orders", width = 6, background = "blue", textOutput("Orders"))
=======
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
>>>>>>> aa3a257c7551b8f6d431e77c7524cbba52e9b86d

###Row for Revenue and Orders Boxes
row2 <- fluidRow(width=5,boxRev, boxOrd)

###Combine Rows into Body
body <- dashboardBody(row1, row2)

###Combine dashboard components
ui <- dashboardPage(header,sidebar,body)

###Create Server
server <- function(input, output){
 
   conn <- dbConnect(RMySQL::MySQL(), "richardtwatson.com", dbname="ClassicModels", user="student", password="student")
  
   output$Rev <- renderText({
    sql1 <- paste0('SELECT FORMAT(SUM(quantityOrdered*priceEach),2)
                    FROM Orders JOIN OrderDetails ON Orders.orderNumber = OrderDetails.orderNumber
                    WHERE YEAR(orderDate) = ',input$Year,' AND MONTH(orderDate)=', input$Month)
    query1 <- dbGetQuery(conn, sql1)[1,1]
  })
 
    output$Ord <- renderText({
    sql2 <- paste0('SELECT COUNT(Orders.orderNumber)
                    FROM Orders JOIN OrderDetails ON Orders.orderNumber = OrderDetails.orderNumber
                    WHERE YEAR(orderDate) = ',input$Year,' AND MONTH(orderDate)=', input$Month)
    query2 <- dbGetQuery(conn, sql2)[1,1]
  })
}

shinyApp(ui, server)
