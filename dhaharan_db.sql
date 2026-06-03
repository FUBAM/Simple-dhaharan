DROP DATABASE IF EXISTS dhaharan_db;
CREATE DATABASE dhaharan_db;
USE dhaharan_db;

-- =========================
-- USERS
-- ==============A===========

CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,

    NAME VARCHAR(100) NOT NULL,

    email VARCHAR(100) NOT NULL UNIQUE,

    password_hash VARCHAR(255) NOT NULL,

    phone VARCHAR(30) NULL,

    bio TEXT NULL,

    ROLE ENUM('admin', 'user')
    DEFAULT 'user',

    is_active BOOLEAN
    DEFAULT TRUE,

    created_at TIMESTAMP
    DEFAULT CURRENT_TIMESTAMP
);

-- =========================
-- CATEGORIES
-- =========================

CREATE TABLE categories (
    id INT PRIMARY KEY AUTO_INCREMENT,

    NAME VARCHAR(100) NOT NULL,

    created_at TIMESTAMP
    DEFAULT CURRENT_TIMESTAMP
);

-- =========================
-- RECIPES
-- =========================

CREATE TABLE recipes (
    id INT PRIMARY KEY AUTO_INCREMENT,

    user_id INT NOT NULL,

    category_id INT NULL,

    title VARCHAR(255) NOT NULL,

    DESCRIPTION TEXT NULL,

    cook_time INT NULL,

    servings INT NULL,

    estimated_cost INT NULL,

    contains_pork BOOLEAN
    DEFAULT FALSE,

    contains_alcohol BOOLEAN
    DEFAULT FALSE,

    cover_image VARCHAR(255) NULL,

    STATUS ENUM(
        'private',
        'pending',
        'public',
        'rejected'
    ) DEFAULT 'private',

    created_at TIMESTAMP
    DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP
    DEFAULT CURRENT_TIMESTAMP
    ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_recipe_user
    FOREIGN KEY (user_id)
    REFERENCES users(id)
    ON DELETE CASCADE,

    CONSTRAINT fk_recipe_category
    FOREIGN KEY (category_id)
    REFERENCES categories(id)
    ON DELETE SET NULL
);

CREATE INDEX idx_recipe_user
ON recipes(user_id);

CREATE INDEX idx_recipe_category
ON recipes(category_id);

CREATE INDEX idx_recipe_status
ON recipes(STATUS);

-- =========================
-- INGREDIENT GROUPS
-- =========================

CREATE TABLE ingredient_groups (
    id INT PRIMARY KEY AUTO_INCREMENT,

    recipe_id INT NOT NULL,

    NAME VARCHAR(255) NOT NULL,

    sort_order INT
    DEFAULT 0,

    created_at TIMESTAMP
    DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_group_recipe
    FOREIGN KEY (recipe_id)
    REFERENCES recipes(id)
    ON DELETE CASCADE
);

CREATE INDEX idx_group_recipe
ON ingredient_groups(recipe_id);

-- =========================
-- INGREDIENTS
-- =========================

CREATE TABLE ingredients (
    id INT PRIMARY KEY AUTO_INCREMENT,

    group_id INT NOT NULL,

    NAME VARCHAR(255) NOT NULL,

    quantity VARCHAR(50) NULL,

    unit VARCHAR(50) NULL,

    sort_order INT
    DEFAULT 0,

    created_at TIMESTAMP
    DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_ingredient_group
    FOREIGN KEY (group_id)
    REFERENCES ingredient_groups(id)
    ON DELETE CASCADE
);

CREATE INDEX idx_ingredient_group
ON ingredients(group_id);

-- =========================
-- RECIPE STEPS
-- =========================

CREATE TABLE recipe_steps (
    id INT PRIMARY KEY AUTO_INCREMENT,

    recipe_id INT NOT NULL,

    step_number INT NOT NULL,

    instruction TEXT NOT NULL,

    created_at TIMESTAMP
    DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_step_recipe
    FOREIGN KEY (recipe_id)
    REFERENCES recipes(id)
    ON DELETE CASCADE
);

CREATE INDEX idx_step_recipe
ON recipe_steps(recipe_id);

-- =========================
-- RECIPE STEP IMAGES
-- =========================

CREATE TABLE  recipe_step_images (
    id INT PRIMARY KEY AUTO_INCREMENT,

    step_id INT NOT NULL,

    image_url VARCHAR(255) NOT NULL,

    sort_order INT
    DEFAULT 0,

    created_at TIMESTAMP
    DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_step_image
    FOREIGN KEY (step_id)
    REFERENCES recipe_steps(id)
    ON DELETE CASCADE
);

CREATE INDEX idx_step_image
ON recipe_step_images(step_id);