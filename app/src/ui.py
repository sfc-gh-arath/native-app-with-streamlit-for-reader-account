# Import python packages
import streamlit as st
from snowflake.snowpark.context import get_active_session
import pandas as pd

# Browse data
st.title("Browse Data App")

@st.cache_data
def load_db():
    vDB = session.sql("select database_name from snowflake.information_schema.databases where database_name <> 'CALENDAR' order by 1").toPandas()
    return vDB

@st.cache_data
def load_schema(vDB):
    vSchema = session.sql("select schema_name from " + vDB + ".information_schema.schemata where schema_name <> 'INFORMATION_SCHEMA' order by 1").toPandas()
    return vSchema

@st.cache_data
def load_table(vDB, vSchema):
    vTable = session.sql("select table_name from " + vDB + ".information_schema.tables where table_schema = '" + vSchema + \
                         "' and right(table_name,6)<>'_AUDIT' order by 1").toPandas()
    return vTable

@st.cache_data
def load_data(vDB, vSchema, vTable):
    vData = session.sql("select * from " + vDB + "." + vSchema + "." + vTable + " limit 1000").toPandas()
    return vData

#get a Snwoflake session
# Get the current credentials
session = get_active_session()
  
#pick a db, schema and a table 
st.caption("[Select DB / Schema / Table below]")
vDB = st.selectbox("Select database", load_db(),label_visibility="collapsed")
vSchema = st.selectbox("Select schema", load_schema(vDB),label_visibility="collapsed")
vTable = st.selectbox("Select table", load_table(vDB, vSchema),label_visibility="collapsed")
if st.button("Submit"):
    df = load_data(vDB, vSchema, vTable)
    st.dataframe(df)

