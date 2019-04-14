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

########## Creating Loop for RMSE of 2 - 6 Hidden Layers
MSE.net <- tibble("Number of Hidden Layers" = integer(),
                  "RMSE" = integer())

for (i in 2:9) {
  net <- neuralnet(price ~ miles+saleCode+modelCode,
                   data= n, hidden= i,
                   linear.output = TRUE)
  ### Predicting with Neural Net
  pr.net <- compute(net,              # object to use for predicting
                    n[,c(2, 4:5)],    # covariates
                    rep = 1)          # repetitions
  predict.net <- pr.net$net.result*(max(data$price)-min(data$price))+
    min(data$price) # reverse the scaling done earlier
  MSE.net[i,1] <- i
  MSE.net[i,2] <- rmse(data$price,predict.net) # actual vs. predicted
}


######################## Model Comparison ##########################

MSE.net.best<-MSE.net %>%
  filter(RMSE == min(MSE.net[2:nrow(MSE.net),2]))

paste('Mean Squared Errors for linear regression and neural net:',
      round(MSE.lm, 0),
      '&',
      round(MSE.net.best[2],0))
paste('Percent improvement for Neural Net:',
      round(((MSE.lm - MSE.net.best[2])/MSE.lm*100),2),'%')

########## Graphing the Comparison

optimumLayers=MSE.net.best[["Number of Hidden Layers"]]

### Generating predictions with optimum number of hidden layers
net <- neuralnet(price ~ miles+saleCode+modelCode,
                 data= n, hidden= optimumLayers,
                 linear.output = TRUE)
pr.net <- compute(net,              # object to use for predicting
                  n[,c(2, 4:5)],    # covariates
                  rep = 1)          # repetitions
predict.net <- pr.net$net.result*(max(data$price)-min(data$price))+
  min(data$price)


data <- data %>% mutate(diff = predict.lm - predict.net)
ggplot(data, aes(x=price)) +
  geom_point(aes(y=diff, color='Prediction difference')) +
  geom_point(aes(y=predict.lm, color='Linear model')) +
  geom_point(aes(y=predict.net,color='Neural net')) +
  geom_abline(intercept = 0, slope = 1) +
  xlab('Actual price') +
  ylab('Predicted price') +
  scale_color_discrete(name="Color Legend") +
  ggtitle("Comparison of Linear Regression & Neural Network",
          subtitle=paste(optimumLayers,
                         "Hidden Layers in Neural Network"))