
class LostFoundItem {
  final int? id;
  final String itemType;
  final String description;
  final String status;
  final String location;
  final List<String> imageUrls;
  final int userId;
  final String? profileImageUrl;
  final String? fullName;
  final DateTime createdAt;

  LostFoundItem({
    this.id,
    required this.itemType,
    required this.description,
    required this.status,
    required this.location,
    required this.imageUrls,
    required this.userId,
    this.profileImageUrl,
    this.fullName,
    required this.createdAt,
  });

  factory LostFoundItem.fromJson(Map<String, dynamic> json) {
    return LostFoundItem(
      id: json['id'],
      itemType: json['item_type'],
      description: json['description'],
      status: json['status'],
      location: json['location'],
      imageUrls: List<String>.from(json['image_urls'] ?? []),
      userId: json['user_id'],
      profileImageUrl: json['profileImageUrl'],
      fullName: json['full_name'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'item_type': itemType,
      'description': description,
      'status': status,
      'location': location,
      'image_urls': imageUrls,
    };
  }
}