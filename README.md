# WEBTOON Originals Dashboard


## Introduction

WEBTOON is an online platform that regularly post digit comics known as webtoons. With that in mind, knowing how key metrics change over time will be beneficial
to the the long term growth of the platform. This impacts decision making such as deciding which series to promote and market, how resources are allocated, 
which sections shows promise, etc. 

To aid in answering these questions, I made a took a data-driven approach and made a reporting dashboard that displays key metrics for titles on the 
WEBTOON website. While I did  use SQL to clean, prepare, and briefly explore the data; the **main purpose** of this project was to visualize the
cleaned data using **[tableau.](https://public.tableau.com/app/profile/awestruck/viz/webt/WebtoonDashboard)**
<br />

## Dataset Information

These datasets were downloaded as CSV files from [Kaggle](https://www.kaggle.com/datasets/iridazzle/webtoon-originals-datasets) which itself scraped data from webtoons.com. Following the link to the datasets, the column headers provide a succint description of the type of information found within the dataset.
The CSV files were the English section's Version 1 and Version 22 files. Both of which were collected on February 2022 and August 2022 respectively.

<br />

## Data Extraction and Cleaning

- Link to [Version 1 SQL Cleaning file](https://github.com/awe-struck/Video_Game_Sales_2016/blob/main/Data_Cleaning/vg_sales_clean.sql) and [Version 22 SQL Cleaning file]()

Pre-cleaned, the Version 1 and Version 22 CSV files contained 669 and 811 rows respectively. The files were then converted into a .xlss format and uploaded to Microsoft SSMS for cleanup and brief analysis. I proceeded to create a copy table to store this information and filter for the columns relevant to the analysis. 
The dropped columns included daily_pass, synopsis and length. Originally, length column would have been considered relevant. Upon exploring the data and the website,  it was cleat that the data for
length is not representative of the actual amount of chapters that a series has. This is due to certain series being locked behind a paywall. Due to this, length
column was dropped.

I also changed two genre fields into its proper naming designation on  the WEBTOON webstie. This is to make it more clear and representative to the viewwel
Finally, when I joined the tables, I noticed two titles were missing from the Version 1 table compared to Version 22. Both of the titles are from the author Ann and 
were removed as per the author's request.

<br />

## Data Exploration

- Link to [Webtoon Info SQL file]( )

This section I briefly explored the clean data while I prepared the tables for Tableau. As a quick overview of the data, the romance genre is the top performer 
in therms of views, subs, likes and ratings. However, this may be due to the genre having the second most titles on the platform. Upon drilling down into the data,
there is an uneven distribution in titles. So, consider adding more titles to other genres to see if their numbers increase. Also, could consider making more
genre tags associated with a title. That is to say have a main genre tag along with mini sub-tags that displays other genres that could be associated with the series.
This could help in bringing more attention to the series as it makes the title more reprensentative to the viewer. 
