use `huxley-prod`;
alter database `huxley-prod` character set utf8;
DROP TABLE IF EXISTS `achievement`;
DROP TABLE IF EXISTS `additional_permissions`;
DROP TABLE IF EXISTS `address`;
DROP TABLE IF EXISTS `analytics_city`;
DROP TABLE IF EXISTS `analytics_city_language`;
DROP TABLE IF EXISTS `analytics_city_topic`;
DROP TABLE IF EXISTS `analytics_continent`;
DROP TABLE IF EXISTS `analytics_continent_language`;
DROP TABLE IF EXISTS `analytics_continent_topic`;
DROP TABLE IF EXISTS `analytics_country`;
DROP TABLE IF EXISTS `analytics_country_language`;
DROP TABLE IF EXISTS `analytics_country_topic`;
DROP TABLE IF EXISTS `analytics_institution`;
DROP TABLE IF EXISTS `analytics_institution_language`;
DROP TABLE IF EXISTS `analytics_institution_topic`;
DROP TABLE IF EXISTS `analytics_region`;
DROP TABLE IF EXISTS `analytics_region_language`;
DROP TABLE IF EXISTS `analytics_region_topic`;
DROP TABLE IF EXISTS `analytics_state`;
DROP TABLE IF EXISTS `analytics_state_language`;
DROP TABLE IF EXISTS `analytics_state_topic`;
DROP TABLE IF EXISTS `city`;
DROP TABLE IF EXISTS `client`;
DROP TABLE IF EXISTS `continent`;
DROP TABLE IF EXISTS `continent_country`;
DROP TABLE IF EXISTS `country`;
DROP TABLE IF EXISTS `country_city`;
DROP TABLE IF EXISTS `country_region`;
DROP TABLE IF EXISTS `country_state`;
DROP TABLE IF EXISTS `event`;
DROP TABLE IF EXISTS `event_params`;
DROP TABLE IF EXISTS `observer`;
DROP TABLE IF EXISTS `region`;
DROP TABLE IF EXISTS `region_state`;
DROP TABLE IF EXISTS `shiro_user_achievement`;
DROP TABLE IF EXISTS `state`;
DROP TABLE IF EXISTS `state_city`;

ALTER TABLE submission_comment ENGINE = InnoDB;
ALTER TABLE user_setting ENGINE=InnoDB;
ALTER TABLE user_problem ENGINE=InnoDB;
ALTER TABLE user_link ENGINE=InnoDB;
ALTER TABLE top_coder ENGINE=InnoDB;
ALTER TABLE test_case ENGINE=InnoDB;
ALTER TABLE teaching_resources ENGINE=InnoDB;
ALTER TABLE shiro_role_permissions ENGINE=InnoDB;
ALTER TABLE shiro_role ENGINE=InnoDB;
ALTER TABLE reference_solution ENGINE=InnoDB;
ALTER TABLE questionnaire_user_penalty ENGINE=InnoDB;
ALTER TABLE questionnaire_statistics ENGINE=InnoDB;
ALTER TABLE profile ENGINE=InnoDB;
ALTER TABLE problem_topics ENGINE=InnoDB;
ALTER TABLE problem_lesson ENGINE=InnoDB;
ALTER TABLE plagium ENGINE=InnoDB;
ALTER TABLE permissions ENGINE=InnoDB;
ALTER TABLE license_type ENGINE=InnoDB;
ALTER TABLE license ENGINE=InnoDB;
ALTER TABLE lesson_topic ENGINE=InnoDB;
ALTER TABLE lesson_plan_lessons ENGINE=InnoDB;
ALTER TABLE lesson_plan ENGINE=InnoDB;
ALTER TABLE lesson ENGINE=InnoDB;
ALTER TABLE institution_shiro_user ENGINE=InnoDB;
ALTER TABLE institution ENGINE=InnoDB;
ALTER TABLE huxley_system_fail ENGINE=InnoDB;
ALTER TABLE history_license ENGINE=InnoDB;
ALTER TABLE historic ENGINE=InnoDB;
ALTER TABLE fragment ENGINE=InnoDB;
ALTER TABLE forum_submission ENGINE = InnoDB;
ALTER TABLE forum_submission_submission_comment ENGINE=InnoDB;
ALTER TABLE cpdqueue ENGINE=InnoDB;
ALTER TABLE content_user ENGINE=InnoDB;
ALTER TABLE content_topics ENGINE=InnoDB;
ALTER TABLE content ENGINE=InnoDB;
ALTER TABLE cluster_permissions ENGINE=InnoDB;

