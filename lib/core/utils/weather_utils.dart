import 'package:flutter/material.dart';

class WeatherUtils {
  WeatherUtils._();

  static String formatTemperature(double temp, {bool showUnit = true}) {
    return '${temp.round()}${showUnit ? '°C' : '°'}';
  }

  static String formatWindSpeed(double speed) {
    return '${speed.toStringAsFixed(1)} m/s';
  }

  static String formatHumidity(int humidity) {
    return '$humidity%';
  }

  static String formatVisibility(int visibility) {
    final km = visibility / 1000;
    return '${km.toStringAsFixed(1)} km';
  }

  static String formatPressure(int pressure) {
    return '$pressure hPa';
  }

  static String getWeatherAnimation(String mainCondition) {
    switch (mainCondition.toLowerCase()) {
      case 'clear':
        return 'sunny';
      case 'clouds':
        return 'cloudy';
      case 'rain':
      case 'drizzle':
        return 'rainy';
      case 'thunderstorm':
        return 'thunder';
      case 'snow':
        return 'snowy';
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'foggy';
      default:
        return 'sunny';
    }
  }

  static LinearGradient getWeatherGradient(String mainCondition, bool isDark) {
    if (isDark) {
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF1a1a2e), Color(0xFF16213e)],
      );
    }

    switch (mainCondition.toLowerCase()) {
      case 'clear':
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF4FC3F7), Color(0xFF0288D1)],
        );
      case 'clouds':
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF90A4AE), Color(0xFF546E7A)],
        );
      case 'rain':
      case 'drizzle':
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF5C6BC0), Color(0xFF283593)],
        );
      case 'thunderstorm':
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF37474F), Color(0xFF263238)],
        );
      case 'snow':
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFE0E0E0), Color(0xFFB0BEC5)],
        );
      default:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF4FC3F7), Color(0xFF0288D1)],
        );
    }
  }

  static IconData getWeatherIcon(String mainCondition) {
    switch (mainCondition.toLowerCase()) {
      case 'clear':
        return Icons.wb_sunny;
      case 'clouds':
        return Icons.cloud;
      case 'rain':
      case 'drizzle':
        return Icons.grain;
      case 'thunderstorm':
        return Icons.flash_on;
      case 'snow':
        return Icons.ac_unit;
      case 'mist':
      case 'fog':
      case 'haze':
        return Icons.blur_on;
      default:
        return Icons.wb_sunny;
    }
  }

  static String getDayName(DateTime date) {
    final now = DateTime.now();
    if (date.day == now.day &&
        date.month == now.month &&
        date.year == now.year) {
      return 'Today';
    }
    final tomorrow = now.add(const Duration(days: 1));
    if (date.day == tomorrow.day &&
        date.month == tomorrow.month &&
        date.year == tomorrow.year) {
      return 'Tomorrow';
    }
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[date.weekday - 1];
  }

  static String getTimeString(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
