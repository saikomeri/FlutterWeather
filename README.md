# FlutterWeather

A beautiful, animated weather application built with Flutter and Riverpod, featuring real-time weather data from OpenWeatherMap API, location-based forecasts, and a polished glassmorphism-inspired UI.

## Features

- **Current Weather** - Real-time temperature, conditions, humidity, wind, pressure, and visibility
- **Hourly Forecast** - 24-hour forecast in scrollable horizontal cards
- **5-Day Forecast** - Daily high/low with gradient temperature bars
- **Location-Based** - Auto-detect user location with Geolocator
- **City Search** - Debounced search with geocoding for worldwide locations
- **Popular Cities** - Quick-access chips for major global cities
- **Pull-to-Refresh** - Swipe down to refresh weather data
- **Animated UI** - Fade-in animations, dynamic weather gradients, shimmer loading
- **Dark/Light Theme** - Full theme support with Google Fonts
- **Temperature Units** - Toggle between Celsius and Fahrenheit
- **Responsive Design** - Adaptive layouts for different screen sizes

## Tech Stack

| Technology | Purpose |
|-----------|---------|
| **Flutter** | Cross-platform UI framework |
| **Riverpod** | State management with StateNotifier pattern |
| **Dio** | HTTP client for API communication |
| **Geolocator** | Device location services |
| **Geocoding** | Reverse geocoding for location search |
| **Cached Network Image** | Async image loading with caching |
| **Shimmer** | Loading state placeholders |
| **Google Fonts** | Custom typography (Poppins) |
| **FL Chart** | Chart rendering utilities |

## Architecture

```
lib/
├── core/
│   ├── constants/     # API endpoints, app-wide constants
│   ├── theme/         # Light/dark Material themes with Google Fonts
│   └── utils/         # Temperature formatting, weather gradients, icons
├── data/
│   ├── datasource/    # Dio-based API service (OpenWeatherMap)
│   ├── models/        # WeatherModel, ForecastModel, LocationModel
│   └── repository/    # Repository layer wrapping API service
└── presentation/
    ├── providers/     # Riverpod providers (Weather, Search, Theme, Units)
    ├── screens/       # Home, Search, Settings screens
    └── widgets/       # Reusable UI components
```

## Widgets

- **WeatherIconWidget** - Cached weather condition icons from OpenWeatherMap
- **WeatherDetailCard** - Glassmorphic detail cards (humidity, wind, pressure, etc.)
- **HourlyForecastWidget** - Horizontal scrollable hourly forecast
- **DailyForecastWidget** - 5-day forecast with custom Canvas temperature bars
- **ShimmerLoading** - Shimmer placeholder during data loading
- **WeatherErrorWidget** - Error state with retry action

## State Management

Uses Riverpod `StateNotifier` pattern:

- `WeatherNotifier` → Manages current weather + forecast state with loading/error handling
- `SearchNotifier` → Manages city search with debounced queries
- `isDarkModeProvider` → Theme toggle state
- `temperatureUnitProvider` → Celsius/Fahrenheit preference

## API

Uses the [OpenWeatherMap API](https://openweathermap.org/api):

- `GET /data/2.5/weather` - Current weather by coordinates or city name
- `GET /data/2.5/forecast` - 5-day/3-hour forecast
- `GET /geo/1.0/direct` - Geocoding (city name → coordinates)
- `GET /geo/1.0/reverse` - Reverse geocoding (coordinates → city name)

## Dynamic Theming

Weather conditions drive the UI gradient background:
- ☀️ **Clear** - Warm amber/blue gradients (day) or deep navy (night)
- 🌧️ **Rain** - Steel blue/grey tones
- ⛈️ **Thunderstorm** - Dark purple/indigo
- 🌨️ **Snow** - Cool ice blue/white
- 🌫️ **Fog/Mist** - Muted grey gradients
- ☁️ **Cloudy** - Soft blue-grey blend

## Setup

1. Clone the repository
2. Get a free API key from [OpenWeatherMap](https://openweathermap.org/api)
3. Update the API key in `lib/core/constants/api_constants.dart`
4. Run `flutter pub get`
5. Run `flutter run`

## Author

**Sai Sampurna Komeri** - Mobile Developer
