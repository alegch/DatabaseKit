DROP TABLE IF EXISTS `foobar`;
CREATE TABLE `foobar` ( `id` int(11) NOT NULL auto_increment, `name` varchar(255) default NULL, `info` text, PRIMARY KEY  (`id`)) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
INSERT INTO `foobar` (`id`,`name`,`info`) VALUES ('1','a name','foobar\nsdæajskld');
INSERT INTO `foobar` (`id`,`name`,`info`) VALUES ('2','another name','sadas');
DROP TABLE IF EXISTS foo;
DROP TABLE IF EXISTS models;
DROP TABLE IF EXISTS people;
DROP TABLE IF EXISTS animals;
DROP TABLE IF EXISTS animals_people;
DROP TABLE IF EXISTS belgians;
CREATE TABLE foo (`id` int(11) NOT NULL auto_increment, `bar` varchar(255) DEFAULT NULL, `baz` TEXT DEFAULT NULL, `int(11)` int(11) DEFAULT NULL, PRIMARY KEY  (`id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8;
INSERT INTO `foo` VALUES(1,'foobarbaz','bazbazb',1337);
INSERT INTO `foo` VALUES(2,'fjolnir','asgeirsson',1601);
CREATE TABLE `models`(`id` int(11) NOT NULL auto_increment, `name` varchar(255) DEFAULT NULL, `info` TEXT DEFAULT NULL, PRIMARY KEY  (`id`)) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
INSERT INTO `models` VALUES(1,'a name','some info!');
INSERT INTO `models` VALUES(2,'another name','some more info!');
CREATE TABLE `people`(`id` int(11) NOT NULL auto_increment, `userName` varchar(255) DEFAULT NULL, `realName` varchar(255) DEFAULT NULL, `modelId` int(11) DEFAULT NULL, PRIMARY KEY  (`id`)) AUTO_INCREMENT=3 ENGINE=InnoDB DEFAULT CHARSET=utf8;
INSERT INTO `people` VALUES(1,'aptiva','fjolnir asgeirsson',1);
INSERT INTO `people` VALUES(2,'god','steve wozniak',1);
INSERT INTO `people` VALUES(3,'co-god','steve jobs',0);
CREATE TABLE `animals`(`id` int(11) NOT NULL auto_increment, `species` varchar(255) DEFAULT NULL, `nickname` varchar(255) DEFAULT NULL, `modelId` int(11) DEFAULT NULL, PRIMARY KEY  (`id`)) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
INSERT INTO `animals` VALUES(1,'cat','awesome',1);
INSERT INTO `animals` VALUES(2,'dog','lame',1)
CREATE TABLE animals_people(`animalId` int(11), `personId` int(11));
INSERT INTO `animals_people` VALUES(1,3);
CREATE TABLE `animals`(`id` int(11) NOT NULL auto_increment, `species` varchar(255) DEFAULT NULL, `nickname` varchar(255) DEFAULT NULL, `modelId` int(11) DEFAULT NULL, PRIMARY KEY  (`id`)) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
INSERT INTO `animals` VALUES(1,'cat','awesome',1);
CREATE TABLE animals_people(`animalId` int(11), `personId` int(11));
INSERT INTO `animals_people` VALUES(1,3)
CREATE TABLE `belgians`(`id` int(11) NOT NULL auto_increment, `nickname` varchar(255) DEFAULT NULL, `personId` int(11) DEFAULT NULL, PRIMARY KEY  (`id`)) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
INSERT INTO `belgians` VALUES(1,'denis',1);
INSERT INTO `belgians` VALUES(2,'chucker',1);
