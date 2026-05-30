-- ==============================================================================
-- SEED DATA UNTUK DHAHARAN_DB
-- Pastikan database dhaharan_db sudah dibuat dan struktur tabel sudah di-import.
-- ==============================================================================

USE dhaharan_db;

-- Menonaktifkan foreign key checks sementara agar proses seeding lebih aman
SET FOREIGN_KEY_CHECKS = 0;

-- Membersihkan data lama (opsional, untuk memastikan data fresh)
TRUNCATE TABLE recipe_step_images;
TRUNCATE TABLE recipe_steps;
TRUNCATE TABLE ingredients;
TRUNCATE TABLE ingredient_groups;
TRUNCATE TABLE recipes;
TRUNCATE TABLE categories;
TRUNCATE TABLE users;

SET FOREIGN_KEY_CHECKS = 1;


-- =========================
-- SEED USERS (1 Admin, 2 User)
-- Password hash menggunakan ('password')
-- =========================
INSERT INTO users
(
    id,
    NAME,
    email,
    password_hash,
    phone,
    bio,
    ROLE,
    is_active
)
VALUES

(
    1,
    'Administrator',
    'admin@dhaharan.com',
    '$2b$12$HatWhcpp0yRFyyhsb0G5YeE8lfRIaNDVDJ/j5Q1iIjb6UwC6mCSbG',
    '081111111111',
    'System administrator Dhaharan',
    'admin',
    TRUE
),

(
    2,
    'Budi Santoso',
    'budi@example.com',
    '$2b$12$HatWhcpp0yRFyyhsb0G5YeE8lfRIaNDVDJ/j5Q1iIjb6UwC6mCSbG',
    '082222222222',
    'Pecinta masakan nusantara dan makanan rumahan.',
    'user',
    TRUE
),

(
    3,
    'Siti Aminah',
    'siti@example.com',
    '$2b$12$HatWhcpp0yRFyyhsb0G5YeE8lfRIaNDVDJ/j5Q1iIjb6UwC6mCSbG',
    '083333333333',
    'Food creator yang gemar membagikan resep keluarga.',
    'user',
    TRUE
);

INSERT INTO categories
(id, NAME)
VALUES

(1,'Nasi'),
(2,'Mie'),
(3,'Ayam'),
(4,'Daging'),
(5,'Seafood'),
(6,'Sayuran'),
(7,'Sup'),
(8,'Sambal'),
(9,'Minuman'),
(10,'Dessert'),
(11,'Cemilan'),
(12,'Sarapan');

INSERT INTO recipes
(
    id,
    user_id,
    category_id,
    title,
    DESCRIPTION,
    cook_time,
    servings,
    estimated_cost,
    contains_pork,
    contains_alcohol,
    cover_image,
    STATUS
)
VALUES

(
    1,
    1,
    1,
    'Nasi Goreng Kampung',
    'Nasi goreng tradisional dengan bumbu sederhana dan cita rasa khas Indonesia.',
    20,
    2,
    25000,
    FALSE,
    FALSE,
    'uploads/covers/nasi-goreng-kampung.jpg',
    'public'
),

(
    2,
    1,
    7,
    'Soto Ayam Lamongan',
    'Soto ayam berkuah kuning dengan taburan koya gurih.',
    60,
    4,
    45000,
    FALSE,
    FALSE,
    'uploads/covers/soto-ayam-lamongan.jpg',
    'public'
),

(
    3,
    1,
    9,
    'Es Teh Lemon',
    'Minuman segar perpaduan teh dan lemon.',
    10,
    2,
    12000,
    FALSE,
    FALSE,
    'uploads/covers/es-teh-lemon.jpg',
    'public'
),

(
    4,
    1,
    11,
    'Pisang Goreng Crispy',
    'Pisang goreng renyah dengan lapisan tepung crispy.',
    20,
    4,
    18000,
    FALSE,
    FALSE,
    'uploads/covers/pisang-goreng-crispy.jpg',
    'public'
),

(
    5,
    1,
    6,
    'Capcay Kuah',
    'Capcay kuah sehat berisi aneka sayuran segar.',
    35,
    4,
    35000,
    FALSE,
    FALSE,
    'uploads/covers/capcay-kuah.jpg',
    'pending'
);

