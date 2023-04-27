SELECT project.project_id, project_name,
JSON_ARRAYAGG(
  JSON_OBJECT(
    'project_id', task.project_id, 'task_id', task.task_id, 'task_name', task.task_name,
    'hours', (
      SELECT JSON_ARRAYAGG(JSON_OBJECT('task_id', time.task_id, 'user_id', time.user_id, 'hours', time.hours))
      FROM time
      WHERE time.task_id = task.task_id
    )
  )
)
FROM project
INNER JOIN task ON task.project_id = project.project_id
GROUP BY project.project_id;
