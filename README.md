# 🚚 Quick-Commerce Delivery Analytics & ETA Prediction

> A descriptive and predictive analytics project using SQL, Python, and machine learning to investigate delivery delays, identify operational areas for improvement, and estimate order-to-door delivery time from historical data.

## 📌 Business Problem

Quick-commerce businesses need to provide customers with reliable delivery estimates while managing day-to-day delivery operations. Delivery time can vary with order characteristics, store readiness, distance, traffic, weather, and delivery coordination.

This project uses historical order and delivery data to examine operational performance, identify potential bottlenecks, and build an ETA prediction model using information available when an order is placed.

## 🎯 Objectives

- Analyze delivery performance and identify operational patterns associated with delays.
- Examine delivery stages and compare on-time and delayed orders.
- Identify locations and operating conditions that warrant further investigation.
- Build and evaluate a model to predict actual delivery duration.
- Provide an interactive application for generating ETA estimates.

## 🗂️ Dataset Overview

- Created a **synthetic Bengaluru quick-commerce dataset** representing historical order and delivery operations.
- Structured around operational entities including orders, order items, dark stores, riders, and deliveries.
- Used SQL to prepare an order-level analytical dataset for descriptive analysis and predictive modeling.
- The dataset is simulated for this case study and is **not FirstClub production data**.

## 🛠️ Tools & Technologies

- **SQL:** Data preparation, joins, CTEs, aggregations, and operational analysis.
- **Python:** Data validation, exploratory analysis, feature engineering, and model development.
- **Pandas / NumPy:** Data manipulation and preparation.
- **scikit-learn:** Model evaluation and cross-validation.
- **XGBoost:** ETA regression model.
- **Streamlit:** Interactive ETA prediction application.
- **Power BI:** Operational performance reporting and visualization.

## 🔎 Analytical Approach

1. **Prepare:** Combine operational tables in SQL and calculate actual order-to-door delivery duration.
2. **Analyze:** Examine delivery stages, delay patterns, traffic, distance, location, and time periods.
3. **Identify:** Highlight operational patterns and areas that may need further investigation.
4. **Model:** Train and compare a mean baseline, Linear Regression, and XGBoost.
5. **Validate:** Use 5-fold cross-validation on training data and evaluate the final model on a held-out test set.
6. **Present:** Summarize findings and build an interactive Streamlit ETA prediction app.

## 📊 Core Operational Insights

- **Delivery-stage performance:** Last-mile travel is the longest reported delivery stage, averaging **8.82 minutes**.
- **On-time vs. delayed orders:** Delayed deliveries take **2.64 minutes longer** overall than on-time deliveries (**17.35 vs. 14.71 minutes**).
- **Potential bottlenecks:** Last-mile travel has the largest reported stage difference between delayed and on-time orders (**+1.46 minutes**). Ready-to-pickup time is also higher for delayed orders (**+0.75 minutes**), while order-to-store-ready time is **+0.42 minutes** higher.
- **Distance:** Long-distance deliveries show **4.95 minutes longer** last-mile travel than normal-distance deliveries. Last-mile time also increases across distance and traffic conditions in the analyzed breakdown.
- **Traffic patterns:** Average total delivery time rises from **13.31 minutes** in Normal traffic to **15.73 minutes** in High traffic and **17.76 minutes** in Very High traffic. Average last-mile time rises from **7.49 to 9.38 to 11.40 minutes** across those groups.
- **Late-delivery rate by traffic:** Despite longer average delivery times in heavier traffic, the observed late-delivery rate decreases across the same groups (**8.91% → 7.72% → 6.20%**). Average minutes late remains nearly unchanged at **1.38–1.41 minutes**. This suggests longer travel time did not correspond to a higher late-delivery rate in this dataset.
- **Location and time:** Jayanagar has the highest overall average delivery time (**16.85 minutes**) and delay rate (**12.27%**) among the zones shown. Mahadevapura is also elevated, with **16.43 minutes** average delivery time and an **11.01%** delay rate. Hourly comparisons between the two zones vary by metric.
- **Late orders:** The analysis identified **23,976 late orders**, with an overall delay rate of **8.02%**.

**Operational takeaway:** The findings point to last-mile travel and pickup coordination as useful areas for further investigation. Stage calculations and metric definitions should be validated before confirming root causes. The available data shows operational associations, not proof that a specific cause—such as rider shortage or slow picking—produced the delays.

## 🤖 Predictive Modeling

**Prediction target:** Actual delivery duration in minutes, measured from order placement to customer delivery.

| Model | MAE | RMSE | R² |
|---|---:|---:|---:|
| Mean Baseline | 3.38 min | 4.28 min | -0.000 |
| **XGBoost** | **1.42 min** | **1.80 min** | **0.823** |

- The final XGBoost model reduced MAE from **3.38 to 1.42 minutes** compared with the mean baseline.
- This is an absolute reduction of **1.96 minutes**, or approximately **58%** in average absolute prediction error.
- On the held-out test set, the model achieved an **MAE of 1.42 minutes**. This is the average absolute difference between predicted and actual delivery duration; individual prediction errors vary.
- The test-set **R² of 0.823** indicates that the model explains approximately **82.3% of the variation** in actual delivery duration in that test set.

## 💡 Business Relevance

- **Customer communication:** Historical delivery patterns and ETA estimates can help teams set more informed delivery expectations.
- **Operational investigation:** Stage-level and location-level findings can help managers prioritize further review of pickup coordination and last-mile operations.
- **Performance monitoring:** Delay rates and delivery-time patterns provide a basis for tracking operational performance across conditions and locations.
- **Decision support:** Prediction error analysis can help identify segments where ETA estimates may need further improvement.

An improved ETA estimate can support better communication and planning, but **it does not itself make deliveries faster**. Improving delivery speed requires operational changes and further validation of the potential bottlenecks.

## 🚀 ETA Prediction App
 [LastMile Prediction app](https://lastmileprediction.streamlit.app)
- Developed an interactive Streamlit application that estimates delivery duration from order and delivery inputs.
- Inputs include store, distance, order hour, item counts, traffic level, and weather condition.
- Automatically derives peak-hour and high-risk-condition indicators.
- Includes a validation check to prevent fresh-item count from exceeding total-item count.

## 🔮 Future Improvements

- Validate delivery-stage calculations and align metric definitions before confirming operational root causes.
- Investigate prediction errors by traffic, weather, distance, and store to identify where the model performs less consistently.
- Evaluate additional operational features only when they are available at the intended prediction time.
- Test the ETA model on real operational data before considering production use.
- Explore live or frequently refreshed traffic and weather inputs for a future dynamic ETA system.

## 👤 Author

**Ashok Kumar N.**

[LinkedIn](https://www.linkedin.com/in/nmashokkumar/)
