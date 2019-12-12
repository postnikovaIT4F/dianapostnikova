-- 1 Шаг:
-- Создание новую таблицу ratings для вынеса информации о рейтингах
CREATE TABLE public.ratings
(
    ent_name text COLLATE pg_catalog."default" NOT NULL,
    okpo bigint NOT NULL,
    ogrn bigint,
    inn bigint,
    finst integer
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.ratings
    OWNER to postgres;

ALTER TABLE public.actions
    OWNER to postgres;

--Добавляем нужные строки в таблицу ratings из таблицы actions
INSERT INTO public.ratings select ent_name, okpo, ogrn, inn, finst FROM public.actions 
--2 Шаг:
--Создаем новую таблицу rating_agency для вынеса информации о рейтингуемом лице
CREATE TABLE public.ratings_agency
(
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
--Добавляем нужные строки в таблицу rating_agency из таблицы actions
INSERT INTO public.ratings_agency SELECT agency_id,rat_industry,rat_type,horizon,skale_typer,currency,backed_flag FROM public.actions 