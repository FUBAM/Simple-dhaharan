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
-- 1. SEED USERS (1 Admin, 2 User)
-- Password hash menggunakan contoh bcrypt standard ('password123')
-- =========================
INSERT INTO users (id, NAME, email, password_hash, phone, bio, ROLE, is_active) VALUES
(1, 'Admin Dhaharan', 'admin@dhaharan.com', '$2b$12$uvS7PGwE7oEv4s2XhRM9wes4UwKvEOc8.bJ2O0cODU4jPacSj4yuy', '081100001111', 'Administrator resmi Dhaharan. Pencinta segala jenis kuliner nusantara.', 'admin', TRUE),
(2, 'Chef Budi Nusantara', 'budi@gmail.com', '$2b$12$uvS7PGwE7oEv4s2XhRM9wes4UwKvEOc8.bJ2O0cODU4jPacSj4yuy', '081233334444', 'Mantan chef hotel yang kini gemar berbagi resep rumahan yang lezat dan mudah.', 'user', TRUE),
(3, 'Ibu Siti Khadijah', 'siti.masak@yahoo.com', '$2b$12$uvS7PGwE7oEv4s2XhRM9wes4UwKvEOc8.bJ2O0cODU4jPacSj4yuy', '081566667777', 'Ibu rumah tangga dengan 3 anak. Resep andalan keluarga turun-temurun.', 'user', TRUE);

-- =========================
-- 2. SEED CATEGORIES (12 Kategori)
-- =========================
INSERT INTO categories (id, NAME) VALUES
(1, 'Makanan Utama'),
(2, 'Makanan Pembuka'),
(3, 'Makanan Penutup'),
(4, 'Sup & Soto'),
(5, 'Jajanan Pasar'),
(6, 'Minuman'),
(7, 'Seafood'),
(8, 'Sayuran'),
(9, 'Daging Sapi'),
(10, 'Daging Ayam'),
(11, 'Mie & Pasta'),
(12, 'Sambal & Saus');

-- =========================
-- 3. SEED RECIPES (15 Resep, masing-masing user 5)
-- =========================
-- Resep dari User 1 (Admin)
INSERT INTO recipes (id, user_id, category_id, title, DESCRIPTION, cook_time, servings, estimated_cost, contains_pork, contains_alcohol, cover_image, STATUS) VALUES
(1, 1, 1, 'Nasi Goreng Spesial Dhaharan', 'Nasi goreng khas nusantara dengan bumbu rahasia yang kaya rempah.', 20, 2, 25000, FALSE, FALSE, '/uploads/covers/nasigoreng.jpg', 'public'),
(2, 1, 4, 'Sup Buntut Kuah Bening', 'Sup buntut daging sapi pilihan dengan kuah kaldu yang segar dan gurih.', 120, 4, 120000, FALSE, FALSE, '/uploads/covers/sop buntut.jpg', 'public'),
(3, 1, 6, 'Es Dawet Ayu Banjarnegara', 'Minuman tradisional manis segar dari tepung beras dan gula merah asli.', 45, 5, 30000, FALSE, FALSE, '/uploads/covers/esdawet.jpg', 'public'),
(4, 1, 5, 'Klepon Pandan Lumer', 'Jajanan pasar kenyal isi gula merah yang meledak di mulut.', 60, 10, 20000, FALSE, FALSE, '/uploads/covers/klepon.jpg', 'public'),
(5, 1, 10, 'Sate Lilit Ayam Khas Bali', 'Sate lilit dengan lilitan serai yang wangi menggugah selera.', 40, 4, 45000, FALSE, FALSE, '/uploads/covers/satelilit.jpg', 'public'),

