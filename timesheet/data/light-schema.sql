CREATE TABLE IF NOT EXISTS `user` (
  `user_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_name` varchar(100) NOT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `project` (
  `project_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `project_name` varchar(100) NOT NULL,
  PRIMARY KEY (`project_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `task` (
  `task_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `task_name` varchar(100) NOT NULL,
  `project_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`task_id`),
  CONSTRAINT `task_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `project` (`project_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `time` (
  `time_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `work_done` varchar(100) NULL,
  `task_id` int(11) unsigned NOT NULL,
  `user_id` int(11) unsigned NOT NULL,
  `hours` decimal(10,2) NOT NULL,
  PRIMARY KEY (`time_id`),
  CONSTRAINT `time_ibfk_1` FOREIGN KEY (`task_id`) REFERENCES `task` (`task_id`) ON DELETE CASCADE,
  CONSTRAINT `time_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
INSERT INTO user (`user_id`, `user_name`) VALUES (1, 'user 1');
INSERT INTO project (`project_id`, `project_name`) VALUES (1, 'Project 1'), (2, 'Project 2');
INSERT INTO task (`task_id`, `task_name`, `project_id`) VALUES (1, 'Task 1', 1), (2, 'Task 2', 1), (3, 'Task 1', 2), (4, 'Task 2', 2);
INSERT INTO time (`task_id`, `user_id`, `hours`) VALUES (1, 1, 1), (1,1,2.5), (2, 1, 1), (2,1,2.5), (3, 1, 1), (3,1,2.5), (4, 1, 1), (4,1,2.5) ;

