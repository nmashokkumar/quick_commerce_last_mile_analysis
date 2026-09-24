import streamlit as st
import pandas as pd
import joblib

# =========================================================
# PAGE CONFIGURATION
# =========================================================

st.set_page_config(
    page_title="QuickCommerce ETA Predictor",
    page_icon="🚚",
    layout="centered",
    initial_sidebar_state="collapsed",
)


# =========================================================
# CUSTOM CSS
# =========================================================

st.markdown(
    """
    <style>
        .block-container {
            max-width: 850px;
            padding-top: 2.5rem;
            padding-bottom: 3rem;
        }

        .main-title {
            text-align: center;
            font-size: 2.2rem;
            font-weight: 700;
            margin-bottom: 0.3rem;
        }

        .subtitle {
            text-align: center;
            color: #6b7280;
            font-size: 1rem;
            margin-bottom: 2rem;
        }

        .section-title {
            font-size: 1.1rem;
            font-weight: 650;
            margin-top: 1rem;
            margin-bottom: 0.8rem;
        }

        .eta-card {
            padding: 1.5rem;
            border-radius: 16px;
            text-align: center;
            margin-top: 1.5rem;
            border: 1px solid rgba(128, 128, 128, 0.25);
        }

        .eta-label {
            font-size: 0.95rem;
            color: #6b7280;
            margin-bottom: 0.3rem;
        }

        .eta-value {
            font-size: 2.6rem;
            font-weight: 750;
        }

        .eta-unit {
            font-size: 1rem;
            color: #6b7280;
        }

        .footer {
            text-align: center;
            color: #9ca3af;
            font-size: 0.8rem;
            margin-top: 2rem;
        }
    </style>
    """,
    unsafe_allow_html=True,
)


# =========================================================
# LOAD MODEL
# =========================================================


@st.cache_resource
def load_model():
    return joblib.load("model/final_eta_model.pkl")


model = load_model()


# =========================================================
# STORE LIST
# =========================================================

store_names = [
    "QuickMart Whitefield Main Road",
    "QuickMart HSR Extension",
    "QuickMart Koramangala",
    "QuickMart Nagarbhavi",
    "QuickMart Hebbal",
    "QuickMart Jayanagar",
    "QuickMart Banashankari",
    "QuickMart Kalyan Nagar",
    "QuickMart Kengeri",
    "QuickMart Bellandur ORR",
    "QuickMart Domlur",
    "QuickMart Marathahalli",
    "QuickMart Yelahanka",
    "QuickMart BTM Layout",
    "QuickMart Mahadevapura",
    "QuickMart Malleshwaram",
    "QuickMart JP Nagar 6th Phase",
    "QuickMart Whitefield",
    "QuickMart Rajajinagar",
    "QuickMart Brookefield",
    "QuickMart Bommanahalli",
    "QuickMart Basavanagudi",
    "QuickMart Sarjapur Road",
    "QuickMart Ejipura",
    "QuickMart HSR Layout",
    "QuickMart Marathahalli ORR",
    "QuickMart Jayanagar 4th Block",
    "QuickMart CV Raman Nagar",
    "QuickMart Kadugodi",
    "QuickMart Yeshwanthpur",
    "QuickMart Hennur",
    "QuickMart Vijayanagar",
    "QuickMart Hebbal Kempapura",
    "QuickMart JP Nagar",
    "QuickMart Indiranagar",
    "QuickMart Bellandur",
    "QuickMart Ulsoor",
    "QuickMart Electronic City",
    "QuickMart Frazer Town",
    "QuickMart BTM 2nd Stage",
]


# =========================================================
# PAGE HEADER
# =========================================================

st.markdown(
    '<div class="main-title">🚚 QuickCommerce ETA Predictor</div>',
    unsafe_allow_html=True,
)

st.markdown(
    '<div class="subtitle">'
    "Estimate delivery time using order, traffic, weather and distance conditions."
    "</div>",
    unsafe_allow_html=True,
)


# =========================================================
# ORDER & DELIVERY
# =========================================================

st.markdown(
    '<div class="section-title">📍 Order & Delivery</div>',
    unsafe_allow_html=True,
)

store_name = st.selectbox(
    "Store",
    store_names,
)