-- Resep dari User 2 (Chef Budi)
(6, 2, 9, 'Rendang Daging Sapi Empuk', 'Resep rendang asli Minang yang dimasak perlahan hingga bumbu meresap sempurna.', 180, 8, 150000, FALSE, FALSE, '/uploads/covers/rendang.jpg', 'public'),
(7, 2, 7, 'Udang Bakar Madu Spesial', 'Udang segar ukuran besar dibakar dengan olesan madu dan rempah.', 30, 3, 85000, FALSE, FALSE, '/uploads/covers/udang.jpg', 'public'),
(8, 2, 11, 'Mie Goreng Jawa Nyemek', 'Mie goreng dengan sedikit kuah kental rasa manis gurih khas Jawa.', 25, 2, 20000, FALSE, FALSE, '/uploads/covers/mienymek.jpg', 'public'),
(9, 2, 12, 'Sambal Matah Segar', 'Sambal mentah khas Bali yang sangat cocok disajikan dengan ikan atau ayam.', 10, 4, 15000, FALSE, FALSE, '/uploads/covers/sambalmatah.jpg', 'public'),
(10, 2, 1, 'Nasi Bakar Cumi Asin', 'Nasi gurih yang dibungkus daun pisang berisi tumisan cumi asin pedas.', 50, 3, 50000, FALSE, FALSE, '/uploads/covers/nasbakcumi.jpg', 'public'),

-- Resep dari User 3 (Ibu Siti)
(11, 3, 8, 'Sayur Asem Sunda Segar', 'Sayur asem bening dengan isian melimpah, cocok disantap siang hari.', 30, 5, 25000, FALSE, FALSE, '/uploads/covers/sayurasem.jpg', 'public'),
(12, 3, 3, 'Puding Coklat Vla Vanila', 'Puding lembut rasa coklat pekat disiram dengan vla vanila buatan sendiri.', 60, 8, 40000, FALSE, FALSE, '/uploads/covers/puding.jpg', 'public'),
(13, 3, 4, 'Soto Ayam Lamongan dengan Koya', 'Soto ayam berkuah kuning gurih ditambah taburan koya kerupuk udang.', 90, 6, 65000, FALSE, FALSE, '/uploads/covers/soto.jpg', 'public'),
(14, 3, 10, 'Ayam Masak Ang Ciu', 'Olahan ayam ala Chinese food dengan kuah jahe dan ang ciu yang menghangatkan.', 45, 4, 70000, FALSE, TRUE, '/uploads/covers/ayamangciu.jpg', 'public'),
(15, 3, 1, 'Babi Panggang Karo (BPK)', 'Babi panggang khas Batak Karo lengkap dengan bumbu darah dan kincong.', 120, 5, 150000, TRUE, FALSE, '/uploads/covers/babi.jpg', 'public');


-- =========================
-- 4. SEED INGREDIENT GROUPS
-- =========================
INSERT INTO ingredient_groups (id, recipe_id, NAME, sort_order) VALUES
-- Nasi Goreng
(1, 1, 'Bahan Utama', 1), (2, 1, 'Bumbu Halus', 2),
-- Sup Buntut
(3, 2, 'Bahan Kaldu & Daging', 1), (4, 2, 'Bumbu Cemplung', 2),
-- Es Dawet
(5, 3, 'Bahan Cendol', 1), (6, 3, 'Bahan Kuah Santan & Gula', 2),
-- Klepon
(7, 4, 'Bahan Adonan Kulit', 1), (8, 4, 'Bahan Isian & Baluran', 2),
-- Sate Lilit
(9, 5, 'Bahan Sate', 1), (10, 5, 'Bumbu Base Genep', 2),
-- Rendang
(11, 6, 'Bahan Utama Rendang', 1), (12, 6, 'Bumbu Halus & Rempah', 2),
-- Udang Bakar
(13, 7, 'Bahan Utama Seafood', 1), (14, 7, 'Bumbu Olesan', 2),
-- Mie Goreng
(15, 8, 'Bahan Mie & Sayur', 1), (16, 8, 'Bumbu Halus & Saus', 2),
-- Sambal Matah
(17, 9, 'Bahan Iris & Cair', 1),
-- Nasi Bakar
(18, 10, 'Bahan Nasi Gurih', 1), (19, 10, 'Bahan Isian Cumi', 2),
-- Sayur Asem
(20, 11, 'Isian Sayur', 1), (21, 11, 'Bumbu Kuah', 2),
-- Puding Coklat
(22, 12, 'Bahan Puding', 1), (23, 12, 'Bahan Vla', 2),
-- Soto Ayam
(24, 13, 'Bahan Utama Kuah & Ayam', 1), (25, 13, 'Bumbu Halus & Pelengkap', 2),
-- Ayam Ang Ciu
(26, 14, 'Bahan Ayam & Bumbu', 1),
-- Babi Panggang
(27, 15, 'Daging Babi', 1), (28, 15, 'Bumbu Marinasi & Sambal', 2);

