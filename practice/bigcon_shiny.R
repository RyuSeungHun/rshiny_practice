pkgs <- c('shiny','ggplot2','stringr','dplyr',
          'dplyr','DT','tools','data.table')
sapply(pkgs,require,character.only = TRUE)

setwd('D:/github_desktop/rshiny_practice/practice')
df <- read.csv('bigcon_shiny.csv')
df$year <- str_sub(df$open_day,1,4)
df <- df[,c(3,5:8,9,11:15,17:22)]
df[,c('month','day')][is.na(df[,c('month','day')])] <- 'no_date'
ddx <- which(sapply(df,class) == 'character') %>% unname()
df[,ddx] <- lapply(df[,ddx],factor)

ui <- fluidPage(
  
  titlePanel(
    '2017_빅콘테스트 영화',
    windowTitle = 'movies'
  ),
  
  sidebarLayout(
    sidebarPanel(
      
      selectInput(inputID = 'x',
                  label = 'x축',
                  choices = c(
                    
                  )
                  )
    )
  )
)