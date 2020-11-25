-- MySQL dump 10.13  Distrib 5.1.72, for debian-linux-gnu (i486)
--
-- Host: localhost    Database: huxley-prod
-- ------------------------------------------------------
-- Server version	5.1.72-0ubuntu0.10.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `huxley-prod`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `huxley-prod` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `huxley-prod`;

--
-- Table structure for table `achievement`
--

DROP TABLE IF EXISTS `achievement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `achievement` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `description` longtext NOT NULL,
  `image` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `script` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `additional_permissions`
--

DROP TABLE IF EXISTS `additional_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `additional_permissions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `action` varchar(255) NOT NULL,
  `permission` int(11) NOT NULL,
  `controller` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `address`
--

DROP TABLE IF EXISTS `address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `address` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `city_id` bigint(20) NOT NULL,
  `country_id` bigint(20) NOT NULL,
  `number` varchar(255) NOT NULL,
  `state_id` bigint(20) NOT NULL,
  `street` varchar(255) NOT NULL,
  `zip_code` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKBB979BF412642685` (`state_id`),
  KEY `FKBB979BF485109DA5` (`country_id`),
  KEY `FKBB979BF4C9BFB20F` (`city_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `analytics_city`
--

DROP TABLE IF EXISTS `analytics_city`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `analytics_city` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `city_id` bigint(20) NOT NULL,
  `date` datetime NOT NULL,
  `problems_correct` bigint(20) NOT NULL,
  `problems_tried` bigint(20) NOT NULL,
  `submission_correct_count` bigint(20) NOT NULL,
  `submission_count` bigint(20) NOT NULL,
  `top15coder_score` bigint(20) NOT NULL,
  `top_coder_score` bigint(20) NOT NULL,
  `total_users` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK4BE4FA84C9BFB20F` (`city_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `analytics_city_language`
--

DROP TABLE IF EXISTS `analytics_city_language`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `analytics_city_language` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `city_id` bigint(20) NOT NULL,
  `date` datetime NOT NULL,
  `language_id` bigint(20) NOT NULL,
  `total` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK282A5EB3E4E9AC6F` (`language_id`),
  KEY `FK282A5EB3C9BFB20F` (`city_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `analytics_city_topic`
--

DROP TABLE IF EXISTS `analytics_city_topic`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `analytics_city_topic` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `city_id` bigint(20) NOT NULL,
  `date` datetime NOT NULL,
  `hits` bigint(20) NOT NULL,
  `topic_id` bigint(20) NOT NULL,
  `tries` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK962B37B48ACEF9C5` (`topic_id`),
  KEY `FK962B37B4C9BFB20F` (`city_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `analytics_continent`
--

