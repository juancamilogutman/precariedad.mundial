import streamlit as st
import pandas as pd

def fetch_data_salarios():
    df = pd.read_csv("pesos_categoria.csv")
    return df

def show_page_salarios():
    "1"