INSERT INTO recipes
(
    id,
    user_id,
    category_id,
    title,
    DESCRIPTION,
    cook_time,
    servings,
    estimated_cost,
    contains_pork,
    contains_alcohol,
    cover_image,
    STATUS
)
VALUES

(
    6,
    2,
    2,
    'Mie Goreng Jawa',
    'Mie goreng manis gurih khas Jawa dengan telur dan sayuran.',
    25,
    2,
    22000,
    FALSE,
    FALSE,
    'uploads/covers/mie-goreng-jawa.jpg',
    'public'
),

(
    7,
    2,
    3,
    'Ayam Bakar Kecap',
    'Ayam bakar dengan bumbu kecap manis dan rempah pilihan.',
    50,
    4,
    50000,
    FALSE,
    FALSE,
    'uploads/covers/ayam-bakar-kecap.jpg',
    'public'
),

(
    8,
    2,
    7,
    'Sup Jagung Ayam',
    'Sup jagung dengan suwiran ayam yang gurih dan hangat.',
    40,
    4,
    30000,
    FALSE,
    FALSE,
    'uploads/covers/sup-jagung-ayam.jpg',
    'public'
),

(
    9,
    2,
    8,
    'Sambal Matah',
    'Sambal khas Bali dengan aroma serai dan daun jeruk.',
    15,
    4,
    10000,
    FALSE,
    FALSE,
    'uploads/covers/sambal-matah.jpg',
    'pending'
),

(
    10,
    2,
    10,
    'Puding Cokelat',
    'Dessert cokelat lembut yang disukai segala usia.',
    120,
    6,
    25000,
    FALSE,
    FALSE,
    'uploads/covers/puding-cokelat.jpg',
    'public'
);

INSERT INTO recipes
(
    id,
    user_id,
    category_id,
    title,
    DESCRIPTION,
    cook_time,
    servings,
    estimated_cost,
    contains_pork,
    contains_alcohol,
    cover_image,
    STATUS
)
VALUES

(
    11,
    3,
    5,
    'Udang Saus Padang',
    'Udang segar dengan saus pedas manis khas Padang.',
    40,
    3,
    65000,
    FALSE,
    FALSE,
    'uploads/covers/udang-saus-padang.jpg',
    'public'
),

(
    12,
    3,
    4,
    'Rendang Sapi',
    'Masakan khas Minang dengan rempah yang kaya rasa.',
    180,
    6,
    120000,
    FALSE,
    FALSE,
    'uploads/covers/rendang-sapi.jpg',
    'public'
),

(
    13,
    3,
    12,
    'Bubur Ayam',
    'Menu sarapan bubur ayam lengkap dengan pelengkap tradisional.',
    45,
    4,
    35000,
    FALSE,
    FALSE,
    'uploads/covers/bubur-ayam.jpg',
    'public'
),

(
    14,
    3,
    11,
    'Bakwan Sayur',
    'Gorengan sayur renyah cocok untuk camilan keluarga.',
    20,
    5,
    15000,
    FALSE,
    FALSE,
    'uploads/covers/bakwan-sayur.jpg',
    'pending'
),

(
    15,
    3,
    9,
    'Es Cincau Gula Aren',
    'Minuman tradisional yang menyegarkan dengan gula aren.',
    15,
    3,
    12000,
    FALSE,
    FALSE,
    'uploads/covers/es-cincau-gula-aren.jpg',
    'public'
);

INSERT INTO ingredient_groups
(
    id,
    recipe_id,
    NAME,
    sort_order
)
VALUES

-- =====================================
-- Recipe 1 : Nasi Goreng Kampung
-- =====================================
(1,1,'Bahan Utama',1),
(2,1,'Bumbu Halus',2),

-- =====================================
-- Recipe 2 : Soto Ayam Lamongan
-- =====================================
(3,2,'Bahan Soto',1),
(4,2,'Bumbu Halus',2),
(5,2,'Pelengkap',3),