-- =========================
-- 5. SEED INGREDIENTS
-- =========================
INSERT INTO ingredients (group_id, NAME, quantity, unit, sort_order) VALUES
-- Nasi Goreng (Group 1, 2)
(1, 'Nasi Putih Dingin', '2', 'piring', 1), (1, 'Telur Ayam', '2', 'butir', 2), (1, 'Kecap Manis', '2', 'sdm', 3),
(2, 'Bawang Merah', '5', 'siung', 1), (2, 'Bawang Putih', '3', 'siung', 2), (2, 'Cabai Merah Keriting', '3', 'buah', 3),

-- Sup Buntut (Group 3, 4)
(3, 'Buntut Sapi (potong, cuci bersih)', '500', 'gram', 1), (3, 'Air Matang', '1.5', 'liter', 2),
(4, 'Wortel (potong bulat)', '2', 'buah', 1), (4, 'Kentang (potong dadu)', '2', 'buah', 2), (4, 'Pala Bubuk', '1/2', 'sdt', 3),

-- Es Dawet (Group 5, 6)
(5, 'Tepung Beras', '100', 'gram', 1), (5, 'Tepung Sagu', '50', 'gram', 2), (5, 'Air Daun Suji/Pandan', '500', 'ml', 3),
(6, 'Gula Merah (sisir)', '250', 'gram', 1), (6, 'Santan Kelapa', '500', 'ml', 2),

-- Klepon (Group 7, 8)
(7, 'Tepung Ketan', '250', 'gram', 1), (7, 'Air Endapan Pandan', '150', 'ml', 2),
(8, 'Gula Merah (potong dadu kecil)', '100', 'gram', 1), (8, 'Kelapa Parut Kukus', '150', 'gram', 2),

-- Sate Lilit (Group 9, 10)
(9, 'Daging Ayam Giling', '350', 'gram', 1), (9, 'Kelapa Parut', '50', 'gram', 2), (9, 'Batang Serai (untuk tusukan)', '15', 'batang', 3),
(10, 'Bawang Merah', '6', 'siung', 1), (10, 'Cabai Rawit', '5', 'buah', 2), (10, 'Kunyit Bakar', '2', 'cm', 3),

-- Rendang (Group 11, 12)
(11, 'Daging Sapi (potong kotak)', '1', 'kg', 1), (11, 'Santan Kental', '1', 'liter', 2),
(12, 'Cabai Merah Giling', '150', 'gram', 1), (12, 'Bawang Merah', '15', 'siung', 2), (12, 'Jahe, Lengkuas, Serai', '1', 'ruas', 3),

-- Udang Bakar (Group 13, 14)
(13, 'Udang Pancet (belah punggung)', '500', 'gram', 1), (13, 'Jeruk Nipis', '1', 'buah', 2),
(14, 'Madu murni', '3', 'sdm', 1), (14, 'Saus Sambal', '2', 'sdm', 2), (14, 'Kecap Asin', '1', 'sdm', 3),

