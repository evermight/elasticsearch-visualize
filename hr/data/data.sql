DELIMITER $$
CREATE PROCEDURE SeedData()
BEGIN

DECLARE user_done INT DEFAULT FALSE;
DECLARE prj_id INT DEFAULT 0;
DECLARE prj_name VARCHAR(100) DEFAULT '';
DECLARE project_done INT DEFAULT FALSE;
DECLARE project_cursor CURSOR FOR SELECT project_id,project_name FROM project;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET project_done = TRUE;

---- DECLARE user_cursor CURSOR FOR SELECT * FROM user;
---- DECLARE CONTINUE HANDLER FOR NOT FOUND SET user_done = TRUE;



INSERT INTO user (`user_name`) VALUES ('Aggrim'), ('Terry'), ('Farnaz'), ('Stephanie'), ('Chee Sam'), ('Roberto'), ('Yan');
INSERT INTO project (`project_name`) VALUES ('St. Michael Hospital'), ('Jorge Chavez International Airport'),
('Gambir Train Station'),
('Panama Canal Museum'),
('Alouette Fine Dining');


CREATE TABLE IF NOT EXISTS `vocabulary` (
  `term` varchar(100) NOT NULL,
  `type` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO vocabulary (`term`, `type`) VALUES
('Website Development', 'e'),
('CRM Integration', 'e'),
('Mobile Game', 'e'),
('Single Sign-on', 's'),
('Content Migration', 's'),
('Database Optimization', 's'),
('Security Audit', 's'),
('Revision', 's'),
('Technical translation', 't'),
('Testing', 't'),
('Setup', 't'),
('Timezone adjustments', 't'),
('Unit tests', 't'),
('Integration tests', 't'),
('CSS fix', 't'),
('Bug fix', 't');

OPEN project_cursor;
REPEAT
	FETCH project_cursor INTO prj_id, prj_name;

	BEGIN
		DECLARE v_epic_name VARCHAR(100) DEFAULT '';
		DECLARE v_epic_done INT DEFAULT FALSE;
		DECLARE v_epic_cursor CURSOR FOR SELECT term FROM vocabulary WHERE type = 'e';
		DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_epic_done = TRUE;

		OPEN v_epic_cursor;
		REPEAT
			FETCH v_epic_cursor INTO v_epic_name;
			INSERT INTO epic (`project_id`, `epic_name`) values (prj_id, v_epic_name);
			SELECT MAX(epic_id) INTO @epic_id FROM epic;
			INSERT INTO story (`epic_id`, `story_name`) VALUES (@epic_id, 'test');
		UNTIL v_epic_done END REPEAT;
	END;
UNTIL project_done END REPEAT;

END $$
DELIMITER ;

CALL SeedData();
