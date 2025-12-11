class LocationModel {
  final String name;
  final double lat;
  final double lon;
  final String country;
  final String? state;

  LocationModel({
    required this.name,
    required this.lat,
    required this.lon,
    required this.country,
    this.state,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      name: json['name'] ?? '',
      lat: (json['lat'] ?? 0).toDouble(),
      lon: (json['lon'] ?? 0).toDouble(),
      country: json['country'] ?? '',
      state: json['state'],
    );
  }

  String get displayName {
    final parts = [name];
    if (state != null && state!.isNotEmpty) parts.add(state!);
    parts.add(country);
    return parts.join(', ');
  }
}