-- submission
update submission set evaluation='0' where evaluation='CORRECT';
update submission set evaluation='1' where evaluation='WRONG_ANSWER';
update submission set evaluation='2' where evaluation='RUNTIME_ERROR';
update submission set evaluation='3' where evaluation='COMPILATION_ERROR';
update submission set evaluation='4' where evaluation='EMPTY_ANSWER';
update submission set evaluation='5' where evaluation='TIME_LIMIT_EXCEEDED';
update submission set evaluation='6' where evaluation='WAITING';
update submission set evaluation='6' where evaluation='EVALUATING_OLD';
update submission set evaluation='7' where evaluation='EMPTY_TEST_CASE';
update submission set evaluation='8' where evaluation='WRONG_FILE_NAME';
update submission set evaluation='9' where evaluation='PRESENTATION_ERROR';
update submission set evaluation='-1' where evaluation='HUXLEY_ERROR_110';
update submission set evaluation='-1' where evaluation='HUXLEY_ERROR_111';

alter table submission modify evaluation tinyint,
  drop column plagiarism_status,
  drop FOREIGN KEY `FK84363B4C8FB80981`,
  drop FOREIGN KEY `FK84363B4C3A487DD2`,
  drop FOREIGN KEY `FK84363B4CFEB10773`,
  drop FOREIGN KEY `FK84363B4C6598D505`,
  drop FOREIGN KEY `FK84363B4C1B247856`,
  drop FOREIGN KEY `FK84363B4CE4E9AC6F`;

alter table submission drop index `FK84363B4C8FB80981`,
  drop index `FK84363B4C3A487DD2`,
  drop index `FK84363B4CFEB10773`,
  drop index `FK84363B4C6598D505`,
  drop index `FK84363B4C1B247856`,
  drop index `FK84363B4CE4E9AC6F`,
  drop index `cache_user_name`,
  drop index  `cache_problem_name`,
  drop index `cache_user_email`,
  drop index `cache_user_username`;

alter table submission add constraint foreign key fk_sub_pro (problem_id) references problem(id),
  add constraint foreign key fk_sub_usr (user_id) references shiro_user(id),
  add constraint foreign key fk_sub_lan (language_id) references language(id);

alter table submission add index idx_submission_date (submission_date),
add index idx_submission_cache_user_name (cache_user_name),
add index idx_submission_cache_user_email (cache_user_email),
add index idx_submission_cache_user_username (cache_user_username),
add index idx_submission_cache_problem_name (cache_problem_name);

-- por default fica waiting (1)
update submission set plagium_status=1 where plagium_status is null;
alter table submission modify column plagium_status int default 1;


-- submission_comment
alter table submission_comment drop index `FK7D51C46C3A487DD2`,
  drop index `FK7D51C46C1B247856`,
  drop index `FK7D51C46C5C09B4F1`;

alter table submission_comment add constraint foreign key fk_subcom_usr (user_id) references shiro_user (id),
  add constraint foreign key fk_subcom_forum (forum_id) references forum_submission (id);

-- Problem
alter table problem modify status tinyint;

-- Questionnaire
alter table questionnaire modify description longtext ;

-- ReferenceSolution
alter table reference_solution modify status smallint ;

-- Plagium
alter table plagium drop index  `FKE28CA25FB56B28F6` ,
  drop index `FKE28CA25FB56B9D55`;

alter table plagium add constraint foreign key fk_pla_sub1 (submission1_id) references submission(id),
  add constraint foreign key fk_pla_sub2 (submission2_id) references submission(id);

-- user_problem
alter table user_problem drop index FK487C5A2B6598D505,
    drop index FK487C5A2B1B247856;

-- removendo uma entrada quebrada
delete from user_problem where id=56686;

alter table user_problem add constraint foreign key fk_usrpro_pro (problem_id) references problem(id),
    add constraint foreign key fk_usrpro_usr (user_id) references shiro_user(id);


-- problem
alter table problem drop foreign key FKED8CC29F812375BF,
    drop foreign key FKED8CC29FBAE1DAF1,
    drop foreign key FKED8CC29FDA05E06D,
    drop foreign key FKED8CC29FF0D7F776,
    drop foreign key FKED8CC29FFFBFCF2,
    drop index `code`,
    drop index `name`,
    drop index FKED8CC29FDA05E06D,
    drop index FKED8CC29FFFBFCF2,
    drop index FKED8CC29F812375BF,

    add unique index idx_pro_code (`code`),
    add unique index idx_pro_name (`name`),

    add constraint foreign key fk_pro_usr_suggest (user_suggest_id) references shiro_user(id),
    add constraint foreign key fk_pro_usr_approv (user_approved_id) references shiro_user(id),
    add constraint foreign key fk_pro_sub (fastest_submision_id) references submission(id);


-- profile



-- cpdqueue
alter table cpdqueue modify problem_id bigint;

-- plagium
ALTER TABLE `plagium` ADD `status` tinyint DEFAULT "0";