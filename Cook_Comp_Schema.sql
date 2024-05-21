-- Set SQL modes and foreign key checks
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

-- Drop the schema if it exists
DROP SCHEMA IF EXISTS cookDB;
CREATE SCHEMA cookDB;
USE cookDB;

-- Table for FoodGroup
CREATE TABLE FoodGroup (
    food_group_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (food_group_id),
    UNIQUE KEY idx_food_group_name (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Table for food groups';

-- Table for Ingredient
CREATE TABLE Ingredient (
    ingredient_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    quantity VARCHAR(255) NOT NULL,
    food_group_id INT UNSIGNED NOT NULL,
    last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (ingredient_id),
    UNIQUE KEY idx_ingredient_name_food_group (name, food_group_id),
    KEY idx_fk_food_group_id (food_group_id),
    CONSTRAINT fk_ingredient_food_group FOREIGN KEY (food_group_id) REFERENCES FoodGroup(food_group_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Table for ingredients';

-- Table for Recipe
CREATE TABLE Recipe (
    recipe_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    cuisine VARCHAR(255) NOT NULL,
    type ENUM('cooking', 'pastry') NOT NULL,
    difficulty INT CHECK (difficulty BETWEEN 1 AND 5),
    meal_types VARCHAR(255) NOT NULL,
    tags VARCHAR(255),
    tips TEXT,
    prep_time INT CHECK (prep_time >= 0),
    cook_time INT CHECK (cook_time >= 0),
    steps TEXT NOT NULL,
    portions INT CHECK (portions > 0),
    main_ingredient_id INT UNSIGNED NOT NULL,
    fat DECIMAL(5,2) CHECK (fat >= 0),
    protein DECIMAL(5,2) CHECK (protein >= 0),
    carbs DECIMAL(5,2) CHECK (carbs >= 0),
    calories INT CHECK (calories >= 0),
    last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (recipe_id),
    UNIQUE KEY idx_recipe_name_cuisine (name, cuisine),
    KEY idx_fk_main_ingredient_id (main_ingredient_id),
    CONSTRAINT fk_recipe_main_ingredient FOREIGN KEY (main_ingredient_id) REFERENCES Ingredient(ingredient_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Table for recipes';

-- Table for Equipment
CREATE TABLE Equipment (
    equipment_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    instructions TEXT NOT NULL,
    last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (equipment_id),
    UNIQUE KEY idx_equipment_name (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Table for equipment';

-- Table for Chef
CREATE TABLE Chef (
    chef_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    contact_info VARCHAR(255),
    birthdate DATE NOT NULL,
    age INT CHECK (age >= 0),
    experience INT CHECK (experience >= 0),
    specialization VARCHAR(255),
    certification ENUM('Third Chef', 'Second Chef', 'First Chef', 'Assistant Head Chef', 'Head Chef') NOT NULL,
    last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (chef_id),
    UNIQUE KEY idx_chef_name_birthdate (first_name, last_name, birthdate),
    KEY idx_chef_last_name (last_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Table for chefs';

-- Table for JudgeChef (inherits attributes from Chef)
CREATE TABLE JudgeChef (
    judge_chef_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    contact_info VARCHAR(255),
    birthdate DATE NOT NULL,
    age INT CHECK (age >= 0),
    experience INT CHECK (experience >= 0),
    specialization VARCHAR(255),
    certification ENUM('Third Chef', 'Second Chef', 'First Chef', 'Assistant Head Chef', 'Head Chef') NOT NULL,
    last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (judge_chef_id),
    UNIQUE KEY idx_judge_chef_name_birthdate (first_name, last_name, birthdate),
    KEY idx_judge_chef_last_name (last_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Table for judge chefs';

-- Table for Episode
CREATE TABLE Episode (
    episode_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    year INT NOT NULL,
    national_cuisine VARCHAR(255) NOT NULL,
    recipe_id INT UNSIGNED NOT NULL,
    last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (episode_id),
    UNIQUE KEY idx_episode_year_cuisine_recipe (year, national_cuisine, recipe_id),
    KEY idx_fk_recipe_id (recipe_id),
    CONSTRAINT fk_episode_recipe FOREIGN KEY (recipe_id) REFERENCES Recipe(recipe_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Table for episodes';

-- Table for Theme
CREATE TABLE Theme (
    theme_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (theme_id),
    UNIQUE KEY idx_theme_name (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Table for themes';

-- Table for User
CREATE TABLE User (
    user_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    username VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('admin', 'chef') NOT NULL,
    last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id),
    UNIQUE KEY idx_username (username)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Table for users';

-- Table for Image
CREATE TABLE Image (
    image_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    url VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    entity_type ENUM('food_group', 'ingredient', 'recipe', 'equipment', 'chef', 'judge_chef', 'episode', 'theme') NOT NULL,
    entity_id INT UNSIGNED NOT NULL,
    last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (image_id),
    UNIQUE KEY idx_image_url_entity (url, entity_type, entity_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Table for images';

-- Table for Score
CREATE TABLE Score (
    score_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    episode_id INT UNSIGNED NOT NULL,
    chef_id INT UNSIGNED NOT NULL,
    judge_chef_id INT UNSIGNED NOT NULL,
    score INT CHECK (score BETWEEN 1 AND 5),
    last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (score_id),
    UNIQUE KEY idx_score_episode_chef_judge (episode_id, chef_id, judge_chef_id),
    KEY idx_fk_episode_id (episode_id),
    KEY idx_fk_chef_id (chef_id),
    KEY idx_fk_judge_chef_id (judge_chef_id),
    CONSTRAINT fk_score_episode FOREIGN KEY (episode_id) REFERENCES Episode(episode_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_score_chef FOREIGN KEY (chef_id) REFERENCES Chef(chef_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_score_judge_chef FOREIGN KEY (judge_chef_id) REFERENCES JudgeChef(judge_chef_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Table for scores';

-- Table for Cuisine
CREATE TABLE Cuisine (
    cuisine_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (cuisine_id),
    UNIQUE KEY idx_cuisine_name (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Table for cuisines';

-- Relationship tables

-- Includes (Recipe and Ingredient)
CREATE TABLE Recipe_Ingredient (
    recipe_id INT UNSIGNED NOT NULL,
    ingredient_id INT UNSIGNED NOT NULL,
    last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (recipe_id, ingredient_id),
    KEY idx_fk_recipe_id (recipe_id),
    KEY idx_fk_ingredient_id (ingredient_id),
    CONSTRAINT fk_recipe_ingredient_recipe FOREIGN KEY (recipe_id) REFERENCES Recipe(recipe_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_recipe_ingredient_ingredient FOREIGN KEY (ingredient_id) REFERENCES Ingredient(ingredient_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Relationship table for Recipe and Ingredient';

-- Requires (Recipe and Equipment)
CREATE TABLE Recipe_Equipment (
    recipe_id INT UNSIGNED NOT NULL,
    equipment_id INT UNSIGNED NOT NULL,
    last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (recipe_id, equipment_id),
    KEY idx_fk_recipe_id (recipe_id),
    KEY idx_fk_equipment_id (equipment_id),
    CONSTRAINT fk_recipe_equipment_recipe FOREIGN KEY (recipe_id) REFERENCES Recipe(recipe_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_recipe_equipment_equipment FOREIGN KEY (equipment_id) REFERENCES Equipment(equipment_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Relationship table for Recipe and Equipment';

-- PreparedBy (Recipe and Chef)
CREATE TABLE Recipe_Chef (
    recipe_id INT UNSIGNED NOT NULL,
    chef_id INT UNSIGNED NOT NULL,
    last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (recipe_id, chef_id),
    KEY idx_fk_recipe_id (recipe_id),
    KEY idx_fk_chef_id (chef_id),
    CONSTRAINT fk_recipe_chef_recipe FOREIGN KEY (recipe_id) REFERENCES Recipe(recipe_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_recipe_chef_chef FOREIGN KEY (chef_id) REFERENCES Chef(chef_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Relationship table for Recipe and Chef';

-- BelongsTo (Recipe and Theme)
CREATE TABLE Recipe_Theme (
    recipe_id INT UNSIGNED NOT NULL,
    theme_id INT UNSIGNED NOT NULL,
    last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (recipe_id, theme_id),
    KEY idx_fk_recipe_id (recipe_id),
    KEY idx_fk_theme_id (theme_id),
    CONSTRAINT fk_recipe_theme_recipe FOREIGN KEY (recipe_id) REFERENCES Recipe(recipe_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_recipe_theme_theme FOREIGN KEY (theme_id) REFERENCES Theme(theme_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Relationship table for Recipe and Theme';

-- SpecializesIn (Chef and Cuisine)
CREATE TABLE Chef_Cuisine (
    chef_id INT UNSIGNED NOT NULL,
    cuisine_id INT UNSIGNED NOT NULL,
    last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (chef_id, cuisine_id),
    KEY idx_fk_chef_id (chef_id),
    KEY idx_fk_cuisine_id (cuisine_id),
    CONSTRAINT fk_chef_cuisine_chef FOREIGN KEY (chef_id) REFERENCES Chef(chef_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_chef_cuisine_cuisine FOREIGN KEY (cuisine_id) REFERENCES Cuisine(cuisine_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Relationship table for Chef and Cuisine';

-- Features (Episode and Recipe)
CREATE TABLE Episode_Recipe (
    episode_id INT UNSIGNED NOT NULL,
    recipe_id INT UNSIGNED NOT NULL,
    last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (episode_id, recipe_id),
    KEY idx_fk_episode_id (episode_id),
    KEY idx_fk_recipe_id (recipe_id),
    CONSTRAINT fk_episode_recipe_episode FOREIGN KEY (episode_id) REFERENCES Episode(episode_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_episode_recipe_recipe FOREIGN KEY (recipe_id) REFERENCES Recipe(recipe_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Relationship table for Episode and Recipe';

-- Includes (Episode and Chef)
CREATE TABLE Episode_Chef (
    episode_id INT UNSIGNED NOT NULL,
    chef_id INT UNSIGNED NOT NULL,
    last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (episode_id, chef_id),
    KEY idx_fk_episode_id (episode_id),
    KEY idx_fk_chef_id (chef_id),
    CONSTRAINT fk_episode_chef_episode FOREIGN KEY (episode_id) REFERENCES Episode(episode_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_episode_chef_chef FOREIGN KEY (chef_id) REFERENCES Chef(chef_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Relationship table for Episode and Chef';

-- JudgedBy (Episode and JudgeChef)
CREATE TABLE Episode_JudgeChef (
    episode_id INT UNSIGNED NOT NULL,
    judge_chef_id INT UNSIGNED NOT NULL,
    last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (episode_id, judge_chef_id),
    KEY idx_fk_episode_id (episode_id),
    KEY idx_fk_judge_chef_id (judge_chef_id),
    CONSTRAINT fk_episode_judge_chef_episode FOREIGN KEY (episode_id) REFERENCES Episode(episode_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_episode_judge_chef_judge_chef FOREIGN KEY (judge_chef_id) REFERENCES JudgeChef(judge_chef_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Relationship table for Episode and JudgeChef';

-- HasImage (Entity and Image)
CREATE TABLE Entity_Image (
    entity_type ENUM('food_group', 'ingredient', 'recipe', 'equipment', 'chef', 'judge_chef', 'episode', 'theme') NOT NULL,
    entity_id INT UNSIGNED NOT NULL,
    image_id INT UNSIGNED NOT NULL,
    last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (entity_type, entity_id, image_id),
    KEY idx_fk_image_id (image_id),
    CONSTRAINT fk_entity_image_image FOREIGN KEY (image_id) REFERENCES Image(image_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Relationship table for entities and images';

-- Manages (User and Entity)
CREATE TABLE User_Entity (
    user_id INT UNSIGNED NOT NULL,
    entity_type ENUM('food_group', 'ingredient', 'recipe', 'equipment', 'chef', 'judge_chef', 'episode', 'theme') NOT NULL,
    entity_id INT UNSIGNED NOT NULL,
    last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, entity_type, entity_id),
    KEY idx_fk_user_id (user_id),
    CONSTRAINT fk_user_entity_user FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Relationship table for users and entities';

-- CategorizedBy (Ingredient and FoodGroup)
CREATE TABLE Ingredient_FoodGroup (
    ingredient_id INT UNSIGNED NOT NULL,
    food_group_id INT UNSIGNED NOT NULL,
    last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (ingredient_id, food_group_id),
    KEY idx_fk_ingredient_id (ingredient_id),
    KEY idx_fk_food_group_id (food_group_id),
    CONSTRAINT fk_ingredient_food_group_ingredient FOREIGN KEY (ingredient_id) REFERENCES Ingredient(ingredient_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_ingredient_food_group_food_group FOREIGN KEY (food_group_id) REFERENCES FoodGroup(food_group_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Relationship table for Ingredient and FoodGroup';

-- Reset SQL modes and foreign key checks
SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