-- =====================================
-- Recipe 3 : Es Teh Lemon
-- =====================================
(6,3,'Bahan Minuman',1),

-- =====================================
-- Recipe 4 : Pisang Goreng Crispy
-- =====================================
(7,4,'Bahan Utama',1),
(8,4,'Adonan Tepung',2),

-- =====================================
-- Recipe 5 : Capcay Kuah
-- =====================================
(9,5,'Bahan Utama',1),
(10,5,'Bumbu Tumisan',2),

-- =====================================
-- Recipe 6 : Mie Goreng Jawa
-- =====================================
(11,6,'Bahan Utama',1),
(12,6,'Bumbu Halus',2),

-- =====================================
-- Recipe 7 : Ayam Bakar Kecap
-- =====================================
(13,7,'Bahan Utama',1),
(14,7,'Bumbu Marinasi',2),

-- =====================================
-- Recipe 8 : Sup Jagung Ayam
-- =====================================
(15,8,'Bahan Sup',1),
(16,8,'Bumbu',2),

-- =====================================
-- Recipe 9 : Sambal Matah
-- =====================================
(17,9,'Bahan Sambal',1),

-- =====================================
-- Recipe 10 : Puding Cokelat
-- =====================================
(18,10,'Bahan Puding',1),
(19,10,'Bahan Saus',2),

-- =====================================
-- Recipe 11 : Udang Saus Padang
-- =====================================
(20,11,'Bahan Utama',1),
(21,11,'Bumbu Saus Padang',2),

-- =====================================
-- Recipe 12 : Rendang Sapi
-- =====================================
(22,12,'Bahan Utama',1),
(23,12,'Bumbu Halus',2),
(24,12,'Rempah Tambahan',3),

-- =====================================
-- Recipe 13 : Bubur Ayam
-- =====================================
(25,13,'Bahan Bubur',1),
(26,13,'Bahan Ayam',2),
(27,13,'Pelengkap',3),

-- =====================================
-- Recipe 14 : Bakwan Sayur
-- =====================================
(28,14,'Bahan Sayuran',1),
(29,14,'Adonan Tepung',2),

-- =====================================
-- Recipe 15 : Es Cincau Gula Aren
-- =====================================
(30,15,'Bahan Minuman',1),
(31,15,'Sirup Gula Aren',2),

-- =====================================
-- Tambahan agar data lebih realistis
-- =====================================

(32,5,'Pelengkap',3),
(33,11,'Pelengkap',3);

INSERT INTO ingredients
(
    id,
    group_id,
    NAME,
    quantity,
    unit,
    sort_order
)
VALUES

-- =====================================================
-- GROUP 1 : Nasi Goreng Kampung - Bahan Utama
-- =====================================================
(1,1,'Nasi putih',2,'piring',1),
(2,1,'Telur ayam',2,'butir',2),
(3,1,'Kol',100,'gram',3),
(4,1,'Daun bawang',2,'batang',4),
(5,1,'Kecap manis',2,'sdm',5),

-- GROUP 2 : Bumbu Halus
(6,2,'Bawang merah',5,'siung',1),
(7,2,'Bawang putih',3,'siung',2),
(8,2,'Cabai merah',3,'buah',3),
(9,2,'Terasi',1,'sdt',4),
(10,2,'Garam',1,'sdt',5),

-- =====================================================
-- GROUP 3 : Soto Ayam - Bahan Soto
-- =====================================================
(11,3,'Ayam',500,'gram',1),
(12,3,'Air',2,'liter',2),
(13,3,'Serai',2,'batang',3),
(14,3,'Daun salam',3,'lembar',4),
(15,3,'Daun jeruk',4,'lembar',5),

-- GROUP 4 : Bumbu Halus
(16,4,'Bawang merah',8,'siung',1),
(17,4,'Bawang putih',5,'siung',2),
(18,4,'Kemiri',4,'butir',3),
(19,4,'Kunyit',3,'cm',4),
(20,4,'Jahe',2,'cm',5),

-- GROUP 5 : Pelengkap
(21,5,'Tauge',100,'gram',1),
(22,5,'Telur rebus',4,'butir',2),
(23,5,'Koya',50,'gram',3),
(24,5,'Seledri',2,'batang',4),

