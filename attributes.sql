-- Base+Attribute tables and selecting data from them

CREATE TABLE ora_attrs (
    id      NUMBER(16),
    name    VARCHAR2(32),
    value   VARCHAR2(1024),
    CONSTRAINT ora_attrs_pk PRIMARY KEY (id, name)
) ORGANIZATION INDEX COMPRESS 1;

INSERT ALL
    INTO ora_attrs (id, name, value) VALUES (1, 'foo', 'A')
    INTO ora_attrs (id, name, value) VALUES (2, 'foo', 'B')
    INTO ora_attrs (id, name, value) VALUES (2, 'bar', 'C')
    INTO ora_attrs (id, name, value) VALUES (3, 'bar', 'D')
SELECT 1 FROM DUAL;

COLUMN foo FORMAT A10
COLUMN bar FORMAT A10
SELECT id,
       MIN(CASE WHEN name='foo' THEN value END) AS foo,
       MIN(CASE WHEN name='bar' THEN value END) AS bar
  FROM ora_attrs
 GROUP BY id;

CREATE TABLE ora_base (
    id      NUMBER(16),
    name    VARCHAR2(32),
    surname VARCHAR2(32),
    CONSTRAINT ora_base_pk PRIMARY KEY (id)
);

INSERT ALL
    INTO ora_base (id, name, surname) VALUES (1, 'Name1', 'Surname1')
    INTO ora_base (id, name, surname) VALUES (2, 'Name2', 'Surname2')
    INTO ora_base (id, name, surname) VALUES (3, 'Name3', 'Surname3')
    INTO ora_base (id, name, surname) VALUES (4, 'Name4', 'Surname4')
SELECT 1 FROM DUAL;

COLUMN name FORMAT A10
COLUMN surname FORMAT A10

SELECT b.id, b.name, b.surname, a.foo, a.bar
  FROM ora_base b, (
        SELECT id,
               MIN(CASE WHEN name='foo' THEN value END) AS foo,
               MIN(CASE WHEN name='bar' THEN value END) AS bar
          FROM ora_attrs
         GROUP BY id) a
 WHERE b.id = a.id(+);

DROP TABLE ora_base;
DROP TABLE ora_attrs;