DROP TABLE IF EXISTS `analytics_continent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `analytics_continent` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `continent_id` bigint(20) NOT NULL,
  `date` datetime NOT NULL,
  `problems_correct` bigint(20) NOT NULL,
  `problems_tried` bigint(20) NOT NULL,
  `submission_correct_count` bigint(20) NOT NULL,
  `submission_count` bigint(20) NOT NULL,
  `top15coder_score` bigint(20) NOT NULL,
  `top_coder_score` bigint(20) NOT NULL,
  `total_users` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK2EBB943B7ABE4225` (`continent_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `analytics_continent_language`
--

DROP TABLE IF EXISTS `analytics_continent_language`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `analytics_continent_language` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `continent_id` bigint(20) NOT NULL,
  `date` datetime NOT NULL,
  `language_id` bigint(20) NOT NULL,
  `total` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK9B2FC2DCE4E9AC6F` (`language_id`),
  KEY `FK9B2FC2DC7ABE4225` (`continent_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `analytics_continent_topic`
--

DROP TABLE IF EXISTS `analytics_continent_topic`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `analytics_continent_topic` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `continent_id` bigint(20) NOT NULL,
  `date` datetime NOT NULL,
  `hits` bigint(20) NOT NULL,
  `topic_id` bigint(20) NOT NULL,
  `tries` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKEA7F6C2B8ACEF9C5` (`topic_id`),
  KEY `FKEA7F6C2B7ABE4225` (`continent_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `analytics_country`
--

DROP TABLE IF EXISTS `analytics_country`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `analytics_country` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `country_id` bigint(20) NOT NULL,
  `date` datetime NOT NULL,
  `problems_correct` bigint(20) NOT NULL,
  `problems_tried` bigint(20) NOT NULL,
  `submission_correct_count` bigint(20) NOT NULL,
  `submission_count` bigint(20) NOT NULL,
  `top15coder_score` bigint(20) NOT NULL,
  `top_coder_score` bigint(20) NOT NULL,
  `total_users` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKF5C4B3DD85109DA5` (`country_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `analytics_country_language`
--

DROP TABLE IF EXISTS `analytics_country_language`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `analytics_country_language` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `country_id` bigint(20) NOT NULL,
  `date` datetime NOT NULL,
  `language_id` bigint(20) NOT NULL,
  `total` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK2973197A85109DA5` (`country_id`),
  KEY `FK2973197AE4E9AC6F` (`language_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `analytics_country_topic`
--

DROP TABLE IF EXISTS `analytics_country_topic`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `analytics_country_topic` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `country_id` bigint(20) NOT NULL,
  `date` datetime NOT NULL,
  `hits` bigint(20) NOT NULL,
  `topic_id` bigint(20) NOT NULL,
  `tries` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKE1A6CA4D85109DA5` (`country_id`),
  KEY `FKE1A6CA4D8ACEF9C5` (`topic_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `analytics_institution`
--

DROP TABLE IF EXISTS `analytics_institution`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `analytics_institution` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `date` datetime NOT NULL,
  `institution_id` bigint(20) NOT NULL,
  `problems_correct` bigint(20) NOT NULL,
  `problems_tried` bigint(20) NOT NULL,
  `submission_correct_count` bigint(20) NOT NULL,
  `submission_count` bigint(20) NOT NULL,
  `top15coder_score` bigint(20) NOT NULL,
  `top_coder_score` bigint(20) NOT NULL,
  `top_problems_correct` bigint(20) NOT NULL,
  `top_problems_tried` bigint(20) NOT NULL,
  `top_submission_correct_count` bigint(20) NOT NULL,
  `top_submission_count` bigint(20) NOT NULL,
  `total_users` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKE7B1867FE41984E5` (`institution_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `analytics_institution_language`
--

DROP TABLE IF EXISTS `analytics_institution_language`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `analytics_institution_language` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `date` datetime NOT NULL,
  `institution_id` bigint(20) NOT NULL,
  `language_id` bigint(20) NOT NULL,
  `total` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK764C1D18E41984E5` (`institution_id`),
  KEY `FK764C1D18E4E9AC6F` (`language_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `analytics_institution_topic`
--

DROP TABLE IF EXISTS `analytics_institution_topic`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `analytics_institution_topic` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `date` datetime NOT NULL,
  `hits` bigint(20) NOT NULL,
  `institution_id` bigint(20) NOT NULL,
  `top_hits` bigint(20) NOT NULL,
  `top_tries` bigint(20) NOT NULL,
  `topic_id` bigint(20) NOT NULL,
  `tries` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK8DF9B6FE41984E5` (`institution_id`),
  KEY `FK8DF9B6F8ACEF9C5` (`topic_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `analytics_region`
--

DROP TABLE IF EXISTS `analytics_region`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `analytics_region` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `date` datetime NOT NULL,
  `problems_correct` bigint(20) NOT NULL,
  `problems_tried` bigint(20) NOT NULL,
  `region_id` bigint(20) NOT NULL,
  `submission_correct_count` bigint(20) NOT NULL,
  `submission_count` bigint(20) NOT NULL,
  `top15coder_score` bigint(20) NOT NULL,
  `top_coder_score` bigint(20) NOT NULL,
  `total_users` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKFFEAA5CDB858A02F` (`region_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `analytics_region_language`
--

DROP TABLE IF EXISTS `analytics_region_language`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `analytics_region_language` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `date` datetime NOT NULL,
  `language_id` bigint(20) NOT NULL,
  `region_id` bigint(20) NOT NULL,
  `total` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKE146558AB858A02F` (`region_id`),
  KEY `FKE146558AE4E9AC6F` (`language_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `analytics_region_topic`
--

DROP TABLE IF EXISTS `analytics_region_topic`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `analytics_region_topic` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `date` datetime NOT NULL,
  `hits` bigint(20) NOT NULL,
  `region_id` bigint(20) NOT NULL,
  `topic_id` bigint(20) NOT NULL,
  `tries` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK51AB883D8ACEF9C5` (`topic_id`),
  KEY `FK51AB883DB858A02F` (`region_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `analytics_state`
--

DROP TABLE IF EXISTS `analytics_state`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `analytics_state` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `date` datetime NOT NULL,
  `problems_correct` bigint(20) NOT NULL,
  `problems_tried` bigint(20) NOT NULL,
  `state_id` bigint(20) NOT NULL,
  `submission_correct_count` bigint(20) NOT NULL,
  `submission_count` bigint(20) NOT NULL,
  `top15coder_score` bigint(20) NOT NULL,
  `top_coder_score` bigint(20) NOT NULL,
  `total_users` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK31A0869812642685` (`state_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `analytics_state_language`
--

DROP TABLE IF EXISTS `analytics_state_language`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `analytics_state_language` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `date` datetime NOT NULL,
  `language_id` bigint(20) NOT NULL,
  `state_id` bigint(20) NOT NULL,
  `total` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKC469291F12642685` (`state_id`),
  KEY `FKC469291FE4E9AC6F` (`language_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `analytics_state_topic`
--

DROP TABLE IF EXISTS `analytics_state_topic`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `analytics_state_topic` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `date` datetime NOT NULL,
  `hits` bigint(20) NOT NULL,
  `state_id` bigint(20) NOT NULL,
  `topic_id` bigint(20) NOT NULL,
  `tries` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKE0A64C812642685` (`state_id`),
  KEY `FKE0A64C88ACEF9C5` (`topic_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `city`
--

DROP TABLE IF EXISTS `city`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `city` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `cod` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `client`
--

DROP TABLE IF EXISTS `client`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `client` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `city` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `state` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cluster`
--

DROP TABLE IF EXISTS `cluster`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cluster` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `name` varchar(255) NOT NULL,
  `institution_id` bigint(20) DEFAULT NULL,
  `hash` varchar(255) DEFAULT NULL,
  `date_created` datetime DEFAULT NULL,
  `last_updated` datetime DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `access_key` varchar(255) DEFAULT NULL,
  `end_date` datetime DEFAULT NULL,
  `start_date` datetime DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `hash` (`hash`),
  UNIQUE KEY `url` (`url`)
) ENGINE=InnoDB AUTO_INCREMENT=113 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cluster_cluster`
--

DROP TABLE IF EXISTS `cluster_cluster`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cluster_cluster` (
  `cluster_groups_id` bigint(20) DEFAULT NULL,
  `cluster_id` bigint(20) DEFAULT NULL,
  KEY `FK1FB930B5F50B07A1` (`cluster_id`),
  KEY `FK1FB930B583135582` (`cluster_groups_id`),
  KEY `FK1FB930B5CAEBD325` (`cluster_id`),
  KEY `FK1FB930B558F42106` (`cluster_groups_id`),
  CONSTRAINT `FK1FB930B558F42106` FOREIGN KEY (`cluster_groups_id`) REFERENCES `cluster` (`id`),
  CONSTRAINT `FK1FB930B583135582` FOREIGN KEY (`cluster_groups_id`) REFERENCES `cluster` (`id`),
  CONSTRAINT `FK1FB930B5CAEBD325` FOREIGN KEY (`cluster_id`) REFERENCES `cluster` (`id`),
  CONSTRAINT `FK1FB930B5F50B07A1` FOREIGN KEY (`cluster_id`) REFERENCES `cluster` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cluster_permissions`
--

DROP TABLE IF EXISTS `cluster_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cluster_permissions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `permission` int(11) NOT NULL,
  `group_id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `status_user` smallint(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKD15D3DBF3A487DD2` (`user_id`),
  KEY `FKD15D3DBF4E718FC` (`group_id`),
  KEY `FKD15D3DBF1B247856` (`user_id`),
  KEY `FKD15D3DBFDAC7E480` (`group_id`)
) ENGINE=MyISAM AUTO_INCREMENT=2594 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cluster_users`
--

DROP TABLE IF EXISTS `cluster_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cluster_users` (
  `shiro_user_id` bigint(20) NOT NULL,
  `cluster_id` bigint(20) NOT NULL,
  PRIMARY KEY (`cluster_id`,`shiro_user_id`),
  KEY `FKA7431F83F50B07A1` (`cluster_id`),
  KEY `FKA7431F83300D1184` (`shiro_user_id`),
  KEY `FKA7431F83CAEBD325` (`cluster_id`),
  KEY `FKA7431F8310E90C08` (`shiro_user_id`),
  CONSTRAINT `FKA7431F8310E90C08` FOREIGN KEY (`shiro_user_id`) REFERENCES `shiro_user` (`id`),
  CONSTRAINT `FKA7431F83300D1184` FOREIGN KEY (`shiro_user_id`) REFERENCES `shiro_user` (`id`),
  CONSTRAINT `FKA7431F83CAEBD325` FOREIGN KEY (`cluster_id`) REFERENCES `cluster` (`id`),
  CONSTRAINT `FKA7431F83F50B07A1` FOREIGN KEY (`cluster_id`) REFERENCES `cluster` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `common_errors`
--

DROP TABLE IF EXISTS `common_errors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `common_errors` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `comment` longtext NOT NULL,
  `error_msg` longtext NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `content`
--

DROP TABLE IF EXISTS `content`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `content` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `date_created` datetime NOT NULL,
  `description` longtext NOT NULL,
  `embedded` varchar(255) NOT NULL,
  `last_updated` datetime NOT NULL,
  `owner_id` bigint(20) NOT NULL,
  `title` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK38B73479870B286E` (`owner_id`)
) ENGINE=MyISAM AUTO_INCREMENT=48 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `content_topics`
--

DROP TABLE IF EXISTS `content_topics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `content_topics` (
  `topic_id` bigint(20) NOT NULL,
  `content_id` bigint(20) NOT NULL,
  PRIMARY KEY (`content_id`,`topic_id`),
  KEY `FK1FA757AAD11A4EC5` (`content_id`),
  KEY `FK1FA757AA8ACEF9C5` (`topic_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `content_user`
--

DROP TABLE IF EXISTS `content_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `content_user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `content_id` bigint(20) NOT NULL,
  `date_created` datetime NOT NULL,
  `last_updated` datetime NOT NULL,
  `status` varchar(255) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK319553D1D11A4EC5` (`content_id`),
  KEY `FK319553D11B247856` (`user_id`)
) ENGINE=MyISAM AUTO_INCREMENT=1159 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `continent`
--

DROP TABLE IF EXISTS `continent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `continent` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `continent_country`
--

DROP TABLE IF EXISTS `continent_country`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `continent_country` (
  `continent_country_id` bigint(20) DEFAULT NULL,
  `country_id` bigint(20) DEFAULT NULL,
  KEY `FKC13C380BC129846E` (`continent_country_id`),
  KEY `FKC13C380B85109DA5` (`country_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `country`
--

DROP TABLE IF EXISTS `country`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `country` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `coda2` varchar(255) NOT NULL,
  `coda3` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `coda2` (`coda2`),
  UNIQUE KEY `coda3` (`coda3`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `country_city`
--

DROP TABLE IF EXISTS `country_city`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `country_city` (
  `country_city_id` bigint(20) DEFAULT NULL,
  `city_id` bigint(20) DEFAULT NULL,
  KEY `FK58474874D0FF9807` (`country_city_id`),
  KEY `FK58474874C9BFB20F` (`city_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `country_region`
--

DROP TABLE IF EXISTS `country_region`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `country_region` (
  `country_region_id` bigint(20) DEFAULT NULL,
  `region_id` bigint(20) DEFAULT NULL,
  KEY `FK7CF137BD6C7C781E` (`country_region_id`),
  KEY `FK7CF137BDB858A02F` (`region_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `country_state`
--

DROP TABLE IF EXISTS `country_state`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `country_state` (
  `country_state_id` bigint(20) DEFAULT NULL,
  `state_id` bigint(20) DEFAULT NULL,
  KEY `FKB187F6A812642685` (`state_id`),
  KEY `FKB187F6A83EEFCD53` (`country_state_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `course_plan`
--

DROP TABLE IF EXISTS `course_plan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course_plan` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `date_created` datetime NOT NULL,
  `description` longtext NOT NULL,
  `last_updated` datetime NOT NULL,
  `owner_id` bigint(20) NOT NULL,
  `title` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `course_plan_questionnaire`
--

DROP TABLE IF EXISTS `course_plan_questionnaire`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course_plan_questionnaire` (
  `course_plan_questionnaire_id` bigint(20) DEFAULT NULL,
  `questionnaire_id` bigint(20) DEFAULT NULL,
  KEY `FK421531B12925F0C2` (`course_plan_questionnaire_id`),
  KEY `FK421531B1858C1A45` (`questionnaire_id`),
  CONSTRAINT `FK421531B12925F0C2` FOREIGN KEY (`course_plan_questionnaire_id`) REFERENCES `course_plan` (`id`),
  CONSTRAINT `FK421531B1858C1A45` FOREIGN KEY (`questionnaire_id`) REFERENCES `questionnaire` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cpdqueue`
--

DROP TABLE IF EXISTS `cpdqueue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cpdqueue` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `language` varchar(255) NOT NULL,
  `problem_id` int(11) NOT NULL,
  `institution_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=42033 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `email`
--

DROP TABLE IF EXISTS `email`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `email` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `port` varchar(255) NOT NULL,
  `smtp` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `email_to_send`
--

DROP TABLE IF EXISTS `email_to_send`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `email_to_send` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `message` mediumtext NOT NULL,
  `status` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `subject` varchar(255) DEFAULT NULL,
  `date_created` datetime NOT NULL,
  `last_updated` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21758 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `event`
--

DROP TABLE IF EXISTS `event`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `event` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `creation_time` datetime NOT NULL,
  `type` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2783792 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `event_params`
--

DROP TABLE IF EXISTS `event_params`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `event_params` (
  `params` bigint(20) DEFAULT NULL,
  `params_idx` varchar(255) DEFAULT NULL,
  `params_elt` varchar(255) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `forum_submission`
--

DROP TABLE IF EXISTS `forum_submission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `forum_submission` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `status` varchar(255) NOT NULL,
  `submission_id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `changed` datetime DEFAULT NULL,
  `date` datetime DEFAULT NULL,
  `message` longtext,
  `title` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK789F352A3A487DD2` (`user_id`),
  KEY `FK789F352A60E048B3` (`submission_id`),
  KEY `FK789F352A1B247856` (`user_id`),
  KEY `FK789F352A9B839EAF` (`submission_id`)
) ENGINE=MyISAM AUTO_INCREMENT=633 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `forum_submission_submission_comment`
--

DROP TABLE IF EXISTS `forum_submission_submission_comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `forum_submission_submission_comment` (
  `forum_submission_comment_id` bigint(20) DEFAULT NULL,
  `submission_comment_id` bigint(20) DEFAULT NULL,
  KEY `FKFE7BE1A1D7544EA8` (`submission_comment_id`),
  KEY `FKFE7BE1A150FBFDA4` (`forum_submission_comment_id`),
  KEY `FKFE7BE1A1F4DF852C` (`submission_comment_id`),
  KEY `FKFE7BE1A1FE2B0528` (`forum_submission_comment_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `fragment`
--

DROP TABLE IF EXISTS `fragment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fragment` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `number_of_lines` int(11) NOT NULL,
  `percentage` double NOT NULL,
  `plagium_id` bigint(20) NOT NULL,
  `start_line1` int(11) NOT NULL,
  `start_line2` int(11) NOT NULL,
  `fragments_idx` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK9DA2E25036EFBD05` (`plagium_id`)
) ENGINE=MyISAM AUTO_INCREMENT=910173 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `historic`
--

DROP TABLE IF EXISTS `historic`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `historic` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `action` varchar(255) NOT NULL,
  `controller` varchar(255) NOT NULL,
  `date` datetime NOT NULL,
  `user_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKB0BCAC5F1B247856` (`user_id`)
) ENGINE=MyISAM AUTO_INCREMENT=173395 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `history_license`
--

DROP TABLE IF EXISTS `history_license`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `history_license` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `date_created` datetime NOT NULL,
  `end_date` datetime DEFAULT NULL,
  `institution_id` bigint(20) DEFAULT NULL,
  `last_updated` datetime NOT NULL,
  `license_id` bigint(20) DEFAULT NULL,
  `start_date` datetime DEFAULT NULL,
  `user_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKC92C3B961B247856` (`user_id`),
  KEY `FKC92C3B96E41984E5` (`institution_id`),
  KEY `FKC92C3B963EBED9C5` (`license_id`)
) ENGINE=MyISAM AUTO_INCREMENT=2234 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `huxley_system_fail`
--

DROP TABLE IF EXISTS `huxley_system_fail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `huxley_system_fail` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `logged_user_id` bigint(20) DEFAULT NULL,
  `message` longtext,
  `stack_trace` longtext NOT NULL,
  `time_of_error` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKB5AB4724A8477299` (`logged_user_id`)
) ENGINE=MyISAM AUTO_INCREMENT=22282 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `institution`
--

DROP TABLE IF EXISTS `institution`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `institution` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `name` varchar(255) NOT NULL,
  `address_id` bigint(20) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `photo` varchar(255) NOT NULL,
  `status` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK3529A5B89424D8E5` (`address_id`)
) ENGINE=MyISAM AUTO_INCREMENT=45 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `institution_shiro_user`
--

DROP TABLE IF EXISTS `institution_shiro_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `institution_shiro_user` (
  `institution_users_id` bigint(20) DEFAULT NULL,
  `shiro_user_id` bigint(20) DEFAULT NULL,
  KEY `FK54E2B24099FF0BB8` (`institution_users_id`),
  KEY `FK54E2B240300D1184` (`shiro_user_id`),
  KEY `FK54E2B240B3C6753C` (`institution_users_id`),
  KEY `FK54E2B24010E90C08` (`shiro_user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `language`
--

DROP TABLE IF EXISTS `language`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `language` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `exec_params` varchar(255) NOT NULL,
  `plag_config` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `compile_params` varchar(255) NOT NULL,
  `compiler` varchar(255) NOT NULL,
  `script` varchar(255) DEFAULT NULL,
  `extension` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lesson`
--

DROP TABLE IF EXISTS `lesson`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lesson` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `date_created` datetime NOT NULL,
  `description` longtext NOT NULL,
  `last_updated` datetime NOT NULL,
  `owner_id` bigint(20) NOT NULL,
  `title` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKBE10AD38870B286E` (`owner_id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lesson_plan`
--

DROP TABLE IF EXISTS `lesson_plan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lesson_plan` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `date_created` datetime NOT NULL,
  `description` longtext NOT NULL,
  `last_updated` datetime NOT NULL,
  `owner_id` bigint(20) NOT NULL,
  `title` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK275219D0870B286E` (`owner_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lesson_plan_lessons`
--

DROP TABLE IF EXISTS `lesson_plan_lessons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lesson_plan_lessons` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `date_created` datetime NOT NULL,
  `last_updated` datetime NOT NULL,
  `lesson_id` bigint(20) NOT NULL,
  `lesson_plan_id` bigint(20) NOT NULL,
  `position` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK6C57EACCFEA616E0` (`lesson_plan_id`),
  KEY `FK6C57EACCC061C9AF` (`lesson_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lesson_topic`
--

DROP TABLE IF EXISTS `lesson_topic`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lesson_topic` (
  `lesson_topics_id` bigint(20) DEFAULT NULL,
  `topic_id` bigint(20) DEFAULT NULL,
  KEY `FKC32B1368F10B87FC` (`lesson_topics_id`),
  KEY `FKC32B13688ACEF9C5` (`topic_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `license`
--

DROP TABLE IF EXISTS `license`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `license` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `active` bit(1) NOT NULL,
  `date_created` datetime NOT NULL,
  `end_date` datetime NOT NULL,
  `hash` varchar(255) NOT NULL,
  `indefinite_validity` bit(1) NOT NULL,
  `institution_id` bigint(20) DEFAULT NULL,
  `last_updated` datetime NOT NULL,
  `start_date` datetime NOT NULL,
  `type_id` bigint(20) NOT NULL,
  `user_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `hash` (`hash`),
  KEY `FK9F084411B247856` (`user_id`),
  KEY `FK9F08441E41984E5` (`institution_id`),
  KEY `FK9F08441BC53ED86` (`type_id`)
) ENGINE=MyISAM AUTO_INCREMENT=2234 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `license_pack`
--

DROP TABLE IF EXISTS `license_pack`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `license_pack` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `date_created` datetime NOT NULL,
  `end_date` datetime NOT NULL,
  `institution_id` bigint(20) NOT NULL,
  `last_updated` datetime NOT NULL,
  `start_date` datetime NOT NULL,
  `total` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `license_type`
--

DROP TABLE IF EXISTS `license_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `license_type` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `date_created` datetime NOT NULL,
  `description` varchar(255) NOT NULL,
  `descriptor` varchar(255) NOT NULL,
  `kind` varchar(17) NOT NULL,
  `last_updated` datetime NOT NULL,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `observer`
--

DROP TABLE IF EXISTS `observer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `observer` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `last_seen` datetime NOT NULL,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `payment`
--

DROP TABLE IF EXISTS `payment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `payment` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `amount` double DEFAULT NULL,
  `date_created` datetime NOT NULL,
  `frequency` int(11) DEFAULT NULL,
  `last_updated` datetime NOT NULL,
  `payment_coupon_id` bigint(20) DEFAULT NULL,
  `profile_id` bigint(20) NOT NULL,
  `quantity` int(11) DEFAULT NULL,
  `response` longtext,
  `status` varchar(255) DEFAULT NULL,
  `total` double DEFAULT NULL,
  `url` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKD11C3206C2174612` (`payment_coupon_id`),
  CONSTRAINT `FKD11C3206C2174612` FOREIGN KEY (`payment_coupon_id`) REFERENCES `payment_coupon` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `payment_coupon`
--

DROP TABLE IF EXISTS `payment_coupon`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `payment_coupon` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `date_created` datetime NOT NULL,
  `discount` double NOT NULL,
  `hash` varchar(255) NOT NULL,
  `last_updated` datetime NOT NULL,
  `status` varchar(8) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `hash` (`hash`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `permissions`
--

DROP TABLE IF EXISTS `permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `permissions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `action` varchar(255) NOT NULL,
  `role` varchar(255) NOT NULL,
  `controller` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=595 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `plagium`
--

DROP TABLE IF EXISTS `plagium`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `plagium` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `percentage` double NOT NULL,
  `submission1_id` bigint(20) NOT NULL,
  `submission2_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKE28CA25FB56B28F6` (`submission1_id`),
  KEY `FKE28CA25FB56B9D55` (`submission2_id`)
) ENGINE=MyISAM AUTO_INCREMENT=28094627 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `plagium_fragment`
--

DROP TABLE IF EXISTS `plagium_fragment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `plagium_fragment` (
  `plagium_fragments_id` bigint(20) DEFAULT NULL,
  `fragment_id` bigint(20) DEFAULT NULL,
  KEY `FKFED2AC3090970473` (`fragment_id`),
  KEY `FKFED2AC3055C0FF1D` (`plagium_fragments_id`),
  CONSTRAINT `FKFED2AC3055C0FF1D` FOREIGN KEY (`plagium_fragments_id`) REFERENCES `plagium` (`id`),
  CONSTRAINT `FKFED2AC3090970473` FOREIGN KEY (`fragment_id`) REFERENCES `fragment` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `problem`
--

DROP TABLE IF EXISTS `problem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `problem` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `time_limit` int(11) NOT NULL,
  `evaluation_detail` int(11) NOT NULL,
  `code` int(11) NOT NULL,
  `level` int(11) NOT NULL,
  `nd` double NOT NULL,
  `description` longtext NOT NULL,
  `name` varchar(255) NOT NULL,
  `status` varchar(255) DEFAULT NULL,
  `user_approved_id` bigint(20) DEFAULT NULL,
  `user_suggest_id` bigint(20) DEFAULT NULL,
  `fastest_submision_id` bigint(20) DEFAULT NULL,
  `input_format` longtext,
  `output_format` longtext,
  `date_created` datetime DEFAULT NULL,
  `last_updated` datetime DEFAULT NULL,
  `source` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  UNIQUE KEY `name` (`name`),
  KEY `FKED8CC29FDA05E06D` (`user_suggest_id`),
  KEY `FKED8CC29FFFBFCF2` (`user_approved_id`),
  KEY `FKED8CC29F812375BF` (`fastest_submision_id`),
  CONSTRAINT `FKED8CC29F812375BF` FOREIGN KEY (`fastest_submision_id`) REFERENCES `submission` (`id`),
  CONSTRAINT `FKED8CC29FBAE1DAF1` FOREIGN KEY (`user_suggest_id`) REFERENCES `shiro_user` (`id`),
  CONSTRAINT `FKED8CC29FDA05E06D` FOREIGN KEY (`user_suggest_id`) REFERENCES `shiro_user` (`id`),
  CONSTRAINT `FKED8CC29FF0D7F776` FOREIGN KEY (`user_approved_id`) REFERENCES `shiro_user` (`id`),
  CONSTRAINT `FKED8CC29FFFBFCF2` FOREIGN KEY (`user_approved_id`) REFERENCES `shiro_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=382 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `problem_lesson`
--

DROP TABLE IF EXISTS `problem_lesson`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `problem_lesson` (
  `problem_lessons_id` bigint(20) DEFAULT NULL,
  `lesson_id` bigint(20) DEFAULT NULL,
  KEY `FK855086D83FE23189` (`problem_lessons_id`),
  KEY `FK855086D8C061C9AF` (`lesson_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `problem_topics`
--

DROP TABLE IF EXISTS `problem_topics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `problem_topics` (
  `topic_id` bigint(20) NOT NULL,
  `problem_id` bigint(20) NOT NULL,
  KEY `FK9382B2C46598D505` (`problem_id`),
  KEY `FK9382B2C48ACEF9C5` (`topic_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `profile`
--

DROP TABLE IF EXISTS `profile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `profile` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `hash` varchar(255) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `photo` varchar(255) NOT NULL,
  `problems_correct` int(11) NOT NULL,
  `problems_tryed` int(11) NOT NULL,
  `small_photo` varchar(255) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `date_created` datetime DEFAULT NULL,
  `last_updated` datetime DEFAULT NULL,
  `institution_id` bigint(20) DEFAULT NULL,
  `submission_correct_count` int(11) NOT NULL,
  `submission_count` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`),
  UNIQUE KEY `hash` (`hash`),
  KEY `FKED8E89A91B247856` (`user_id`),
  KEY `FKED8E89A9E41984E5` (`institution_id`)
) ENGINE=MyISAM AUTO_INCREMENT=2033 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `questionnaire`
--

DROP TABLE IF EXISTS `questionnaire`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `questionnaire` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `start_date` datetime NOT NULL,
  `evaluation_detail` int(11) NOT NULL,
  `score` double NOT NULL,
  `end_date` datetime NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=360 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `questionnaire_cluster`
--

DROP TABLE IF EXISTS `questionnaire_cluster`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `questionnaire_cluster` (
  `questionnaire_groups_id` bigint(20) DEFAULT NULL,
  `cluster_id` bigint(20) DEFAULT NULL,
  KEY `FK7421735EF50B07A1` (`cluster_id`),
  KEY `FK7421735EBC829454` (`questionnaire_groups_id`),
  KEY `FK7421735ECAEBD325` (`cluster_id`),
  KEY `FK7421735E8215ACD8` (`questionnaire_groups_id`),
  CONSTRAINT `FK7421735E8215ACD8` FOREIGN KEY (`questionnaire_groups_id`) REFERENCES `questionnaire` (`id`),
  CONSTRAINT `FK7421735EBC829454` FOREIGN KEY (`questionnaire_groups_id`) REFERENCES `questionnaire` (`id`),
  CONSTRAINT `FK7421735ECAEBD325` FOREIGN KEY (`cluster_id`) REFERENCES `cluster` (`id`),
  CONSTRAINT `FK7421735EF50B07A1` FOREIGN KEY (`cluster_id`) REFERENCES `cluster` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `questionnaire_problem`
--

DROP TABLE IF EXISTS `questionnaire_problem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `questionnaire_problem` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `questionnaire_id` bigint(20) NOT NULL,
  `score` double NOT NULL,
  `problem_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK2DB324038FB80981` (`problem_id`),
  KEY `FK2DB32403BFF901C1` (`questionnaire_id`),
  KEY `FK2DB324036598D505` (`problem_id`),
  KEY `FK2DB32403858C1A45` (`questionnaire_id`),
  CONSTRAINT `FK2DB324036598D505` FOREIGN KEY (`problem_id`) REFERENCES `problem` (`id`),
  CONSTRAINT `FK2DB32403858C1A45` FOREIGN KEY (`questionnaire_id`) REFERENCES `questionnaire` (`id`),
  CONSTRAINT `FK2DB324038FB80981` FOREIGN KEY (`problem_id`) REFERENCES `problem` (`id`),
  CONSTRAINT `FK2DB32403BFF901C1` FOREIGN KEY (`questionnaire_id`) REFERENCES `questionnaire` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3853 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `questionnaire_shiro_user`
--

DROP TABLE IF EXISTS `questionnaire_shiro_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `questionnaire_shiro_user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `questionnaire_id` bigint(20) NOT NULL,
  `score` double NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `comment` longtext,
  `status` int(11) DEFAULT NULL,
  `plagium_status` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK17E7B9753A487DD2` (`user_id`),
  KEY `FK17E7B975BFF901C1` (`questionnaire_id`),
  KEY `FK17E7B9751B247856` (`user_id`),
  KEY `FK17E7B975858C1A45` (`questionnaire_id`),
  CONSTRAINT `FK17E7B9751B247856` FOREIGN KEY (`user_id`) REFERENCES `shiro_user` (`id`),
  CONSTRAINT `FK17E7B9753A487DD2` FOREIGN KEY (`user_id`) REFERENCES `shiro_user` (`id`),
  CONSTRAINT `FK17E7B975858C1A45` FOREIGN KEY (`questionnaire_id`) REFERENCES `questionnaire` (`id`),
  CONSTRAINT `FK17E7B975BFF901C1` FOREIGN KEY (`questionnaire_id`) REFERENCES `questionnaire` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11750 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `questionnaire_statistics`
--

DROP TABLE IF EXISTS `questionnaire_statistics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `questionnaire_statistics` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `average_note` double NOT NULL,
  `greater_then_equals_seven` double NOT NULL,
  `group_id` bigint(20) NOT NULL,
  `less_seven` double NOT NULL,
  `questionnaire_id` bigint(20) NOT NULL,
  `standart_deviaton` double NOT NULL,
  `try_percentage` double NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK2CBC253FDAC7E480` (`group_id`),
  KEY `FK2CBC253F858C1A45` (`questionnaire_id`)
) ENGINE=MyISAM AUTO_INCREMENT=371 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `questionnaire_user_penalty`
--

DROP TABLE IF EXISTS `questionnaire_user_penalty`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `questionnaire_user_penalty` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `date_created` datetime NOT NULL,
  `last_updated` datetime NOT NULL,
  `penalty` double NOT NULL,
  `questionnaire_problem_id` bigint(20) NOT NULL,
  `questionnaire_user_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK4A91AD3181AB9C88` (`questionnaire_problem_id`),
  KEY `FK4A91AD31A576EF61` (`questionnaire_user_id`)
) ENGINE=MyISAM AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `reference_solution`
--

DROP TABLE IF EXISTS `reference_solution`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reference_solution` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `status` varchar(255) NOT NULL,
  `user_approved_id` bigint(20) DEFAULT NULL,
  `reference_solution` varchar(255) NOT NULL,
  `problem_id` bigint(20) NOT NULL,
  `language_id` bigint(20) NOT NULL,
  `user_suggest_id` bigint(20) NOT NULL,
  `comment` varchar(255) DEFAULT NULL,
  `reply` varchar(255) DEFAULT NULL,
  `submission_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK3243ED8FB80981` (`problem_id`),
  KEY `FK3243EDDA05E06D` (`user_suggest_id`),
  KEY `FK3243EDFEB10773` (`language_id`),
  KEY `FK3243EDFFBFCF2` (`user_approved_id`),
  KEY `FK3243ED6598D505` (`problem_id`),
  KEY `FK3243EDBAE1DAF1` (`user_suggest_id`),
  KEY `FK3243EDE4E9AC6F` (`language_id`),
  KEY `FK3243EDF0D7F776` (`user_approved_id`)
) ENGINE=MyISAM AUTO_INCREMENT=380 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `region`
--

DROP TABLE IF EXISTS `region`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `region` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `region_state`
--

DROP TABLE IF EXISTS `region_state`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `region_state` (
  `region_state_id` bigint(20) DEFAULT NULL,
  `state_id` bigint(20) DEFAULT NULL,
  KEY `FKB32B478612642685` (`state_id`),
  KEY `FKB32B4786CD63DE5D` (`region_state_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shiro_role`
--

DROP TABLE IF EXISTS `shiro_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `shiro_role` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shiro_role_permissions`
--

DROP TABLE IF EXISTS `shiro_role_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `shiro_role_permissions` (
  `shiro_role_id` bigint(20) DEFAULT NULL,
  `permissions_string` varchar(255) DEFAULT NULL,
  KEY `FK389B46C98AE24DA4` (`shiro_role_id`),
  KEY `FK389B46C96BBE4828` (`shiro_role_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shiro_user`
--

DROP TABLE IF EXISTS `shiro_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `shiro_user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `password_hash` varchar(255) DEFAULT NULL,
  `username` varchar(255) DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `status` varchar(255) DEFAULT NULL,
  `last_login` datetime DEFAULT NULL,
  `top_coder_position` int(11) DEFAULT NULL,
  `top_coder_score` double DEFAULT NULL,
  `current_license_id` bigint(20) DEFAULT NULL,
  `settings_id` bigint(20) DEFAULT NULL,
  `cpf` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `cpf` (`cpf`)
) ENGINE=InnoDB AUTO_INCREMENT=2169 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shiro_user_achievement`
--

DROP TABLE IF EXISTS `shiro_user_achievement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `shiro_user_achievement` (
  `shiro_user_achievement_id` bigint(20) DEFAULT NULL,
  `achievement_id` bigint(20) DEFAULT NULL,
  KEY `FK58ECF54982FF1618` (`shiro_user_achievement_id`),
  KEY `FK58ECF5496E3AFD85` (`achievement_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shiro_user_permissions`
--

DROP TABLE IF EXISTS `shiro_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `shiro_user_permissions` (
  `shiro_user_id` bigint(20) DEFAULT NULL,
  `permissions_string` varchar(255) DEFAULT NULL,
  KEY `FK34555A9E300D1184` (`shiro_user_id`),
  KEY `FK34555A9E10E90C08` (`shiro_user_id`),
  CONSTRAINT `FK34555A9E10E90C08` FOREIGN KEY (`shiro_user_id`) REFERENCES `shiro_user` (`id`),
  CONSTRAINT `FK34555A9E300D1184` FOREIGN KEY (`shiro_user_id`) REFERENCES `shiro_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shiro_user_questionnaire`
--

DROP TABLE IF EXISTS `shiro_user_questionnaire`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `shiro_user_questionnaire` (
  `shiro_user_id` bigint(20) NOT NULL,
  `questionnaire_id` bigint(20) NOT NULL,
  PRIMARY KEY (`shiro_user_id`,`questionnaire_id`),
  KEY `FK8D22553D300D1184` (`shiro_user_id`),
  KEY `FK8D22553DBFF901C1` (`questionnaire_id`),
  KEY `FK8D22553D10E90C08` (`shiro_user_id`),
  KEY `FK8D22553D858C1A45` (`questionnaire_id`),
  CONSTRAINT `FK8D22553D10E90C08` FOREIGN KEY (`shiro_user_id`) REFERENCES `shiro_user` (`id`),
  CONSTRAINT `FK8D22553D300D1184` FOREIGN KEY (`shiro_user_id`) REFERENCES `shiro_user` (`id`),
  CONSTRAINT `FK8D22553D858C1A45` FOREIGN KEY (`questionnaire_id`) REFERENCES `questionnaire` (`id`),
  CONSTRAINT `FK8D22553DBFF901C1` FOREIGN KEY (`questionnaire_id`) REFERENCES `questionnaire` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shiro_user_roles`
--

DROP TABLE IF EXISTS `shiro_user_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `shiro_user_roles` (
  `shiro_user_id` bigint(20) NOT NULL,
  `shiro_role_id` bigint(20) NOT NULL,
  PRIMARY KEY (`shiro_user_id`,`shiro_role_id`),
  KEY `FKBA221057300D1184` (`shiro_user_id`),
  KEY `FKBA2210578AE24DA4` (`shiro_role_id`),
  KEY `FKBA22105710E90C08` (`shiro_user_id`),
  CONSTRAINT `FKBA22105710E90C08` FOREIGN KEY (`shiro_user_id`) REFERENCES `shiro_user` (`id`),
  CONSTRAINT `FKBA221057300D1184` FOREIGN KEY (`shiro_user_id`) REFERENCES `shiro_user` (`id`),
  CONSTRAINT `FK_roles_user` FOREIGN KEY (`shiro_user_id`) REFERENCES `shiro_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `state`
--

DROP TABLE IF EXISTS `state`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `state` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `cod` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `state_city`
--

DROP TABLE IF EXISTS `state_city`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `state_city` (
  `state_city_id` bigint(20) DEFAULT NULL,
  `city_id` bigint(20) DEFAULT NULL,
  KEY `FKF267C059BB7C35BD` (`state_city_id`),
  KEY `FKF267C059C9BFB20F` (`city_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `submission`
--

DROP TABLE IF EXISTS `submission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `submission` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `problem_id` bigint(20) NOT NULL,
  `submission` varchar(255) NOT NULL,
  `evaluation` varchar(255) NOT NULL,
  `submission_date` datetime NOT NULL,
  `detailed_log` bit(1) NOT NULL,
  `diff_file` varchar(255) NOT NULL,
  `language_id` bigint(20) NOT NULL,
  `tries` int(11) NOT NULL,
  `output` varchar(255) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `time` double DEFAULT '-1',
  `plagium_status` int(11) DEFAULT NULL,
  `input_test_case` longtext,
  `cache_user_name` varchar(255) DEFAULT NULL,
  `cache_user_email` varchar(255) DEFAULT NULL,
  `cache_user_username` varchar(255) DEFAULT NULL,
  `cache_problem_name` varchar(255) DEFAULT NULL,
  `error_msg` longtext,
  `plagiarism_status` varchar(255) NOT NULL,
  `test_case_id` bigint(20) DEFAULT NULL,
  `comment` longtext,
  PRIMARY KEY (`id`),
  KEY `FK84363B4C8FB80981` (`problem_id`),
  KEY `FK84363B4C3A487DD2` (`user_id`),
  KEY `FK84363B4CFEB10773` (`language_id`),
  KEY `FK84363B4C6598D505` (`problem_id`),
  KEY `FK84363B4C1B247856` (`user_id`),
  KEY `FK84363B4CE4E9AC6F` (`language_id`),
  KEY `cache_user_name` (`cache_user_name`),
  KEY `cache_problem_name` (`cache_problem_name`),
  KEY `cache_user_email` (`cache_user_email`),
  KEY `cache_user_username` (`cache_user_username`),
  CONSTRAINT `FK84363B4C1B247856` FOREIGN KEY (`user_id`) REFERENCES `shiro_user` (`id`),
  CONSTRAINT `FK84363B4C3A487DD2` FOREIGN KEY (`user_id`) REFERENCES `shiro_user` (`id`),
  CONSTRAINT `FK84363B4C6598D505` FOREIGN KEY (`problem_id`) REFERENCES `problem` (`id`),
  CONSTRAINT `FK84363B4C8FB80981` FOREIGN KEY (`problem_id`) REFERENCES `problem` (`id`),
  CONSTRAINT `FK84363B4CE4E9AC6F` FOREIGN KEY (`language_id`) REFERENCES `language` (`id`),
  CONSTRAINT `FK84363B4CFEB10773` FOREIGN KEY (`language_id`) REFERENCES `language` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=161669 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `submission_comment`
--

DROP TABLE IF EXISTS `submission_comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `submission_comment` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `date` datetime NOT NULL,
  `comment` mediumtext NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `forum_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK7D51C46C3A487DD2` (`user_id`),
  KEY `FK7D51C46C1B247856` (`user_id`),
  KEY `FK7D51C46C5C09B4F1` (`forum_id`)
) ENGINE=MyISAM AUTO_INCREMENT=1004 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `teaching_resources`
--

DROP TABLE IF EXISTS `teaching_resources`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `teaching_resources` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `content_id` bigint(20) DEFAULT NULL,
  `lesson_id` bigint(20) NOT NULL,
  `order_in_list` int(11) NOT NULL,
  `problem_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK1A7C7BB36598D505` (`problem_id`),
  KEY `FK1A7C7BB3D11A4EC5` (`content_id`),
  KEY `FK1A7C7BB3C061C9AF` (`lesson_id`)
) ENGINE=MyISAM AUTO_INCREMENT=49 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `test_case`
--

DROP TABLE IF EXISTS `test_case`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `test_case` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `input` longtext NOT NULL,
  `output` longtext NOT NULL,
  `problem_id` bigint(20) NOT NULL,
  `type` int(11) NOT NULL,
  `max_output_size` double NOT NULL,
  `tip` longtext,
  `rank` int(11) NOT NULL,
  `unrank` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKB9A0FABD6598D505` (`problem_id`)
) ENGINE=MyISAM AUTO_INCREMENT=3953 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `top_coder`
--

DROP TABLE IF EXISTS `top_coder`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `top_coder` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `points` double NOT NULL,
  `user_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK62220BB3A487DD2` (`user_id`),
  KEY `FK62220BB1B247856` (`user_id`)
) ENGINE=MyISAM AUTO_INCREMENT=479435 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `topic`
--

DROP TABLE IF EXISTS `topic`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `topic` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `topic_problems`
--

DROP TABLE IF EXISTS `topic_problems`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `topic_problems` (
  `topic_id` bigint(20) NOT NULL,
  `problem_id` bigint(20) NOT NULL,
  PRIMARY KEY (`topic_id`,`problem_id`),
  KEY `FK74AC5AC48FB80981` (`problem_id`),
  KEY `FK74AC5AC452E91D41` (`topic_id`),
  KEY `FK74AC5AC46598D505` (`problem_id`),
  KEY `FK74AC5AC48ACEF9C5` (`topic_id`),
  CONSTRAINT `FK74AC5AC452E91D41` FOREIGN KEY (`topic_id`) REFERENCES `topic` (`id`),
  CONSTRAINT `FK74AC5AC46598D505` FOREIGN KEY (`problem_id`) REFERENCES `problem` (`id`),
  CONSTRAINT `FK74AC5AC48ACEF9C5` FOREIGN KEY (`topic_id`) REFERENCES `topic` (`id`),
  CONSTRAINT `FK74AC5AC48FB80981` FOREIGN KEY (`problem_id`) REFERENCES `problem` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_evolution`
--

DROP TABLE IF EXISTS `user_evolution`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_evolution` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `date_created` datetime NOT NULL,
  `last_updated` datetime NOT NULL,
  `problem_correct` int(11) NOT NULL,
  `problems_tried` int(11) NOT NULL,
  `top_coder_position` int(11) NOT NULL,
  `top_coder_score` double NOT NULL,
  `user_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=228027 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_link`
--

DROP TABLE IF EXISTS `user_link`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_link` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `link` varchar(255) NOT NULL,
  `status` int(11) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK143923EE1B247856` (`user_id`)
) ENGINE=MyISAM AUTO_INCREMENT=1555 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_problem`
--

DROP TABLE IF EXISTS `user_problem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_problem` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `problem_id` bigint(20) NOT NULL,
  `status` int(11) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `similarity` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK487C5A2B6598D505` (`problem_id`),
  KEY `FK487C5A2B1B247856` (`user_id`)
) ENGINE=MyISAM AUTO_INCREMENT=56684 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_setting`
--

DROP TABLE IF EXISTS `user_setting`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_setting` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `email_notify` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2014-06-29  9:20:24
