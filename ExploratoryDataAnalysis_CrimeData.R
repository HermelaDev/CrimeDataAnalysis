---
  title: "ExploratoryDataAnalysis_CrimeData"
author: "Hermela Seltanu"
date: "2024-11-09"
output: html_document
---
  
# installing packages
# install.packages('tidyverse')

# Loading the libraries
library(tidyverse)
library(readr)
library(scales)


# importing the dataset
data <- read_csv("C:\\Users\\Hermela\\Desktop\\Predogy_Internship\\Cleaned_Crime_Data.csv")

glimpse(data)

# Changing the data types to factor
data$`Part_1-2`<- as.factor(data$`Part_1-2`)
data$Weapon_Desc <- as.factor(data$Weapon_Desc)
data$Status_Desc <- as.factor(data$Status_Desc)
data$Vict_Sex <- as.factor(data$Vict_Sex)
data$Vict_Descent <- as.factor(data$Vict_Descent)

# To get statistical information
summary(data$Vict_Age)

# Frequency counts for the categoriacals
cat("Part_1-2:- \n")
table(data$`Part_1-2`)
cat("\n\n") 

cat("Weapon_Desc:- \n")
table(data$Weapon_Desc)
cat("\n\n") 

cat("Status_Desc:- \n")
table(data$Status_Desc)
cat("\n\n") 

cat("Vict_Descent:- \n")
table(data$Vict_Descent)
cat("\n\n") 

cat("Vict_Sex:- \n")
table(data$Vict_Sex)


#### Categorical Columns

# Calculating the crime count for each gender
gender_data <- data %>%
  count(Vict_Sex) %>%
  mutate(percentage = n / sum(n) * 100)

# Creating a donut chart to help comparison
ggplot(gender_data, aes(x = 2, y = n, fill = Vict_Sex)) +
  geom_bar(stat = "identity") +   
  coord_polar(theta = "y") +
  xlim(1, 2.5) +  # To create the hole in the middle
  geom_text(aes(label = paste0(round(percentage), "%")),
            position = position_stack(vjust = 0.5), size = 4) +
  labs(title = "Victims Gender Distribution", fill = "Victim's Gender") +
  theme_void() +
  scale_fill_manual(values = c("purple", "yellow", "green")) +
  theme(legend.position = "right")


# Creating bar graph to show the distribution in seriousness of crimes
ggplot(data, aes(x = `Part_1-2`)) +
  geom_bar(fill = "blue") +
  labs(title = "Seriousness of Crimes", x = "Seriousness level", y = "Crime Count") +
  scale_y_continuous(labels = comma) +
  theme_gray()


# Creating bar chart to analyze weapon usage by victim gender
ggplot(data, aes(x = Weapon_Desc, fill = Vict_Sex)) +
  geom_bar(position = "dodge") +
  labs(title = "Weapon Usage by Victim Gender", x = "Weapon Description", y = "Number of Victims", fill = "Victim Gender") +
  scale_y_continuous(labels = comma) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  scale_fill_manual(values = c("lightblue", "red", "black"))


#### Numericla Columns

# Creating a histogram for the numerucal variable 'vict_Age' and categorizing it by gender
ggplot(data, aes(x = Vict_Age)) +
  geom_histogram(binwidth = 1, fill = "brown", color = "red") +
  labs(title = "Distribution of Victim Age", x = "Victim Age", y = "Number of Victims") +
  scale_y_continuous(labels = comma) +
  facet_wrap(~Vict_Sex) +
  theme_bw()

### Insights from the above summary statistics and visualizations

#### - Crime Severity (Part_1-2):

The dataset reveals a significant number of serious crimes (585,404 occurrences) and less serious crimes (397,234 occurrences) in the region Over the past four years. This insight tells us that while the focus is is mostly given to serious crimes, it is important to address the numerous less serious crimes as well, as they collectively represent a substantial portion of criminal activities. Both crime categories may need different law enforcement strategies.

#### - Victim Age Distribution:

Victims of crimes show a wide range of ages, with most victims being in their 30s. This age group seems to be highly affected by crime, highlighting the need for special attention and crime prevention programs focusing on this demographic.

