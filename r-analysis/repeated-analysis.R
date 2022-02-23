library(ggplot2)
library(tidyr)

literature <- read.csv("final-set.csv", sep=",")

# check data types
str(literature)

# data cleaning (remove beginning and trailing whitespaces)
literature$BibtexKey <- trimws(literature$BibtexKey, which = c("both"))
literature$Contribution <- trimws(literature$Contribution, which = c("both"))
literature$Characteristics <- trimws(literature$Characteristics, which = c("both"))
literature$Rationale <- trimws(literature$Rationale, which = c("both"))
literature$Notes <- trimws(literature$Notes, which = c("both"))

# parse contribution type as factor
contributionFactor <- factor(c("model", "meta-model", "method", "evaluation-method", "taxonomy"))
literature$Contribution <- as.list(lapply(strsplit(literature$Contribution, ","), factor, levels=levels(contributionFactor)))

# parse characteristics in consideration as factor
characteristicsFactor <- factor(c("internal characteristics", "external characteristics"))
literature$Characteristics <- as.list(lapply(strsplit(literature$Characteristics, ","), factor, levels=levels(characteristicsFactor)))

# parse rationale as factor
rationaleFactor <- factor(c("logical implication", "empirical-experts", "empirical-survey", "literature-based", "algorithmic", "none"))
literature$Rationale <- as.list(lapply(strsplit(literature$Rationale, ","), factor, levels=levels(rationaleFactor)))

# parse explicit evaluation as factor
literature$ExplicitValidation <- as.factor(literature$ExplicitValidation)

# parse evaluated relations as factor
validatedRelationsFactor <- factor(c("CodeMeasure-ProductFactor", "DeploymentMeasure-CodeMeasure", "UserMeasure-DeploymentMeasure", "ProductFactorImpactWeights", "ProductFactor-QualityAspect", "QualityAspectValidity","ExpertRating-QualityModelResult"))
literature$ValidatedRelations <- as.list(lapply(strsplit(literature$ValidatedRelations, ","), factor, levels=levels(validatedRelationsFactor)))

# filter for all entries where a model is presented
filtered_model <- subset(literature, grepl(match("model", levels(contributionFactor)), Contribution))

# how many models have been explicitly validated
# ggplot(data=filtered_model, aes(x=ExplicitValidation)) +
#  geom_bar(stat="count", width=0.7, fill="steelblue") +
#  geom_text(stat='count', aes(label=..count..), vjust=1.6, color="white", size=3.5) +
#  theme_minimal() 

explicitlyValidated <- subset(filtered_model, filtered_model$ExplicitValidation == "yes")
sprintf("Out of %d models, %d have been explicitly validated.", nrow(filtered_model), sum(filtered_model$ExplicitValidation == "yes"))

# Barplot for rationale used overall
rationaleData <- data.frame(Rationale=unlist(filtered_model$Rationale))
ggplot(data=rationaleData, aes(x=Rationale)) +
  geom_bar(stat="count", width=0.5, fill=rgb(0.26,0.37,0.52)) +
  geom_text(stat='count', aes(label=..count..), position = position_stack(vjust = 0.5), color="white", size=4.5) +
  theme_minimal() + 
  theme(axis.text=element_text(size=14), axis.title=element_text(size=14,face="plain"))


# better barplot for rationale
#contributionData <- data.frame(Contribution=unlist(literature$Contribution))
#ggplot(data=contributionData, aes(x=Contribution)) +
#  geom_bar(stat="count", width=0.7, fill="steelblue") +
#  geom_text(stat='count', aes(label=..count..), vjust=1.6, color="white", size=3.5) +
#  theme_minimal()





# transform back to text data
filtered$Contribution <- lapply(lapply(filtered$Contribution, unlist), paste, collapse=',')
filtered$Contribution <- as.character(filtered$Contribution)

filtered$Characteristics <- lapply(lapply(filtered$Characteristics, unlist), paste, collapse=',')
filtered$Characteristics <- as.character(filtered$Characteristics)

filtered$Rationale <- lapply(lapply(filtered$Rationale, unlist), paste, collapse=',')
filtered$Rationale <- as.character(filtered$Rationale)

filtered$ExplicitEvaluation <- as.character(filtered$ExplicitEvaluation)

filtered$EvaluatedRelations <- lapply(lapply(filtered$EvaluatedRelations, unlist), paste, collapse=',')
filtered$EvaluatedRelations <- as.character(filtered$EvaluatedRelations)


write.csv(filtered,"./test.csv", row.names = FALSE)
