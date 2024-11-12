---
  title: "DataCleaning_CrimeData"
author: "Hermela Seltanu"
date: "2024-11-02"
output: html_document
---
  
  ```{r warning=FALSE, message=FALSE}
# installing packages
# install.packages('tidyverse')

# Loading the libraries
library(tidyverse)
library(readxl)
library(lubridate)
library(hms)

```

```{r}
# importing the dataset
data <- read_excel("C:\\Users\\Hermela\\Desktop\\Predogy_Internship\\Crime_Data_from_2020_to_Present_up.xlsx")
data
```

```{r}
data
# Dimension of dataframe
dim(data)
```

```{r}
# To know all of our column names
colnames(data)
```

```{r}
# To understand data type of each column in the dataframe
glimpse(data)
```

```{r}
# Checking for duplicated rows
sum(duplicated(data))
```

# **Cleaning each column**

```{r}
# Renaming columns
colnames(data) <- gsub(" ", "_", colnames(data))
```

#### DR_NO

```{r}
# Converting DR_NO to string (character) data type
data$DR_NO <- as.character(data$DR_NO)

```

```{r}
# Checking for duplicates
sum(duplicated(data$DR_NO))
```

```{r}
# Checking for missing values
sum(is.na(data$DR_NO))
```

#### DATE_OCC

```{r}
# Checking the varaible is in date format
class(data$DATE_OCC)
```

```{r}
# Checking for missing values
sum(is.na(data$DATE_OCC))
```

#### TIME_OCC

```{r}
# Changing the times to four digits
data$TIME_OCC <- sprintf("%04d", as.numeric(data$TIME_OCC))

# Converting to time format
data$TIME_OCC <- strptime(data$TIME_OCC, format = "%H%M")

# Changing to time format 
data$TIME_OCC <- as_hms(data$TIME_OCC)
```

```{r}
# Checking for missing values
sum(is.na(data$TIME_OCC))
```

```{r}
glimpse(data)
```

```{r}
data
```

#### AREA_NAME

```{r}
# Checking for unique values
unique(data$AREA_NAME)
```

```{r}
# Replacing for abbreviation
data$AREA_NAME <- gsub("N Hollywood", "North Hollywood", data$AREA_NAME)
```

```{r}
glimpse(data)
```

```{r}
# Checking for the modified unique values
unique(data$AREA_NAME)
```

```{r}
# Trimming for leading and ending spaces
data$AREA_NAME <- trimws(data$AREA_NAME)
```

#### Part_1-2

```{r}
# Checking if 'Part 1-2' column should be factor data type
unique(data$`Part_1-2`)

# Converting it to factor data type
data$`Part_1-2` <- as.factor(data$`Part_1-2`)

# Recoding the variable
data <- data %>% 
  mutate(`Part_1-2`=recode(`Part_1-2`, "1" = "Serious", "2" = "LessSerious"))

class(data$`Part_1-2`)
```

#### Vict_age

```{r}
# Finding the median age
median_age <- median(data$Vict_Age[data$Vict_Age > 0], na.rm = TRUE)

# Replacing Vict_Age where it's 0 with the median value
data$Vict_Age <- replace(data$Vict_Age, data$Vict_Age <= 0, median_age)
```

```{r}
glimpse(data)
```

#### Vict_Sex

```{r}
# Checking for missing values
sum(is.na(data$Vict_Sex))

# Handling missing values
# Calculating the most common Sex for each Crime Type
common_crime <- data %>% 
  group_by(Crm_Cd_Desc, Vict_Sex) %>% 
  summarise(count = n(), .groups = "drop") # Counting the unique pairs & Removing the grouping
common_crime
```

```{r}
# Finding the most common Vict_Sex for each Crime Type
most_common_sex <- common_crime %>%
  filter(!is.na(Vict_Sex)) %>%  # Exclude missing Vict_Sex
  group_by(Crm_Cd_Desc) %>%
  slice_max(count, n = 1, with_ties = FALSE) %>%   # Get the row with the maximum count (n=1: only one max, with_ties = FALSE: if tie select the 1st finding)
  ungroup() %>%                                   
  select(Crm_Cd_Desc, Vict_Sex)

most_common_sex

```

