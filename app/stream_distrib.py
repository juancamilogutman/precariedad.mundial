import streamlit as st
import pandas as pd

def fetch_data_distrib():
    df = pd.read_csv('app/data/pesos_categoria.csv')
    return df

def show_page_distrib():
    dframe = fetch_data_distrib()
    unique_categorias = list(set(dframe.variable_interes))
    st.title(f"Prueba para aplicacion de precariedad mundial")
    categoria = st.radio("Elegí una categoria", unique_categorias)
    df_filtrado = dframe[dframe.variable_interes == categoria]
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