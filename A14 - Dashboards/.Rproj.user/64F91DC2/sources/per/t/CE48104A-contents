
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

###Orders Box
boxOrd <- box(title = "Orders", width = 6, background = "blue", textOutput("Orders"))

###Row for Revenue and Orders Boxes
row2 <- fluidRow(width=5,boxRev, boxOrd)

###Combine Rows into Body
body <- dashboardBody(row1, row2)

###Combine dashboard components
ui <- dashboardPage(header,sidebar,body)

###Create Server
server <- function(input, output) {
  
  #connecting to server
  conn <-dbConnect(RMySQL::MySQL(), "www.richardtwatson.com", dbname="ClassicModels", user="student", password="student")
  
  output$Revenue <- renderText({
    
    sql1 <- paste0('SELECT FORMAT(SUM(quantityOrdered*priceEach),2)
                 FROM Orders JOIN OrderDetails ON Orders.orderNumber = OrderDetails.orderNumber 
                 WHERE YEAR(orderDate) = ',input$Year,' AND MONTH(orderDate)=', input$Month)
    
    query1 <- dbGetQuery(conn, sql1)[1,1]})
  
  output$Orders <- renderText({
    
    sql2 <- paste0('SELECT COUNT(Orders.orderNumber) FROM Orders JOIN OrderDetails ON Orders.orderNumber = OrderDetails.orderNumber WHERE YEAR(orderDate) = ',input$Year,' AND MONTH(orderDate)=', input$Month) 
    
    query2 <- dbGetQuery(conn, sql2)[1,1]})
}

shinyApp(ui, server)