-- =====================================================
-- GROUP 6 : Es Teh Lemon
-- =====================================================
(25,6,'Teh celup',2,'kantong',1),
(26,6,'Air panas',500,'ml',2),
(27,6,'Lemon',1,'buah',3),
(28,6,'Gula pasir',3,'sdm',4),
(29,6,'Es batu',1,'gelas',5),

-- =====================================================
-- GROUP 7 : Pisang Goreng
-- =====================================================
(30,7,'Pisang kepok',6,'buah',1),

-- GROUP 8 : Adonan
(31,8,'Tepung terigu',200,'gram',1),
(32,8,'Tepung beras',50,'gram',2),
(33,8,'Gula pasir',2,'sdm',3),
(34,8,'Garam',1,'sdt',4),
(35,8,'Air',250,'ml',5),

-- =====================================================
-- GROUP 9 : Capcay
-- =====================================================
(36,9,'Wortel',1,'buah',1),
(37,9,'Kembang kol',150,'gram',2),
(38,9,'Sawi putih',150,'gram',3),
(39,9,'Bakso sapi',8,'butir',4),
(40,9,'Udang',100,'gram',5),

-- GROUP 10 : Bumbu Tumisan
(41,10,'Bawang putih',4,'siung',1),
(42,10,'Bawang bombay',1,'buah',2),
(43,10,'Saus tiram',2,'sdm',3),
(44,10,'Kecap asin',1,'sdm',4),

-- GROUP 32 : Pelengkap
(45,32,'Daun bawang',2,'batang',1),
(46,32,'Bawang goreng',2,'sdm',2),

-- =====================================================
-- GROUP 11 : Mie Goreng Jawa
-- =====================================================
(47,11,'Mie telur',250,'gram',1),
(48,11,'Telur ayam',2,'butir',2),
(49,11,'Kol',100,'gram',3),
(50,11,'Daun bawang',2,'batang',4),

-- GROUP 12 : Bumbu
(51,12,'Bawang merah',5,'siung',1),
(52,12,'Bawang putih',3,'siung',2),
(53,12,'Cabai merah',2,'buah',3),
(54,12,'Kecap manis',3,'sdm',4),

-- =====================================================
-- GROUP 13 : Ayam Bakar
-- =====================================================
(55,13,'Ayam potong',1,'ekor',1),

-- GROUP 14 : Marinasi
(56,14,'Kecap manis',5,'sdm',1),
(57,14,'Bawang putih',5,'siung',2),
(58,14,'Ketumbar',1,'sdt',3),
(59,14,'Garam',1,'sdt',4),

-- =====================================================
-- GROUP 15 : Sup Jagung
-- =====================================================
(60,15,'Jagung manis',2,'buah',1),
(61,15,'Dada ayam',200,'gram',2),
(62,15,'Air',1500,'ml',3),
(63,15,'Wortel',1,'buah',4),

-- GROUP 16 : Bumbu
(64,16,'Bawang putih',3,'siung',1),
(65,16,'Merica',1,'sdt',2),
(66,16,'Garam',1,'sdt',3),

-- =====================================================
-- GROUP 17 : Sambal Matah
-- =====================================================
(67,17,'Bawang merah',10,'siung',1),
(68,17,'Cabai rawit',15,'buah',2),
(69,17,'Serai',2,'batang',3),
(70,17,'Daun jeruk',5,'lembar',4),
(71,17,'Minyak panas',100,'ml',5),

-- =====================================================
-- GROUP 18 : Puding
-- =====================================================
(72,18,'Agar-agar cokelat',1,'bungkus',1),
(73,18,'Susu cair',500,'ml',2),
(74,18,'Gula pasir',100,'gram',3),

-- GROUP 19 : Saus
(75,19,'Dark chocolate',100,'gram',1),
(76,19,'Susu cair',100,'ml',2),

-- =====================================================
-- GROUP 20 : Udang Saus Padang
-- =====================================================
(77,20,'Udang',500,'gram',1),

