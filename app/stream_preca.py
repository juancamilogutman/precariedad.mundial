import streamlit as st
import pandas as pd

def fetch_data_preca():
    df = pd.read_csv('app/data/precariedad_categoria.csv')
    #df = pd.read_csv('data/precariedad_categoria.csv')    
    return df

def show_page_preca():
    dframe = fetch_data_preca()
    unique_categorias = list(set(dframe.variable_interes))
    variables_preca = ['tasa_part', 'tasa_seg', 'tasa_reg', 'tasa_temp']
    st.title(f"Prueba para aplicacion de precariedad mundial")
    col1, col2 = st.columns(2)
    with col1:
        categoria = st.radio("Elegí una categoria", unique_categorias)
    with col2:
        preca = st.radio("Elegí una variable de precariedad", variables_preca)
    df_filtrado = dframe[dframe.variable_interes == categoria]
    st.write(f"Distribucion del empleo según la variable: {categoria}")
    chart_data = pd.DataFrame(
        {
        "pais": df_filtrado["PAIS"],
        "tasa": df_filtrado[preca],
        "categoria": df_filtrado["categoria"],
        }
        )
    st.bar_chart(chart_data, x="pais", y="tasa", color="categoria",stack=False)

if __name__ == "__main__":
    while True:
        show_page_preca()