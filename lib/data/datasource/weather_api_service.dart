import 'package:dio/dio.dart';
import 'package:flutter_weather/core/constants/api_constants.dart';
import 'package:flutter_weather/data/models/forecast_model.dart';
import 'package:flutter_weather/data/models/location_model.dart';
import 'package:flutter_weather/data/models/weather_model.dart';

class WeatherApiService {
  final Dio _dio;

  WeatherApiService({Dio? dio})
      : _dio = dio ??
            Dio(BaseOptions(
              connectTimeout: const Duration(seconds: 15),
              receiveTimeout: const Duration(seconds: 15),
            ));

  /// Get current weather by coordinates
  Future<WeatherModel> getCurrentWeather(double lat, double lon) async {
    try {
      final response = await _dio.get(
        '${ApiConstants.baseUrl}/weather',
        queryParameters: {
          'lat': lat,
          'lon': lon,
          'appid': ApiConstants.apiKey,
          'units': ApiConstants.units,
        },
      );
      return WeatherModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get current weather by city name
  Future<WeatherModel> getCurrentWeatherByCity(String city) async {
    try {
      final response = await _dio.get(
        '${ApiConstants.baseUrl}/weather',
        queryParameters: {
          'q': city,
          'appid': ApiConstants.apiKey,
          'units': ApiConstants.units,
        },
      );
      return WeatherModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get 5-day / 3-hour forecast
  Future<ForecastModel> getForecast(double lat, double lon) async {
    try {
      final response = await _dio.get(
        '${ApiConstants.baseUrl}/forecast',
        queryParameters: {
          'lat': lat,
          'lon': lon,
          'appid': ApiConstants.apiKey,
          'units': ApiConstants.units,
        },
      );
      return ForecastModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Search locations by name (Geocoding API)
  Future<List<LocationModel>> searchLocations(String query) async {
    try {
      final response = await _dio.get(
        '${ApiConstants.geoUrl}/direct',
        queryParameters: {
          'q': query,
          'limit': 5,
          'appid': ApiConstants.apiKey,
        },
      );
      return (response.data as List)
          .map((json) => LocationModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Reverse geocoding - get location name from coordinates
  Future<LocationModel?> reverseGeocode(double lat, double lon) async {
    try {
      final response = await _dio.get(
        '${ApiConstants.geoUrl}/reverse',
        queryParameters: {
          'lat': lat,
          'lon': lon,
          'limit': 1,
          'appid': ApiConstants.apiKey,
        },
      );
      final list = response.data as List;
      if (list.isEmpty) return null;
      return LocationModel.fromJson(list.first);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timed out. Please check your internet.';
      case DioExceptionType.connectionError:
        return 'No internet connection.';
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 401) return 'Invalid API key.';
        if (statusCode == 404) return 'City not found.';
        if (statusCode == 429) return 'Too many requests. Try again later.';
        return 'Server error ($statusCode).';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}