```{r}
# Filling NA values in Vict_Sex with the most common sex for each Crime Type
data <- data %>%
  left_join(most_common_sex, by = "Crm_Cd_Desc") %>% # Joining datasets based on a common key
  mutate(Vict_Sex = ifelse(is.na(Vict_Sex.x), Vict_Sex.y, Vict_Sex.x)) %>% # if na put Vict_Sex.y(the corresponding value in most_common_sex column), if not keep the value in Vict_Sex.x)
  select(-Vict_Sex.x, -Vict_Sex.y) # Drop these columns 
data
```

```{r}
# Checking for missing values
sum(is.na(data$Vict_Sex))
```

```{r}
# Check for mismatches between the 'Crm_Cd_Desc' in both datasets
setdiff(unique(data$Crm_Cd_Desc), unique(most_common_sex$Crm_Cd_Desc))
```

```{r}
# Finding the most common Vict_Sex in the entire dataset, excluding NA values
most_common_gender <- data %>%
  filter(!is.na(Vict_Sex)) %>%  
  count(Vict_Sex) %>%           
  slice_max(Vict_Sex,n = 1, with_ties = FALSE) %>%          
  pull(Vict_Sex)                # Extract the Vict_Sex value

# Replacing 'Vict_Sex' for 'BOAT - STOLEN' with the most common Vict_Sex
data <- data %>% 
  mutate(Vict_Sex = replace(Vict_Sex, Crm_Cd_Desc == "BOAT - STOLEN", most_common_gender))

```

```{r}
# Checking for missing values
sum(is.na(data$Vict_Sex))
```

```{r}
# Checking if 'Vict_Sex' column should be factor data type
unique(data$Vict_Sex)

# Recoding the variables
data <- data %>% 
  mutate(Vict_Sex = recode(Vict_Sex, "M"= "Male", "F" = "Female", "X" = "Other", "H" = "Other","-" = "Other"))

# Converting it to factor data type
data <- data %>% 
  mutate(Vict_Sex = factor(Vict_Sex, labels = c("Male", "Female", "Other")))

unique(data$Vict_Sex)
class(data$Vict_Sex)
```

#### Vict_Descent

```{r}
# Checking for missing values
sum(is.na(data$Vict_Descent))
```

```{r}
# Handling missing values
# Calculating the most common Descent for each Crime Type
common_crime2 <- data %>% 
  group_by(Crm_Cd_Desc, Vict_Descent) %>% 
  summarise(count = n(), .groups = "drop") # Counting the unique pairs and  Removing the grouping
```

```{r}
# Finding the most common Vict_descent for each Crime Type
most_common_descent <- common_crime2 %>%
  filter(!is.na(Vict_Descent)) %>%  # Exclude missing Vict_Descent
  group_by(Crm_Cd_Desc) %>%
  slice_max(count, n = 1, with_ties = FALSE) %>%   # Get the row with the maximum count (n=1: only one max, with_ties = FALSE: if tie select the 1st finding)
  ungroup() %>%                                   
  select(Crm_Cd_Desc, Vict_Descent)

```

```{r}
# Filling NA values with the most common descent for each Crime Type
data <- data %>%
  left_join(most_common_descent, by = "Crm_Cd_Desc") %>% # Joining datasets based on a common key
  mutate(Vict_Descent = ifelse(is.na(Vict_Descent.x), Vict_Descent.y, Vict_Descent.x)) %>% # if na put Vict_Descent.y(the corresponding value in most_common_sex column), if not keep the value in Vict_Descent.x)
  select(-Vict_Descent.x, -Vict_Descent.y) # Drop these columns 
```

```{r}
# Checking for missing values
sum(is.na(data$Vict_Descent))
```

```{r}
# Check for mismatches between the 'Crm_Cd_Desc' in both datasets
setdiff(unique(data$Crm_Cd_Desc), unique(most_common_descent$Crm_Cd_Desc))
```

```{r}
# Finding the most common Vict_Descent in the entire dataset, excluding NA values
most_common_descent <- data %>%
  filter(!is.na(Vict_Descent)) %>%  
  count(Vict_Descent) %>%           
  slice_max(Vict_Descent,n = 1, with_ties = FALSE) %>%          
  pull(Vict_Descent)                # Extract the Vict_Descent value

# Replacing 'Vict_Descent' for 'BOAT - STOLEN' with the most common Vict_Descent
data <- data %>% 
  mutate(Vict_Descent = replace(Vict_Descent, Crm_Cd_Desc == "BOAT - STOLEN", most_common_descent))

```

