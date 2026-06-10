import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import '../../providers/recipe_provider.dart';
import '../../models/local_ingredient.dart';
import '../../models/local_ingredient_group.dart';
import '../../models/local_step.dart';
import 'my_recipe_screen.dart';
import '../../core/constants/api_constants.dart';

class CreateRecipeScreen extends StatefulWidget {
  final int? recipeId;

  const CreateRecipeScreen({super.key, this.recipeId});

  @override
  State<CreateRecipeScreen> createState() => _CreateRecipeScreenState();
}

class _CreateRecipeScreenState extends State<CreateRecipeScreen> {
  bool get isEdit => widget.recipeId != null;

  File? coverImage;
  String? existingCoverImage;

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final cookTimeController = TextEditingController();
  final servingsController = TextEditingController();
  final costController = TextEditingController();
  int? selectedCategory;

  // STATE BARU: Untuk Babi dan Alkohol
  bool containsPork = false;
  bool containsAlcohol = false;

  List<LocalIngredientGroup> ingredientGroups = [
    LocalIngredientGroup(name: 'Bahan Utama', ingredients: [LocalIngredient()]),
  ];
  List<LocalStep> steps = [LocalStep(stepNumber: 1, imageUrls: [])];

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final provider = context.read<RecipeProvider>();
      await provider.loadCategories();

