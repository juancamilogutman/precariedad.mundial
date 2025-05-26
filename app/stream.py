import streamlit as st
import pandas as pd
import stream_distrib
import stream_preca
import stream_salarios
from streamlit_option_menu import option_menu


# Page configurations
st.set_page_config(page_title="Precariedad Mundial", 
                   page_icon="🌍", 
                   layout="wide")

page_selection = option_menu(
            None,  # No menu title
            ["Distribucion empleo", "Tasas de precariedad","Salarios"],  
            icons=["pie-chart","bar-chart-steps", "arrow-up-circle"],   
            menu_icon="cast",  
            default_index=0, 
            orientation="horizontal")
if page_selection == "Distribucion empleo":
    stream_distrib.show_page_distrib()
elif page_selection == "Tasas de precariedad":
    stream_preca.show_page_preca()
elif page_selection == "Salarios":
    stream_salarios.show_page_salarios()