-- Mie Goreng (Group 15, 16)
(15, 'Mie Telur Basah/Kering', '200', 'gram', 1), (15, 'Sawi Hijau', '1', 'ikat', 2),
(16, 'Kemiri Sangrai', '2', 'butir', 1), (16, 'Kecap Manis', '3', 'sdm', 2),

-- Sambal Matah (Group 17)
(17, 'Bawang Merah (iris sangat tipis)', '10', 'siung', 1), (17, 'Cabai Rawit Merah (iris tipis)', '15', 'buah', 2), (17, 'Serai (ambil bagian putih, iris)', '3', 'batang', 3), (17, 'Minyak Kelapa Panas', '4', 'sdm', 4),

-- Nasi Bakar (Group 18, 19)
(18, 'Beras', '3', 'cup', 1), (18, 'Santan Sedang', 'secukupnya', '', 2),
(19, 'Cumi Asin (rendam air panas)', '150', 'gram', 1), (19, 'Daun Pisang', 'secukupnya', 'lembar', 2),

-- Sayur Asem (Group 20, 21)
(20, 'Jagung Manis (potong)', '1', 'buah', 1), (20, 'Melinjo & Daunnya', '1', 'genggam', 2), (20, 'Labu Siam', '1', 'buah', 3),
(21, 'Asam Jawa', '2', 'sdm', 1), (21, 'Bawang Merah', '5', 'siung', 2),

-- Puding Coklat (Group 22, 23)
(22, 'Agar-agar Bening/Coklat', '1', 'bungkus', 1), (22, 'Coklat Bubuk', '2', 'sdm', 2), (22, 'Susu UHT Coklat', '800', 'ml', 3),
(23, 'Susu UHT Putih', '300', 'ml', 1), (23, 'Tepung Maizena', '1', 'sdm', 2),

-- Soto Ayam (Group 24, 25)
(24, 'Ayam Kampung', '1/2', 'ekor', 1), (24, 'Bihun Seduh', '100', 'gram', 2), (24, 'Kol (iris halus)', '1/4', 'bonggol', 3),
(25, 'Kunyit, Jahe, Kemiri', 'secukupnya', 'ruas', 1), (25, 'Kerupuk Udang & Bawang Putih (Koya)', 'secukupnya', 'gram', 2),

-- Ayam Ang Ciu (Group 26)
(26, 'Ayam Kampung (potong kecil)', '1/2', 'ekor', 1), (26, 'Jahe (iris korek api)', '3', 'cm', 2), (26, 'Ang Ciu (Arak Masak)', '3', 'sdm', 3), (26, 'Kecap Asin', '1', 'sdm', 4),

-- Babi Panggang (Group 27, 28)
(27, 'Daging Babi Kapsim (berlemak)', '500', 'gram', 1),
(28, 'Bawang Putih', '4', 'siung', 1), (28, 'Ketumbar Bubuk', '1', 'sdt', 2), (28, 'Andaliman', '1', 'sdm', 3);


-- =========================
-- 6. SEED RECIPE STEPS
-- =========================
INSERT INTO recipe_steps (id, recipe_id, step_number, instruction) VALUES
-- R1: Nasi Goreng
(1, 1, 1, 'Tumis bumbu halus hingga harum dan matang sempurna.'),
(2, 1, 2, 'Masukkan telur, orak-arik hingga hancur dan tercampur dengan bumbu.'),
(3, 1, 3, 'Masukkan nasi putih dingin, tambahkan kecap manis, garam, dan kaldu bubuk. Aduk dengan api besar hingga merata.'),
(4, 1, 4, 'Sajikan selagi hangat dengan taburan bawang goreng dan kerupuk.'),

-- R2: Sup Buntut
(5, 2, 1, 'Presto buntut sapi selama kurang lebih 45 menit hingga dagingnya empuk.'),
(6, 2, 2, 'Tumis bumbu cemplung (pala, cengkeh, kayu manis) dan masukkan ke dalam rebusan kaldu buntut.'),
(7, 2, 3, 'Masukkan wortel dan kentang. Masak hingga sayuran empuk. Tambahkan garam dan lada sesuai selera.'),

