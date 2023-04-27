SELECT task.task_id, task_name,
JSON_ARRAY(JSON_OBJECT('task_id', time.task_id, 'user_id', time.user_id, 'hours', hours)) AS hours
FROM task
INNER JOIN time ON time.task_id = task.task_id
LIMIT 3;

SELECT story.story_id, story_name,
JSON_ARRAY(
  JSON_OBJECT(
    'story_id', task.story_id, 'task_name', task.task_name,
    'hours', JSON_ARRAY(JSON_OBJECT('task_id', time.task_id, 'user_id', time.user_id, 'hours', hours))
  )
) AS tasks
FROM story
INNER JOIN task ON task.story_id = story.story_id
INNER JOIN time ON time.task_id = task.task_id
LIMIT 3;


https://stackoverflow.com/questions/36350058/how-to-put-json-into-a-column-data-if-sub-query-returns-more-than-1-row-in-mysql