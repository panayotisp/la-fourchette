/// Tier 1: Preloaded Image Library
/// 
/// This hard-coded map provides instant image URLs for the most common Greek dishes
/// served at the company restaurant. This avoids API calls for ~70-80% of menu items.
/// 
/// Images are sourced from Unsplash with proper attribution.

class PreloadedImages {
  static const Map<String, ImageData> library = {
    // Main Dishes
    'μουσακάς': ImageData(
      url: 'https://images.unsplash.com/photo-1621852004158-f3bc7b6e9a16',
      photographer: 'Hert Niks',
      photoId: 'photo-1621852004158-f3bc7b6e9a16',
    ),
    'παστίτσιο': ImageData(
      url: 'https://images.unsplash.com/photo-1473093295043-cdd812d0e601',
      photographer: 'Sorin Gheorghita',
      photoId: 'photo-1473093295043-cdd812d0e601',
    ),
    'σουβλάκι': ImageData(
      url: 'https://images.unsplash.com/photo-1603360946369-dc9bb56dff83',
      photographer: 'Jimmy Dean',
      photoId: 'photo-1603360946369-dc9bb56dff83',
    ),
    'σουβλάκι κοτόπουλο': ImageData(
      url: 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1',
      photographer: 'Ella Olsson',
      photoId: 'photo-1555939594-58d7cb561ad1',
    ),
    'γιουβέτσι': ImageData(
      url: 'https://images.unsplash.com/photo-1621996346865-749c0e0d4f31',
      photographer: 'Eiliv Aceron',
      photoId: 'photo-1621996346865-749c0e0d4f31',
    ),
    'κοτόπουλο σχάρας': ImageData(
      url: 'https://images.unsplash.com/photo-1598103442097-8b74394b95c6',
      photographer: 'Louis Hansel',
      photoId: 'photo-1598103442097-8b74394b95c6',
    ),
    'φιλέτο κοτόπουλο': ImageData(
      url: 'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d',
      photographer: 'Lily Banse',
      photoId: 'photo-1604908176997-125f25cc6f3d',
    ),
    'σπαγγέτι μπολονέζ': ImageData(
      url: 'https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9',
      photographer: 'Chad Montano',
      photoId: 'photo-1621996346565-e3dbc646d9a9',
    ),
    'κρεατόσουπα': ImageData(
      url: 'https://images.unsplash.com/photo-1547592166-23ac45744acd',
      photographer: 'Calum Lewis',
      photoId: 'photo-1547592166-23ac45744acd',
    ),
    'ρολό κιμά': ImageData(
      url: 'https://images.unsplash.com/photo-1619895092538-128341789043',
      photographer: 'Towfiqu barbhuiya',
      photoId: 'photo-1619895092538-128341789043',
    ),
    
    // Vegetarian Options
    'μαυρομάτικα': ImageData(
      url: 'https://images.unsplash.com/photo-1598515214211-89d3c73ae83a',
      photographer: 'Deryn Macey',
      photoId: 'photo-1598515214211-89d3c73ae83a',
    ),
    'φασόλια': ImageData(
      url: 'https://images.unsplash.com/photo-1578895101408-1a36b834405b',
      photographer: 'Deryn Macey',
      photoId: 'photo-1578895101408-1a36b834405b',
    ),
    'γίγαντες πλακί': ImageData(
      url: 'https://images.unsplash.com/photo-1585032226651-759b368d7246',
      photographer: 'Louis Hansel',
      photoId: 'photo-1585032226651-759b368d7246',
    ),
    'μπάμιες': ImageData(
      url: 'https://images.unsplash.com/photo-1606923829579-0cb981a83e2e',
      photographer: 'Pranjali Phadnis',
      photoId: 'photo-1606923829579-0cb981a83e2e',
    ),
    'χόρτα': ImageData(
      url: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd',
      photographer: 'Anna Pelzer',
      photoId: 'photo-1512621776951-a57141f2eefd',
    ),
    
    // Fish Dishes
    'γλώσσα': ImageData(
      url: 'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2',
      photographer: 'Caroline Attwood',
      photoId: 'photo-1519708227418-c8fd9a32b7a2',
    ),
    'μπακαλιάρος': ImageData(
      url: 'https://images.unsplash.com/photo-1580959375944-57c8f26340d5',
      photographer: 'CA Creative',
      photoId: 'photo-1580959375944-57c8f26340d5',
    ),
    'σολομός': ImageData(
      url: 'https://images.unsplash.com/photo-1467003909585-2f8a72700288',
      photographer: 'Caroline Attwood',
      photoId: 'photo-1467003909585-2f8a72700288',
    ),
    
    // Pork/Meat
    'χοιρινή τηγανιά': ImageData(
      url: 'https://images.unsplash.com/photo-1432139555190-58524dae6a55',
      photographer: 'Jakub Kapusnak',
      photoId: 'photo-1432139555190-58524dae6a55',
    ),
    'σνίτσελ': ImageData(
      url: 'https://images.unsplash.com/photo-1604909052868-73d743f97b1b',
      photographer: 'Farhad Ibrahimzade',
      photoId: 'photo-1604909052868-73d743f97b1b',
    ),
    'μπριζόλα': ImageData(
      url: 'https://images.unsplash.com/photo-1600891964092-4316c288032e',
      photographer: 'Emilio Garcia',
      photoId: 'photo-1600891964092-4316c288032e',
    ),
    
    // Side Dishes
    'πατάτες φούρνου': ImageData(
      url: 'https://images.unsplash.com/photo-1573047829542-39ce8fdc69dd',
      photographer: 'Kristiana Pinne',
      photoId: 'photo-1573047829542-39ce8fdc69dd',
    ),
    'ρύζι': ImageData(
      url: 'https://images.unsplash.com/photo-1516684732162-798a0062be99',
      photographer: 'Pierre Bamin',
      photoId: 'photo-1516684732162-798a0062be99',
    ),
    'πατατοσαλάτα': ImageData(
      url: 'https://images.unsplash.com/photo-1614960024989-51ab8d8ba2c7',
      photographer: 'Natasha Bhogal',
      photoId: 'photo-1614960024989-51ab8d8ba2c7',
    ),
  };

  /// Lookup image by Greek dish name (case-insensitive, normalized)
  static ImageData? getImage(String dishName) {
    final normalized = dishName.toLowerCase().trim();
    
    // Direct match
    if (library.containsKey(normalized)) {
      return library[normalized];
    }
    
    // Partial match (e.g., "φιλέτο κοτόπουλο σχάρας" matches "φιλέτο κοτόπουλο")
    for (final entry in library.entries) {
      if (normalized.contains(entry.key) || entry.key.contains(normalized)) {
        return entry.value;
      }
    }
    
    return null;
  }
}

class ImageData {
  final String url;
  final String photographer;
  final String photoId;

  const ImageData({
    required this.url,
    required this.photographer,
    required this.photoId,
  });
}
