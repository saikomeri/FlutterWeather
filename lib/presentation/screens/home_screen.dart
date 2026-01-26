// Main weather display with pull-to-refresh
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_weather/core/utils/weather_utils.dart';
import 'package:flutter_weather/presentation/providers/weather_provider.dart';
import 'package:flutter_weather/presentation/screens/search_screen.dart';
import 'package:flutter_weather/presentation/screens/settings_screen.dart';
import 'package:flutter_weather/presentation/widgets/daily_forecast_widget.dart';
import 'package:flutter_weather/presentation/widgets/error_widget.dart';
import 'package:flutter_weather/presentation/widgets/hourly_forecast_widget.dart';
import 'package:flutter_weather/presentation/widgets/shimmer_loading.dart';
import 'package:flutter_weather/presentation/widgets/weather_detail_card.dart';
import 'package:flutter_weather/presentation/widgets/weather_icon_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    // Fetch weather on first load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(weatherProvider.notifier).fetchWeatherByLocation();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final weatherState = ref.watch(weatherProvider);
    final unit = ref.watch(temperatureUnitProvider);

    // Trigger animation when data loads
    if (weatherState.weather != null && !_fadeController.isCompleted) {
      _fadeController.forward();
    }

    final gradient = weatherState.weather != null
        ? WeatherUtils.getWeatherGradient(
            weatherState.weather!.condition,
            _isDaytime(weatherState.weather!.icon),
          )
        : WeatherUtils.getWeatherGradient('Clear', true);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: gradient,
          ),
        ),
        child: SafeArea(
          child: weatherState.isLoading && weatherState.weather == null
              ? const ShimmerLoading()
              : weatherState.error != null && weatherState.weather == null
                  ? WeatherErrorWidget(
                      message: weatherState.error!,
                      onRetry: () {
                        ref
                            .read(weatherProvider.notifier)
                            .fetchWeatherByLocation();
                      },
                    )
                  : _buildWeatherContent(weatherState, unit),
        ),
      ),
    );
  }

  bool _isDaytime(String icon) {
    return icon.endsWith('d');
  }

  Widget _buildWeatherContent(WeatherState state, TemperatureUnit unit) {
    final weather = state.weather!;
    final forecast = state.forecast;

    return RefreshIndicator(
      onRefresh: () => ref.read(weatherProvider.notifier).refresh(),
      color: Colors.white,
      backgroundColor: Colors.white.withOpacity(0.2),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            // App bar row
            _buildAppBar(),
            const SizedBox(height: 20),

            // Main weather info
            _buildMainWeather(weather, unit),
            const SizedBox(height: 32),

            // Hourly forecast
            if (forecast != null)
              HourlyForecastWidget(hourlyItems: forecast.items),
            const SizedBox(height: 24),

            // Weather details grid
            _buildWeatherDetails(weather, unit),
            const SizedBox(height: 24),

            // Daily forecast
            if (forecast != null)
              DailyForecastWidget(
                dailyForecasts: forecast.dailyForecasts,
              ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white, size: 28),
            onPressed: () async {
              final result = await Navigator.push<Map<String, double>>(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchScreen(),
                ),
              );
              if (result != null) {
                ref.read(weatherProvider.notifier).fetchWeatherByCoordinates(
                      result['lat']!,
                      result['lon']!,
                    );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined,
                color: Colors.white, size: 28),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMainWeather(dynamic weather, TemperatureUnit unit) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Location
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.location_on,
              color: Colors.white70,
              size: 18,
            ),
            const SizedBox(width: 4),
            Text(
              weather.cityName,
              style: theme.textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Weather icon
        WeatherIconWidget(
          iconCode: weather.icon,
          size: 100,
        ),

        // Temperature
        Text(
          WeatherUtils.formatTemperature(weather.temp, unit),
          style: theme.textTheme.displayLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w200,
            fontSize: 80,
            height: 1,
          ),
        ),
        const SizedBox(height: 8),

        // Description
        Text(
          weather.description[0].toUpperCase() +
              weather.description.substring(1),
          style: theme.textTheme.titleMedium?.copyWith(
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 4),

        // High / Low
        Text(
          'H: ${WeatherUtils.formatTemperature(weather.tempMax, unit)}  L: ${WeatherUtils.formatTemperature(weather.tempMin, unit)}',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.white60,
          ),
        ),

        // Feels like
        Text(
          'Feels like ${WeatherUtils.formatTemperature(weather.feelsLike, unit)}',
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.white54,
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherDetails(dynamic weather, TemperatureUnit unit) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.0,
        children: [
          WeatherDetailCard(
            icon: Icons.water_drop_outlined,
            label: 'Humidity',
            value: '${weather.humidity}%',
            iconColor: Colors.lightBlue.shade200,
          ),
          WeatherDetailCard(
            icon: Icons.air,
            label: 'Wind',
            value: '${weather.windSpeed.toStringAsFixed(1)} m/s',
            iconColor: Colors.teal.shade200,
          ),
          WeatherDetailCard(
            icon: Icons.compress,
            label: 'Pressure',
            value: '${weather.pressure} hPa',
            iconColor: Colors.purple.shade200,
          ),
          WeatherDetailCard(
            icon: Icons.visibility_outlined,
            label: 'Visibility',
            value: '${(weather.visibility / 1000).toStringAsFixed(1)} km',
            iconColor: Colors.amber.shade200,
          ),
          WeatherDetailCard(
            icon: Icons.cloud_outlined,
            label: 'Clouds',
            value: '${weather.clouds}%',
            iconColor: Colors.grey.shade300,
          ),
          WeatherDetailCard(
            icon: Icons.wb_sunny_outlined,
            label: 'UV Index',
            value: _getUvLabel(weather.clouds),
            iconColor: Colors.orange.shade200,
          ),
        ],
      ),
    );
  }

  String _getUvLabel(int clouds) {
    if (clouds > 80) return 'Low';
    if (clouds > 50) return 'Moderate';
    if (clouds > 20) return 'High';
    return 'Very High';
  }
}
