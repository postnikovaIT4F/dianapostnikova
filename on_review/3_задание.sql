-- Выбираем все колоки из трех таблиц и соединяем их через столбцы INN и GRADE
SELECT rat_id, outlook, change, actions.date, ent_name, okpo, ogrn, actions.inn, finst, agency_id, rat_industry, rat_type, horizon, skale_typer, currency, backed_flag, scale_exp_task.grade, grade_id,credit_events.inn, credit_events.date,credit_events.event
FROM public.actions, public.scale_exp_task, public.credit_events
WHERE actions.inn = credit_events.inn AND actions.grade = scale_exp_task.grade
