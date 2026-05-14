-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 12, 2025 at 09:22 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `moonlinks_menu`
--

-- --------------------------------------------------------

--
-- Table structure for table `assets`
--

CREATE TABLE `assets` (
  `uuid` varchar(50) NOT NULL,
  `name` varchar(100) NOT NULL,
  `type` enum('image','icon') NOT NULL,
  `url` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `uuid` varchar(50) NOT NULL,
  `menu_uuid` varchar(50) NOT NULL,
  `title` varchar(255) NOT NULL,
  `icon_key` varchar(100) DEFAULT NULL,
  `image_url` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `categories_translations`
--

CREATE TABLE `categories_translations` (
  `id` int(11) NOT NULL,
  `category_uuid` varchar(50) NOT NULL,
  `menu_translation_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `items`
--

CREATE TABLE `items` (
  `uuid` varchar(50) NOT NULL,
  `subcategory_uuid` varchar(50) NOT NULL,
  `title` text NOT NULL,
  `description` text DEFAULT NULL,
  `main_image_url` text DEFAULT NULL,
  `badges` longtext NOT NULL DEFAULT '[]',
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `display_order` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `items_translations`
--

CREATE TABLE `items_translations` (
  `id` int(11) NOT NULL,
  `item_uuid` varchar(50) NOT NULL,
  `subcategory_translation_id` int(11) NOT NULL,
  `title` text NOT NULL,
  `description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `item_images`
--

CREATE TABLE `item_images` (
  `uuid` varchar(50) NOT NULL,
  `item_uuid` varchar(50) NOT NULL,
  `url` text NOT NULL,
  `alt` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `item_prices`
--

CREATE TABLE `item_prices` (
  `uuid` varchar(50) NOT NULL,
  `item_uuid` varchar(50) NOT NULL,
  `label` varchar(100) NOT NULL,
  `amount` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `item_types`
--

CREATE TABLE `item_types` (
  `uuid` varchar(50) NOT NULL,
  `item_uuid` varchar(50) NOT NULL,
  `name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `item_types_translations`
--

CREATE TABLE `item_types_translations` (
  `id` int(11) NOT NULL,
  `item_type_uuid` varchar(50) NOT NULL,
  `item_translation_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `menu`
--

CREATE TABLE `menu` (
  `uuid` varchar(50) NOT NULL,
  `user_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `name_lower` varchar(255) GENERATED ALWAYS AS (lcase(`name`)) STORED,
  `design` longtext NOT NULL DEFAULT json_object(),
  `created_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `updated_at` datetime(6) NOT NULL DEFAULT current_timestamp(6) ON UPDATE current_timestamp(6),
  `status` varchar(16) NOT NULL DEFAULT 'draft',
  `image_counter` int(11) NOT NULL DEFAULT 0,
  `main_lang` varchar(10) DEFAULT NULL,
  `currency` char(3) DEFAULT NULL,
  `direction` enum('ltr','rtl') NOT NULL DEFAULT 'ltr'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `menu_country_branches`
--

CREATE TABLE `menu_country_branches` (
  `id` int(11) NOT NULL,
  `menu_feature_id` int(11) NOT NULL,
  `country` varchar(100) NOT NULL,
  `branch_name` varchar(100) NOT NULL,
  `branch_link` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `menu_features`
--

CREATE TABLE `menu_features` (
  `id` int(11) NOT NULL,
  `menu_uuid` varchar(50) NOT NULL,
  `banner_url` varchar(255) DEFAULT NULL,
  `feedback_enabled` tinyint(1) NOT NULL DEFAULT 0,
  `openclose_hours` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `menu_snapshots`
--

CREATE TABLE `menu_snapshots` (
  `uuid` varchar(50) NOT NULL,
  `menu_uuid` varchar(50) NOT NULL,
  `version` int(11) NOT NULL,
  `payload` longtext NOT NULL,
  `searched_before` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime(6) NOT NULL DEFAULT current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `menu_social_media`
--

CREATE TABLE `menu_social_media` (
  `id` int(11) NOT NULL,
  `menu_feature_id` int(11) NOT NULL,
  `platform` varchar(50) NOT NULL,
  `url` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `menu_translations`
--

CREATE TABLE `menu_translations` (
  `id` int(11) NOT NULL,
  `menu_uuid` varchar(50) NOT NULL,
  `lang_code` char(5) NOT NULL,
  `name` varchar(255) NOT NULL,
  `direction` enum('ltr','rtl') NOT NULL DEFAULT 'ltr',
  `currency` char(3) DEFAULT NULL,
  `multiplier_currency` decimal(10,4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `subcategories`
--

CREATE TABLE `subcategories` (
  `uuid` varchar(50) NOT NULL,
  `category_uuid` varchar(50) NOT NULL,
  `title` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `subcategories_translations`
--

CREATE TABLE `subcategories_translations` (
  `id` int(11) NOT NULL,
  `subcategory_uuid` varchar(50) NOT NULL,
  `category_translation_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `assets`
--
ALTER TABLE `assets`
  ADD PRIMARY KEY (`uuid`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`uuid`),
  ADD KEY `fk_categories_menu` (`menu_uuid`);

--
-- Indexes for table `categories_translations`
--
ALTER TABLE `categories_translations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_categories_translations_category` (`category_uuid`),
  ADD KEY `fk_categories_translations_menu_translation` (`menu_translation_id`);

--
-- Indexes for table `items`
--
ALTER TABLE `items`
  ADD PRIMARY KEY (`uuid`),
  ADD KEY `fk_items_subcategory` (`subcategory_uuid`);

--
-- Indexes for table `items_translations`
--
ALTER TABLE `items_translations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_items_translations_item` (`item_uuid`),
  ADD KEY `fk_items_translations_subcategory_translation` (`subcategory_translation_id`);

--
-- Indexes for table `item_images`
--
ALTER TABLE `item_images`
  ADD PRIMARY KEY (`uuid`),
  ADD KEY `fk_item_images_item` (`item_uuid`);

--
-- Indexes for table `item_prices`
--
ALTER TABLE `item_prices`
  ADD PRIMARY KEY (`uuid`),
  ADD KEY `fk_item_prices_item` (`item_uuid`);

--
-- Indexes for table `item_types`
--
ALTER TABLE `item_types`
  ADD PRIMARY KEY (`uuid`),
  ADD KEY `fk_item_types_item` (`item_uuid`);

--
-- Indexes for table `item_types_translations`
--
ALTER TABLE `item_types_translations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_item_types_translations_type` (`item_type_uuid`),
  ADD KEY `fk_item_types_translations_item_translation` (`item_translation_id`);

--
-- Indexes for table `menu`
--
ALTER TABLE `menu`
  ADD PRIMARY KEY (`uuid`),
  ADD UNIQUE KEY `ux_menu_user` (`user_id`),
  ADD UNIQUE KEY `ux_menu_name` (`name_lower`);

--
-- Indexes for table `menu_country_branches`
--
ALTER TABLE `menu_country_branches`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_menu_country_branches_feature` (`menu_feature_id`);

--
-- Indexes for table `menu_features`
--
ALTER TABLE `menu_features`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_menu_features_menu` (`menu_uuid`);

--
-- Indexes for table `menu_snapshots`
--
ALTER TABLE `menu_snapshots`
  ADD PRIMARY KEY (`uuid`),
  ADD UNIQUE KEY `ux_menu_version` (`menu_uuid`,`version`);

--
-- Indexes for table `menu_social_media`
--
ALTER TABLE `menu_social_media`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_menu_social_media_feature` (`menu_feature_id`);

--
-- Indexes for table `menu_translations`
--
ALTER TABLE `menu_translations`
  ADD PRIMARY KEY (`id`,`menu_uuid`,`lang_code`),
  ADD KEY `fk_menu_translations_menu` (`menu_uuid`);

--
-- Indexes for table `subcategories`
--
ALTER TABLE `subcategories`
  ADD PRIMARY KEY (`uuid`),
  ADD KEY `fk_subcategories_category` (`category_uuid`);

--
-- Indexes for table `subcategories_translations`
--
ALTER TABLE `subcategories_translations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_subcategories_translations_subcategory` (`subcategory_uuid`),
  ADD KEY `fk_subcategories_translations_category_translation` (`category_translation_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `categories_translations`
--
ALTER TABLE `categories_translations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `items_translations`
--
ALTER TABLE `items_translations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `item_types_translations`
--
ALTER TABLE `item_types_translations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `menu_country_branches`
--
ALTER TABLE `menu_country_branches`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `menu_features`
--
ALTER TABLE `menu_features`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `menu_social_media`
--
ALTER TABLE `menu_social_media`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `menu_translations`
--
ALTER TABLE `menu_translations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `subcategories_translations`
--
ALTER TABLE `subcategories_translations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `categories`
--
ALTER TABLE `categories`
  ADD CONSTRAINT `fk_categories_menu` FOREIGN KEY (`menu_uuid`) REFERENCES `menu` (`uuid`) ON DELETE CASCADE;

--
-- Constraints for table `categories_translations`
--
ALTER TABLE `categories_translations`
  ADD CONSTRAINT `fk_categories_translations_category` FOREIGN KEY (`category_uuid`) REFERENCES `categories` (`uuid`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_categories_translations_menu_translation` FOREIGN KEY (`menu_translation_id`) REFERENCES `menu_translations` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `items`
--
ALTER TABLE `items`
  ADD CONSTRAINT `fk_items_subcategory` FOREIGN KEY (`subcategory_uuid`) REFERENCES `subcategories` (`uuid`) ON DELETE CASCADE;

--
-- Constraints for table `items_translations`
--
ALTER TABLE `items_translations`
  ADD CONSTRAINT `fk_items_translations_item` FOREIGN KEY (`item_uuid`) REFERENCES `items` (`uuid`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_items_translations_subcategory_translation` FOREIGN KEY (`subcategory_translation_id`) REFERENCES `subcategories_translations` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `item_images`
--
ALTER TABLE `item_images`
  ADD CONSTRAINT `fk_item_images_item` FOREIGN KEY (`item_uuid`) REFERENCES `items` (`uuid`) ON DELETE CASCADE;

--
-- Constraints for table `item_prices`
--
ALTER TABLE `item_prices`
  ADD CONSTRAINT `fk_item_prices_item` FOREIGN KEY (`item_uuid`) REFERENCES `items` (`uuid`) ON DELETE CASCADE;

--
-- Constraints for table `item_types`
--
ALTER TABLE `item_types`
  ADD CONSTRAINT `fk_item_types_item` FOREIGN KEY (`item_uuid`) REFERENCES `items` (`uuid`) ON DELETE CASCADE;

--
-- Constraints for table `item_types_translations`
--
ALTER TABLE `item_types_translations`
  ADD CONSTRAINT `fk_item_types_translations_item_translation` FOREIGN KEY (`item_translation_id`) REFERENCES `items_translations` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_item_types_translations_type` FOREIGN KEY (`item_type_uuid`) REFERENCES `item_types` (`uuid`) ON DELETE CASCADE;

--
-- Constraints for table `menu_country_branches`
--
ALTER TABLE `menu_country_branches`
  ADD CONSTRAINT `fk_menu_country_branches_feature` FOREIGN KEY (`menu_feature_id`) REFERENCES `menu_features` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `menu_features`
--
ALTER TABLE `menu_features`
  ADD CONSTRAINT `fk_menu_features_menu` FOREIGN KEY (`menu_uuid`) REFERENCES `menu` (`uuid`) ON DELETE CASCADE;

--
-- Constraints for table `menu_snapshots`
--
ALTER TABLE `menu_snapshots`
  ADD CONSTRAINT `fk_menu_snapshots` FOREIGN KEY (`menu_uuid`) REFERENCES `menu` (`uuid`) ON DELETE CASCADE;

--
-- Constraints for table `menu_social_media`
--
ALTER TABLE `menu_social_media`
  ADD CONSTRAINT `fk_menu_social_media_feature` FOREIGN KEY (`menu_feature_id`) REFERENCES `menu_features` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `menu_translations`
--
ALTER TABLE `menu_translations`
  ADD CONSTRAINT `fk_menu_translations_menu` FOREIGN KEY (`menu_uuid`) REFERENCES `menu` (`uuid`) ON DELETE CASCADE;

--
-- Constraints for table `subcategories`
--
ALTER TABLE `subcategories`
  ADD CONSTRAINT `fk_subcategories_category` FOREIGN KEY (`category_uuid`) REFERENCES `categories` (`uuid`) ON DELETE CASCADE;

--
-- Constraints for table `subcategories_translations`
--
ALTER TABLE `subcategories_translations`
  ADD CONSTRAINT `fk_subcategories_translations_category_translation` FOREIGN KEY (`category_translation_id`) REFERENCES `categories_translations` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_subcategories_translations_subcategory` FOREIGN KEY (`subcategory_uuid`) REFERENCES `subcategories` (`uuid`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
