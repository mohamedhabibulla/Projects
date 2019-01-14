#Loading the required packages
library(rvest)
library(shiny)
library(shinydashboard)
library(DT)

#Specifying the url to be scraped
url <- 'https://www.imdb.com/search/title?count=100&release_date=2018,2018'

#Read the HTML code from the website
webpage <- read_html(url)

#Scrape the main title of the webpage
main_title <- html_nodes(webpage,'h1.header')
mt_text <- html_text(main_title)
webtitle <- gsub("\n","",mt_text)

#Scrape the rankings from the webpage 
rank_data_html <- html_nodes(webpage,'.text-primary')
rank_text <- html_text(rank_data_html)
rank_text <- as.numeric(rank_text)
#head(rank_text)

#Scrape the movie titles from the webpage 
movie_data_html <- html_nodes(webpage,'.lister-item-header a')
movie_text <- html_text(movie_data_html)
movie_text <- gsub("\n","",movie_text)

#Scrape the movie description from the webpage
movie_desc_html <- html_nodes(webpage,'.ratings-bar+ .text-muted')
movie_desc_text <- html_text(movie_desc_html)
movie_desc_text <- gsub("\n","",movie_desc_text)
#head(movie_desc_text)

#Creating data frame with the three features Ranking, Movie title, Movie description
movie_df <- data.frame(Rank=rank_text,Movie_Title=movie_text,Movie_description=movie_desc_text)

#server code
server <- function(input, output, session) {
  
  #Render Data Table for movie data frame set with single selection and rownames false
  output$movie_table <- DT::renderDataTable({
    datatable(movie_df, selection = "single",rownames = FALSE)
  })
  
  #Render text to show the webpage title
  output$web_title <- renderText({
  webtitle  
  })
}



