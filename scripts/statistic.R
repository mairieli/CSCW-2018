library(readr)
library(effsize)

trunc.dig <- function(x, digits) trunc(x*10^digits)/10^digits

stat.tests <- function(before, after, column) {
  w <- wilcox.test(unlist(before[column]), unlist(after[column]))
  es = cliff.delta(unlist(before[column]), unlist(after[column]), return.dm = TRUE)
  
  results <- c(w$p.value, es$estimate)
  
  return(results)
}

data <- read_csv("selected.csv", trim_ws = FALSE)

# updating churn
data["num_churn"] <- NA
data$num_churn <- data$num_add + data$num_del

projects <- unique(data$name)

for (project in projects) {
  project_data <- data[data$name == project,]
  
  merged <- project_data[project_data$is_merged == 'True',]
  unmerged <- project_data[project_data$is_merged == 'False',]
  
  merged_before <- merged[merged$is_before == 'True',]
  merged_after <- merged[merged$is_before == 'False',]
  
  unmerged_before <- unmerged[unmerged$is_before == 'True',]
  unmerged_after <- unmerged[unmerged$is_before == 'False',]
  
  # comments
  comments_merged <- stat.tests(merged_before, merged_after, "num_comments")
  comments_unmerged <- stat.tests(unmerged_before, unmerged_after, "num_comments")
  
  # review comments
  review_merged <- stat.tests(merged_before, merged_after, "num_review_comments")
  review_unmerged <- stat.tests(unmerged_before, unmerged_after, "num_review_comments")
  
  # commits
  commits_merged <- stat.tests(merged_before, merged_after, "num_commits")
  commits_unmerged <- stat.tests(unmerged_before, unmerged_after, "num_commits")
  
  # changed files
  files_merged <- stat.tests(merged_before, merged_after, "num_changed_files")
  files_unmerged <- stat.tests(unmerged_before, unmerged_after, "num_changed_files")
  
  # close time
  time_merged <- stat.tests(merged_before, merged_after, "close_time_seconds")
  time_unmerged <- stat.tests(unmerged_before, unmerged_after, "close_time_seconds")
  
  # Churn
  churn_merged <- stat.tests(merged_before, merged_after, "num_churn")
  churn_unmerged <- stat.tests(unmerged_before, unmerged_after, "num_churn")

  result <- data.frame(t(c(project, trunc.dig(comments_merged, 4), trunc.dig(comments_unmerged, 4), 
                                  trunc.dig(review_merged, 4), trunc.dig(review_unmerged, 4),
                                  trunc.dig(commits_merged, 4), trunc.dig(commits_unmerged, 4),
                                  trunc.dig(files_merged, 4), trunc.dig(files_unmerged, 4),
                                  trunc.dig(time_merged, 4), trunc.dig(time_unmerged, 4),
                                  trunc.dig(churn_merged, 4), trunc.dig(churn_unmerged, 4))))
  write.table(result, "result_stat.csv", append=TRUE, eol = "\n", sep=";", col.names = F, row.names = F)
}

