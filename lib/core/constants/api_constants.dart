class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';
  static const String geoUrl = 'https://api.openweathermap.org/geo/1.0';
  static const String iconUrl = 'https://openweathermap.org/img/wn';

  // Replace with your OpenWeatherMap API key
  static const String apiKey = 'YOUR_API_KEY_HERE';

  static const String units = 'metric'; // metric or imperial

  static String weatherIconUrl(String iconCode, {int size = 4}) =>
      '$iconUrl/$iconCode@${size}x.png';
}
