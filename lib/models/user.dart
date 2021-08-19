class UserModel {
  final String id;
  final String? email;
  final String? bannerImageUrl;
  final String? profileImageUrl;
  final String? name;

  UserModel({
    required this.id,
    this.email,
    this.bannerImageUrl,
    this.profileImageUrl,
    this.name,
  });
}
