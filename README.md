# 🚗 Vehicle Loan Risk Command Center
### **End-to-End Fintech Analytics Project**

---

## 📺 Project Demo
> **[ACTION REQUIRED]**: To make this look professional, record a 30-second video of you clicking the slicers and the Reset button. Drag that video file here in the GitHub editor, and it will replace this text with a video player.
Project Demo/Demo.mp4

---

## 📌 Executive Summary
This project analyzes **67,000+ vehicle loan records** to identify high-risk borrower segments and quantify potential financial loss. By integrating **Python** for data engineering, **PostgreSQL** for data warehousing, and **Power BI** for executive reporting, I developed a dynamic risk engine that identifies "Danger Zones" where default probability exceeds 10%.

## ⚙️ The Data Pipeline
This project follows a professional **ETL (Extract, Transform, Load)** workflow:

1.  **Extraction & Engineering (Python/Pandas):** * Performed Data Cleaning on the raw 67k+ records.
    * Handled missing values in critical columns like `dti` and `revol_util`.
    * Conducted Exploratory Data Analysis (EDA) using **Matplotlib** and **Seaborn** to find correlations between Interest Rates and Default probability.
2.  **Data Warehousing (PostgreSQL):** * Exported the cleaned data into a relational database.
    * Created an optimized **SQL View** (`risk_dashboard_view`) to pre-calculate loan volumes and average rates for faster Power BI performance.
3.  **Visualization & Modeling (Power BI):** * Developed complex **DAX measures** for dynamic risk assessment.
    * Designed an interactive UI to visualize "Danger Zones" across different borrower segments.

---

## 🛠️ The Technical Stack
* **Data Engineering:** Python (Pandas) for cleaning and feature engineering (handling missing DTI ratios).
* **Database:** PostgreSQL for structured storage and optimized `risk_dashboard_view` creation.
* **Analytics:** Power BI & **DAX** (Data Analysis Expressions) for real-time risk modeling.
* **UI/UX:** Modular "Executive-Tier" layout with high-contrast semantic coloring.

---

## 📊 Key Dashboard Features
### 1. Risk Semantic KPIs
* **Total Portfolio Volume:** Total loan count (67.5k).
* **Portfolio Default Rate:** The live risk percentage (9.23%).
* **Expected Loss Exposure:** A DAX-driven financial metric showing the actual value at risk (₹ 4.5M+).
* **Dynamic Risk Status:** An automated assessment label (STABLE, WATCHLIST, or CRITICAL).

### 2. Interactive Risk Matrix (Heatmap)
I developed a cross-functional matrix comparing **Credit Grade** against **Home Ownership**.
* **Insight:** The heatmap instantly identifies that **Grade G Renters** represent the highest concentration of risk, allowing for immediate policy adjustments.

### 3. Smart Filtering
* **Multi-Factor Slicers:** Filter by Grade, Home Ownership, and Verification Status.
* **One-Touch Reset:** A custom bookmark-linked button to clear all filters instantly.

---

## 📈 Business Insights
* **Concentration Risk:** 35% of the portfolio is held by renters, who show a 1.2x higher default rate than homeowners.
* **Verification Impact:** Loans that were "Not Verified" showed a 2% higher default rate in Grade F/G compared to "Verified" counterparts.
* **Loss Mitigation:** By targeting Grade G for stricter approval, the bank could potentially reduce its **Expected Loss Exposure** by ~15%.

---

## 📂 Project Structure
```text
├── data/
│   └── loan_data.csv             # Raw Dataset
├── scripts/
│   ├── data_cleaning.py         # Python/Pandas Script
│   └── risk_views.sql           # PostgreSQL View Logic
├── dashboard/
│   └── Risk_Command_Center.pbix  # Power BI File
└──
