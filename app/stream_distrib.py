import streamlit as st
import pandas as pd

def fetch_data_distrib():
    df = pd.read_csv('app/data/pesos_categoria.csv')
    df2 = pd.read_csv('app/data/pesos_categorias2.csv')

    return df, df2

def show_page_distrib():
    dframe,dframe2 = fetch_data_distrib()
    unique_categorias = list(set(dframe.variable_interes))
    unique_categorias2 = list(set(dframe2.variable_interes))   
    st.title(f"Prueba para aplicacion de precariedad mundial")
    col1, col2 = st.columns(2)
    with col1:
        categoria = st.radio("Elegí una categoria", unique_categorias)
    with col2:
        categorias2 = st.radio("Graficar con dos categorias", unique_categorias2, value=None)
        if categorias2 == None:
            df_filtrado = dframe[dframe.variable_interes == categoria]
        else: 
            combined = f"{categoria}-{categorias2}"
            df_filtrado = dframe2[dframe2.variable_interes == combined]
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