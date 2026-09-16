import streamlit as st
import pandas as pd
import joblib

#Load saved model and scaler
model = joblib.load("breast_cancer_model_small.pkl")
scaler = joblib.load("scaler_small.pkl")

st.set_page_config(
    page_title = "Breast Cancer Deection System",
    page_icon = "sign.png",
    layout = "wide"
)

st.image("sign.png", width = 40)
st.title("Breast Cancer Detection System")
st.caption("Early Disease Detection and Predictive Analysis: A Case Study of Breast Cancer Prediction")
st.write("Enter the tumor measurements below to predict whether the tumor is Benign or Malignant.")

st.markdown("---")
st.subheader("Patient Tumor Measurements")

col1, col2 = st.columns(2)

with col1:
    perimeter_worst = st.number_input("Perimeter Worst", min_value = 0.0)
    area_worst = st.number_input("Area Worst", min_value = 0.0)
    concave_points_worst = st.number_input("Concave Points Worst", min_value = 0.0)
    radius_worst = st.number_input("Radius Worst", min_value = 0.0)
    concave_points_mean = st.number_input("Concave Points Mean", min_value = 0.0)

with col2:
    perimeter_mean = st.number_input("Perimeter Mean", min_value = 0.0)
    radius_mean = st.number_input("Radius Mean", min_value = 0.0)
    concavity_mean = st.number_input("Concavity Mean", min_value = 0.0)
    area_mean = st.number_input("Area Mean", min_value = 0.0)
    concavity_worst = st.number_input("Concavity Worst", min_value = 0.0)

if st.button("Predict Tumor Type"):

    input_data = pd.DataFrame([[
        perimeter_worst,
        area_worst,
        concave_points_worst,
        radius_worst,
        concave_points_mean,
        perimeter_mean,
        radius_mean,
        concavity_mean,
        area_mean,
        concavity_worst
    ]], columns = [
        'perimeter_worst',
        'area_worst',
        'concave_points_worst',
        'radius_worst',
        'concave_points_mean',
        'perimeter_mean',
        'radius_mean',
        'concavity_mean',
        'area_mean',
        'concavity_worst'
    ])

    input_scaled = scaler.transform(input_data)

    prediction = model.predict(input_scaled)[0]
    probability = model.predict_proba(input_scaled)[0]

    st.markdown("### Probability Breakdown")

    col1, col2 = st.columns(2)

    with col1:
        st.metric("Benign Probability", f"{probability[0]*100:.2f}%")
        st.progress(float(probability[0]))
    
    with col2:
        st.metric("Malignant Probability", f"{probability[1]*100:.2f}%")
        st.progress(float(probability[1]))

    st.markdown("---")
    st.subheader("Diagnostic Results")

    if prediction == 1:
        st.image("warning.png", width = 40)
        st.error("High Risk: Malignant Tumor Detected")
    else:
        st.image("shield.png", width = 40)
        st.success("Low Risk: Benign Tumor Detected")
        





