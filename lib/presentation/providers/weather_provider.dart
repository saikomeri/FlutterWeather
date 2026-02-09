// Riverpod providers for weather state management
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_weather/data/models/forecast_model.dart';
import 'package:flutter_weather/data/models/location_model.dart';
import 'package:flutter_weather/data/models/weather_model.dart';
import 'package:flutter_weather/data/repository/weather_repository.dart';
import 'package:geolocator/geolocator.dart';

// Repository Provider
final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  return WeatherRepository();
});

// Current Weather State
class WeatherState {
  final WeatherModel? weather;
  final ForecastModel? forecast;
  final bool isLoading;
  final String? error;

  const WeatherState({
    this.weather,
    this.forecast,
    this.isLoading = false,
    this.error,
  });

  WeatherState copyWith({
    WeatherModel? weather,
    ForecastModel? forecast,
    bool? isLoading,
    String? error,
  }) {
    return WeatherState(
      weather: weather ?? this.weather,
      forecast: forecast ?? this.forecast,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Weather Notifier
class WeatherNotifier extends StateNotifier<WeatherState> {
  final WeatherRepository _repository;

  WeatherNotifier(this._repository) : super(const WeatherState());

  Future<void> fetchWeatherByLocation() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          state = state.copyWith(
            isLoading: false,
            error: 'Location permission denied. Please search for a city.',
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        state = state.copyWith(
          isLoading: false,
          error: 'Location permission permanently denied. Search for a city.',
        );
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
        timeLimit: const Duration(seconds: 10),
      );

      await _fetchWeatherData(position.latitude, position.longitude);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> fetchWeatherByCity(String city) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final weather = await _repository.getCurrentWeatherByCity(city);
      final forecast = await _repository.getForecast(weather.lat, weather.lon);

      state = WeatherState(
        weather: weather,
        forecast: forecast,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> fetchWeatherByCoordinates(double lat, double lon) async {
    state = state.copyWith(isLoading: true, error: null);
    await _fetchWeatherData(lat, lon);
  }

  Future<void> refresh() async {
    if (state.weather != null) {
      await _fetchWeatherData(state.weather!.lat, state.weather!.lon);
    } else {
      await fetchWeatherByLocation();
    }
  }

  Future<void> _fetchWeatherData(double lat, double lon) async {
    try {
      final weather = await _repository.getCurrentWeather(lat, lon);
      final forecast = await _repository.getForecast(lat, lon);

      state = WeatherState(
        weather: weather,
        forecast: forecast,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}

// Weather Provider
final weatherProvider =
    StateNotifierProvider<WeatherNotifier, WeatherState>((ref) {
  final repository = ref.watch(weatherRepositoryProvider);
  return WeatherNotifier(repository);
});

// Search State
class SearchState {
  final List<LocationModel> results;
  final bool isLoading;
  final String? error;

  const SearchState({
    this.results = const [],
    this.isLoading = false,
    this.error,
  });
}

// Search Notifier
class SearchNotifier extends StateNotifier<SearchState> {
  final WeatherRepository _repository;

  SearchNotifier(this._repository) : super(const SearchState());

  Future<void> search(String query) async {
    if (query.length < 2) {
      state = const SearchState();
      return;
    }

    state = SearchState(isLoading: true, results: state.results);

    try {
      final results = await _repository.searchLocations(query);
      state = SearchState(results: results);
    } catch (e) {
      state = SearchState(error: e.toString());
    }
  }

  void clear() {
    state = const SearchState();
  }
}

// Search Provider
final searchProvider =
    StateNotifierProvider<SearchNotifier, SearchState>((ref) {
  final repository = ref.watch(weatherRepositoryProvider);
  return SearchNotifier(repository);
});

// Theme Provider
final isDarkModeProvider = StateProvider<bool>((ref) => false);

// Temperature Unit Provider
enum TemperatureUnit { celsius, fahrenheit }

final temperatureUnitProvider =
    StateProvider<TemperatureUnit>((ref) => TemperatureUnit.celsius);