-- GROUP 21 : Saus Padang
(78,21,'Bawang merah',6,'siung',1),
(79,21,'Bawang putih',4,'siung',2),
(80,21,'Cabai merah',5,'buah',3),
(81,21,'Saus tomat',3,'sdm',4),
(82,21,'Saus sambal',3,'sdm',5),

-- GROUP 33 : Pelengkap
(83,33,'Daun bawang',2,'batang',1),
(84,33,'Bawang goreng',2,'sdm',2),

-- =====================================================
-- GROUP 22 : Rendang
-- =====================================================
(85,22,'Daging sapi',1,'kg',1),
(86,22,'Santan',1500,'ml',2),

-- GROUP 23 : Bumbu Halus
(87,23,'Bawang merah',12,'siung',1),
(88,23,'Bawang putih',6,'siung',2),
(89,23,'Cabai merah',10,'buah',3),
(90,23,'Jahe',3,'cm',4),
(91,23,'Lengkuas',4,'cm',5),

-- GROUP 24 : Rempah
(92,24,'Daun salam',4,'lembar',1),
(93,24,'Daun jeruk',5,'lembar',2),
(94,24,'Serai',3,'batang',3),

-- =====================================================
-- GROUP 25 : Bubur Ayam
-- =====================================================
(95,25,'Beras',250,'gram',1),
(96,25,'Air',2,'liter',2),

-- GROUP 26 : Ayam
(97,26,'Dada ayam',300,'gram',1),
(98,26,'Kecap manis',2,'sdm',2),
(99,26,'Bawang putih',3,'siung',3),

-- GROUP 27 : Pelengkap
(100,27,'Cakwe',2,'buah',1),
(101,27,'Daun bawang',2,'batang',2),
(102,27,'Bawang goreng',3,'sdm',3),

-- =====================================================
-- GROUP 28 : Bakwan Sayur
-- =====================================================
(103,28,'Wortel',1,'buah',1),
(104,28,'Kol',100,'gram',2),
(105,28,'Tauge',100,'gram',3),

-- GROUP 29 : Adonan
(106,29,'Tepung terigu',200,'gram',1),
(107,29,'Bawang putih',3,'siung',2),
(108,29,'Garam',1,'sdt',3),
(109,29,'Air',250,'ml',4),

-- =====================================================
-- GROUP 30 : Es Cincau
-- =====================================================
(110,30,'Cincau hitam',200,'gram',1),
(111,30,'Es batu',1,'gelas',2),
(112,30,'Santan',200,'ml',3),

-- GROUP 31 : Sirup
(113,31,'Gula aren',150,'gram',1),
(114,31,'Air',200,'ml',2),
(115,31,'Daun pandan',2,'lembar',3);

INSERT INTO recipe_steps
(
    id,
    recipe_id,
    step_number,
    instruction
)
VALUES

-- =====================================================
-- RECIPE 1 : Nasi Goreng Kampung
-- =====================================================
(1,1,1,'Haluskan seluruh bumbu halus hingga merata.'),
(2,1,2,'Panaskan minyak lalu tumis bumbu hingga harum.'),
(3,1,3,'Masukkan telur dan orak-arik hingga matang.'),
(4,1,4,'Tambahkan kol, daun bawang, dan nasi putih lalu aduk rata.'),
(5,1,5,'Tambahkan kecap manis kemudian masak hingga bumbu meresap dan sajikan.'),

-- =====================================================
-- RECIPE 2 : Soto Ayam Lamongan
-- =====================================================
(6,2,1,'Rebus ayam hingga matang lalu angkat dan suwir-suwir.'),
(7,2,2,'Haluskan bumbu kemudian tumis hingga harum.'),
(8,2,3,'Masukkan bumbu tumis ke dalam kaldu ayam.'),
(9,2,4,'Tambahkan serai, daun salam, dan daun jeruk lalu masak hingga mendidih.'),
(10,2,5,'Sajikan bersama ayam suwir, tauge, telur rebus, dan koya.'),

-- =====================================================
-- RECIPE 3 : Es Teh Lemon
-- =====================================================
(11,3,1,'Seduh teh dengan air panas selama beberapa menit.'),
(12,3,2,'Tambahkan gula pasir lalu aduk hingga larut.'),
(13,3,3,'Peras lemon dan campurkan ke dalam teh.'),
(14,3,4,'Masukkan es batu ke dalam gelas.'),
(15,3,5,'Tuang teh lemon dan sajikan dingin.'),

