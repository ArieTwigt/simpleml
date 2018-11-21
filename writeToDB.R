# Module required for exporting to database
library(DBI)
library("RSQLite")

# Import CSV-file
projecten <- read.csv("~/Sites/expnisi/data/projecten.csv", sep=";", stringsAsFactors=FALSE)

# Save to database
con <- dbConnect(SQLite(), dbname="database.db")

# Write to database
dbWriteTable(con, "projecten", projecten)