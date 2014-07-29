ALTER TABLE `codeface`.`file_instance`
  ADD COLUMN `commit_id` BIGINT NOT NULL,
  DROP FOREIGN KEY `fk_file_instance_release_timeline1`,
  DROP COLUMN `release_timeline_id`,
  ADD CONSTRAINT `fk_file_instance_commit1`
    FOREIGN KEY (`commit_id`)
    REFERENCES `codeface`.`commit` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE;

CREATE INDEX `fk_file_instance_commit1_idx` ON `codeface`.`file_instance` (`commit_id` ASC);

