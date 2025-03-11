import 'package:http/http.dart' as http;
import 'package:pocketbase/pocketbase.dart';

import '../models/food.dart';
import 'pocketbase_client.dart';

class FoodsService {
  String _getFeaturedImageUrl(PocketBase pb, RecordModel foodModel) {
    final featuredImageName = foodModel.getStringValue('featuredImage');
    return pb.files.getUrl(foodModel, featuredImageName).toString();
  }

  Future<List<Food>> fetchFoods() async {
    final List<Food> foods = [];

    try {
      final pb = await getPocketbaseInstance();
      final foodModels = await pb.collection('foods').getFullList();

      for (final foodModel in foodModels) {
        foods.add(
          Food.fromJson(
            foodModel.toJson()
              ..addAll({'imageUrl': _getFeaturedImageUrl(pb, foodModel)}),
          ),
        );
      }

      return foods;
    } catch (error) {
      return foods;
    }
  }

  Future<Food?> addFood(Food food) async {
    try {
      final pb = await getPocketbaseInstance();
      print("✅ PocketBase instance initialized");

      if (food.featuredImage == null) {
        print("❌ Error: featuredImage is null");
        return null;
      }

      final imageBytes = await food.featuredImage!.readAsBytes();
      final fileName = food.featuredImage!.uri.pathSegments.last;

      print("📷 Uploading image: $fileName (${imageBytes.length} bytes)");

      final foodModel = await pb.collection('foods').create(
        body: food.toJson(),
        files: [
          http.MultipartFile.fromBytes(
            'featuredImage',
            imageBytes,
            filename: fileName,
          ),
        ],
      );

      print("✅ Food added successfully: ${foodModel.id}");

      return food.copyWith(
        id: foodModel.id,
        imageUrl: _getFeaturedImageUrl(pb, foodModel),
      );
    } catch (error, stackTrace) {
      print("❌ Error adding food: $error");
      print(stackTrace);
      return null;
    }
  }

  Future<Food?> updateFood(Food food) async {
    try {
      final pb = await getPocketbaseInstance();

      final foodModel = await pb.collection('foods').update(
            food.id!,
            body: food.toJson(),
            files: food.featuredImage != null
                ? [
                    http.MultipartFile.fromBytes(
                      'featuredImage',
                      await food.featuredImage!.readAsBytes(),
                      filename: food.featuredImage!.uri.pathSegments.last,
                    ),
                  ]
                : [],
          );

      return food.copyWith(
        imageUrl: food.featuredImage != null
            ? _getFeaturedImageUrl(pb, foodModel)
            : food.imageUrl,
      );
    } catch (error) {
      return null;
    }
  }

  Future<bool> deleteFood(String id) async {
    try {
      final pb = await getPocketbaseInstance();
      await pb.collection('foods').delete(id);
      return true;
    } catch (error) {
      return false;
    }
  }
}
