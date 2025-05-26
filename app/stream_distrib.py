import streamlit as st
import pandas as pd

def fetch_data_distrib():
    df = pd.read_csv("pesos_categoria.csv")
    return df

def show_page_distrib():
    df = fetch_data_distrib()
    unique_categorias = list(set(df.variable_interes))
    st.title(f"Prueba para aplicacion de precariedad mundial")
    categoria = st.radio("Elegí una categoria", unique_categorias)
    df_filtrado = df[df.variable_interes == categoria]
    st.write(f"Distribucion del empleo según la variable: {categoria}")
    chart_data = pd.DataFrame(
        {
        "pais": df_filtrado["PAIS"],
        "particip_empleo": df_filtrado["particip.ocup"],
        "categoria": df_filtrado["categoria"],
        }
        )
    st.bar_chart(chart_data, x="pais", y="particip_empleo", color="categoria")

if __name__ == "__main__":
    while True:
        show_page_distrib()