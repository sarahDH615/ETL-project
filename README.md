# ETL-project #
Comparing Travel restrictions by Country during COVID-19. 


## Extraction Stage 
We chose three data sources based around international Covid-19 data: one describing the travel restrictions each country placed on its own citizens; another showing immigration policy restrictions on people entering each country; and vaccination data for each country. Links to these three datasets can be found in the References section of this README. All the datasets were in CSV format, and were downloaded on 11 February 2021. The immigration policy and travel restrictions datasets are updated daily, so new data has already been entered since our commencing of this project. The CSVs were downloaded to separate Jupyter Notebooks, where the data was cleaned. 

## Transformation Stage 

![Sample Processing](/images/sampleProcessing.png)

All three datasets went through a similar overall process: a subset of columns being selected from the source CSVs, renaming the chosen columns, removing null/irrelevant values, changing any date columns to the datatype datetime, sorting for the most recent date for each country in the dataset, and dropping all but the most recent date data. More in depth information, including the challenges for each dataset, follows. 

<ins>Travel Restrictions cleaning</ins>
* Had to decide to enter “unknown” for NaNs in Quarantine Type column. 
![Dropping Nans](/images/TravRes_removeNans.png)
* Dropping rows where country IDs are either “x--” or more then 2 Country IDs. These are territories of larger countries and do not have specific quarantine data.
![Sample Processing](/images/TravRes_dupIDs.png)
* The Quarantine start date column was reformatted to fit datetime structure, NaNs were replaced with placeholder dates, as well as changing an obvious error ('04-02-20201') to an educated guess (‘04-02-20'), all in order to match the date columns of the other two datasets.
![Date Changes](/images/TravRes_dateReplace.png)
* There were several duplicated Country ID columns, which mostly derived from outlying islands being counted separately from the mainland areas. We decided to discard the rows relating to those island territories, keeping only mainland data. 
![Duplicate ID list](/images/TravRes_dupIDs.png)
![Duplicate ID removal](/images/TravRes_dropDups.png)
* We also discovered that the signs for ‘new line’ and ‘break’ were showing up within the text for the Quarantine column, so they were removed with replace statements. 
![Remove Breaks](/images/TravRes_removeInlineBreaks.png)


<ins>Vaccinations cleaning</ins>
* The columns kept were 'location', 'iso_code', 'date', 'total_vaccinations', and 'Daily_vaccinations', which were renamed to more informative names (country, country code, vaccination date, total vaccinations and daily vaccinations). Only 58 country codes (plus the category ‘World’, which was eventually dropped) had vaccination data in the source CSV, in contrast to 243 in the Immigration Policy, and 267 in the Travel Restrictions ones, which had to be addressed in the merging stage when creating tables.
![Subsetting Columns](/images/vacc_colSubset.png)
![Renaming Columns](/images/vacc_colRename.png)
* There were many ‘null’ rows, which we thought might contain countries that had country codes that were ambiguous or controversial. For example, some countries were segmented such as: 'England', 'European Union', 'Northern Cyprus', 'Northern Ireland',  'Scotland', and 'Wales'. The number of vaccinations for those countries in the UK were found to equal the total number of vaccinations for rows labelled ‘United Kingdom’, so one or the other could be deleted. The other datasets had information only for the United Kingdom as a whole, so the rows for the individual countries in the UK were dropped, along with the ‘EU’ rows, which, while perhaps useful for other analyses, were not under our scope of individual nations, and along with the ‘Northern Cyprus’ rows, which weren’t found in the other datasets. 
![Checking for null Country IDs](/images/vacc_vacc_nullCountryIDs.png)
![Checking UK totals](/images/vacc_checkingUKcountries.png)
![Removing Duplicate Countries](/images/vacc_droppingnullCountryIDs.png)
* After subsetting the dataframe to remove rows where the country code was null, the remaining NaNs, which were in the total and daily vaccinations columns, were replaced with zeros, so mathematical operations could be done on those columns if necessary. 
![Removing Remaining NaNs](/images/vacc_nansToZeros.png)
* We also took a subset of the vaccinations dataframe, containing just the country code and the daily vaccinations, setting the daily vaccinations column to a numeric type, so that the dataframe subset could be grouped by country code, and the average vaccinations per day could be found. After only keeping the most recent row for each country code in the main vaccinations dataframe, the average vaccinations were then fed back into the main vaccinations dataframe, and the daily vaccination column deleted.
![Creating a subset](/images/vacc_subsetDF.png)
![Grouping, Finding Avg Vaccine Rate](/images/vacc_groupbyCountryID.png)
![Saving the means](/images/vacc_dailyVaccMean.png)
![Creating final df](/images/vacc_createLastDateDF.png)
![Adding the means](/images/vacc_addAvgVacc.png)

<ins>Immigration Policy cleaning</ins>
* Many of the columns from the original dataset were kept, as we wanted to have information on all the different kinds of bans/exceptions.
* The columns dropped were the ISO2 country code, as the other datasets used ISO3; the ‘END_DATE’ column, in preference to the ‘START_DATE’ column; and the ‘SOURCE’ columns. 
* The dataset dcumentation explained that whether some columns had information depended on whether the Policy type was complete or partial: where columns relating to one policy type were on rows relating to the other policy type, NaNs would be found (as well as, in the case of partial policies, where the partial policy did not cover some land/sea/air borders). We decided to replace those NaNs with ‘no policy’. 
![Adding the means](/images/pol_replNansNoPolicy.png)
* The ‘Policy_start_date’ (the name we gave to the ‘START_DATE’ column) was used in this project as an indicator of the most recent policy, as it was more likely that a policy still ongoing would not have an end date listed. The ‘Policy_start_date’ column was edited by replacing underscores with slashes for better conversion to datetime. Additionally, values of ‘NONE’ or ‘0’ were replaced with a placeholder date of ‘01-01-01’, as the column could not be converted to datetime if there were any non-date-like values within it. Finally, there was a date within the column that seemed impossible: 31 April 2020. We took an educated guess that it was an entry error, and that 21 April 2020 was meant, and replaced that date with our guess date. Once this pre-work was complete, the conversion to datetime was done, and the dataframe was sorted by country code, then date, and only the rows with the most recent date for each country were kept. 
![Adding the means](/images/pol_datesList.png)
![Adding the means](/images/pol_replwDatesList.png)
![Adding the means](/images/pol_doubleSorted.png)
![Adding the means](/images/pol_keepLastDate.png)
* As in the other datasets, we found some Country IDs that needed to be dropped. In this dataset, one was, like in Travel Restrictions, due to outlying islands being counted separately from the rest of a country; another was due to a self-declared independent area not mentioned in the other datasets; a third used a different Country ID for a country already counted in the dataset. All three of these IDs were dropped.
![Adding the means](/images/pol_IDsToDrop.png)
![Adding the means](/images/pol_dropIDs.png)
* We decided to divide the data by their Policy Types and Subtypes, resulting in six dataframes, which would eventually form six of the tables in our database: one for full closures, one for no closures, and four for the Subtypes of partial closures. 
![Full Bans DF](/images/pol_completeBan.png)
![First separation of partial bans](/images/pol_partial1stSep.png)
![Full separation of partial bans](/images/pol_partialFull.png)
![Replace NaNs](/images/pol_noPolicy.png)

## Loading Stage
<ins>Creation of a Junction Table</ins>

We decided to use a SQL database for our data, as it was possible for our data to be stored in rectangular tables. However, some steps needed to be taken to transform our cleaned CSVs into an appropriate database. This pre-work was done at the end of the policy_clean notebook. 

The vaccinations, travel restrictions, and six immigration policy CSVs were all in the correct form for being made into SQL tables. However, they still needed to be linked to each other, through a joining table of Country and Country ID. This database plan can be seen in our [ERD](Covid_restrictions_ERD.png). The database contains nine tables: 'country', 'vaccinations', 'travel_restrictions', 'full_closures', 'no_closures', 'partial_borders', 'partial_visa', 'partial_citizenship' and 'partial_history'. 

In order to create this junction table, the vaccination and travel restrictions CSVs were read into the Policy notebook. Each dataframe was reduced to its Country and Country ID columns. The three dataframes were merged together in two steps, and the resulting dataframe was checked for duplicates and null values, sorted by Country name, and exported.
![Create Junction Table](/images/join_createJunctionTable.png)
![View Junction Table](/images/join_JTabHead.png)

<ins>Importing into PostgreSQL</ins>

From our ERD work, we exported a SQL file for input into our SQL database Covid_restrictions_db, resulting in empty tables. We then created a new Jupyter Notebook, merging_notebook, for inserting the data into those tables. Each of the cleaned CSVs were read into the notebook, and, after establishing a conection to the database and dropping any existing table rows (to ensure duplicates wouldn’t be added if the code was run multiple times), was read into the corresponding Covid_restrictions_db empty table. Finally, we checked the proper entry of values by conducting some select all queries within the notebook. 
![SQL connection](/images/sql_connect.png)
![Drop existing tables](/images/sql_dropExisting.png)
![First load](/images/sql_loadTables1.png)
![Second load](/images/sql_loadTables2.png)
![Tests](/images/sql_test.png)


## <ins> References</ins>

Buggaveeti, Padmaja. (2021 January 27). Covid Vaccination Dataset - 2021. Kaggle. https://www.kaggle.com/padmajabuggaveeti/covid-vaccination-dataset-2021. Accessed 2021 February 11. 

Centre for Humanitarian Data. (2021 February 11). COVID-19 Global Travel Restrictions and Airline Information. Humanitarian Data Exchange. https://data.humdata.org/dataset/covid-19-global-travel-restrictions-and-airline-information. Accessed 2021 February 11. 

Shiraef, Mary A.; Weiss, Mark A.; Hirst, Cora; Walker, Bryn; Nguyen, Thuy; Kline, Camilla; Bhaskaran, Aadya; Beling, Elizabeth; Mattar, Layth; Amme, Matthew; Shum, Maggie; Sweere, Johanna; Brantley, Susanna; Schenoni, Luis; Lewis-Beck, Colin; Selvaraj, Yashwini; Jackson, Cayleigh; Lazar, Nikolas; Musetti, Rachel; Naseer, Sarah; Taylor, Noah; Gradie, Amalia; Yu, William; Martin, Suzanne; Rossi, Hannah. (2021 February 14). The COVID Border Accountability Project (COBAP): Mapping Travel and Immigration Policy Responses to COVID-19. Harvard Dataverse. https://doi.org/10.7910/DVN/U6DJAC. Accessed 2021 February 11.
