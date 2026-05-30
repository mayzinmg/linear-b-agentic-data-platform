CREATE OR REPLACE TABLE bronze_linear_b_tablets AS
SELECT *
FROM read_csv(
    'data/raw/external/insiderphd_tablets.csv',
    delim = ';',
    header = true,
    columns = {
        'identifier': 'VARCHAR',
        'location': 'VARCHAR',
        'series': 'VARCHAR',
        'inscription': 'VARCHAR',
        'original': 'VARCHAR'
    },
    null_padding = true,
    ignore_errors = true,
    strict_mode = false
);