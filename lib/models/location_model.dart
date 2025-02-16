class LocationModel {
  final String id;
  final String name;
  final String country;

  LocationModel({
    required this.id,
    required this.name,
    required this.country,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['Key'],
      name: json['LocalizedName'],
      country: json['Country']['LocalizedName'],
    );
  }
}