#### - Weapon Usage:

The majority of crimes were committed without weapons, followed by crimes involving bladed or sharp objects and firearms. This pattern may reflect trends in the types of crimes occurring, in which crimes not involving weapons being more common. However, the presence of firearms and bladed objects in a numerous number of crimes signals a need for better regulatio on weapon use.

#### - Criminal Status (status_Desc):

The 'status_Desc' column shows that a large portion of the crimes are still under investigaton. When I analyze the proportion of crimes leading to arrests vs those that are unresolved, 80% of the crimes are still under investigation, which indicates a large portion of unresolved cases. The 8.7% of the crimes resulted adult arrests, 10.9% resulted other adult offences, and 0.33% juvenile arrests. This insight from the data shows the challanges that the law enforcement and crime investigations are going through across the US.

#### - Victim Gender:

Females constitute the majority of the victims, which suggests an increased vulnerability to certain types of crimes. This is a concerning trend that warrants further research, especially as femicide rates (gender-based killings of women) are rising globally, including in countries like Kenya. Addressing violence against women and improving victim support systems could be crucial.

#### - Victim Descent (Vict_Descent Column):

The majority of victims belong to the Hispanic(H) community, followed by White and Black victims. This distribution suggests possible disparities in number of victims across different ethnic groups. Understanding the socio-economic and cultural factors that contribute to this pattern could help develop crime prevention strategies in these communities.


unique(data$AREA_NAME)
ggplot(data, aes(x=AREA_NAME, fill = AREA_NAME))+
  geom_bar()+
  labs(title = "Crime frequency in different areas")

#### Interpretation and insight

The above bar plot shows the frequency of crimes across different areas. The x-axis lists the area names, and the y-axis shows the count of crimes. We can see that the Central & 77th Street have the highest crime frequencies and Foothill & Hollenbeck have relatively lower crime occurrences.

This variation in crime frequencies indicate that some areas are prone to crimes than others, and law enforcement officials can use this information to allocate resources more effectively.


# Breaking the DATE_OCC column into Year, Month, and Day
data <- data %>%
  mutate(DATE_OCC = ymd(DATE_OCC),
         Year = year(DATE_OCC), 
         Month = month(DATE_OCC), 
         Day = day(DATE_OCC)) 

# Converting numeric months to full month names
data <- data %>%
  mutate(Month = month.name[Month])


# Converting Month to a factor 
data$Month <- factor(data$Month, levels = c("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"))

# Creating bar chart to analyze the crime counts in each month
ggplot(data, aes(x = Month, fill = Month)) +
  geom_bar() +
  labs(title = "Crime Frequency Over Time", x = "Month", y = "Crime Count") +
  theme_minimal()

#### Interpretation and insight

The above bar plot show the distribution of crime over months of the year. The x-axis shows the months, and the y-axis is representing the crime occurrences. The plot shows January with the highest frequency of crimes, then decline as the year progresses, and lower counts in November and December.

The variation in the crimes frequency over the months can be related to multiple scenarios. The post-holiday factors such as economic stress could be the issue for higher crime rate in January and the increased effort of legal bodies in preparation for the holidays could have caused for the decline of crimes during the last months.

# Creating bar chart to analyze crime occurrence throughout years
ggplot(data, aes(x = Year)) +
  geom_bar(fill = "purple", width = 0.5) +
  labs(title = "Crime Frequency throughout years", x = "Date", y = "Crime Count", fill="Years")


# Crime trends throughout months for each year
ggplot(data, aes(x = Month, group = Year, color = factor(Year))) +
  geom_line(stat = "count") +
  geom_point(stat = "count") +
  labs(title = "Crimes throughout months for each year", x = "Month", y = "Crime Count", color = "Year") +
  theme_minimal()


#### Interpretation and insight

Crime counts generally increased, as we go from 2020-2022. This increase might be linked to post-pandemic challenges.The decline in crime frequency from 2023 might be showing fruitful interventions. Such analysis over years and months made the legal bodies realize what have changed to cause a certain variation.
