require(likert)

survey <- read.csv("ContributorsSurvey.csv", header=T)
colnames(survey) <- c("NoticeBots", "EasierBotsInt", "Guidelines", "CodeReview", "DecisionTime", 
                      "CI", "Tests","License", "SocialInteraction")

surveyInt <- read.csv("IntegratorsSurvey.csv", header=T)
colnames(surveyInt) <- c("Guidelines", "CodeReview", "DecisionTime", 
                      "CI", "Tests","License", "SocialInteraction")

# set levels and their ordering
mylevels <- c("Very irrelevant support", "Irrelevant support", "I do not know", "Relevant support", "Very relevant support")



# columns to generate the chart
columns = c("Guidelines", "CodeReview", "DecisionTime", 
            "CI", "Tests","License", "SocialInteraction")

# likert scale
filtered = survey[columns]

# make sure all columns have all the levels (otherwise 'likert' function breaks)
for(i in seq_along(filtered)) {
  filtered[,i] <- factor(filtered[,i], levels=mylevels)
}

x <- likert(filtered)

### GENERATE DEFINITIONS.TEX
strongly_agree = 6
agree = 5
neutral = 4
disagree = 3
strongly_disagree = 2


### GENERATE FIGURES

# figure 1
columns_fig1 = c("Guidelines", "CodeReview", "DecisionTime", 
                 "CI", "Tests","License", "SocialInteraction") # order in the paper
filtered = survey[columns_fig1]

# make sure all columns have all the levels (otherwise 'likert' function breaks)
for(i in seq_along(filtered)) {
  filtered[,i] <- factor(filtered[,i], levels=mylevels)
}


x <- likert(filtered)
x$results$Item <- c("Q1. Explain the Project Guidelines",
                    "Q2. Help during the code review",
                    "Q3. Decrease time to merge / reject your Pull Request",
                    "Q4. Automate the continuous integration required",
                    "Q5. Run tests / quality assurance tasks",
                    "Q6. License Issues related to contributions",
                    "Q7. Improve the social interaction between integrators and contributors") 
colnames(x$items)  <- c("Q1. Explain the Project Guidelines",
                        "Q2. Help during the code review",
                        "Q3. Decrease time to merge / reject your Pull Request",
                        "Q4. Automate the continuous integration required",
                        "Q5. Run tests / quality assurance tasks",
                        "Q6. License Issues related to contributions",
                        "Q7. Improve the social interaction between integrators and contributors")
#x$results$Item <- c("Q1", "Q2", "Q3", "Q4", "Q5", "Q6", "Q7", "Q8", "Q9", "Q10") 
#colnames(x$items) <- c("Q1", "Q2", "Q3", "Q4", "Q5", "Q6", "Q7", "Q8", "Q9", "Q10") 


pdf("survey-likert-contributors.pdf", width=12, height=3.5)
likert.bar.plot(x, centered = T, group.order = x$results$Item, legend.position="") +
               theme(text = element_text(size = rel(4.5)), axis.title.x=element_blank())
dev.off()


# figure 2
columns_fig2 = c("Guidelines", "CodeReview", "DecisionTime", 
                 "CI", "Tests","License", "SocialInteraction") # order in the paper
filtered = surveyInt[columns_fig2]

# make sure all columns have all the levels (otherwise 'likert' function breaks)
for(i in seq_along(filtered)) {
  filtered[,i] <- factor(filtered[,i], levels=mylevels)
}


x <- likert(filtered)
x$results$Item <- c("Q1. Explain the Project Guidelines",
                    "Q2. Help during the code review",
                    "Q3. Decrease time to merge / reject your Pull Request",
                    "Q4. Automate the continuous integration required",
                    "Q5. Run tests / quality assurance tasks",
                    "Q6. License Issues related to contributions",
                    "Q7. Improve the social interaction between integrators and contributors") 
colnames(x$items)  <- c("Q1. Explain the Project Guidelines",
                        "Q2. Help during the code review",
                        "Q3. Decrease time to merge / reject your Pull Request",
                        "Q4. Automate the continuous integration required",
                        "Q5. Run tests / quality assurance tasks",
                        "Q6. License Issues related to contributions",
                        "Q7. Improve the social interaction between integrators and contributors")
#x$results$Item <- c("Q1", "Q2", "Q3", "Q4", "Q5", "Q6", "Q7", "Q8", "Q9", "Q10") 
#colnames(x$items) <- c("Q1", "Q2", "Q3", "Q4", "Q5", "Q6", "Q7", "Q8", "Q9", "Q10") 

pdf("survey-likert-integrators.pdf", width=12, height=3.5)
likert.bar.plot(x, centered = T, group.order = x$results$Item, legend.position="") + theme(text = element_text(size = rel(4.5)), axis.title.x=element_blank())
dev.off()
