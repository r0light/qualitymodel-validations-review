library(ggplot2)
library(tidyr)

literature <- read.csv("quality-models-literature.csv", sep=";")

# check data types
str(literature)

# data cleaning (remove beginning and trailing whitespaces)
literature$Contribution <- trimws(literature$Contribution, which = c("both"))
literature$Characteristics <- trimws(literature$Characteristics, which = c("both"))
literature$Rationale <- trimws(literature$Rationale, which = c("both"))

# parse contribution type as factor
contributionFactor <- factor(c("model", "meta-model", "method", "validation-method", "taxonomy"))
literature$Contribution <- as.list(lapply(strsplit(literature$Contribution, ","), factor, levels=levels(contributionFactor)))

# parse rationale as factor
rationaleFactor <- factor(c("logical implication", "empirical-experts", "empirical-survey", "literature-based", "algorithmic", "none"))
literature$Rationale <- as.list(lapply(strsplit(literature$Rationale, ","), factor, levels=levels(rationaleFactor)))

# parse characteristics in consideration as factor
characteristicsFactor <- factor(c("internal characteristics", "external characteristics"))
literature$Characteristics <- as.list(lapply(strsplit(literature$Characteristics, ","), factor, levels=levels(characteristicsFactor)))

# initial plotting
#barplot(summary(unlist(literature$Contribution)))
#barplot(summary(unlist(literature$Rationale)))


# filtering
## filter for all entries where a model is presented
filtered_model <- subset(literature, grepl(match("model", levels(contributionFactor)), Contribution))
filtered_evaluation_method <- subset(literature, grepl(match("validation-method", levels(contributionFactor)), Contribution))

filtered <- rbind(filtered_model, filtered_evaluation_method)
filtered <- filtered[!duplicated(filtered[, c("BibtexKey")]), ]

filtered <- subset(filtered, grepl(match("internal characteristics", levels(characteristicsFactor)), Characteristics))

str(filtered)

# basic barplot
barplot(summary(unlist(filtered$Rationale)))


# better barplot
rationaleData <- data.frame(Rationale=unlist(filtered$Rationale))
ggplot(data=rationaleData, aes(x=Rationale)) +
  geom_bar(stat="count", width=0.7, fill="steelblue") +
  geom_text(stat='count', aes(label=..count..), vjust=1.6, color="white", size=3.5) +
  theme_minimal()


# transform back to text data
filtered$Contribution <- lapply(lapply(filtered$Contribution, unlist), paste, collapse=',')
filtered$Contribution <- as.character(filtered$Contribution)

filtered$Characteristics <- lapply(lapply(filtered$Characteristics, unlist), paste, collapse=',')
filtered$Characteristics <- as.character(filtered$Characteristics)

filtered$Rationale <- lapply(lapply(filtered$Rationale, unlist), paste, collapse=',')
filtered$Rationale <- as.character(filtered$Rationale)

write.csv(filtered,"./filtered.csv", row.names = FALSE)