-- R3: Es Dawet
(8, 3, 1, 'Campur tepung beras, tepung sagu, dan air pandan. Masak dengan api kecil sambil terus diaduk hingga mengental dan meletup.'),
(9, 3, 2, 'Cetak adonan menggunakan saringan dawet ke dalam wadah berisi air es.'),
(10, 3, 3, 'Rebus gula merah dengan sedikit air hingga larut. Rebus santan di panci terpisah dengan daun pandan.'),

-- R4: Klepon
(11, 4, 1, 'Campur tepung ketan dengan air endapan pandan sedikit demi sedikit hingga adonan bisa dipulung.'),
(12, 4, 2, 'Ambil sedikit adonan, pipihkan, beri isian gula merah, lalu bulatkan kembali.'),
(13, 4, 3, 'Rebus klepon di air mendidih. Angkat saat sudah mengapung. Gulingkan di atas kelapa parut kukus.'),

-- R5: Sate Lilit
(14, 5, 1, 'Tumis bumbu base genep hingga harum dan tidak langu.'),
(15, 5, 2, 'Campurkan bumbu ke dalam daging ayam giling dan kelapa parut. Uleni hingga rata.'),
(16, 5, 3, 'Lilitkan adonan ke batang serai. Panggang di atas teflon atau arang hingga kecoklatan dan matang.'),

-- R6: Rendang
(17, 6, 1, 'Masak santan bersama bumbu halus, daun jeruk, daun kunyit, dan serai hingga mengeluarkan minyak.'),
(18, 6, 2, 'Masukkan daging sapi. Aduk terus dengan api sedang hingga santan menyusut dan bumbu meresap.'),
(19, 6, 3, 'Kecilkan api, masak terus hingga daging berwarna coklat kehitaman dan empuk (kurang lebih 3-4 jam).'),

-- R7: Udang Bakar
(20, 7, 1, 'Cuci bersih udang, beri perasan jeruk nipis dan diamkan 15 menit. Bilas kembali.'),
(21, 7, 2, 'Campur semua bahan saus olesan (madu, saus sambal, kecap asin).'),
(22, 7, 3, 'Bakar udang sambil sesekali diolesi bumbu campuran madu. Jangan terlalu lama agar daging udang tidak keras.'),

-- R8: Mie Goreng
(23, 8, 1, 'Rebus mie sebentar saja, tiriskan dan lumuri dengan kecap manis serta sedikit minyak.'),
(24, 8, 2, 'Tumis bumbu halus hingga harum. Masukkan sayuran (sawi/kol) dan sedikit air (nyemek).'),
(25, 8, 3, 'Masukkan mie, aduk cepat dengan api besar hingga bumbu merata. Sajikan hangat.'),

-- R9: Sambal Matah
(26, 9, 1, 'Iris sangat tipis bawang merah, cabai rawit, dan serai. Masukkan dalam mangkuk.'),
(27, 9, 2, 'Tambahkan garam, sedikit gula, dan perasan jeruk limau. Remas perlahan agar rasa keluar.'),
(28, 9, 3, 'Panaskan minyak kelapa hingga benar-benar panas, tuangkan ke atas irisan bahan sambal. Aduk rata.'),

-- R10: Nasi Bakar
(29, 10, 1, 'Masak beras dengan santan, daun salam, serai, dan sedikit garam menggunakan rice cooker hingga matang (menjadi nasi gurih).'),
(30, 10, 2, 'Tumis cumi asin yang sudah direndam dengan bumbu irisan cabai dan bawang. Masak hingga matang.'),
(31, 10, 3, 'Siapkan daun pisang, tata nasi gurih, letakkan tumisan cumi di tengahnya, gulung rapat, lalu bakar di atas teflon hingga daun harum.'),

