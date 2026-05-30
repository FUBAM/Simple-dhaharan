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

  final titleController = TextEditingController();

  final descriptionController = TextEditingController();

  final cookTimeController = TextEditingController();

  final servingsController = TextEditingController();

  final costController = TextEditingController();

  int? selectedCategory;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final provider = context.read<RecipeProvider>();

      await provider.loadCategories();

      if (isEdit) {
        await provider.loadRecipeDetail(widget.recipeId!);

        print(provider.selectedRecipe);
        fillForm();
      }
    });
  }

  String? existingCoverImage;
  void fillForm() {
    final recipe = context.read<RecipeProvider>().selectedRecipe;

    if (recipe == null) {
      return;
    }
    existingCoverImage = recipe.coverImage;

    titleController.text = recipe.title;

    descriptionController.text = recipe.description ?? '';

    selectedCategory = recipe.categoryId;

    cookTimeController.text = recipe.cookTime?.toString() ?? '';

    servingsController.text = recipe.servings?.toString() ?? '';

    costController.text = recipe.estimatedCost?.toString() ?? '';

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

          imageUrls: (stepData['images'] as List).map<String>((image) {
            return image['image_url'];
          }).toList(),
        ),
      );
    }

    setState(() {});

    print(ingredientGroups.length);
    print(steps.length);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RecipeProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Recipe' : 'Create Recipe')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            GestureDetector(
              onTap: pickCover,

              child: Container(
                height: 180,

                width: double.infinity,

                decoration: BoxDecoration(border: Border.all()),

                child: coverImage != null
                    ? Image.file(coverImage!, fit: BoxFit.cover)
                    : existingCoverImage != null
                    ? Image.network(ApiConstants.baseUrl + existingCoverImage!)
                    : const Center(child: Text('Pilih Cover')),
              ),
            ),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            DropdownButtonFormField<int>(
              value: selectedCategory,

              items: provider.categories.map((category) {
                return DropdownMenuItem(
                  value: category.id,
                  child: Text(category.name),
                );
              }).toList(),

              onChanged: (value) {
                setState(() {
                  selectedCategory = value;
                });
              },

              decoration: const InputDecoration(labelText: 'Category'),
            ),
            TextField(
              controller: cookTimeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Cook Time'),
            ),
            TextField(
              controller: servingsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Servings'),
            ),
            TextField(
              controller: costController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Estimated Cost'),
            ),
            const SizedBox(height: 24),

            const Text(
              'Ingredient Groups',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            ...ingredientGroups.asMap().entries.map((groupEntry) {
              final groupIndex = groupEntry.key;

              final group = groupEntry.value;

              return Card(
                margin: const EdgeInsets.only(top: 12),

                child: Padding(
                  padding: const EdgeInsets.all(12),

                  child: Column(
                    children: [
                      TextFormField(
                        key: ValueKey('${group.name}_${groupIndex}'),
                        initialValue: group.name,

                        decoration: const InputDecoration(
                          labelText: 'Group Name',
                        ),

                        onChanged: (value) {
                          group.name = value;
                        },
                      ),

                      const SizedBox(height: 12),

                      ...group.ingredients.asMap().entries.map((
                        ingredientEntry,
                      ) {
                        final ingredientIndex = ingredientEntry.key;

                        final ingredient = ingredientEntry.value;

                        return Column(
                          children: [
                            TextFormField(
                              key: ValueKey(
                                'ingredient_${groupIndex}_$ingredientIndex',
                              ),

                              initialValue: ingredient.name,

                              decoration: const InputDecoration(
                                labelText: 'Ingredient Name',
                              ),

                              onChanged: (value) {
                                ingredient.name = value;
                              },
                            ),

                            TextFormField(
                              key: ValueKey(
                                'qty_${groupIndex}_$ingredientIndex',
                              ),

                              initialValue: ingredient.quantity,

                              decoration: const InputDecoration(
                                labelText: 'Quantity',
                              ),

                              onChanged: (value) {
                                ingredient.quantity = value;
                              },
                            ),

                            TextFormField(
                              key: ValueKey(
                                'unit_${groupIndex}_$ingredientIndex',
                              ),

                              initialValue: ingredient.unit,

                              decoration: const InputDecoration(
                                labelText: 'Unit',
                              ),

                              onChanged: (value) {
                                ingredient.unit = value;
                              },
                            ),

                            Align(
                              alignment: Alignment.centerRight,

                              child: TextButton(
                                onPressed: () {
                                  removeIngredient(groupIndex, ingredientIndex);
                                },

                                child: const Text('Delete Ingredient'),
                              ),
                            ),
                          ],
                        );
                      }),

                      ElevatedButton(
                        onPressed: () {
                          addIngredient(groupIndex);
                        },

                        child: const Text('Add Ingredient'),
                      ),

                      TextButton(
                        onPressed: () {
                          removeGroup(groupIndex);
                        },

                        child: const Text('Delete Group'),
                      ),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 12),

            ElevatedButton(onPressed: addGroup, child: const Text('Add Group')),

            const SizedBox(height: 24),

            const Text(
              'Recipe Steps',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            ...steps.asMap().entries.map((entry) {
              final index = entry.key;

              final step = entry.value;

              return Card(
                margin: const EdgeInsets.only(top: 12),

                child: Padding(
                  padding: const EdgeInsets.all(12),

                  child: Column(
                    children: [
                      Text(
                        'Step ${step.stepNumber}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 12),

                      TextFormField(
                        key: ValueKey('step_${step.stepNumber}'),

                        initialValue: step.instruction,

                        maxLines: 4,

                        decoration: const InputDecoration(
                          labelText: 'Instruction',
                        ),

                        onChanged: (value) {
                          step.instruction = value;
                        },
                      ),

                      const SizedBox(height: 12),
                      if (step.imageUrls.isNotEmpty)
                        SizedBox(
                          height: 90,

                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,

                            itemCount: step.imageUrls.length,

                            itemBuilder: (context, imageIndex) {
                              return Container(
                                margin: const EdgeInsets.only(right: 8),

                                width: 90,

                                decoration: BoxDecoration(border: Border.all()),

                                child: Center(
                                  child: Text('Image ${imageIndex + 1}'),
                                ),
                              );
                            },
                          ),
                        ),

                      ElevatedButton(
                        onPressed: () {
                          pickStepImage(step);
                        },
                        child: const Text('Add Image'),
                      ),

                      const SizedBox(height: 12),

                      TextButton(
                        onPressed: () {
                          removeStep(index);
                        },

                        child: const Text('Delete Step'),
                      ),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 12),

            ElevatedButton(onPressed: addStep, child: const Text('Add Step')),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () {
                final provider = context.read<RecipeProvider>();
                print(provider.coverImageUrl);
                submitRecipe();
              },
              child: Text(isEdit ? 'UPDATE' : 'CREATE'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> pickCover() async {
    final picker = ImagePicker();

    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) {
      return;
    }

    setState(() {
      coverImage = File(image.path);
    });

    await context.read<RecipeProvider>().uploadCover(image.path);
  }

  List<LocalIngredientGroup> ingredientGroups = [
    LocalIngredientGroup(name: 'Bahan Utama', ingredients: [LocalIngredient()]),
  ];

  void addGroup() {
    setState(() {
      ingredientGroups.add(
        LocalIngredientGroup(name: '', ingredients: [LocalIngredient()]),
      );
    });
  }

  void addIngredient(int groupIndex) {
    setState(() {
      ingredientGroups[groupIndex].ingredients.add(LocalIngredient());
    });
  }

  void removeIngredient(int groupIndex, int ingredientIndex) {
    setState(() {
      ingredientGroups[groupIndex].ingredients.removeAt(ingredientIndex);
    });
  }

  void removeGroup(int groupIndex) {
    setState(() {
      ingredientGroups.removeAt(groupIndex);
    });
  }

  List<LocalStep> steps = [LocalStep(stepNumber: 1, imageUrls: [])];

  void addStep() {
    setState(() {
      steps.add(LocalStep(stepNumber: steps.length + 1, imageUrls: []));
    });
  }

  void removeStep(int index) {
    setState(() {
      steps.removeAt(index);

      for (int i = 0; i < steps.length; i++) {
        steps[i].stepNumber = i + 1;
      }
    });
  }

  Future<void> pickStepImage(LocalStep step) async {
    final picker = ImagePicker();

    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) {
      return;
    }

    final imageUrl = await context.read<RecipeProvider>().uploadStepImage(
      image.path,
    );

    setState(() {
      step.imageUrls.add(imageUrl);
    });
  }

  Future<void> submitRecipe() async {
    final provider = context.read<RecipeProvider>();

    final ingredientGroupsJson = ingredientGroups.map((group) {
      return {
        "name": group.name,
        "sort_order": 0,

        "ingredients": group.ingredients.map((ingredient) {
          return {
            "name": ingredient.name,

            "quantity": ingredient.quantity,

            "unit": ingredient.unit,

            "sort_order": 0,
          };
        }).toList(),
      };
    }).toList();
    final stepsJson = steps.map((step) {
      return {
        "step_number": step.stepNumber,

        "instruction": step.instruction,

        "images": step.imageUrls.map((url) {
          return {"image_url": url, "sort_order": 0};
        }).toList(),
      };
    }).toList();
    final payload = {
      "category_id": selectedCategory,

      "title": titleController.text,

      "description": descriptionController.text,

      "cook_time": int.tryParse(cookTimeController.text),

      "servings": int.tryParse(servingsController.text),

      "estimated_cost": int.tryParse(costController.text),

      "contains_pork": false,

      "contains_alcohol": false,

      "cover_image": provider.coverImageUrl ?? existingCoverImage,

      "status": "private",

      "ingredient_groups": ingredientGroupsJson,

      "steps": stepsJson,
    };
    try {
      print(payload);

      if (isEdit) {
        await provider.updateRecipe(widget.recipeId!, payload);
      } else {
        await provider.createRecipe(payload);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Recipe Created')));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MyRecipesScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}
