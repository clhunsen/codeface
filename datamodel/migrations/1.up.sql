-- -----------------------------------------------------
-- Table `codeface`.`file_instance`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `codeface`.`file_instance` (
  `id` BIGINT NOT NULL,
  `path` VARCHAR(1000) NOT NULL,
  `lines_of_code` INT NOT NULL,
  `commit_id` BIGINT NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_file_instance_commit1`
    FOREIGN KEY (`commit_id`)
    REFERENCES `codeface`.`commit` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

CREATE INDEX `fk_file_instance_commit1_idx` ON `codeface`.`file_instance` (`commit_id` ASC);


-- -----------------------------------------------------
-- Table `codeface`.`spl_statistics_project`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `codeface`.`spl_statistics_project` (
  `project_id` BIGINT NOT NULL,
  `variable` VARCHAR(45) NOT NULL,
  `value` FLOAT NOT NULL,
  PRIMARY KEY (`project_id`, `variable`),
  CONSTRAINT `fk_spl_statistics_project_project1`
    FOREIGN KEY (`project_id`)
    REFERENCES `codeface`.`project` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

CREATE INDEX `fk_spl_statistics_project_project1_idx` ON `codeface`.`spl_statistics_project` (`project_id` ASC);


-- -----------------------------------------------------
-- Table `codeface`.`spl_statistics_file`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `codeface`.`spl_statistics_file` (
  `file_instance_id` BIGINT NOT NULL,
  `variable` VARCHAR(45) NOT NULL,
  `value` FLOAT NOT NULL,
  PRIMARY KEY (`variable`, `file_instance_id`),
  CONSTRAINT `fk_spl_statistics_file_file_instance1`
    FOREIGN KEY (`file_instance_id`)
    REFERENCES `codeface`.`file_instance` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

CREATE INDEX `fk_spl_statistics_file_file_instance1_idx` ON `codeface`.`spl_statistics_file` (`file_instance_id` ASC);


-- -----------------------------------------------------
-- Table `codeface`.`spl_statistics_release`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `codeface`.`spl_statistics_release` (
  `release_timeline_id` BIGINT NOT NULL,
  `variable` VARCHAR(45) NOT NULL,
  `value` FLOAT NOT NULL,
  PRIMARY KEY (`variable`, `release_timeline_id`),
  CONSTRAINT `fk_spl_statistics_release_release_timeline1`
    FOREIGN KEY (`release_timeline_id`)
    REFERENCES `codeface`.`release_timeline` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

