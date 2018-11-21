#########################################################
# Create regression model for prediction of costs 'Personeelskosten' 
#########################################################
library(DBI)
library(RSQLite)
library(dummies)

# 1. Data collection
##################

# Connect to database
con <- dbConnect(SQLite(), dbname="database.db")

# Import file
res <- dbSendQuery(con, "select * from projecten")
projecten <- dbFetch(res)

# Check file
str(projecten)
summary(projecten)

# Verdelingen kijken voor variabelen
summary(factor(projecten$Type.Project))

# Visualiseren
barplot(summary(factor(projecten$Type.Project)))

# 2. Normalization - Not needed
######################################

# 3. Dimension Reduction - Not needed
######################################

# 4. Data Augmentation
######################################

# New variable: Costs per hour
projecten$Kosten.Uur <- projecten$Personeelskosten / projecten$Uren.Project

# check new variable
head(projecten$Kosten.Uur)

# 5. Data Conversion - To one-hot-encoding
######################################

# check variables
str(projecten)
projecten_oh <- dummy.data.frame(projecten, 
                                 names = c("Werkgroep", "Maand", "Type.Project"), 
                                 sep = "_")


# 6. Modelling - Experimenting
######################################

# model 1: one variable
model <- lm(Personeelskosten ~ Materiaalkosten, data = projecten_oh)
print(model)
summary(model)

# model 2: all variables
model2 <- lm(Personeelskosten ~ ., data = projecten_oh)
summary(model2)

# model 3: roughly only take significant variables
model3 <- lm(Personeelskosten ~ Tevredenheid.Klant + Uren.Project + Materiaalkosten  + Maand_januari,
             data = projecten_oh)
summary(model3)

# model 3: roughly only take significant variables
model4 <- lm(Personeelskosten ~ Uren.Project,
             data = projecten_oh)
summary(model4)

# 7. Visualizing
######################################
plot(projecten_oh$Uren.Project, projecten_oh$Personeelskosten)
print(model4)
abline(712.8, 16.8)