-- =====================================================
-- RECIPE 4 : Pisang Goreng Crispy
-- =====================================================
(16,4,1,'Kupas dan potong pisang sesuai selera.'),
(17,4,2,'Campurkan seluruh bahan adonan hingga rata.'),
(18,4,3,'Celupkan pisang ke dalam adonan.'),
(19,4,4,'Goreng dalam minyak panas hingga kuning keemasan.'),
(20,4,5,'Tiriskan lalu sajikan selagi hangat.'),

-- =====================================================
-- RECIPE 5 : Capcay Kuah
-- =====================================================
(21,5,1,'Potong seluruh sayuran dan siapkan bahan lainnya.'),
(22,5,2,'Tumis bawang putih dan bawang bombay hingga harum.'),
(23,5,3,'Masukkan bakso, udang, dan seluruh sayuran.'),
(24,5,4,'Tambahkan air, saus tiram, dan kecap asin kemudian masak hingga matang.'),
(25,5,5,'Taburi daun bawang dan bawang goreng sebelum disajikan.'),

-- =====================================================
-- RECIPE 6 : Mie Goreng Jawa
-- =====================================================
(26,6,1,'Haluskan bumbu kemudian tumis hingga harum.'),
(27,6,2,'Masukkan telur lalu buat orak-arik.'),
(28,6,3,'Tambahkan kol dan daun bawang.'),
(29,6,4,'Masukkan mie dan kecap manis lalu aduk rata.'),
(30,6,5,'Masak hingga matang lalu sajikan.'),

-- =====================================================
-- RECIPE 7 : Ayam Bakar Kecap
-- =====================================================
(31,7,1,'Campurkan ayam dengan seluruh bahan marinasi.'),
(32,7,2,'Diamkan ayam selama 30 menit agar bumbu meresap.'),
(33,7,3,'Panggang ayam hingga setengah matang.'),
(34,7,4,'Olesi kembali dengan sisa bumbu marinasi.'),
(35,7,5,'Panggang hingga matang dan berwarna kecokelatan.'),

-- =====================================================
-- RECIPE 8 : Sup Jagung Ayam
-- =====================================================
(36,8,1,'Rebus ayam hingga matang kemudian suwir-suwir.'),
(37,8,2,'Tumis bawang putih hingga harum.'),
(38,8,3,'Masukkan jagung, wortel, dan air kaldu.'),
(39,8,4,'Tambahkan ayam suwir lalu masak hingga sayuran empuk.'),
(40,8,5,'Bumbui dengan garam dan merica lalu sajikan.'),

-- =====================================================
-- RECIPE 9 : Sambal Matah
-- =====================================================
(41,9,1,'Iris tipis bawang merah, cabai, serai, dan daun jeruk.'),
(42,9,2,'Campurkan seluruh bahan dalam mangkuk.'),
(43,9,3,'Panaskan minyak hingga benar-benar panas.'),
(44,9,4,'Siram minyak panas ke atas campuran bahan sambal.'),
(45,9,5,'Aduk rata lalu sajikan.'),

-- =====================================================
-- RECIPE 10 : Puding Cokelat
-- =====================================================
(46,10,1,'Campurkan agar-agar, susu, dan gula dalam panci.'),
(47,10,2,'Masak hingga mendidih sambil terus diaduk.'),
(48,10,3,'Tuang ke dalam cetakan lalu dinginkan.'),
(49,10,4,'Lelehkan dark chocolate bersama susu untuk membuat saus.'),
(50,10,5,'Sajikan puding bersama saus cokelat.'),

-- =====================================================
-- RECIPE 11 : Udang Saus Padang
-- =====================================================
(51,11,1,'Bersihkan udang lalu sisihkan.'),
(52,11,2,'Tumis seluruh bumbu saus hingga harum.'),
(53,11,3,'Tambahkan saus tomat dan saus sambal.'),
(54,11,4,'Masukkan udang lalu masak hingga matang.'),
(55,11,5,'Taburi daun bawang dan sajikan.'),