-- R11: Sayur Asem
(32, 11, 1, 'Didihkan air. Masukkan bahan sayuran yang keras terlebih dahulu (jagung dan melinjo).'),
(33, 11, 2, 'Masukkan bumbu halus, asam jawa, daun salam, dan lengkuas. Rebus hingga wangi.'),
(34, 11, 3, 'Masukkan sayuran lunak (daun melinjo, labu siam). Beri garam dan gula, koreksi rasa.'),

-- R12: Puding Coklat
(35, 12, 1, 'Campur agar-agar, coklat bubuk, dan susu UHT coklat. Masak sambil terus diaduk hingga mendidih. Cetak dan dinginkan.'),
(36, 12, 2, 'Membuat Vla: Rebus susu cair putih, tambahkan gula secukupnya. Larutkan maizena dengan sedikit air, masukkan ke rebusan susu hingga mengental.'),

-- R13: Soto Ayam
(37, 13, 1, 'Rebus ayam bersama serai dan daun jeruk untuk membuat kaldu bening.'),
(38, 13, 2, 'Tumis bumbu halus (kunyit, bawang) lalu tuang ke dalam rebusan kuah. Angkat ayam, lalu goreng sebentar dan suwir-suwir.'),
(39, 13, 3, 'Tata bihun, kol, dan ayam suwir di mangkuk. Siram kuah soto panas dan taburi dengan koya (campuran kerupuk udang giling dan bawang putih goreng).'),

-- R14: Ayam Ang Ciu
(40, 14, 1, 'Tumis jahe iris dengan sedikit minyak wijen hingga benar-benar wangi dan sedikit kecoklatan.'),
(41, 14, 2, 'Masukkan potongan ayam, aduk hingga ayam berubah warna.'),
(42, 14, 3, 'Tuangkan ang ciu, kecap asin, sedikit kaldu jamur. Masak dengan api besar sebentar agar aroma ang ciu terkaramelisasi, beri sedikit air, lalu masak hingga matang.'),

-- R15: Babi Panggang
(43, 15, 1, 'Lumuri daging babi dengan perasan jeruk nipis, bawang putih halus, ketumbar, dan sedikit garam. Marinasi minimal 1 jam.'),
(44, 15, 2, 'Panggang daging di atas oven atau arang dengan suhu sedang hingga matang sempurna dan lapisan luarnya renyah.'),
(45, 15, 3, 'Iris tipis daging yang sudah matang. Sajikan bersama sambal andaliman yang pedas menggigit.');


-- =========================
-- 7. SEED RECIPE STEP IMAGES
-- Mengambil beberapa id dari recipe_steps secara spesifik untuk diberikan contoh gambar
-- =========================
INSERT INTO recipe_step_images (step_id, image_url, sort_order) VALUES
-- Nasi Goreng Step 1 (Menumis)
(1, '/uploads/steps/nasgor-tumis.jpg', 1),
-- Nasi Goreng Step 3 (Mencampur Nasi)
(3, '/uploads/steps/nasgor-campur.jpg', 1),

-- Sup Buntut Step 1 (Presto)
(5, '/uploads/steps/supbuntut-presto.jpg', 1),

-- Klepon Step 2 (Mengisi gula)
(12, '/uploads/steps/klepon-isi.jpg', 1),
(12, '/uploads/steps/klepon-bulat.jpg', 2), -- 2 gambar di satu step

-- Rendang Step 2 (Aduk daging di santan)
(18, '/uploads/steps/rendang-masak.jpg', 1),

-- Udang Bakar Step 3 (Bakar)
(22, '/uploads/steps/udang-bakar-proses.jpg', 1),

-- Nasi Bakar Step 3 (Bungkus & Bakar)
(31, '/uploads/steps/nasibakar-bungkus.jpg', 1),
(31, '/uploads/steps/nasibakar-panggang.jpg', 2);

-- Selesai