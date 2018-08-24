library(readr)
library(ggplot2)
library(ggpubr)

data_merged <- read_csv("merged.csv", trim_ws = FALSE)
data_unmerged <- read_csv("unmerged.csv", trim_ws = FALSE)

data_merged["month_index"] <- NA
data_merged$month_index <- rep((-6:6)[-6:6 != 0], 44)
data_merged$month_index <- factor(data_merged$month_index, levels=c((-6:6)[-6:6 != 0]),ordered=TRUE)

data_unmerged["month_index"] <- NA
data_unmerged$month_index <- rep((-6:6)[-6:6 != 0], 44)
data_unmerged$month_index <- factor(data_unmerged$month_index, levels=c((-6:6)[-6:6 != 0]),ordered=TRUE)

# Commits
g1 <- ggplot(data_merged, aes(data_merged$month_index, as.numeric(data_merged$num_commits))) + 
      geom_boxplot() +
      scale_y_log10(breaks = scales::trans_breaks("log10", function(x) 10^x), 
                labels = scales::trans_format("log10", scales::math_format(10^.x))) +
      theme(text = element_text(size = 7)) +
      labs(y="Num. commits in merged PRs", x="Month index")

g2 <- ggplot(data_unmerged, aes(data_unmerged$month_index, as.numeric(data_unmerged$num_commits))) + 
      geom_boxplot() +
      scale_y_log10(breaks = scales::trans_breaks("log10", function(x) 10^x), 
                    labels = scales::trans_format("log10", scales::math_format(10^.x))) +
      theme(text = element_text(size = 7)) +
      labs(y="Num. commits in non-merged PRs", x="Month index")

ggarrange(g1, g2, nrow = 2, ncol = 1)

ggsave("commits.png", width = 4, height = 4, dpi = 300)

# Churn
c1 <- ggplot(data_merged, aes(data_merged$month_index, as.numeric(data_merged$avg_churn))) + 
  geom_boxplot() +
  scale_y_log10(breaks = scales::trans_breaks("log10", function(x) 10^x), 
              labels = scales::trans_format("log10", scales::math_format(10^.x))) +
  theme(text = element_text(size = 7)) +
  labs(y="Mean churn in merged PRs", x="Month index")

c2 <- ggplot(data_unmerged, aes(data_unmerged$month_index, as.numeric(data_unmerged$avg_churn))) + 
  geom_boxplot() +
  scale_y_log10(breaks = scales::trans_breaks("log10", function(x) 10^x), 
                labels = scales::trans_format("log10", scales::math_format(10^.x))) +
  theme(text = element_text(size = 7)) +
  labs(y="Mean churn in non-merged PRs", x="Month index")

ggarrange(c1, c2, nrow = 2, ncol = 1)

ggsave("churn.png", width = 4, height = 4)

# comments review
c1 <- ggplot(data_merged, aes(data_merged$month_index, as.numeric(data_merged$avg_review_comments))) + 
  geom_boxplot() +
  scale_y_log10(breaks = scales::trans_breaks("log10", function(x) 10^x), 
                labels = scales::trans_format("log10", scales::math_format(10^.x))) +
  theme(text = element_text(size = 7)) +
  labs(y="Mean com. review in merged PRs", x="Month index")

c2 <- ggplot(data_unmerged, aes(data_unmerged$month_index, as.numeric(data_unmerged$avg_review_comments))) + 
  geom_boxplot() +
  scale_y_log10(breaks = scales::trans_breaks("log10", function(x) 10^x), 
                labels = scales::trans_format("log10", scales::math_format(10^.x))) +
  theme(text = element_text(size = 7)) +
  labs(y="Mean com. review in non-merged PRs", x="Month index")

ggarrange(c1, c2, nrow = 2, ncol = 1)

ggsave("comments_review.png", width = 4, height = 4)


