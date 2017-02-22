-- Check how JSON types are returned by SQL/JSON
SET ECHO ON
CREATE TABLE ora_json(data CLOB CHECK (data IS JSON));
DESC ora_json

INSERT INTO ora_json VALUES ('{"number_value": 3.14, "string_value": "string", "boolean_value": false, "array_value": [1, 2, 3], "object_value": {"key": "value"}}');

-- Default SQL/JSON types

CREATE TABLE ora_json_types
AS
SELECT j.data.number_value,
       j.data.string_value,
       j.data.boolean_value,
       j.data.missing_value,
       j.data.array_value,
       j.data.object_value
  FROM ora_json j;
DESC ora_json_types
SELECT * FROM ora_json_types;

DROP TABLE ora_json_types;

-- Default function JSON_VALUE types

CREATE TABLE ora_json_types
AS
SELECT JSON_VALUE(j.data, '$.number_value') AS number_value,
       JSON_VALUE(j.data, '$.string_value') AS string_value,
       JSON_VALUE(j.data, '$.boolean_value') AS boolean_value,
       JSON_VALUE(j.data, '$.missing_value') AS missing_value,
       JSON_VALUE(j.data, '$.array_value') AS array_value,
       JSON_VALUE(j.data, '$.object_value') AS object_value
  FROM ora_json j;
DESC ora_json_types
SELECT * FROM ora_json_types;

DROP TABLE ora_json_types;

-- JSON table w/o types (default types)

CREATE TABLE ora_json_types
AS
SELECT jt.*
  FROM ora_json j,
       JSON_TABLE(j.data, '$' COLUMNS
                  number_value PATH '$.number_value',
                  string_value PATH '$.string_value',
                  array_value PATH  '$.array_value',
                  object_value PATH  '$.object_value',
                  ) jt;
DESC ora_json_types
SELECT * FROM ora_json_types;

DROP TABLE ora_json_types;

-- JSON table with types
-- Check complex nested types

CREATE TABLE ora_json_types
AS
SELECT jt.*
  FROM ora_json j,
       JSON_TABLE(j.data, '$' COLUMNS
                  number_value NUMBER(10,2) PATH '$.number_value',
                  string_value VARCHAR2(10) PATH '$.string_value',
                  array_value_string VARCHAR2(20) PATH  '$.array_value',
                  array_value_json VARCHAR2(20) FORMAT JSON PATH  '$.array_value',
                  object_value_string VARCHAR2(20) PATH  '$.object_value',
                  object_value_json VARCHAR2(20) FORMAT JSON PATH  '$.object_value'
                  ) jt;
DESC ora_json_types
SELECT * FROM ora_json_types;

DROP TABLE ora_json_types;

-- Unpack nested array

CREATE TABLE ora_json_types
AS
SELECT jt.*
  FROM ora_json j,
       JSON_TABLE(j.data, '$' COLUMNS
                  number_value NUMBER(10,2) PATH '$.number_value',
                  string_value VARCHAR2(10) PATH '$.string_value',
                  NESTED PATH '$.array_value[*]' COLUMNS (
                          array_value NUMBER(10) PATH '$'
                      )
                  ) jt;
DESC ora_json_types
SELECT * FROM ora_json_types;


DROP TABLE ora_json;
DROP TABLE ora_json_types;
EXIT