```{r}
# Checking for missing values
sum(is.na(data$Vict_Descent))
```

```{r}
# Checking if 'Vict_Descent' column should be factor data type
unique(data$Vict_Descent)

# Replacing "-" with "Other"
data$Vict_Descent[data$Vict_Descent == "-"] <- "Other"

# Converting the variable to factor data type
data$Vict_Descent <- as.factor(data$Vict_Descent)

class(data$Vict_Descent)
unique(data$Vict_Descent)
```

#### Trimming in the remaining chr columns

```{r}
# Trimming leading and ending spaces
data <- data %>% 
  mutate(across(c(Premis_Desc, Weapon_Desc, Status_Desc), trimws))
```

#### Premis_Desc

```{r}
sum(is.na(data$Premis_Desc))

```

```{r}
# Handling missing values
# Calculating the most common premis for each Crime Type
common_crime_premis <- data %>% 
  group_by(Crm_Cd_Desc, Premis_Desc) %>% 
  summarise(count = n(), .groups = "drop") # Counting the unique pairs and  Removing the grouping
```

```{r}
# Finding the most common Premis_Desc for each Crime Type
most_common_premis <- common_crime_premis%>%
  filter(!is.na(Premis_Desc)) %>%  # Exclude missing Premis_Desc
  group_by(Crm_Cd_Desc) %>%
  slice_max(count, n = 1, with_ties = FALSE) %>%   # Get the row with the maximum count (n=1: only one max, with_ties = FALSE: if tie select the 1st finding)
  ungroup() %>%                                   
  select(Crm_Cd_Desc, Premis_Desc)

```

```{r}
# Filling NA values with the most common premis for each Crime Type
data <- data %>%
  left_join(most_common_premis, by = "Crm_Cd_Desc") %>% # Joining datasets based on a common key
  mutate(Premis_Desc = ifelse(is.na(Premis_Desc.x), Premis_Desc.y, Premis_Desc.x)) %>% # if na put Premis_Desc.y(the corresponding value in most_common_premis column), if not keep the value in Premis_Desc.x)
  select(-Premis_Desc.x, -Premis_Desc.y) # Drop these columns 
```

```{r}
# Checking for missing values
sum(is.na(data$Premis_Desc))
```

#### weapon_Desc

```{r}
# Checking for missing values
sum(is.na(data$Weapon_Desc))
```

```{r}
data <- data %>% 
  mutate(Weapon_Desc = replace(Weapon_Desc,is.na(Weapon_Desc), "No weapon used"))
```

