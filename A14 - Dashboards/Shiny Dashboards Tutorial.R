# Assignment 11

#install.packages("shiny")
#install.packages("shinydashboard")
#install.packages("quantmod")
#install.packages("dygraphs")

library(shiny)
library(shinydashboard)
library(quantmod) # Provides current stock prices
library(dygraphs)
library(instalr)


### Creating a basic dashboard layout
header <- dashboardHeader(title = 'First dashboard')
sidebar <- dashboardSidebar()
body <- dashboardBody()
ui <-dashboardPage(header,sidebar,body)

server <- function(input, output){}

shinyApp(ui, server)

# Remember to hit stop sign in console befoer updating code

### Creating a dashboard of Apple Stock Prices
header <- dashboardHeader(title = 'Apple stock watch')
menuApple <-  menuItem("Apple", tabName = "Apple", icon = icon("dashboard"))
menuGoogle <- menuItem("Google", tabName = "Google", icon = icon("dashboard"))
sidebar <- dashboardSidebar(sidebarMenu(menuApple, menuGoogle))
boxLatest <- box(title = 'Latest price: ',getQuote('AAPL')$Last, background = 'blue' )
boxChange <-  box(title = 'Change ',getQuote('AAPL')$Change, background = 'red' )
row1 <- fluidRow(boxLatest,boxChange)
boxOld <- box(title='Oldest Price: ',getQuote('AAPL')$First, background='olive')
boxReallyOld <-box(title='Really Oldest Price', getQuote('AAPL')$First, footer='this stat sucks', background='light-blue')
row2 <- fluidRow(boxOld,boxReallyOld)
tabApple <-  tabItem(tabName = "Apple", getQuote('AAPL')$Last)
tabGoogle <-  tabItem(tabName = "Google", getQuote('GOOG')$Last)
tabs <-  tabItems(tabApple,tabGoogle)
body <- dashboardBody(tabs, row1, row2)
ui <- dashboardPage(header,sidebar,body)
server <- function(input, output) {}
shinyApp(ui, server)

# General form of boxes
box(title =NULL, footer =NULL, status =NULL, solidHeader =FALSE,
    background =NULL, width =6, height =NULL,
    collapsible =FALSE, collapsed =FALSE)


####################

header <- dashboardHeader(title = 'Apple stock watch')
sidebar <- dashboardSidebar()
infoLatest <- infoBox(title = 'Latest', icon('dollar'), getQuote('AAPL')$Last, color='red')
infoChange <- infoBox(title = 'Web site', icon('apple'),href='http://investor.apple.com', color='purple')
row <- fluidRow(width=4,infoLatest,infoChange)
body <- dashboardBody(row)
ui <- dashboardPage(header,sidebar,body)
server <- function(input, output) {}
shinyApp(ui, server)

################################ Dynamic Dashboards
header <- dashboardHeader(title = 'Stock watch')
sidebar <- dashboardSidebar(NULL)
boxSymbol <-  box(selectInput("symbol", "Equity:", choices = c("Apple" = "AAPL",  "Ford" = "F", "Google" = "GOOG"), selected = 'AAPL'))
boxPrice <- box(title='Closing price', width = 12, height = NULL, dygraphOutput("chart"))
boxOutput <-  box(textOutput("text"))
body <- dashboardBody(fluidRow(boxSymbol, boxOutput, boxPrice))
ui <- dashboardPage(header, sidebar, body)

server <- function(input, output) 
{output$text <- renderText({
  paste("Symbol is:",input$symbol)
})                      ## Cl in quantmod retrieves closing price as a time series
output$chart <- renderDygraph({dygraph(Cl(getSymbols(input$symbol, auto.assign=FALSE)))}) # graph time series
}
shinyApp(ui, server)