col1, col2 = st.columns(2)

with col1:
    distance_km = st.number_input(
        "Delivery Distance (km)",
        min_value=0.1,
        max_value=10.0,
        value=1.5,
        step=0.1,
        format="%.1f",
        help="Estimated distance from the store to the customer.",
    )

with col2:
    hour = st.number_input(
        "Order Hour",
        min_value=0,
        max_value=23,
        value=18,
        step=1,
        help="Hour when the order was placed, from 0 to 23.",
    )


# =========================================================
# ORDER DETAILS
# =========================================================

st.markdown(
    '<div class="section-title">🛒 Order Details</div>',
    unsafe_allow_html=True,
)

col1, col2 = st.columns(2)

with col1:
    total_items = st.number_input(
        "Total Items",
        min_value=1,
        max_value=50,
        value=5,
        step=1,
        help="Total number of items in the order.",
    )

with col2:
    fresh_item_count = st.number_input(
        "Fresh Items",
        min_value=0,
        max_value=total_items,
        value=min(1, total_items),
        step=1,
        help="Number of fresh/perishable items. Cannot exceed total items.",
    )


# =========================================================
# BUSINESS VALIDATION
# =========================================================

if fresh_item_count > total_items:
    st.error("Fresh items cannot be greater than total items.")
    st.stop()


# =========================================================
# DELIVERY CONDITIONS
# =========================================================

st.markdown(
    '<div class="section-title">🌦️ Delivery Conditions</div>',
    unsafe_allow_html=True,
)

col1, col2 = st.columns(2)

with col1:
    traffic_level = st.selectbox(
        "Traffic Level",
        [
            "Normal",
            "High",
            "Very High",
        ],
    )

with col2:
    weather_condition = st.selectbox(
        "Weather Condition",
        [
            "Clear",
            "Light Rain",
            "Heavy Rain",
        ],
    )


# =========================================================
# DERIVED FEATURES
# =========================================================

# Peak hour: 6 PM to 9 PM
is_peak_hour = int(hour in [18, 19, 20, 21])


# High-risk condition:
# Very High traffic + Heavy Rain
high_risk_condition = int(
    traffic_level == "Very High" and weather_condition == "Heavy Rain"
)


# =========================================================
# SHOW DERIVED CONDITIONS
# =========================================================

with st.expander("Prediction Conditions"):

    condition_col1, condition_col2 = st.columns(2)

    with condition_col1:
        st.write(f"**Peak Hour:** " f"{'Yes' if is_peak_hour else 'No'}")

    with condition_col2:
        st.write(
            f"**High-Risk Condition:** " f"{'Yes' if high_risk_condition else 'No'}"
        )


# =========================================================
# PREDICTION BUTTON
# =========================================================

st.markdown(
    "<br>",
    unsafe_allow_html=True,
)

predict_clicked = st.button(
    "🚀 Predict Delivery Time",
    type="primary",
    use_container_width=True,
)


# =========================================================
# PREDICTION
# =========================================================

# =========================================================
# PREDICTION
# =========================================================

if predict_clicked:

    input_data = pd.DataFrame(
        {
            "distance_km": [distance_km],
            "hour": [hour],
            "store_name": [store_name],
            "total_items": [total_items],
            "fresh_item_count": [fresh_item_count],
            "is_peak_hour": [is_peak_hour],
            "traffic_level": [traffic_level],
            "weather_condition": [weather_condition],
            "high_risk_condition": [high_risk_condition],
        }
    )

    prediction = model.predict(input_data)[0]

    # ETA cannot be negative
    prediction = max(0, prediction)

    # Display result
    st.markdown(
        f'<div class="eta-card">'
        f'<div class="eta-label">Estimated Delivery Time</div>'
        f'<div class="eta-value">{prediction:.0f}</div>'
        f'<div class="eta-unit">minutes</div>'
        f"</div>",
        unsafe_allow_html=True,
    )

    st.caption("Prediction generated using the trained ETA model.")

# =========================================================
# FOOTER
# =========================================================

st.markdown(
    """
    <div class="footer">
        QuickCommerce Delivery Analytics • ETA Prediction
    </div>
    """,
    unsafe_allow_html=True,
)
