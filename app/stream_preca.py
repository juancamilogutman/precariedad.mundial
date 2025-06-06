import streamlit as st
import pandas as pd

def fetch_data_preca():
    df = pd.read_csv('app/data/precariedad_categoria.csv')
    #df = pd.read_csv('data/precariedad_categoria.csv')    
    return df

def show_page_preca():
    dframe = fetch_data_preca()
    unique_categorias = list(set(dframe.variable_interes))
    
    # Variables de precariedad con nombres descriptivos
    variables_preca_dict = {
        'tasa_part': 'Trabajo part-time involuntario',
        'tasa_seg': 'Falta de aportes a la seguridad social', 
        'tasa_reg': 'No registro de la relación laboral',
        'tasa_temp': 'Trabajo temporario'
    }
    
    st.title("📊 Precariedad Laboral Mundial")
    st.markdown("### Análisis comparativo de las condiciones de empleo en el mundo")
    
    # Introducción del proyecto
    st.markdown("""
    Esta aplicación presenta datos del proyecto **Precariedad Mundial** del Centro de Estudios sobre 
    Población, Empleo y Desarrollo (CEPED - IIEP – UBA), que analiza la incidencia de la precariedad 
    laboral a nivel mundial utilizando microdatos de encuestas de hogares oficiales.
    """)
    
    # Explicación de las variables de precariedad
    st.markdown("### 🔍 Variables de Precariedad Laboral")
    
    with st.expander("📖 Conocé las dimensiones de la precariedad laboral", expanded=False):
        st.markdown("""
        **🕒 Trabajo part-time involuntario (PRECAPT):**  
        Mide la proporción de trabajadores que desean trabajar más horas pero no pueden hacerlo, 
        reflejando subempleo horario y limitaciones en el acceso a empleos de tiempo completo.
        
        **🏛️ No registro de la relación laboral (PRECAREG):**  
        Indica el porcentaje de trabajadores asalariados cuya relación laboral no está registrada 
        formalmente, lo que implica falta de protección legal y derechos laborales básicos.
        
        **⏰ Trabajo temporario (PRECATEMP):**  
        Representa la proporción de empleos con contratos de duración determinada o sin contrato, 
        caracterizados por mayor inestabilidad e incertidumbre laboral.
        
        **🛡️ Falta de aportes a la seguridad social (PRECASEG):**  
        Mide el porcentaje de trabajadores que no reciben aportes a sistemas de seguridad social, 
        quedando desprotegidos ante riesgos de salud, vejez y desempleo.
        """)
    
    col1, col2 = st.columns(2)
    with col1:
        categoria = st.radio("🎯 Elegí una categoría", unique_categorias)
    with col2:
        preca_key = st.radio("📈 Elegí una variable de precariedad", 
                            list(variables_preca_dict.keys()),
                            format_func=lambda x: variables_preca_dict[x])
    
    df_filtrado = dframe[dframe.variable_interes == categoria]
    st.markdown(f"### Distribución del empleo según: **{categoria}**")
    st.markdown(f"*Variable analizada: {variables_preca_dict[preca_key]}*")
    
    chart_data = pd.DataFrame(
        {
        "pais": df_filtrado["PAIS"],
        "tasa": df_filtrado[preca_key],
        "categoria": df_filtrado["categoria"],
        }
        )
    st.bar_chart(chart_data, x="pais", y="tasa", color="categoria",stack=False)

if __name__ == "__main__":
    while True:
        show_page_preca()