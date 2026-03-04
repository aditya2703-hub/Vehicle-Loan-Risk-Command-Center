import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

# =================================================================
# PROJECT: BANKING RISK & LOAN DEFAULT ANALYTICS
# AUTHOR: Aditya Singh
# DATASET: 67k+ Loan Records
# =================================================================

# --- PHASE 1: DATA INGESTION ---
# Question: How do we load the large-scale financial dataset and 
# verify the available financial metrics?

df = pd.read_csv('train.csv')
print(f"Dataset Shape: {df.shape}")
print("Available Metrics:", df.columns.tolist())

# --- PHASE 2: DATA CLEANING & RECTIFICATION ---
# Question 1: How do we handle missing data in critical risk columns like 'Debit to Income'?
# Insight: Missing values can skew risk assessment. We use median imputation for stability.

df['Debit to Income'] = df['Debit to Income'].fillna(df['Debit to Income'].median())

# Question 2: The 'Term' and 'Employment Duration' columns are strings. 
# How do we convert them to numerical data for mathematical analysis?

if df['Term'].dtype == 'object':
    df['Term'] = df['Term'].str.extract('(\d+)').astype(int)

df['Employment Duration'] = df['Employment Duration'].str.extract('(\d+)').fillna(0).astype(int)

# Question 3: How do we normalize text fields like 'Grade' for consistent grouping?

df['Grade'] = df['Grade'].str.upper()
df['Sub Grade'] = df['Sub Grade'].str.upper()

# --- PHASE 3: FEATURE ENGINEERING ---
# Question: Can we create a ratio to measure the 'gap' between 
# what a user requested vs. what the bank actually funded?

df['Approval_Ratio'] = df['Funded Amount'] / df['Loan Amount']

# --- PHASE 4: OUTLIER DETECTION & UNIVARIATE ANALYSIS ---
# Question 1: What is the distribution of Loan Amounts across the portfolio?

plt.figure(figsize=(10, 6))
sns.histplot(df['Loan Amount'], bins=50, kde=True, color='blue')
plt.title('Portfolio Distribution: Loan Amounts')
plt.show()

# Question 2: Are there extreme 'Interest Rate' errors that could corrupt our averages?
# Action: Capping the interest rate at 40% based on logical banking limits.

df = df[df['Interest Rate'] <= 40]
plt.figure(figsize=(8, 5))
sns.boxplot(x=df['Interest Rate'], color='orange')
plt.title('Interest Rate Spread & Outliers')
plt.show()

# --- PHASE 5: BIVARIATE ANALYSIS (THE GOLD INSIGHTS) ---
# Question 1: Does the bank's internal 'Grade' system accurately 
# reflect the actual default risk?

grade_pivot = df.groupby('Grade')['Loan Status'].mean().sort_values() * 100
print("Default Rate by Grade:\n", grade_pivot)

plt.figure(figsize=(10, 6))
grade_pivot.plot(kind='bar', color='teal')
plt.ylabel('Default Rate (%)')
plt.title('Risk Analysis: Default Rate by Credit Grade')
plt.show()

# Question 2: How do Interest Rates vary across different Risk Grades?

plt.figure(figsize=(12,6))
sns.boxplot(x='Grade', y='Interest Rate', data=df, order=['A','B','C','D','E','F','G'])
plt.title('Interest Rate Pricing per Grade')
plt.show()

# --- PHASE 6: MULTIVARIATE CORRELATION ---
# Question: Which financial features have the strongest relationship 
# with the 'Loan Status' (Default)?

numeric_df = df.select_dtypes(include=[np.number])
plt.figure(figsize=(15,10))
sns.heatmap(numeric_df.corr(), annot=False, cmap='coolwarm')
plt.title('Financial Feature Correlation Matrix')
plt.show()

print("\n--- Project Analysis Complete ---")