create or replace database vani;
create or replace schema e_stg;
create or replace schema f_fmt;
create or replace schema spipe;
create or replace schema stint;
use schema f_fmt;
create or replace file format csv_f
type = csv
skip_header = 1
field_delimiter = ','
null_if = ('//N','null','NULL','Null');
desc file format csv_f;
alter file format csv_f set null_if = ('\\N','null','NULL','Null'),EMPTY_FIELD_AS_NULL = true ,FIELD_OPTIONALLY_ENCLOSED_BY = '"';
create or replace file format csv_f_is
type = csv
field_delimiter = ','
parse_header = true;

use schema e_stg;
use schema stint;
create or replace storage integration s3int
type = external_stage
storage_provider = s3
enabled = true
storage_aws_role_arn = 'arn:aws:iam::049706517980:role/empsnflake'
storage_allowed_locations = ('s3://resturantscsvp/emps/','s3://resturantscsvp/emps/emp1va/');
describe storage integration s3int;

create or replace stage e_stg.empstg url = 's3://resturantscsvp/emps/' storage_integration = s3int;

describe stage e_stg.empstg;

List @e_stg.empstg;

Select $1,$2,$3,$4,$5,$6 from @e_stg.empstg/emp1.csv;

Select * from table(infer_schema(location => '@vani.e_stg.empstg', file_format => 'f_fmt.csv_f_is', files => ('emp1.csv')));

create or replace table public.Emps using template (
    Select ARRAY_AGG(OBJECT_CONSTRUCT(*)) from table(infer_schema(location => '@vani.e_stg.empstg', file_format => 'f_fmt.csv_f_is', files => ('emp1.csv'))));
Select * from public.emps;
truncate table public.emps;
desc table public.emps;
show tables;
create or replace pipe vani.spipe.emppipe auto_ingest = true as 
copy into public.emps from @vani.e_stg.empstg 
file_format = (format_name = vani.f_fmt.csv_f)
pattern = 'emp.*\\.csv';

--drop pipe vani.spipe.emppipe;

use schema spipe;

describe pipe vani.spipe.emppipe;

select SYSTEM$PIPE_STATUS('VANI.SPIPE.emppipe');
Select dateadd('minute',-10, current_timestamp());
Select * from table(information_schema.copy_history(table_name => 'EMPS', start_time => dateadd('minute',-30, current_timestamp()),END_TIME =>current_timestamp()));

Select * from SNOWFLAKE.account_usage.pipe_usage_history where pipe_name = UPPER('emppipe');

alter PIPE emppipe set pipe_execution_paused = true;
alter PIPE emppipe set pipe_execution_paused = false;

Select * from INFORMATION_SCHEMA.LOAD_HISTORY;
Select * from table(INFORMATION_SCHEMA.VALIDATE_PIPE_LOAD(
    PIPE_NAME => 'VANI.SPIPE.EMPPIPE',
    START_TIME => dateadd('hour', -1, current_timestamp()),
    END_TIME => current_timestamp()
));

--Tribleshooting Snowpipe
--Changing delimiter from ',' to '|' in file format
create or replace file format f_fmt.csv_f
type = csv
skip_header = 1
field_delimiter = ','
null_if = ('//N','null','NULL','Null');

--alter file format f_fmt.csv_f set field_delimiter = ','

describe file format f_fmt.csv_f;

--trying to run COPY Command
copy into public.emps from @vani.e_stg.empstg 
file_format = (format_name = vani.f_fmt.csv_f)
pattern = 'emp.*\\.csv'
validation_mode = 'return_errors'
on_error = 'continue';

--truncate table public.emps;
Select * from public.emps;
