ALTER TABLE `codeface`.`file_instance`
  DROP FOREIGN KEY `fk_file_instance_commit1`,
  DROP COLUMN `commit_id`,
  ADD COLUMN `release_timeline_id` BIGINT NOT NULL,
  ADD CONSTRAINT `fk_file_instance_release_timeline1`
    FOREIGN KEY (`release_timeline_id`)
    REFERENCES `codeface`.`release_timeline` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE;

CREATE INDEX `fk_file_instance_release_timeline1_idx` ON `codeface`.`file_instance` (`release_timeline_id` ASC);
