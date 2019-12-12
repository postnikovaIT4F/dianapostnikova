--1 Шаг:
-- Создаем таблицу под названием actions, задаем переменные с форматом и нулевым или ненулевым значениям.
CREATE TABLE public.actions
(
    rat_id integer NOT NULL,
    grade text COLLATE pg_catalog."default" NOT NULL,
    outlook text COLLATE pg_catalog."default",
    change text COLLATE pg_catalog."default" NOT NULL,
    date real NOT NULL, 
    ent_name text COLLATE pg_catalog."default" NOT NULL,
    okpo bigint NOT NULL,
    ogrn bigint,
    inn bigint,
    finst integer,
    agency_id text COLLATE pg_catalog."default" NOT NULL,
    rat_industry text COLLATE pg_catalog."default",
    rat_type text COLLATE pg_catalog."default" NOT NULL,
    horizon text COLLATE pg_catalog."default",
    skale_typer text COLLATE pg_catalog."default",
    currency text COLLATE pg_catalog."default",
    backed_flag text COLLATE pg_catalog."default"
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.actions
    OWNER to postgres;
-- Далее используется загрузка файла (в случае загрузки через командную строку). В данном случае я переформатировал формат файла в csv и переименовал название файла в actions. 	
COPY public.actions  FROM 'C:/Users/Public/SQL/actions.csv' DELIMITER ';' CSV HEADER
;
--2 Шаг:
-- Создаем таблицу credit_events и выбираем формат ячеек с нулевыми или ненулевыми значениями
CREATE TABLE public.credit_events
(
    inn bigint NOT NULL,
    date date NOT NULL,
    event text COLLATE pg_catalog."default" NOT NULL
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.credit_events
    OWNER to postgres;	
-- Далее используется загрузка файла (в случае загрузки через командную строку). В данном случае я переформатировал формат файла в csv.	
COPY public.credit_events FROM 'C:/Users/Public/SQL/credit_events_task.csv' DELIMITER ';' CSV HEADER
;
--3 Шаг:
--Создаем таблицу scale_exp_task и выбираем формат ячеек с нулевыми или ненулевыми значениями
CREATE TABLE public.scale_exp_task
(
    grade text COLLATE pg_catalog."default" NOT NULL,
    grade_id integer NOT NULL
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.scale_exp_task
    OWNER to postgres;
-- Далее используется загрузка файла (в случае загрузки через командную строку).
COPY public.scale_exp_task FROM 'C:/Users/Public/SQL/scale_EXP_task.csv' DELIMITER ';' CSV HEADER
;