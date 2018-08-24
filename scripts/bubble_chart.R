library(readr)
library(plotly)

selected <- read_csv("github.csv")
a <- read_delim("first_bot_interaction.csv", col_names = FALSE, delim = ";")
github <- selected[!is.na(selected$Verified),]

projects <- github[github$Name %in% a$X2,]
sub <- subset(projects, select = c(3, c(13:25)))

i <- 1
while (i <= nrow(sub)){
  s <- sub[i,]
  vec <- unique(c(s$`Code Review`, s$`Pull Request Review`, s$License, s$CI, s$Merge, s$`Mention Review`, s$Welcome, s$`Dependencies Control`,
           s$Benchmark, s$`Issue Creator`, s$Builder, s$Test, s$Test, s$Outside))
  vec <- vec[!is.na(vec)]
  lineina <- a[a$X2 == s$Name,]
  d <- as.Date(lineina$X7)
  write.table(t(c(lineina$X1, lineina$X2, projects[i,]$Language, projects[i,]$Domain, projects[i,]$Commits, as.character(d), length(vec))), "bot.csv", append=TRUE, eol = "\n", sep=";", col.names = F, row.names = F)
  i <- i + 1
}

bot <- read_delim("bot.csv", delim = ";")
ggplot(bot, aes(y = `First bot adoption`, x = Language)) +
  geom_point(aes(size = `Num. of bots`, colour = Domain), alpha=.5) +
  scale_size(breaks = c(1,2,3)) +
  scale_y_date(date_breaks = "1 year", date_labels = "%Y") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) 
ggsave("botperproject.png", width = 8, height = 4)
