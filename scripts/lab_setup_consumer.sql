--sepcial previlege for snowflake databse
USE ROLE ACCOUNTADMIN;

show applications;
GRANT IMPORTED PRIVILEGES ON DATABASE SNOWFLAKE TO application SAMPLE_NATIVE_APP;
--lets give application previlege on some other databses

GRANT IMPORTED PRIVILEGES ON DATABASE MOVIES TO application SAMPLE_NATIVE_APP;

GRANT IMPORTED PRIVILEGES ON schema MOVIES.DATA TO application SAMPLE_NATIVE_APP;
-- grant all on database ARATH_DB to application sample_native_app_instance;
-- grant all on schema ARATH_DB.ADVERTISING to application sample_native_app_instance;
-- grant select on all tables in schema ARATH_DB.ADVERTISING to application sample_native_app_instance;

grant usage,operate on warehouse COMPUTE_WH to application SAMPLE_NATIVE_APP;

grant usage,operate on warehouse COMPUTE_WH to role sysadmin;
