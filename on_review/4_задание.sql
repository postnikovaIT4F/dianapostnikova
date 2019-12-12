-- Для этого необходимо использовать подзапрос
SELECT grade, ent_name, actions.date AS assign_date  
FROM actions 
WHERE actions.date IN 
(SELECT max(date)
 FROM actions 
 WHERE NOT change = 'снят' AND change = 'приостановлен' 
 GROUP BY ent_name
)
