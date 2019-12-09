-- HOMEWORK 1. Кредитные рейтинги.
-- 1. Выгрузить файлы с папки «Рейтинги» с Яндекс.Диск. Файлы credit_events_task.xls и ratings_task.xlsx необходимо открыть и сохранить в формате .csv. В файле ratings_task.xlsx поле date должно иметь формат ‘дата’, поле ent_name - 'общий'.
-- Таблица ratings_task. Создаем пустую таблицу. При импорте разделитель указать ';'. Ни один столбец не является первичным ключом. 
-- DROP TABLE public.ratings_task;

CREATE TABLE public.ratings_task
(
    rat_id smallint NOT NULL,
    grade text COLLATE pg_catalog."default" NOT NULL,
    outlook text COLLATE pg_catalog."default",
    change text COLLATE pg_catalog."default" NOT NULL,
    date date NOT NULL,
    ent_name text COLLATE pg_catalog."default" NOT NULL,
    okpo integer NOT NULL,
    ogm bigint,
    inn bigint,
    finst integer,
    agency_id text COLLATE pg_catalog."default" NOT NULL,
    rat_industry text COLLATE pg_catalog."default",
    rat_type text COLLATE pg_catalog."default" NOT NULL,
    horizon text COLLATE pg_catalog."default",
    scale_typer text COLLATE pg_catalog."default",
    currency text COLLATE pg_catalog."default",
    backed_flag text COLLATE pg_catalog."default"
)
TABLESPACE pg_default;

ALTER TABLE public.ratings_task
    OWNER to postgres;
	
-- Команда для импорта данных из файла в готовую таблицу.
-- Внимание! PostgreSQL Server имеет ограниченные права доступа к файлам. Команда COPY будет работать из pgAdmin
только, если загружаемый файл находится в папке с публичным доступом (например, ~\User\Public для Windows,
/tmp для Mac). Альтернатива - использовать команду \COPY, которая обходит все права доступа, но ее нужно запускать
из терминала SQL Shell (psql). Ниже представлены оба вариант. Используйте тот, который Вам больше нравится.

-- copy public.ratings_task  FROM 'C:/Users/Public/ratings_task.csv' DELIMITER ';' CSV HEADER;
\copy public.ratings_task  FROM 'C:/Users/Public/ratings_task.csv' DELIMITER ';' CSV HEADER;




-- Таблица credit_events_task. Создаем пустую таблицу. При импорте разделитель указать ';'. Снова ни один столбец не может являться первичным ключом.
-- DROP TABLE public.credit_events;

