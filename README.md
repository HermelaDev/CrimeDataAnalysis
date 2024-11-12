<p align="center">
  <img src="images/91lgK3xtGfL._AC_UF350,350_QL80_.jpg" alt="Alt text" width="300"/>
</p>

# Data Cleaning and Exploratory Data Analysis (EDA) on Crime Data

## Overview

This project involves performing data cleaning and exploratory data analysis (EDA) on a dataset of crime data. The goal of this project is to clean the data by handling missing values, duplicates, and inconsistencies in the dataset, followed by a thorough exploration of the relationships between variables. Patterns, trends, and insights are uncovered to understand the dataset better and prepare it for potential further analysis or modeling.

## Table of Contents

1. [Installation](#installation)
2. [Data Collection](#data-collection)
3. [Data Cleaning](#data-cleaning)
4. [Exploratory Data Analysis](#exploratory-data-analysis)
5. [Contributing](#contributing)
6. [License](#license)
7. [Contact](#contact)

## Installation

To run this project, ensure you have the following R libraries installed:

```r
install.packages('tidyverse')
install.packages('readxl')
install.packages('lubridate')
install.packages('hms')
These libraries are required to handle data manipulation (tidyverse), date/time handling (lubridate), reading data from Excel files (readxl), and time formatting (hms).
```
## Data Collection

The dataset used in this project is the Crime Data from 2020 to Present, available in Excel format. The dataset contains multiple columns related to the details of crimes, including date, time, location, and crime type.

## Data Cleaning

The DataCleaning_CrimeData process involved multiple steps to prepare the crime dataset for analysis:

- **Loading Libraries and Data Import:**
Installed and loaded necessary R packages (tidyverse, readxl, lubridate, hms).
Imported the dataset using read_excel.

- **Initial Inspection:**
Checked the dimensions, column names, and data types using dim(), colnames(), and glimpse().
Identified and counted duplicate entries using sum(duplicated()).

- **Column Renaming:**
Replaced spaces in column names with underscores for consistency.

- **Data Type Conversion:**
Converted specific columns like DR_NO to character type and formatted TIME_OCC to time format using sprintf() and as_hms().

- **Handling Missing Values:**
Identified missing values across key columns such as Vict_Sex, Vict_Descent, and Premis_Desc.
Imputed missing values by determining the most common attribute per crime type (e.g., most common victim sex and descent per crime category).

- **Data Transformation:**
Cleaned text columns by standardizing values (e.g., replacing abbreviations in AREA_NAME).
Trimmed leading and trailing spaces for consistency in character columns.

- **Factorization:**
Converted relevant columns to factors (e.g., Part_1-2, Vict_Sex, Vict_Descent) to better represent categorical data.
Recoded categorical values for clarity (e.g., recoding "1" and "2" in Part_1-2 to "Serious" and "LessSerious").

- **Special Cases Handling:**
For specific crime descriptions with unique handling (e.g., "BOAT - STOLEN"), filled missing values using the most common attribute from the entire dataset.

## Exploratory Data Analysis

As part of the analysis on the **Cleaned Crime Data** dataset, the following steps were performed:

#### 1. Data Import and Preprocessing
- The dataset was loaded using the `read_csv` function.
- Categorical variables like `Part_1-2`, `Weapon_Desc`, `Vict_Sex`, and `Vict_Descent` were converted to factors for better analysis.

#### 2. Summary Statistics
- Generated a summary of victim age to understand the distribution.
- Frequency counts of key categorical variables (e.g., crime seriousness, weapon usage, victim's gender, and descent) were obtained for initial insights.

#### 3. Data Visualization
- **Victim Gender Distribution**: A donut chart showed that most crime victims were females, indicating a potential gender disparity in victimization.
<p align="center">
  <img src="images/WhatsApp Image 2024-11-12 at 11.19.30 PM.jpeg" alt="Alt text" width="300"/>
</p>

- **Crime Seriousness**: A bar chart highlighted the distribution between serious (`Part 1`) and less serious (`Part 2`) crimes, showing a high prevalence of both categories.
- **Weapon Usage by Gender**: A bar chart compared weapon usage across genders, revealing a high frequency of crimes without weapons, followed by bladed objects and firearms.
- **Victim Age Distribution**: A histogram indicated that most victims were in their 30s, emphasizing a need for targeted crime prevention strategies for this age group.
- **Crime Distribution by Area**: A bar plot identified the Central and 77th Street areas as having the highest crime rates, suggesting the need for increased law enforcement in these regions.
- **Monthly Crime Trends**: Analysis over months indicated a spike in crimes in January, with a gradual decline towards November and December. This pattern might be influenced by post-holiday factors and increased police efforts during year-end.
- **Yearly Crime Trends**: A line plot showed an increasing trend in crime counts from 2020 to 2022, potentially reflecting post-pandemic challenges, with a decline observed in 2023, indicating possible effective interventions.

#### 4. Key Insights
- **Severity of Crimes**: Both serious and less serious crimes are prevalent, requiring distinct strategies for law enforcement.
- **Victim Demographics**: The Hispanic community had the highest number of victims, highlighting potential socio-economic disparities in victimization.
- **Weapon Usage**: Non-weapon crimes are the most common, but the significant presence of bladed objects and firearms indicates a need for better weapon control policies.
- **Unresolved Cases**: A large portion of crimes remain under investigation, pointing to challenges in the criminal justice system.
- **Crime Hotspots**: Specific areas (Central & 77th Street) had high crime frequencies, suggesting the need for focused crime prevention efforts.

This analysis provides a comprehensive overview of crime patterns and potential areas for policy intervention and resource allocation by law enforcement agencies.

## Contributing

If you wish to contribute to this project, you are welcome to clone the repository and submit a pull request with your improvements or suggestions.

## License

This project is licensed under the [MIT License](LICENSE) - see the LICENSE file for details.

## Contact

If you have any questions or need further assistance, feel free to reach out:
Hermela Seltanu
LinkedIn: [Hermela Seltanu](https://www.linkedin.com/in/hermelaseltanu/)
