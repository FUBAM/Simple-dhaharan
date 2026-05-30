import 'local_ingredient.dart';

class LocalIngredientGroup {

  String name;

  List<LocalIngredient> ingredients;

  LocalIngredientGroup({
    this.name = '',
    required this.ingredients,
  });
}