CREATE TABLE public.credit_events_task
(
    date date NOT NULL,
    event text COLLATE pg_catalog."default" NOT NULL,
    inn bigint NOT NULL
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.credit_events_task
    OWNER to postgres;
	
-- Команда для импорта данных из файла в готовую таблицу.
-- copy public.credit_events_task  FROM 'C:/Users/Public/credit_events_task.csv' DELIMITER ';' CSV HEADER;
\copy public.credit_events_task  FROM 'C:/Users/credit_events_task.csv' DELIMITER ';' CSV HEADER;




-- Таблица scale_EXP_task. Создаем пустую таблицу. При импорте файла scale_EXP_task.csv необходимо выбрать кодировку 'WIN1251'. Разделитель - ';'. Оба поля выступают в качестве первичного ключа. 
-- DROP TABLE public."scale_EXP_task";

CREATE TABLE public."scale_EXP_task"
(
    grade text COLLATE pg_catalog."default" NOT NULL,
    grade_id integer NOT NULL,
    CONSTRAINT "scale_EXP_pkey" PRIMARY KEY (grade, grade_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public."scale_EXP_task"
    OWNER to postgres;

-- Команда для импорта данных из файла в готовую таблицу.
-- copy public.scale_EXP_task  FROM 'C:/Users/Public/scale_EXP_task.csv' DELIMITER ';' CSV HEADER;
\copy public.scale_EXP_task  FROM 'C:/Users/scale_EXP_task.csv' DELIMITER ';' CSV HEADER;




-- 2. a) Выносим из таблицы ratings_task информацию о рейтингах (agency_id, rat_industry, rat_type, horizon, scale_typer, currency, backed_flag) в отдельную таблицу rating_inf. Добавляем новое поле 'no_rat' в новой таблице, которое будет являться первичным ключом.
-- DROP TABLE IF EXISTS public.rating_inf;

-- создание таблицы rating_inf для выноса информации
CREATE TABLE public.rating_inf
(
"no_rat" integer NOT NULL,
agency_id text COLLATE pg_catalog."default" NOT NULL,
rat_industry text COLLATE pg_catalog."default",
rat_type text COLLATE pg_catalog."default" NOT NULL,
horizon text COLLATE pg_catalog."default",
scale_typer text COLLATE pg_catalog."default",
currency text COLLATE pg_catalog."default",
backed_flag text COLLATE pg_catalog."default",
CONSTRAINT rating_inf_pkey PRIMARY KEY ("no_rat")
)
WITH (
OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.rating_inf
OWNER to postgres;

-- запрос и копирование информации из таблицы ratings_task в rating_inf
insert into rating_inf select count(*) over (order by "agency_id", "rat_industry", "rat_type","horizon", "scale_typer", "currency", "backed_flag") as no_rat,
"agency_id", "rat_industry", "rat_type","horizon", "scale_typer", "currency", "backed_flag"
from (select distinct "agency_id", "rat_industry", "rat_type","horizon", "scale_typer", "currency", "backed_flag"
from ratings_task)
 as one_select;
 
-- добавление в ratings_task поля 'no_rat' с кодами-ссылками на таблицу rating_inf
alter table ratings add column "no_rat" integer;

-- заполнение поля с кодами-ссылками на новую таблицу
update ratings_task
set no_rat=rating_inf.no_rat
from rating_inf
where ratings_task."agency_id"=rating_inf."agency_id"
;



-- b) Выносим из таблицы ratings_task информацию о рейтингуемом лице (ent_name, okpo, ogm, inn, finst) в отдельную таблицу comp_inf. Добавляем новое поле 'comp_id' в новой таблице, которое будет являться первичным ключом.
-- DROP TABLE IF EXISTS public.comp_inf;

-- создание таблицы comp_inf для выноса информации
CREATE TABLE public.comp_inf
(
"comp_id" integer NOT NULL,
ent_name text COLLATE pg_catalog."default" NOT NULL,
okpo integer NOT NULL,
ogm bigint,
inn bigint,
finst integer,
CONSTRAINT comp_information_pkey PRIMARY KEY ("comp_id")
)
WITH (
OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.comp_inf
OWNER to postgres;

-- запрос и копирование информации из таблицы ratings_task в comp_inf
insert into comp_inf select count(*) over (order by "ent_name", "okpo", "ogm", "inn", "finst") as comp_id,
"ent_name", "okpo", "ogm", "inn", "finst"
from (select distinct "ent_name", "okpo", "ogm", "inn", "finst"
from ratings_task)
as two_select;

-- добавление в таблицу ratings_task поля 'comp_id' с кодами-ссылками на таблицу comp_inf
alter table ratings add column "comp_id" integer;

-- заполнение поля с кодами-ссылками на новую таблицу
update ratings_task 
set comp_id=comp_inf.comp_id
from comp_inf
where ratings_task."ent_name"=comp_inf."ent_name"
;


-- 3. a)Присвоение полю 'no_rat' ограничение внешнего ключа
ALTER TABLE public.ratings_task
ADD CONSTRAINT rating_inf_fkey FOREIGN KEY (no_rat) REFERENCES public.rating_inf (no_rat);

-- удаление вынесенной информации из таблицы ratings_task
ALTER TABLE public.ratings_task
DROP COLUMN IF EXISTS "agency_id",
DROP COLUMN IF EXISTS "rat_industry", 
DROP COLUMN IF EXISTS "rat_type",
DROP COLUMN IF EXISTS "horizon", 
DROP COLUMN IF EXISTS "scale_typer", 
DROP COLUMN IF EXISTS "currency",
DROP COLUMN IF EXISTS "backed_flag";

-- b)Присвоение полю 'comp_id' ограничение внешнего ключа
ALTER TABLE public.ratings_task 
ADD CONSTRAINT comp_inf_fkey FOREIGN KEY (comp_id) REFERENCES public.comp_inf (comp_id);

-- удаление вынесенной информации из таблицы ratings_task
ALTER TABLE public.ratings_task 
DROP COLUMN IF EXISTS "ent_name", 
DROP COLUMN IF EXISTS "okpo", 
DROP COLUMN IF EXISTS "ogm",
DROP COLUMN IF EXISTS "inn", 
DROP COLUMN IF EXISTS "finst";


-- 4. Данный запрос выводит для выбранных вида рейтинга (rat_id='49') и даты (date<='2014-11-18') все актуальные рейтинги.
SELECT ent_name, max(date) as assign_date 
FROM public.ratings_task INNER JOIN (select comp_id, ent_name from comp_inf) as third_select 
ON public.ratings_task."comp_id"=third_select."comp_id"
WHERE rat_id='49' and not grade='снят' and not grade='приостановлен' and date<='2014-11-18'
GROUP BY ent_name



-- Комментарий:
-- Существенных замечаний по коду нет. Только все создаваемые Вами таблицы пусты, т.к. не прописаны процедуры копирования данных из файлов. 