-- =====================================================
-- RECIPE 12 : Rendang Sapi
-- =====================================================
(56,12,1,'Haluskan seluruh bumbu halus.'),
(57,12,2,'Tumis bumbu hingga harum lalu masukkan santan dan rempah.'),
(58,12,3,'Masukkan daging sapi kemudian aduk rata.'),
(59,12,4,'Masak dengan api kecil sambil sesekali diaduk.'),
(60,12,5,'Masak hingga kuah menyusut dan rendang menghitam.'),

-- =====================================================
-- RECIPE 13 : Bubur Ayam
-- =====================================================
(61,13,1,'Masak beras bersama air hingga menjadi bubur.'),
(62,13,2,'Tumis bawang putih lalu masukkan ayam.'),
(63,13,3,'Tambahkan kecap manis dan masak hingga ayam matang.'),
(64,13,4,'Suwir ayam dan siapkan seluruh pelengkap.'),
(65,13,5,'Sajikan bubur bersama ayam dan pelengkap.'),

-- =====================================================
-- RECIPE 14 : Bakwan Sayur
-- =====================================================
(66,14,1,'Iris seluruh sayuran tipis-tipis.'),
(67,14,2,'Campurkan bahan adonan hingga rata.'),
(68,14,3,'Masukkan sayuran ke dalam adonan.'),
(69,14,4,'Goreng satu sendok demi satu sendok hingga kecokelatan.'),
(70,14,5,'Tiriskan lalu sajikan hangat.'),

-- =====================================================
-- RECIPE 15 : Es Cincau Gula Aren
-- =====================================================
(71,15,1,'Masak gula aren, air, dan daun pandan hingga larut.'),
(72,15,2,'Dinginkan sirup gula aren.'),
(73,15,3,'Potong cincau menjadi dadu kecil.'),
(74,15,4,'Masukkan cincau, santan, dan es batu ke dalam gelas.'),
(75,15,5,'Tuang sirup gula aren lalu sajikan.');

INSERT INTO recipe_step_images
(
    id,
    step_id,
    image_url,
    sort_order
)
VALUES

-- RECIPE 1
(1,1,'uploads/steps/recipe-1-step-1.jpg',1),
(2,2,'uploads/steps/recipe-1-step-2.jpg',1),
(3,3,'uploads/steps/recipe-1-step-3.jpg',1),
(4,4,'uploads/steps/recipe-1-step-4.jpg',1),
(5,5,'uploads/steps/recipe-1-step-5.jpg',1),

-- RECIPE 2
(6,6,'uploads/steps/recipe-2-step-1.jpg',1),
(7,7,'uploads/steps/recipe-2-step-2.jpg',1),
(8,8,'uploads/steps/recipe-2-step-3.jpg',1),
(9,9,'uploads/steps/recipe-2-step-4.jpg',1),
(10,10,'uploads/steps/recipe-2-step-5.jpg',1),

-- RECIPE 3
(11,11,'uploads/steps/recipe-3-step-1.jpg',1),
(12,12,'uploads/steps/recipe-3-step-2.jpg',1),
(13,13,'uploads/steps/recipe-3-step-3.jpg',1),
(14,14,'uploads/steps/recipe-3-step-4.jpg',1),
(15,15,'uploads/steps/recipe-3-step-5.jpg',1),

-- RECIPE 4
(16,16,'uploads/steps/recipe-4-step-1.jpg',1),
(17,17,'uploads/steps/recipe-4-step-2.jpg',1),
(18,18,'uploads/steps/recipe-4-step-3.jpg',1),
(19,19,'uploads/steps/recipe-4-step-4.jpg',1),
(20,20,'uploads/steps/recipe-4-step-5.jpg',1),

-- RECIPE 5
(21,21,'uploads/steps/recipe-5-step-1.jpg',1),
(22,22,'uploads/steps/recipe-5-step-2.jpg',1),
(23,23,'uploads/steps/recipe-5-step-3.jpg',1),
(24,24,'uploads/steps/recipe-5-step-4.jpg',1),
(25,25,'uploads/steps/recipe-5-step-5.jpg',1),

