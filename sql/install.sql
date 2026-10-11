-- mezos-clothing creates and upgrades these tables automatically on start.
-- This file is only for manual installs. Existing qb-clothing data is kept as-is.

CREATE TABLE IF NOT EXISTS `playerskins` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `citizenid` varchar(255) NOT NULL,
    `model` varchar(255) NOT NULL,
    `skin` text NOT NULL,
    `active` tinyint(2) NOT NULL DEFAULT 1,
    PRIMARY KEY (`id`),
    KEY `citizenid` (`citizenid`),
    KEY `active` (`active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `player_outfits` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `citizenid` varchar(50) DEFAULT NULL,
    `outfitname` varchar(50) NOT NULL,
    `model` varchar(50) DEFAULT NULL,
    `skin` text DEFAULT NULL,
    `outfitId` varchar(50) NOT NULL,
    `share_code` varchar(16) DEFAULT NULL,
    `folder` varchar(32) NOT NULL DEFAULT '',
    `tags` varchar(128) NOT NULL DEFAULT '',
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `citizenid` (`citizenid`),
    KEY `outfitId` (`outfitId`),
    UNIQUE KEY `share_code` (`share_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Upgrading an existing qb-clothing player_outfits table (skip columns that already exist):
-- ALTER TABLE `player_outfits` ADD COLUMN `share_code` varchar(16) DEFAULT NULL, ADD UNIQUE KEY `share_code` (`share_code`);
-- ALTER TABLE `player_outfits` ADD COLUMN `folder` varchar(32) NOT NULL DEFAULT '';
-- ALTER TABLE `player_outfits` ADD COLUMN `tags` varchar(128) NOT NULL DEFAULT '';
-- ALTER TABLE `player_outfits` ADD COLUMN `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP;

CREATE TABLE IF NOT EXISTS `mezos_outfit_gallery` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `citizenid` varchar(50) NOT NULL,
    `author` varchar(100) NOT NULL,
    `name` varchar(50) NOT NULL,
    `model` varchar(50) NOT NULL,
    `skin` text NOT NULL,
    `tags` varchar(128) NOT NULL DEFAULT '',
    `likes` int(11) NOT NULL DEFAULT 0,
    `uses` int(11) NOT NULL DEFAULT 0,
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `model` (`model`),
    KEY `citizenid` (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `mezos_gallery_likes` (
    `gallery_id` int(11) NOT NULL,
    `citizenid` varchar(50) NOT NULL,
    PRIMARY KEY (`gallery_id`, `citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `mezos_outfitbags` (
    `bag_id` varchar(32) NOT NULL,
    `label` varchar(50) NOT NULL DEFAULT 'Outfit Bag',
    `outfits` longtext NOT NULL,
    `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`bag_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
