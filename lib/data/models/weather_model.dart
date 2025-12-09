class WeatherModel {
  final String cityName;
  final String country;
  final double lat;
  final double lon;
  final double temperature;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int humidity;
  final int pressure;
  final int visibility;
  final double windSpeed;
  final int windDeg;
  final int clouds;
  final String mainCondition;
  final String description;
  final String icon;
  final DateTime dateTime;
  final DateTime? sunrise;
  final DateTime? sunset;

  WeatherModel({
    required this.cityName,
    required this.country,
    required this.lat,
    required this.lon,
    required this.temperature,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.humidity,
    required this.pressure,
    required this.visibility,
    required this.windSpeed,
    required this.windDeg,
    required this.clouds,
    required this.mainCondition,
    required this.description,
    required this.icon,
    required this.dateTime,
    this.sunrise,
    this.sunset,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final weather = json['weather'][0];
    final main = json['main'];
    final wind = json['wind'];
    final sys = json['sys'] ?? {};

    return WeatherModel(
      cityName: json['name'] ?? '',
      country: sys['country'] ?? '',
      lat: (json['coord']?['lat'] ?? 0).toDouble(),
      lon: (json['coord']?['lon'] ?? 0).toDouble(),
      temperature: (main['temp'] ?? 0).toDouble(),
      feelsLike: (main['feels_like'] ?? 0).toDouble(),
      tempMin: (main['temp_min'] ?? 0).toDouble(),
      tempMax: (main['temp_max'] ?? 0).toDouble(),
      humidity: main['humidity'] ?? 0,
      pressure: main['pressure'] ?? 0,
      visibility: json['visibility'] ?? 0,
      windSpeed: (wind['speed'] ?? 0).toDouble(),
      windDeg: wind['deg'] ?? 0,
      clouds: json['clouds']?['all'] ?? 0,
      mainCondition: weather['main'] ?? '',
      description: weather['description'] ?? '',
      icon: weather['icon'] ?? '01d',
      dateTime: DateTime.fromMillisecondsSinceEpoch(
        (json['dt'] ?? 0) * 1000,
      ),
      sunrise: sys['sunrise'] != null
          ? DateTime.fromMillisecondsSinceEpoch(sys['sunrise'] * 1000)
          : null,
      sunset: sys['sunset'] != null
          ? DateTime.fromMillisecondsSinceEpoch(sys['sunset'] * 1000)
          : null,
    );
  }
}
