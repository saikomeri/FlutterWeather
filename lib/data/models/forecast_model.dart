class ForecastModel {
  final List<ForecastItem> hourly;
  final List<DailyForecast> daily;
  final String cityName;

  ForecastModel({
    required this.hourly,
    required this.daily,
    required this.cityName,
  });

  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    final list = json['list'] as List<dynamic>;
    final city = json['city'];

    final hourly = list.map((item) => ForecastItem.fromJson(item)).toList();

    // Group by day for daily forecasts
    final Map<String, List<ForecastItem>> grouped = {};
    for (final item in hourly) {
      final dayKey =
          '${item.dateTime.year}-${item.dateTime.month}-${item.dateTime.day}';
      grouped.putIfAbsent(dayKey, () => []);
      grouped[dayKey]!.add(item);
    }

    final daily = grouped.entries.map((entry) {
      final items = entry.value;
      final temps = items.map((i) => i.temperature).toList();
      return DailyForecast(
        dateTime: items.first.dateTime,
        tempMin: temps.reduce((a, b) => a < b ? a : b),
        tempMax: temps.reduce((a, b) => a > b ? a : b),
        mainCondition: items[items.length ~/ 2].mainCondition,
        icon: items[items.length ~/ 2].icon,
        description: items[items.length ~/ 2].description,
        humidity: items.map((i) => i.humidity).reduce((a, b) => a + b) ~/
            items.length,
        windSpeed:
            items.map((i) => i.windSpeed).reduce((a, b) => a + b) /
                items.length,
      );
    }).toList();

    return ForecastModel(
      hourly: hourly,
      daily: daily,
      cityName: city?['name'] ?? '',
    );
  }
}

class ForecastItem {
  final DateTime dateTime;
  final double temperature;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final String mainCondition;
  final String description;
  final String icon;
  final double pop; // Probability of precipitation

  ForecastItem({
    required this.dateTime,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.mainCondition,
    required this.description,
    required this.icon,
    required this.pop,
  });

  factory ForecastItem.fromJson(Map<String, dynamic> json) {
    final weather = json['weather'][0];
    final main = json['main'];

    return ForecastItem(
      dateTime: DateTime.fromMillisecondsSinceEpoch((json['dt'] ?? 0) * 1000),
      temperature: (main['temp'] ?? 0).toDouble(),
      feelsLike: (main['feels_like'] ?? 0).toDouble(),
      humidity: main['humidity'] ?? 0,
      windSpeed: (json['wind']?['speed'] ?? 0).toDouble(),
      mainCondition: weather['main'] ?? '',
      description: weather['description'] ?? '',
      icon: weather['icon'] ?? '01d',
      pop: (json['pop'] ?? 0).toDouble(),
    );
  }
}

class DailyForecast {
  final DateTime dateTime;
  final double tempMin;
  final double tempMax;
  final String mainCondition;
  final String icon;
  final String description;
  final int humidity;
  final double windSpeed;

  DailyForecast({
    required this.dateTime,
    required this.tempMin,
    required this.tempMax,
    required this.mainCondition,
    required this.icon,
    required this.description,
    required this.humidity,
    required this.windSpeed,
  });
}