      if (isEdit) {
        await provider.loadMyRecipeDetail(widget.recipeId!);
        fillForm();
      }
    });
  }

  void fillForm() {
    final recipe = context.read<RecipeProvider>().selectedRecipe;
    if (recipe == null) return;

    existingCoverImage = recipe.coverImage;
    titleController.text = recipe.title;
    descriptionController.text = recipe.description ?? '';
    selectedCategory = recipe.categoryId;
    cookTimeController.text = recipe.cookTime?.toString() ?? '';
    servingsController.text = recipe.servings?.toString() ?? '';
    costController.text = recipe.estimatedCost?.toString() ?? '';

    // Set state kandungan babi dan alkohol saat Edit
    containsPork = recipe.containsPork;
    containsAlcohol = recipe.containsAlcohol;

    ingredientGroups.clear();
    for (final group in recipe.ingredientGroups) {
      ingredientGroups.add(
        LocalIngredientGroup(name: group['name'] ?? '', ingredients: []),
      );
      final currentGroup = ingredientGroups.last;
      for (final ingredient in group['ingredients']) {
        currentGroup.ingredients.add(
          LocalIngredient(
            name: ingredient['name'] ?? '',
            quantity: ingredient['quantity']?.toString() ?? '',
            unit: ingredient['unit'] ?? '',
          ),
        );
      }
    }

    steps.clear();
    for (final stepData in recipe.steps) {
      steps.add(
        LocalStep(
          stepNumber: stepData['step_number'],
          instruction: stepData['instruction'] ?? '',
          imageUrls: (stepData['images'] as List)
              .map<String>((image) => image['image_url'])
              .toList(),
        ),
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RecipeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Resep' : 'Buat Resep Baru'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover Image Section
            _buildCoverImagePicker(),
            const SizedBox(height: 24),

            // Basic Info Section
            _buildSectionTitle('Informasi Dasar'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildTextField(
                    titleController,
                    'Judul Resep',
                    icon: Icons.restaurant_menu,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    descriptionController,
                    'Deskripsi',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<int>(
                    value: selectedCategory,
                    decoration: InputDecoration(
                      labelText: 'Kategori',
                      prefixIcon: const Icon(
                        Icons.category_outlined,
                        color: Colors.orange,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: provider.categories
                        .map(
                          (c) => DropdownMenuItem(
                            value: c.id,
                            child: Text(c.name),
                          ),
                        )
                        .toList(),
                    onChanged: (val) => setState(() => selectedCategory = val),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          cookTimeController,
                          'Waktu (Menit)',
                          isNumber: true,
                          icon: Icons.timer_outlined,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          servingsController,
                          'Porsi',
                          isNumber: true,
                          icon: Icons.people_outline,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    costController,
                    'Estimasi Biaya (Rp)',
                    isNumber: true,
                    icon: Icons.monetization_on_outlined,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // SECTION BARU: Peringatan Kandungan
            _buildSectionTitle('Informasi Kandungan (Opsional)'),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.red.shade100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text(
                      'Mengandung Babi',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text(
                      'Aktifkan jika resep menggunakan bahan daging/minyak babi',
                    ),
                    value: containsPork,
                    activeColor: Colors.red,
                    secondary: const Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.red,
                    ),
                    onChanged: (val) => setState(() => containsPork = val),
                  ),
                  Divider(height: 1, color: Colors.red.shade50),
                  SwitchListTile(
                    title: const Text(
                      'Mengandung Alkohol',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text(
                      'Aktifkan jika resep menggunakan arak masak, mirin, dsb',
                    ),
                    value: containsAlcohol,
                    activeColor: Colors.red,
                    secondary: const Icon(
                      Icons.liquor_outlined,
                      color: Colors.red,
                    ),
                    onChanged: (val) => setState(() => containsAlcohol = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('Bahan-bahan'),
            const SizedBox(height: 12),
            ...ingredientGroups
                .asMap()
                .entries
                .map((entry) => _buildIngredientGroup(entry.key, entry.value))
                .toList(),
            const SizedBox(height: 12),
            Center(
              child: TextButton.icon(
                onPressed: addGroup,
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('Tambah Kelompok Bahan'),
                style: TextButton.styleFrom(foregroundColor: Colors.orange),
              ),
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('Langkah Memasak'),
            const SizedBox(height: 12),
            ...steps
                .asMap()
                .entries
                .map((entry) => _buildStepCard(entry.key, entry.value))
                .toList(),
            const SizedBox(height: 12),
            Center(
              child: TextButton.icon(
                onPressed: addStep,
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('Tambah Langkah'),
                style: TextButton.styleFrom(foregroundColor: Colors.orange),
              ),
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: submitRecipe,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  isEdit ? 'SIMPAN PERUBAHAN' : 'BUAT RESEP',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
    bool isNumber = false,
    IconData? icon,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon, color: Colors.grey) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }

  Widget _buildCoverImagePicker() {
    return GestureDetector(
      onTap: pickCover,
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.orange.shade200,
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: coverImage != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.file(coverImage!, fit: BoxFit.cover),
              )
            : existingCoverImage != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                  ApiConstants.baseUrl + existingCoverImage!,
                  fit: BoxFit.cover,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_a_photo_outlined,
                    size: 48,
                    color: Colors.orange.shade300,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Upload Foto Makanan',
                    style: TextStyle(
                      color: Colors.orange.shade400,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildIngredientGroup(int groupIndex, LocalIngredientGroup group) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    key: ValueKey('${group.name}_$groupIndex'),
                    initialValue: group.name,
                    decoration: const InputDecoration(
                      labelText: 'Nama Kelompok (Mis: Bumbu Halus)',
                    ),
                    onChanged: (val) => group.name = val,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => removeGroup(groupIndex),
                ),
              ],
            ),
            const Divider(height: 24),
            ...group.ingredients.asMap().entries.map((entry) {
              final idx = entry.key;
              final ingredient = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        initialValue: ingredient.name,
                        decoration: const InputDecoration(
                          labelText: 'Bahan',
                          isDense: true,
                        ),
                        onChanged: (val) => ingredient.name = val,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        initialValue: ingredient.quantity,
                        decoration: const InputDecoration(
                          labelText: 'Qty',
                          isDense: true,
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (val) => ingredient.quantity = val,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        initialValue: ingredient.unit,
                        decoration: const InputDecoration(
                          labelText: 'Unit',
                          isDense: true,
                        ),
                        onChanged: (val) => ingredient.unit = val,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.remove_circle_outline,
                        color: Colors.red,
                      ),
                      onPressed: () => removeIngredient(groupIndex, idx),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              );
            }).toList(),
            Center(
              child: TextButton.icon(
                onPressed: () => addIngredient(groupIndex),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Tambah Bahan'),
                style: TextButton.styleFrom(foregroundColor: Colors.orange),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepCard(int index, LocalStep step) {
    return Card(
      key: ValueKey('${step.stepNumber}_${step.instruction}_$index'),
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.orange,
                  radius: 14,
                  child: Text(
                    '${step.stepNumber}',
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => removeStep(index),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              initialValue: step.instruction,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Instruksi memasak',
                filled: true,
              ),
              onChanged: (val) => step.instruction = val,
            ),
            const SizedBox(height: 12),
            if (step.imageUrls.isNotEmpty)
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: step.imageUrls.length,
                  itemBuilder: (context, imgIdx) {
                    return Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 8),
                          width: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              ApiConstants.baseUrl + step.imageUrls[imgIdx],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => step.imageUrls.removeAt(imgIdx)),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                size: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            TextButton.icon(
              onPressed: () => pickStepImage(step),
              icon: const Icon(Icons.add_a_photo_outlined, size: 18),
              label: const Text('Foto Langkah'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> pickCover() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    setState(() => coverImage = File(image.path));
    await context.read<RecipeProvider>().uploadCover(image.path);
  }

  void addGroup() => setState(
    () => ingredientGroups.add(
      LocalIngredientGroup(name: '', ingredients: [LocalIngredient()]),
    ),
  );
  void addIngredient(int groupIndex) => setState(
    () => ingredientGroups[groupIndex].ingredients.add(LocalIngredient()),
  );
  void removeIngredient(int groupIndex, int ingredientIndex) => setState(
    () => ingredientGroups[groupIndex].ingredients.removeAt(ingredientIndex),
  );
  void removeGroup(int groupIndex) =>
      setState(() => ingredientGroups.removeAt(groupIndex));

  void addStep() => setState(
    () => steps.add(LocalStep(stepNumber: steps.length + 1, imageUrls: [])),
  );
  void removeStep(int index) {
    setState(() {
      steps.removeAt(index);
      for (int i = 0; i < steps.length; i++) {
        steps[i].stepNumber = i + 1;
      }
    });
  }

  Future<void> pickStepImage(LocalStep step) async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    if (!mounted) return;
    final imageUrl = await context.read<RecipeProvider>().uploadStepImage(
      image.path,
    );
    setState(() => step.imageUrls.add(imageUrl));
  }

  Future<void> submitRecipe() async {
    final provider = context.read<RecipeProvider>();

    final payload = {
      "category_id": selectedCategory,
      "title": titleController.text,
      "description": descriptionController.text,
      "cook_time": int.tryParse(cookTimeController.text),
      "servings": int.tryParse(servingsController.text),
      "estimated_cost": int.tryParse(costController.text),
      "contains_pork": containsPork, // Sudah menggunakan State
      "contains_alcohol": containsAlcohol, // Sudah menggunakan State
      "cover_image": provider.coverImageUrl ?? existingCoverImage,
      "status": "private",
      "ingredient_groups": ingredientGroups
          .map(
            (group) => {
              "name": group.name,
              "sort_order": ingredientGroups.indexOf(group),
              "ingredients": group.ingredients
                  .map(
                    (ing) => {
                      "name": ing.name,
                      "quantity": ing.quantity,
                      "unit": ing.unit,
                      "sort_order": group.ingredients.indexOf(ing),
                    },
                  )
                  .toList(),
            },
          )
          .toList(),
      "steps": steps
          .map(
            (step) => {
              "step_number": step.stepNumber,
              "instruction": step.instruction,
              "images": step.imageUrls
                  .map(
                    (url) => {
                      "image_url": url,
                      "sort_order": step.imageUrls.indexOf(url),
                    },
                  )
                  .toList(),
            },
          )
          .toList(),
    };

    try {
      if (isEdit) {
        await provider.updateRecipe(widget.recipeId!, payload);
      } else {
        await provider.createRecipe(payload);
        // Pastikan me-load ulang daftar resep setelah membuat baru
        await provider.loadMyRecipes();
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEdit ? 'Resep berhasil diupdate' : 'Resep berhasil dibuat',
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );

      // ========================================================
      // PERBAIKAN: Gunakan pop() untuk menutup halaman form ini
      // ========================================================
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    }
  }
}