-- RECIPE 6
(26,26,'uploads/steps/recipe-6-step-1.jpg',1),
(27,27,'uploads/steps/recipe-6-step-2.jpg',1),
(28,28,'uploads/steps/recipe-6-step-3.jpg',1),
(29,29,'uploads/steps/recipe-6-step-4.jpg',1),
(30,30,'uploads/steps/recipe-6-step-5.jpg',1),

-- RECIPE 7
(31,31,'uploads/steps/recipe-7-step-1.jpg',1),
(32,32,'uploads/steps/recipe-7-step-2.jpg',1),
(33,33,'uploads/steps/recipe-7-step-3.jpg',1),
(34,34,'uploads/steps/recipe-7-step-4.jpg',1),
(35,35,'uploads/steps/recipe-7-step-5.jpg',1),

-- RECIPE 8
(36,36,'uploads/steps/recipe-8-step-1.jpg',1),
(37,37,'uploads/steps/recipe-8-step-2.jpg',1),
(38,38,'uploads/steps/recipe-8-step-3.jpg',1),
(39,39,'uploads/steps/recipe-8-step-4.jpg',1),
(40,40,'uploads/steps/recipe-8-step-5.jpg',1),

-- RECIPE 9
(41,41,'uploads/steps/recipe-9-step-1.jpg',1),
(42,42,'uploads/steps/recipe-9-step-2.jpg',1),
(43,43,'uploads/steps/recipe-9-step-3.jpg',1),
(44,44,'uploads/steps/recipe-9-step-4.jpg',1),
(45,45,'uploads/steps/recipe-9-step-5.jpg',1),

-- RECIPE 10
(46,46,'uploads/steps/recipe-10-step-1.jpg',1),
(47,47,'uploads/steps/recipe-10-step-2.jpg',1),
(48,48,'uploads/steps/recipe-10-step-3.jpg',1),
(49,49,'uploads/steps/recipe-10-step-4.jpg',1),
(50,50,'uploads/steps/recipe-10-step-5.jpg',1),

-- RECIPE 11
(51,51,'uploads/steps/recipe-11-step-1.jpg',1),
(52,52,'uploads/steps/recipe-11-step-2.jpg',1),
(53,53,'uploads/steps/recipe-11-step-3.jpg',1),
(54,54,'uploads/steps/recipe-11-step-4.jpg',1),
(55,55,'uploads/steps/recipe-11-step-5.jpg',1),

-- RECIPE 12
(56,56,'uploads/steps/recipe-12-step-1.jpg',1),
(57,57,'uploads/steps/recipe-12-step-2.jpg',1),
(58,58,'uploads/steps/recipe-12-step-3.jpg',1),
(59,59,'uploads/steps/recipe-12-step-4.jpg',1),
(60,60,'uploads/steps/recipe-12-step-5.jpg',1),

-- RECIPE 13
(61,61,'uploads/steps/recipe-13-step-1.jpg',1),
(62,62,'uploads/steps/recipe-13-step-2.jpg',1),
(63,63,'uploads/steps/recipe-13-step-3.jpg',1),
(64,64,'uploads/steps/recipe-13-step-4.jpg',1),
(65,65,'uploads/steps/recipe-13-step-5.jpg',1),

-- RECIPE 14
(66,66,'uploads/steps/recipe-14-step-1.jpg',1),
(67,67,'uploads/steps/recipe-14-step-2.jpg',1),
(68,68,'uploads/steps/recipe-14-step-3.jpg',1),
(69,69,'uploads/steps/recipe-14-step-4.jpg',1),
(70,70,'uploads/steps/recipe-14-step-5.jpg',1),

-- RECIPE 15
(71,71,'uploads/steps/recipe-15-step-1.jpg',1),
(72,72,'uploads/steps/recipe-15-step-2.jpg',1),
(73,73,'uploads/steps/recipe-15-step-3.jpg',1),
(74,74,'uploads/steps/recipe-15-step-4.jpg',1),
(75,75,'uploads/steps/recipe-15-step-5.jpg',1);