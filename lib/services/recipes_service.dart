import 'package:http/http.dart' as http;
import 'package:pocketbase/pocketbase.dart';

import '../models/recipe.dart';
import 'pocketbase_client.dart';

class RecipesService {
  String _getFeaturedImageUrl(PocketBase pb, RecordModel recipeModel) {
    final featuredImageName = recipeModel.getStringValue('featuredImage');
    return pb.files.getUrl(recipeModel, featuredImageName).toString();
  }

  Future<List<Recipe>> fetchRecipes({bool filteredByUser = false}) async {
    final List<Recipe> recipes = [];

    try {
      final pb = await getPocketbaseInstance();
      final userId = pb.authStore.record!.id;
      final recipeModels = await pb
          .collection('recipes')
          .getFullList(filter: filteredByUser ? "userId='$userId'" : null);

      for (final recipeModel in recipeModels) {
        recipes.add(
          Recipe.fromJson(
            recipeModel.toJson()
              ..addAll({'imageUrl': _getFeaturedImageUrl(pb, recipeModel)}),
          ),
        );
      }
      return recipes;
    } catch (error) {
      return recipes;
    }
  }

  Future<Recipe?> addRecipe(Recipe recipe) async {
    try {
      final pb = await getPocketbaseInstance();
      final userId = pb.authStore.record!.id;

      List<http.MultipartFile>? files;
      if (recipe.featuredImage != null) {
        files = [
          http.MultipartFile.fromBytes(
            'featuredImage',
            await recipe.featuredImage!.readAsBytes(),
            filename: recipe.featuredImage!.uri.pathSegments.last,
          ),
        ];
      }

      final recipeModel = await pb.collection('recipes').create(
        body: {
          ...recipe.toJson(),
          'userId': userId,
        },
        files: files ?? [],
      );

      return recipe.copyWith(
        id: recipeModel.id,
        imageUrl: files != null
            ? _getFeaturedImageUrl(pb, recipeModel)
            : recipe.imageUrl,
      );
    } catch (error) {
      return null;
    }
  }

  Future<Recipe?> updateRecipe(Recipe recipe) async {
    try {
      final pb = await getPocketbaseInstance();

      final recipeModel = await pb.collection('recipes').update(
            recipe.id!,
            body: recipe.toJson(),
            files: recipe.featuredImage != null
                ? [
                    http.MultipartFile.fromBytes(
                      'featuredImage',
                      await recipe.featuredImage!.readAsBytes(),
                      filename: recipe.featuredImage!.uri.pathSegments.last,
                    ),
                  ]
                : [],
          );

      return recipe.copyWith(
        imageUrl: recipe.featuredImage != null
            ? _getFeaturedImageUrl(pb, recipeModel)
            : recipe.imageUrl,
      );
    } catch (error) {
      return null;
    }
  }

  Future<bool> deleteRecipe(String id) async {
    try {
      final pb = await getPocketbaseInstance();
      await pb.collection('recipes').delete(id);
      return true;
    } catch (error) {
      return false;
    }
  }
}
