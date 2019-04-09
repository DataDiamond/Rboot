##### A22

library(keras)
library(dplyr)
library(readr)
library(neuralnet)
library(ggplot2)
library(Metrics)
library(httr)
set_config( config( ssl_verifypeer = 0L ) )

url <- "http://www.richardtwatson.com/data/manheim.csv"
data <- read_csv(url)

###################### General Linear Model #########################

lm <- lm(price ~ miles + sale + model, data)
summary(lm)

##### Predicting with Linear Regression
data$predict.lm <- round(predict(lm),0)
MSE.lm <- rmse(data$price,data$predict.lm)


################## Reformatting for neural net ######################
##### Recoding
data$saleCode <- case_when(
  data$sale == 'Auction' ~1,
  data$sale == 'Online' ~2
)
data$modelCode <- case_when(
  data$model == 'X' ~1,
  data$model == 'Y' ~2,
  data$model == 'Z' ~3
)
data$sale <- NULL
data$model <- NULL

##### Normalizing Data
maxs <- apply(data, 2, max)
mins <- apply(data, 2, min)
n <- as.data.frame(scale(data, center = mins, scale = maxs - mins))


###################### Building Neural Net ##########################

set.seed(2)

##########  2 Hidden Layers
net.2 <- neuralnet(price ~ miles+saleCode+modelCode,
                 data= n, hidden= 2,
                 linear.output = TRUE)
### Predicting with Neural Net
pr.net.2 <- compute(net.2,              # object to use for predicting
                  n[,c(2, 4:5)],    # covariates
                  rep = 1)          # repetitions
plot(net.2)

predict.net.2 <- pr.net.2$net.result*(max(data$price)-min(data$price))+
  min(data$price) # reverse the scaling done earlier
MSE.net.2 <- rmse(data$price,predict.net.2) # actual vs. predicted

########## 3 Hidden Layers
net.3 <- neuralnet(price ~ miles+saleCode+modelCode,
                   data= n, hidden= 3,
                   linear.output = TRUE)
pr.net.3 <- compute(net.3, n[,c(2, 4:5)], rep = 1)
predict.net.3 <- pr.net.3$net.result*(max(data$price)-min(data$price))+min(data$price)
MSE.net.3 <- rmse(data$price,predict.net.3)

########## 4 Hidden Layers
net.4 <- neuralnet(price ~ miles+saleCode+modelCode,
                   data= n, hidden= 4,
                   linear.output = TRUE)
pr.net.4 <- compute(net.4, n[,c(2, 4:5)], rep = 1)
predict.net.4 <- pr.net.4$net.result*(max(data$price)-min(data$price))+min(data$price)
MSE.net.4 <- rmse(data$price,predict.net.4)

########## 5 Hidden Layers
net.5 <- neuralnet(price ~ miles+saleCode+modelCode,
                   data= n, hidden= 5,
                   linear.output = TRUE)
pr.net.5 <- compute(net.5, n[,c(2, 4:5)], rep = 1)
predict.net.5 <- pr.net.5$net.result*(max(data$price)-min(data$price))+min(data$price)
MSE.net.5 <- rmse(data$price,predict.net.5)

######################## Model Comparison ##########################

##### 2 Hidden Layers
paste('MSEs for linear regression and neural net(2):',
      round(MSE.lm, 0),
      '&',
      round(MSE.net.2,0)) ;paste('Percent difference for nn(2):', round(((MSE.net.2 - MSE.lm)/MSE.lm*100),2),'%')

##### 3 Hidden Layers
paste('MSEs for linear regression and neural net(3):',
      round(MSE.lm, 0),
      '&',
      round(MSE.net.3,0)) ; paste('Percent difference for nn(3):', round(((MSE.net.3 - MSE.lm)/MSE.lm*100),2),'%')

##### 4 Hidden Layers
paste('MSEs for linear regression and neural net(4):',
      round(MSE.lm, 0),
      '&',
      round(MSE.net.4,0)) ; paste('Percent difference for nn(4):', round(((MSE.net.4 - MSE.lm)/MSE.lm*100),2),'%')

##### 5 Hidden Layers
paste('MSEs for linear regression and neural net(5):',
      round(MSE.lm, 0),
      '&',
      round(MSE.net.5,0)); paste('Percent difference for nn(5):', round(((MSE.net.5 - MSE.lm)/MSE.lm*100),2),'%')

########## Graphing the Comparison

data <- data %>% mutate(diff = predict.lm - predict.net.4)
ggplot(data, aes(x=price)) +
  geom_point(aes(y=diff, color='Prediction difference')) +
  geom_point(aes(y=predict.lm, color='Linear model')) +
  geom_point(aes(y=predict.net,color='Neural net')) +
  geom_abline(intercept = 0, slope = 1) +
  xlab('Actual price') +
  ylab('Predicted price') +
  scale_color_discrete(name="Color Legend") +
  ggtitle("Comparison of Linear Regression & Neural Network",
          subtitle="4 Hidden Layers in Neural Network")