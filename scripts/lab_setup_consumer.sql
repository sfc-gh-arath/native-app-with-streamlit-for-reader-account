use role accountadmin;

-- STEP ONE
create warehouse READER_WH 
warehouse_size = 'x-small', auto_suspend = 60;

grant usage,operate on warehouse READER_WH to role sysadmin;

--STEP TWO
-- use Snowsight Provider Studio to accept the application package share and any other dat sahres provided from parent org
-- data products --> private sharing

--STEP THREE
--sepcial previlege for snowflake databse
USE ROLE ACCOUNTADMIN;

--see the applciation in your account
show applications;

--grant privileges to the applciation
GRANT IMPORTED PRIVILEGES ON DATABASE SNOWFLAKE TO application SAMPLE_NATIVE_APPP;

--lets give application previlege on some other databses
GRANT IMPORTED PRIVILEGES ON DATABASE SAMPLE_CRM_DATA TO application SAMPLE_NATIVE_APPP;

--the sample app also needs permssison ona warehouse.
grant usage,operate on warehouse READER_WH to application SAMPLE_NATIVE_APPP;

-- STEP FOUR
-- grant previleges to other users/roles
-- https://other-docs.snowflake.com/en/native-apps/consumer-managing-applications#granting-application-roles-to-account-roles
GRANT APPLICATION ROLE SAMPLE_NATIVE_APPP.app_public TO ROLE public;