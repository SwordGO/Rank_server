-- MySQL dump 10.15  Distrib 10.0.27-MariaDB, for debian-linux-gnu (i686)
--
-- Host: localhost    Database: goldrush
-- ------------------------------------------------------
-- Server version	10.0.27-MariaDB-0ubuntu0.16.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `axe`
--

DROP TABLE IF EXISTS `axe`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `axe` (
  `idaxe` int(11) NOT NULL,
  `s_lv` int(10) unsigned DEFAULT NULL,
  `r_lv` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`idaxe`),
  UNIQUE KEY `idaxe_UNIQUE` (`idaxe`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `axe`
--

LOCK TABLES `axe` WRITE;
/*!40000 ALTER TABLE `axe` DISABLE KEYS */;
INSERT INTO `axe` VALUES (0,0,0);
/*!40000 ALTER TABLE `axe` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mine`
--

DROP TABLE IF EXISTS `mine`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mine` (
  `idmine` int(11) NOT NULL AUTO_INCREMENT,
  `hp` int(10) unsigned DEFAULT '1000',
  `user` int(11) DEFAULT NULL,
  `lat` double DEFAULT NULL,
  `lon` double DEFAULT NULL,
  PRIMARY KEY (`idmine`),
  UNIQUE KEY `idmine_UNIQUE` (`idmine`),
  KEY `mine_user_idx` (`user`),
  CONSTRAINT `mine_user` FOREIGN KEY (`user`) REFERENCES `user` (`iduser`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mine`
--

LOCK TABLES `mine` WRITE;
/*!40000 ALTER TABLE `mine` DISABLE KEYS */;
INSERT INTO `mine` VALUES (1,10,1,40.716743,-73.951368);
/*!40000 ALTER TABLE `mine` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `team`
--

DROP TABLE IF EXISTS `team`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `team` (
  `idteam` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  PRIMARY KEY (`idteam`,`name`),
  UNIQUE KEY `idteam_UNIQUE` (`idteam`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `team`
--

LOCK TABLES `team` WRITE;
/*!40000 ALTER TABLE `team` DISABLE KEYS */;
INSERT INTO `team` VALUES (0,'None');
/*!40000 ALTER TABLE `team` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user` (
  `iduser` int(11) NOT NULL AUTO_INCREMENT,
  `id` varchar(45) NOT NULL,
  `name` varchar(45) NOT NULL,
  `picture` longblob,
  `team` int(11) NOT NULL,
  `axe` int(11) NOT NULL,
  PRIMARY KEY (`iduser`),
  UNIQUE KEY `id_UNIQUE` (`iduser`),
  UNIQUE KEY `user_UNIQUE` (`id`),
  UNIQUE KEY `axe_UNIQUE` (`axe`),
  KEY `user_team_idx` (`team`),
  CONSTRAINT `user_axe` FOREIGN KEY (`axe`) REFERENCES `axe` (`idaxe`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `user_team` FOREIGN KEY (`team`) REFERENCES `team` (`idteam`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'test','test',NULL,0,0);
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'goldrush'
--
/*!50003 DROP FUNCTION IF EXISTS `slc` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`goldrush`@`localhost` FUNCTION `slc`(lat1 double, lon1 double, lat2 double, lon2 double) RETURNS double
RETURN 6371 * acos(cos(radians(lat1)) * cos(radians(lat2)) * cos(radians(lon2) - radians(lon1)) + sin(radians(lat1)) * sin(radians(lat2))) ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `circle_geo` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`goldrush`@`localhost` PROCEDURE `circle_geo`(IN _lat double, IN _lon double, IN distance double)
BEGIN
    select idmine, slc( _lon, _lat, lon, lat)*1000 as distance_in_meters, mine.user as user, user.team as team
    from mine, user 
    where 
		mine.user = user.iduser
		and MBRContains(envelope(linestring(point((_lat+(distance/1000/111)), (_lon+(distance/1000/111))), point((_lat-(distance/1000/111)), (_lon-(distance/1000/111))))), point(lat, lon))
		and slc( _lon, _lat, lon, lat)*1000 <= distance
		order by distance_in_meters limit 10;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `rec_geo` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`goldrush`@`localhost` PROCEDURE `rec_geo`(IN _lat double, IN _lon double, IN distance double)
BEGIN
    select idmine, slc( _lon, _lat, lon, lat)*1000 as distance_in_meters, mine.user as user, user.team as team
    from mine, user
    where 
		mine.user = user.iduser
		and MBRContains(envelope(linestring(point((_lat+(distance/1000/111)), (_lon+(distance/1000/111))), point((_lat-(distance/1000/111)), (_lon-(distance/1000/111))))), point(lat, lon))
		order by distance_in_meters limit 10;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-10-14 22:15:24
