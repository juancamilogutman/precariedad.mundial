import streamlit as st
import pandas as pd

def fetch_metadata():
    diccionario = pd.read_excel('app/data/Metadata.xlsx', sheet_name='Diccionario')
    homogeneizacion = pd.read_excel('app/data/Metadata.xlsx', sheet_name='Homogeneizacion')

    return diccionario, homogeneizacion
 
def show_page_metadata():
    diccionario,homogeneizacion = fetch_metadata()
    
    st.title(f"Metadatos - Variables y definiciones adoptadas")
#    col1, col2 = st.columns(2)
#    with col1:
    st.subheader("Diccionario de la base de datos")
    st.dataframe(diccionario, use_container_width=True,)
#    with col2:
    st.subheader("Homogeneizacion de las encuestas")
    st.dataframe(homogeneizacion, use_container_width=True)    

if __name__ == "__main__":
    while True:
        show_page_metadata()