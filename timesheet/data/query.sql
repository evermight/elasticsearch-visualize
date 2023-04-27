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

SELECT task.task_id, task_name,
JSON_ARRAY(JSON_OBJECT('task_id', time.task_id, 'user_id', time.user_id, 'hours', hours)) AS hours
FROM task
INNER JOIN time ON time.task_id = task.task_id
LIMIT 3;

SELECT
1 AS story_id,
'Story' AS story_name,
'{\"task_id\":1, \"task_name\":\"Task Name\", \"hours\": [{\"user_id\":2,\"task_id\":5,\"hours\":4},{\"user_id\":1,\"task_id\":2,\"hours\":20}]}' AS tasks

https://stackoverflow.com/questions/36350058/how-to-put-json-into-a-column-data-if-sub-query-returns-more-than-1-row-in-mysql