# comments
c1 <- ggplot(data_merged, aes(data_merged$month_index, as.numeric(data_merged$avg_comments))) + 
  geom_boxplot() +
  scale_y_log10(breaks = scales::trans_breaks("log10", function(x) 10^x), 
                labels = scales::trans_format("log10", scales::math_format(10^.x))) +
  theme(text = element_text(size = 7)) +
  labs(y="Mean comments in merged PRs", x="Month index")

c2 <- ggplot(data_unmerged, aes(data_unmerged$month_index, as.numeric(data_unmerged$avg_comments))) + 
  geom_boxplot() +
  scale_y_log10(breaks = scales::trans_breaks("log10", function(x) 10^x), 
                labels = scales::trans_format("log10", scales::math_format(10^.x))) +
  theme(text = element_text(size = 7)) +
  labs(y="Mean comments in non-merged PRs", x="Month index")

ggarrange(c1, c2, nrow = 2, ncol = 1)

ggsave("comments.png", width = 4, height = 4)

# changed files
c1 <- ggplot(data_merged, aes(data_merged$month_index, as.numeric(data_merged$avg_changed_files))) + 
  geom_boxplot() +
  scale_y_log10(breaks = scales::trans_breaks("log10", function(x) 10^x), 
                labels = scales::trans_format("log10", scales::math_format(10^.x))) +
  theme(text = element_text(size = 7)) +
  labs(y="Mean changed files in merged PRs", x="Month index")

c2 <- ggplot(data_unmerged, aes(data_unmerged$month_index, as.numeric(data_unmerged$avg_changed_files))) + 
  geom_boxplot() +
  scale_y_log10(breaks = scales::trans_breaks("log10", function(x) 10^x), 
                labels = scales::trans_format("log10", scales::math_format(10^.x))) +
  theme(text = element_text(size = 7)) +
  labs(y="Mean changed files in non-merged PRs", x="Month index")

ggarrange(c1, c2, nrow = 2, ncol = 1)

ggsave("changed_files.png", width = 4, height = 4)

# close time
c1 <- ggplot(data_merged, aes(data_merged$month_index, as.numeric(data_merged$avg_close_time_seconds))) + 
  geom_boxplot() +
  scale_y_log10(breaks = scales::trans_breaks("log10", function(x) 10^x), 
                labels = scales::trans_format("log10", scales::math_format(10^.x))) +
  theme(text = element_text(size = 7)) +
  labs(y="Mean close time in merged PRs", x="Month index")

c2 <- ggplot(data_unmerged, aes(data_unmerged$month_index, as.numeric(data_unmerged$avg_close_time_seconds))) + 
  geom_boxplot() +
  scale_y_log10(breaks = scales::trans_breaks("log10", function(x) 10^x), 
                labels = scales::trans_format("log10", scales::math_format(10^.x))) +
  theme(text = element_text(size = 7)) +
  labs(y="Mean close time in non-merged PRs", x="Month index")

ggarrange(c1, c2, nrow = 2, ncol = 1)

ggsave("close_time.png", width = 4, height = 4)

# pull requests
c1 <- ggplot(data_merged, aes(data_merged$month_index, as.numeric(data_merged$num_pull_requests))) + 
  geom_boxplot() +
  scale_y_log10(breaks = scales::trans_breaks("log10", function(x) 10^x), 
                labels = scales::trans_format("log10", scales::math_format(10^.x))) +
  theme(text = element_text(size = 7)) +
  labs(y="Num. PRs merged", x="Month index")

c2 <- ggplot(data_unmerged, aes(data_unmerged$month_index, as.numeric(data_unmerged$num_pull_requests))) + 
  geom_boxplot() +
  scale_y_log10(breaks = scales::trans_breaks("log10", function(x) 10^x), 
                labels = scales::trans_format("log10", scales::math_format(10^.x))) +
  theme(text = element_text(size = 7)) +
  labs(y="Num. PRs unmerged", x="Month index")

ggarrange(c1, c2, nrow = 2, ncol = 1)

ggsave("pull_requests.png", width = 4, height = 4)