```{r}
data <- data %>%
  mutate(Weapon_Desc = case_when(
    # Firearms category 
    Weapon_Desc %in% c("HAND GUN", "UNKNOWN FIREARM", "AIR PISTOL/REVOLVER/RIFLE/BB GUN", 
                       "SEMI-AUTOMATIC PISTOL", "SIMULATED GUN", "REVOLVER", "SHOTGUN",
                       "SEMI-AUTOMATIC RIFLE", "ASSAULT WEAPON/UZI/AK47/ETC", 
                       "HECKLER & KOCH 93 SEMIAUTOMATIC ASSAULT RIFLE",
                       "MAC-11 SEMIAUTOMATIC ASSAULT WEAPON", "MAC-10 SEMIAUTOMATIC ASSAULT WEAPON", 
                       "M-14 SEMIAUTOMATIC ASSAULT RIFLE", "UZI SEMIAUTOMATIC ASSAULT RIFLE",
                       "OTHER FIREARM", "RIFLE", "STARTER PISTOL/REVOLVER", "RELIC FIREARM",
                       "AUTOMATIC WEAPON/SUB-MACHINE GUN", "HECKLER & KOCH 91 SEMIAUTOMATIC ASSAULT RIFLE", 
                       "M1-1 SEMIAUTOMATIC ASSAULT RIFLE", "SAWED OFF RIFLE/SHOTGUN", "ANTIQUE FIREARM",
                       "UNK TYPE SEMIAUTOMATIC ASSAULT RIFLE") ~ "Firearm",
    
    # Bladed/Sharp Objects category
    Weapon_Desc %in% c("KNIFE WITH BLADE 6INCHES OR LESS", "KITCHEN KNIFE", "MACHETE", 
                       "OTHER KNIFE", "KNIFE WITH BLADE OVER 6 INCHES IN LENGTH",
                       "RAZOR", "FOLDING KNIFE", "SWITCH BLADE", "SCISSORS",
                       "CLEAVER", "RAZOR BLADE", "DIRK/DAGGER", "STRAIGHT RAZOR", 
                       "ICE PICK", "BOWIE KNIFE", "SWORD", "UNKNOWN TYPE CUTTING INSTRUMENT", "OTHER CUTTING INSTRUMENT") ~ "Bladed/Sharp Objects",
    
    # Blunt Instruments category
    Weapon_Desc %in% c("BELT FLAILING INSTRUMENT/CHAIN", "FIXED OBJECT", "STICK", 
                       "HAMMER", "PIPE/METAL PIPE", "ROCK/THROWN OBJECT", "BOARD",
                       "CLUB/BAT", "BLUNT INSTRUMENT", "CONCRETE BLOCK/BRICK",
                       "TIRE IRON", "BRASS KNUCKLES", "MARTIAL ARTS WEAPONS", "BLACKJACK") ~ "Blunt Instruments",
    
    # Explosives/Chemicals category
    Weapon_Desc %in% c("BOMB THREAT", "EXPLOXIVE DEVICE", "MACE/PEPPER SPRAY",
                       "CAUSTIC CHEMICAL/POISON", "SCALDING LIQUID", "FIRE") ~ "Explosives/Chemicals",
    
    # Other/Unconventional category
    Weapon_Desc %in% c("VEHICLE", "VERBAL THREAT", "PHYSICAL PRESENCE", 
                       "DOG/ANIMAL (SIC ANIMAL ON)", "LIQUOR/DRUGS", "ROPE/LIGATURE", 
                       "TOY GUN", "DEMAND NOTE", "SYRINGE", "UNKNOWN WEAPON/OTHER WEAPON", 
                       "STRONG-ARM (HANDS, FIST, FEET OR BODILY FORCE)", "BOTTLE", 
                       "STUN GUN", "SCREWDRIVER", "GLASS", "AXE", "BOW AND ARROW") ~ "Other/Unconventional", 
    
    # No weapon used
    Weapon_Desc == "No weapon used" ~ "No weapon used",
    
    # Catch-all for anything else that doesn't match the above categories
    TRUE ~ Weapon_Desc)) # if not keep the existing

```

```{r}
# Converting to factor
data$Weapon_Desc <- factor(data$Weapon_Desc, levels = c("Firearm", "Bladed/Sharp Objects", 
                                                        "Blunt Instruments", "Explosives/Chemicals", 
                                                        "Other/Unconventional", "No weapon used"))
```

```{r}
sum(is.na(data$Weapon_Desc))
unique(data$Weapon_Desc)
class(data$Weapon_Desc)
```

```{r}
glimpse(data)
```

#### Status_Desc

```{r}
sum(is.na(data$Status_Desc))
unique(data$Status_Desc)
```

```{r}
# Renaming the values
data <- data %>%
  mutate(Status_Desc = case_when( Status_Desc == "Adult Arrest" ~ "Adult Arrests", Status_Desc == "Invest Cont" ~ "Investigation Continued", Status_Desc == "Adult Other" ~ "Other Adult Offenses", Status_Desc == "Juv Arrest" ~ "Juvenile Arrests", Status_Desc == "Juv Other" ~ "Other Juvenile Offenses", Status_Desc == "UNK" ~ "Unknown", TRUE ~ Status_Desc))

```

```{r}
# Changing to factor
data$Status_Desc <- factor(data$Status_Desc, levels = c("Adult Arrests", "Investigation Continued", "Other Adult Offenses", "Juvenile Arrests", "Other Juvenile Offenses", "Unknown"))
class(data$Status_Desc)
unique(data$Status_Desc)

```

#### LAT & LON

```{r}
# Checking for missing values
anyNA(data$LAT)
anyNA(data$LON)
```

```{r}
# Checking all the values are within the valid ranges of LAT & LON
invalid_lat <- sum(data$LAT < -90 | data$LAT > 90, na.rm = TRUE)
invalid_lon <- sum(data$LON < -180 | data$LON > 180, na.rm = TRUE)

invalid_lat  
invalid_lon  

```

```{r}
# Checking the columns once more
glimpse(data)

```

```{r}
colnames(data)
```

```{r}
# unique(data$Crm_Cd_Desc)
```

```{r}
# Saving the cleaned dataset
write.csv(data, "Cleaned_Crime_Data.csv", row.names = FALSE)
```
