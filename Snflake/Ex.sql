

show tables;
select * from location;
describe table location;
COPY INTO public.location(locationid, city, state, zipcode, activeflag, createddate, modifieddate,
                         _stg_file_name, _stg_file_load_ts, _stg_file_md5, _copy_data_ts)
FROM (
    SELECT 
        t.$1 AS locationid,
        t.$2 AS city,
        t.$3 AS state,
        t.$4 AS zipcode,
        t.$5 AS activeflag,
        t.$6 AS createddate,
        t.$7 AS modifieddate,
        metadata$filename AS _stg_file_name,
        metadata$file_last_modified AS _stg_file_load_ts,
        metadata$file_content_key AS _stg_file_md5,
        CURRENT_TIMESTAMP AS _copy_data_ts
    FROM @swiggy.e_stg.swiggyloc t
)
FILE_FORMAT = (format_name = 'f_fmt.csv_file_format')
files = ('location-day03-invalid-delimiter.csv')
on_error = 'continue';

COPY INTO public.locationl(locationid, city, state, zipcode, activeflag, createddate, modifieddate)
FROM (
    SELECT 
        t.$1 AS locationid,
        t.$2 AS city,
        t.$3 AS state,
        t.$4 AS zipcode,
        t.$5 AS activeflag,
        t.$6 AS createddate,
        t.$7 AS modifieddate
    FROM @e_stg.swiggyloc t
)
FILE_FORMAT = (format_name = 'f_fmt.csv_file_format')
files = ('location-day03-invalid-delimiter.csv')
on_error = 'continue';
Select * from locationl;
CREATE OR REPLACE PIPE SPIPE.LOPIPE
AUTO_INGEST = TRUE
AS 
COPY INTO public.location(locationid, city, state, zipcode, activeflag, createddate, modifieddate,
                         _stg_file_name, _stg_file_load_ts, _stg_file_md5, _copy_data_ts)
FROM (
    SELECT 
        t.$1 AS locationid,
        t.$2 AS city,
        t.$3 AS state,
        t.$4 AS zipcode,
        t.$5 AS activeflag,
        t.$6 AS createddate,
        t.$7 AS modifieddate,
        metadata$filename AS _stg_file_name,
        metadata$file_last_modified AS _stg_file_load_ts,
        metadata$file_content_key AS _stg_file_md5,
        CURRENT_TIMESTAMP() AS _copy_data_ts
    FROM @e_stg.swiggyloc t
)
FILE_FORMAT = (format_name = 'f_fmt.csv_file_format')
pattern = '.*\.csv'
on_error = 'continue';
show pipes;
describe pipe SPIPE.LOPIPE;
--arn:aws:sqs:eu-north-1:681214183808:sf-snowpipe-AIDAZ5G4HRGAAHKVAEN2S-7ih_NRKp9hhRE7HXp3hHtA
Select system$pipe_status('swiggy.spipe.LOPIPE'); 
alter pipe swiggy.spipe.LOPIPE set pipe_execution_paused = true;
alter pipe swiggy.spipe.LOPIPE set pipe_execution_paused = false;
Select * from public.location;

Select * from SNOWFLAKE.ACCOUNT_USAGE.PIPE_USAGE_HISTORY
WHERE PIPE_NAME = 'LOPIPE';

SELECT * FROM TABLE(INFORMATION_SCHEMA.COPY_HISTORY(
    TABLE_NAME => 'LOCATION',
    START_TIME => DATEADD('MINUTES', -25, CURRENT_TIMESTAMP()),
    END_TIME => CURRENT_TIMESTAMP()
))
WHERE PIPE_NAME = 'LOPIPE'
ORDER BY LAST_LOAD_TIME DESC;




