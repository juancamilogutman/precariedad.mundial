import streamlit as st
import pandas as pd

df = pd.read_csv("pesos_categoria.csv")
df.head()
unique_categorias = list(set(df.variable_interes))
st.title(f"Prueba para aplicacion de precariedad mundial",)

categoria = st.radio("Elegí una categoria", unique_categorias)
df_filtrado = df[df.variable_interes == categoria]

st.write(f"Distribucion del empleo según la variable : {categoria}")
chart_data = pd.DataFrame(
    {
        "pais": df_filtrado["PAIS"],
        "particip_empleo": df_filtrado["particip.ocup"],
        "categoria": df_filtrado["categoria"],
        
    }
)

st.bar_chart(chart_data, x="pais", y="particip_empleo", color="categoria")

#st.bar_chart(df_filtrado, x="PAIS", y="particip.ocup",color="categoria")

#def filter_data(data):
#    filtered_data = data[data.variable_interes == categoria]
#    return filtered_data
#def show_plot():
#    datos = filter_data(df)
#    st.bar_chart(datos, x="PAIS", y="particip.ocup",color="variable_interes")

#show_plot() 

