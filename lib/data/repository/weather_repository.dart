import 'package:flutter_weather/data/datasource/weather_api_service.dart';
import 'package:flutter_weather/data/models/forecast_model.dart';
import 'package:flutter_weather/data/models/location_model.dart';
import 'package:flutter_weather/data/models/weather_model.dart';

class WeatherRepository {
  final WeatherApiService _apiService;

  WeatherRepository({WeatherApiService? apiService})
      : _apiService = apiService ?? WeatherApiService();

  Future<WeatherModel> getCurrentWeather(double lat, double lon) {
    return _apiService.getCurrentWeather(lat, lon);
  }

  Future<WeatherModel> getCurrentWeatherByCity(String city) {
    return _apiService.getCurrentWeatherByCity(city);
  }

  Future<ForecastModel> getForecast(double lat, double lon) {
    return _apiService.getForecast(lat, lon);
  }

  Future<List<LocationModel>> searchLocations(String query) {
    return _apiService.searchLocations(query);
  }

  Future<LocationModel?> reverseGeocode(double lat, double lon) {
    return _apiService.reverseGeocode(lat, lon);
  }
}
