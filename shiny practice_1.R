pkgs <- c('shiny','ggplot2','dplyr','tools')
sapply(pkgs,require,character.only = TRUE)

load(url("http://s3.amazonaws.com/assets.datacamp.com/production/course_4850/datasets/movies.Rdata"))

# ui
ui <- fluidPage(
  
  titlePanel('Movie browser'),
  
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = 'y',
                  label = 'y-axis : ',
                  choices = c('IMDB_ rating'         = 'imdb_rating',
                              'IMDB number of votes' = 'imdb_num_votes',
                              'Critics score'        = 'critics_score',
                              'Audience score'       = 'audience_score',
                              'Runtime'              = 'runtime'),
                  selected = 'audience_score'),
      
      selectInput(inputId = 'x',
                  label = 'x-axis : ',
                  choices = c('IMDB_ rating'         = 'imdb_rating',
                              'IMDB number of votes' = 'imdb_num_votes',
                              'Critics score'        = 'critics_score',
                              'Audience score'       = 'audience_score',
                              'Runtime'              = 'runtime'),
                  selected = 'critics_score'),
      selectInput(inputId = 'z',
                  label = 'Color by : ',
                  choices = c('Title type'       = 'title_type',
                              'Genre'            = 'genre', 
                              'MPAA rating'      = 'mpaa_rating',
                              'Critics rating'   = 'critics_rating',
                              'Audience rating'  = 'audience_rating'),
                  selected = 'mpaa_rating'),
      
      textInput(inputId = 'plot_title',
                label = 'Plot title',
                placeholder = 'Enter text plot title'),
      
      checkboxGroupInput(inputId = 'selected_type',
                         label = 'Select movie type(s) : ',
                         choices = c('Documentary','Feature Film',
                                     'TV Movie'),
                         selected = 'Feature Film')
    ),
   mainPanel(
     plotOutput(outputId = 'scatterplot'),
     textOutput(outputId = 'description')
   )
  )
)

# server
server <- function(input,output){
  movies_subset <- reactive({
    req(input$selected_type)
    filter(movies, title_type %in% input$selected_type)
  })
  pretty_plot_title <- reactive({
    toTitleCase(input$plot_title)
  })
  
  output$scatterplot <- renderPlot({
    ggplot(data = movies_subset(),
           aes_string(x = input$x, y = input$y,
                      color = input$z)) +
    geom_point() +
    labs(title = pretty_plot_title())
  })
  output$description <- renderText({
    paste0("The plot above titled '", pretty_plot_title(), "' 
           visualizes the relationship between ",
           input$x, " and ", input$y, ", conditional on",
           input$z, ".")
  })
}

shinyApp(ui, server)
