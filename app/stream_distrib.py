import streamlit as st
import pandas as pd
import altair as alt

def fetch_data_distrib():
    df = pd.read_csv('app/data/pesos_categoria.csv')
    df['categoria'] = pd.Categorical(df['categoria'], categories=pd.unique(df['categoria']), ordered=True)
    df2 = pd.read_csv('app/data/pesos_categorias2.csv')
    df2['categoria'] = pd.Categorical(df2['categoria'], categories=pd.unique(df2['categoria']), ordered=True)

    return df, df2

def show_page_distrib():
    dframe,dframe2 = fetch_data_distrib()
    unique_categorias = list(set(dframe.variable_interes))
    #unique_categorias2 = list(set(dframe2.variable_interes))   
    st.title(f"Prueba para aplicacion de precariedad mundial")
    col1, col2 , col3 = st.columns(3)
    with col1:
        categoria = st.radio("Elegí una categoria", unique_categorias)
    with col2:
        eleccion = st.radio("Desagregar por una segunda variable?", ("No", "Si"))
    with col3:
        if eleccion == "No":
            df_filtrado = dframe[dframe.variable_interes == categoria]
        else:
            categorias2 = st.radio("Elegir segunda categoria", unique_categorias,index = 1)
            combined = f"{categoria}-{categorias2}"
            combined_reverse = f"{categorias2}-{categoria}"
            df_filtrado = dframe2[dframe2.variable_interes.isin([combined, combined_reverse])]
    if eleccion == "No":
         st.write(f"Distribucion del empleo según la variable: {categoria}")
    else:
         st.write(f"Distribucion del empleo según las variables: {categoria} y {categorias2}")
    
    chart_data = pd.DataFrame(
        {
        "pais": df_filtrado["PAIS"],
        "particip_empleo": df_filtrado["particip.ocup"],
        "categoria": df_filtrado["categoria"],
        }
        )

    desired_order = chart_data['categoria'].cat.categories
    chart_data["categoria"] = pd.Categorical(
        chart_data["categoria"],
        categories=desired_order,
        ordered=True
        )
    chart_data = chart_data.sort_values("categoria")
#    st.bar_chart(chart_data, x="pais", y="particip_empleo", color="categoria")
# paleta de colores
# color_palette = alt.Scale(
#     domain=list(desired_order),
#     range=["#1f77b4", "#ff7f0e", "#2ca02c", "#d62728", "#9467bd", "#8c564b"]  # ajusta según tus categorías
# )

# Crea el gráfico Altair
    reversed_order = list(desired_order)[::-1]

    bar_chart = alt.Chart(chart_data).mark_bar().encode(
        x=alt.X('pais:N', title='País'),
        y=alt.Y('particip_empleo:Q', title='Participación empleo',stack ='zero'), 
        color=alt.Color('categoria:N', sort=list(reversed_order), title='Categoría'),
        order=alt.Order('color_Category_sort_index:Q'),
        tooltip=['pais', 'particip_empleo', 'categoria']
    ).properties(
        width=700,
        height=400
    )

    st.altair_chart(bar_chart, use_container_width=True)


if __name__ == "__main__":
    while True:
        show_page_distrib()