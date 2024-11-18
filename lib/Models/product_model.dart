class ProductModel {
  final String id;
  final String name;
  final String category;
  final String description;
  final double price;
  final String imageUrl;

  ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    required this.imageUrl,
  });

  // Factory method to create a ProductModel from Firestore data
  factory ProductModel.fromFirestore(Map<String, dynamic> data, String id) {
    return ProductModel(
      id: id,
      name: data['product_name'] ?? 'Unnamed',
      category: data['category'] ?? 'Uncategorized',
      description: data['product_description'] ?? 'No description',
      price: (data['product_price'] ?? 0).toDouble(),
      imageUrl: data['product_imageURL'] ?? '',
    );
  }

  // Method to convert ProductModel to a map (for uploading/updating data)
  Map<String, dynamic> toMap() {
    return {
      'product_name': name,
      'category': category,
      'description': description,
      'price': price,
      'image_url': imageUrl,
    };
  }
}
