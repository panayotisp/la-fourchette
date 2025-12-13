import 'preloaded_images.dart';

/// Service responsible for retrieving images using the three-tier approach:
/// 1. Preloaded library (instant)
/// 2. SQL cache (requires backend)
/// 3. Translation + Unsplash API (requires backend)
class ImageService {
  /// Tier 1: Check preloaded library first
  Future<ImageData?> getImageForDish(String greekDishName) async {
    // Try preloaded library first
    final preloaded = PreloadedImages.getImage(greekDishName);
    if (preloaded != null) {
      return preloaded;
    }

    // TODO: Tier 2 - Check SQL cache via backend API
    // final cached = await _checkCache(greekDishName);
    // if (cached != null) return cached;

    // TODO: Tier 3 - Translate + search Unsplash + save to cache
    // return await _searchAndCache(greekDishName);

    // For now, return null (will use placeholder)
    return null;
  }

  // TODO: Implement when backend is ready
  // Future<ImageData?> _checkCache(String dishName) async {
  //   final response = await http.get(
  //     Uri.parse('$apiBaseUrl/api/images/cache/$dishName'),
  //   );
  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);
  //     return ImageData.fromJson(data);
  //   }
  //   return null;
  // }

  // Future<ImageData?> _searchAndCache(String greekDishName) async {
  //   final response = await http.post(
  //     Uri.parse('$apiBaseUrl/api/images/search'),
  //     body: jsonEncode({'dish_name': greekDishName}),
  //   );
  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);
  //     return ImageData.fromJson(data);
  //   }
  //   return null;
  // }
}
