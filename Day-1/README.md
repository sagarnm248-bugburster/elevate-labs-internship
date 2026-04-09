# 🚀 Day 1 Task – Data Cleaning & Preprocessing

## 📌 Task Description
The objective of this task was to clean and preprocess a raw dataset by handling missing values, duplicates, and inconsistent formats.

## 📊 Dataset Used
Netflix Movies and TV Shows Dataset

## 🛠️ Steps Performed
- Checked missing values using isnull()
- Removed missing values using dropna()
- Removed duplicate records using drop_duplicates()
- Standardized column names (lowercase, no spaces)
- Converted date_added column to datetime format
- Cleaned text fields (e.g., country column)

## 📚 What I Learned
- Importance of data cleaning before analysis
- Handling null values and duplicates
- Using pandas for preprocessing
- Real-world data is messy and needs cleaning

## ✅ Output
- Original dataset shape: (8808 , 12)
- Cleaned dataset shape: (5333 , 12)
- Cleaned dataset saved as CSV file

## 📂 Files Included
- cleaned_netflix_data.csv
- day1_data_cleaning.ipynb

## 📈 Results
- Successfully reduced dataset size by removing null and duplicate values
- Improved data quality and consistency
