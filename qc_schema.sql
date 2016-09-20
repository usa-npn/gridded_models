-- MySQL dump 10.13  Distrib 5.5.52, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: climate
-- ------------------------------------------------------
-- Server version	5.5.52-0ubuntu0.14.04.1-log

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
-- Table structure for table `agdds`
--

DROP TABLE IF EXISTS `agdds`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `agdds` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `station_id` int(11) NOT NULL,
  `source_id` int(11) NOT NULL,
  `gdd` float DEFAULT NULL,
  `agdd` float DEFAULT NULL,
  `year` int(11) NOT NULL,
  `doy` int(11) NOT NULL,
  `date` date NOT NULL,
  `base_temp_f` int(11) NOT NULL,
  `missing` tinyint(4) DEFAULT NULL,
  `tmin` float DEFAULT NULL,
  `tmax` float DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `station_id_indx` (`station_id`),
  KEY `source_id_indx` (`source_id`),
  KEY `date_indx` (`date`),
  KEY `base_indx` (`base_temp_f`),
  KEY `station_date_source_base_indx` (`station_id`,`date`,`source_id`,`base_temp_f`),
  CONSTRAINT `fk_agdd_source` FOREIGN KEY (`source_id`) REFERENCES `sources` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_agdd_station` FOREIGN KEY (`station_id`) REFERENCES `stations` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=358360 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `attribute_types`
--

DROP TABLE IF EXISTS `attribute_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `attribute_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `description` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_UNIQUE` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sources`
--

DROP TABLE IF EXISTS `sources`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sources` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `description` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `station_attributes`
--

DROP TABLE IF EXISTS `station_attributes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `station_attributes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `station_id` int(11) NOT NULL,
  `attribute_id` int(11) NOT NULL,
  `int_value` int(11) DEFAULT NULL,
  `char_value` text,
  `float_value` float DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `station_id_indx` (`station_id`),
  KEY `attribute_id_indx` (`attribute_id`),
  CONSTRAINT `fk_value_attribute` FOREIGN KEY (`attribute_id`) REFERENCES `attribute_types` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_value_station` FOREIGN KEY (`station_id`) REFERENCES `stations` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=277 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `stations`
--

DROP TABLE IF EXISTS `stations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `stations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `latitude` float NOT NULL,
  `longitude` float NOT NULL,
  `elevation` float DEFAULT NULL,
  `name` varchar(128) DEFAULT NULL,
  `int_network_id` int(11) DEFAULT NULL,
  `char_network_id` varchar(45) DEFAULT NULL,
  `type` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `int_network_id_indx` (`int_network_id`)
) ENGINE=InnoDB AUTO_INCREMENT=729 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `vw_agdds_tabular`
--

DROP TABLE IF EXISTS `vw_agdds_tabular`;
/*!50001 DROP VIEW IF EXISTS `vw_agdds_tabular`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `vw_agdds_tabular` (
  `id` tinyint NOT NULL,
  `station_id` tinyint NOT NULL,
  `year` tinyint NOT NULL,
  `doy` tinyint NOT NULL,
  `date` tinyint NOT NULL,
  `acis_32_gdd` tinyint NOT NULL,
  `acis_32_agdd` tinyint NOT NULL,
  `acis_32_missing` tinyint NOT NULL,
  `acis_32_tmin` tinyint NOT NULL,
  `acis_32_tmax` tinyint NOT NULL,
  `urma_32_gdd` tinyint NOT NULL,
  `urma_32_agdd` tinyint NOT NULL,
  `urma_32_missing` tinyint NOT NULL,
  `urma_32_tmin` tinyint NOT NULL,
  `urma_32_tmax` tinyint NOT NULL,
  `prism_32_gdd` tinyint NOT NULL,
  `prism_32_agdd` tinyint NOT NULL,
  `prism_32_missing` tinyint NOT NULL,
  `prism_32_tmin` tinyint NOT NULL,
  `prism_32_tmax` tinyint NOT NULL,
  `acis_50_gdd` tinyint NOT NULL,
  `acis_50_agdd` tinyint NOT NULL,
  `acis_50_missing` tinyint NOT NULL,
  `acis_50_tmin` tinyint NOT NULL,
  `acis_50_tmax` tinyint NOT NULL,
  `urma_50_gdd` tinyint NOT NULL,
  `urma_50_agdd` tinyint NOT NULL,
  `urma_50_missing` tinyint NOT NULL,
  `urma_50_tmin` tinyint NOT NULL,
  `urma_50_tmax` tinyint NOT NULL,
  `prism_50_gdd` tinyint NOT NULL,
  `prism_50_agdd` tinyint NOT NULL,
  `prism_50_missing` tinyint NOT NULL,
  `prism_50_tmin` tinyint NOT NULL,
  `prism_50_tmax` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `vw_agdds_tabular`
--

/*!50001 DROP TABLE IF EXISTS `vw_agdds_tabular`*/;
/*!50001 DROP VIEW IF EXISTS `vw_agdds_tabular`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_agdds_tabular` AS select `acis_32`.`id` AS `id`,`acis_32`.`station_id` AS `station_id`,`acis_32`.`year` AS `year`,`acis_32`.`doy` AS `doy`,`acis_32`.`date` AS `date`,`acis_32`.`gdd` AS `acis_32_gdd`,`acis_32`.`agdd` AS `acis_32_agdd`,`acis_32`.`missing` AS `acis_32_missing`,`acis_32`.`tmin` AS `acis_32_tmin`,`acis_32`.`tmax` AS `acis_32_tmax`,`urma_32`.`gdd` AS `urma_32_gdd`,`urma_32`.`agdd` AS `urma_32_agdd`,`urma_32`.`missing` AS `urma_32_missing`,`urma_32`.`tmin` AS `urma_32_tmin`,`urma_32`.`tmax` AS `urma_32_tmax`,`prism_32`.`gdd` AS `prism_32_gdd`,`prism_32`.`agdd` AS `prism_32_agdd`,`prism_32`.`missing` AS `prism_32_missing`,`prism_32`.`tmin` AS `prism_32_tmin`,`prism_32`.`tmax` AS `prism_32_tmax`,`acis_50`.`gdd` AS `acis_50_gdd`,`acis_50`.`agdd` AS `acis_50_agdd`,`acis_50`.`missing` AS `acis_50_missing`,`acis_50`.`tmin` AS `acis_50_tmin`,`acis_50`.`tmax` AS `acis_50_tmax`,`urma_50`.`gdd` AS `urma_50_gdd`,`urma_50`.`agdd` AS `urma_50_agdd`,`urma_50`.`missing` AS `urma_50_missing`,`urma_50`.`tmin` AS `urma_50_tmin`,`urma_50`.`tmax` AS `urma_50_tmax`,`prism_50`.`gdd` AS `prism_50_gdd`,`prism_50`.`agdd` AS `prism_50_agdd`,`prism_50`.`missing` AS `prism_50_missing`,`prism_50`.`tmin` AS `prism_50_tmin`,`prism_50`.`tmax` AS `prism_50_tmax` from (((((`agdds` `acis_32` left join `agdds` `urma_32` on(((`acis_32`.`station_id` = `urma_32`.`station_id`) and (`acis_32`.`year` = `urma_32`.`year`) and (`acis_32`.`doy` = `urma_32`.`doy`) and (`acis_32`.`base_temp_f` = `urma_32`.`base_temp_f`) and (`urma_32`.`source_id` = 3)))) left join `agdds` `prism_32` on(((`acis_32`.`station_id` = `prism_32`.`station_id`) and (`acis_32`.`year` = `prism_32`.`year`) and (`acis_32`.`doy` = `prism_32`.`doy`) and (`acis_32`.`base_temp_f` = `prism_32`.`base_temp_f`) and (`prism_32`.`source_id` = 4)))) left join `agdds` `acis_50` on(((`acis_32`.`station_id` = `acis_50`.`station_id`) and (`acis_32`.`year` = `acis_50`.`year`) and (`acis_32`.`doy` = `acis_50`.`doy`) and (`acis_32`.`base_temp_f` <> `acis_50`.`base_temp_f`) and (`acis_32`.`source_id` = `acis_50`.`source_id`)))) left join `agdds` `urma_50` on(((`acis_32`.`station_id` = `urma_50`.`station_id`) and (`acis_32`.`year` = `urma_50`.`year`) and (`acis_32`.`doy` = `urma_50`.`doy`) and (`acis_32`.`base_temp_f` <> `urma_50`.`base_temp_f`) and (`urma_50`.`source_id` = 3)))) left join `agdds` `prism_50` on(((`acis_32`.`station_id` = `prism_50`.`station_id`) and (`acis_32`.`year` = `prism_50`.`year`) and (`acis_32`.`doy` = `prism_50`.`doy`) and (`acis_32`.`base_temp_f` <> `prism_50`.`base_temp_f`) and (`prism_50`.`source_id` = 4)))) where ((`acis_32`.`source_id` = 2) and (`acis_32`.`base_temp_f` = 32)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-09-20 15:30:07
