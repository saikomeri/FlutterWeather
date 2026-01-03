import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_weather/core/utils/weather_utils.dart';
import 'package:flutter_weather/data/models/forecast_model.dart';
import 'package:flutter_weather/presentation/providers/weather_provider.dart';
import 'package:flutter_weather/presentation/widgets/weather_icon_widget.dart';

class DailyForecastWidget extends ConsumerWidget {
  final List<DailyForecast> dailyForecasts;

  const DailyForecastWidget({
    super.key,
    required this.dailyForecasts,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unit = ref.watch(temperatureUnitProvider);
    final theme = Theme.of(context);

    if (dailyForecasts.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            '5-Day Forecast',
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: List.generate(dailyForecasts.length, (index) {
              final daily = dailyForecasts[index];
              final isToday = index == 0;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    // Day name
                    SizedBox(
                      width: 80,
                      child: Text(
                        isToday ? 'Today' : WeatherUtils.getDayName(daily.date),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontWeight:
                              isToday ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                    // Weather icon
                    WeatherIconWidget(
                      iconCode: daily.icon,
                      size: 36,
                    ),
                    const SizedBox(width: 8),
                    // Description
                    Expanded(
                      child: Text(
                        daily.description,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white60,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Temperature range
                    Text(
                      WeatherUtils.formatTemperature(daily.tempMin, unit),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white54,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildTemperatureBar(daily, dailyForecasts),
                    const SizedBox(width: 8),
                    Text(
                      WeatherUtils.formatTemperature(daily.tempMax, unit),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildTemperatureBar(
      DailyForecast daily, List<DailyForecast> allDays) {
    // Find global min/max for the bar scale
    final globalMin = allDays
        .map((d) => d.tempMin)
        .reduce((a, b) => a < b ? a : b);
    final globalMax = allDays
        .map((d) => d.tempMax)
        .reduce((a, b) => a > b ? a : b);
    final range = globalMax - globalMin;

    if (range == 0) {
      return SizedBox(
        width: 60,
        height: 4,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      );
    }

    final startFraction = (daily.tempMin - globalMin) / range;
    final endFraction = (daily.tempMax - globalMin) / range;

    return SizedBox(
      width: 60,
      height: 4,
      child: CustomPaint(
        painter: _TemperatureBarPainter(
          startFraction: startFraction,
          endFraction: endFraction,
        ),
      ),
    );
  }
}

class _TemperatureBarPainter extends CustomPainter {
  final double startFraction;
  final double endFraction;

  _TemperatureBarPainter({
    required this.startFraction,
    required this.endFraction,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Background track
    final bgPaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(2),
      ),
      bgPaint,
    );

    // Temperature gradient bar
    final left = size.width * startFraction;
    final right = size.width * endFraction;
    final gradient = LinearGradient(
      colors: [
        Colors.blue.shade300,
        Colors.green.shade300,
        Colors.yellow.shade400,
        Colors.orange.shade400,
        Colors.red.shade400,
      ],
    );

    final barPaint = Paint()
      ..shader = gradient.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      )
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(left, 0, right, size.height),
        const Radius.circular(2),
      ),
      barPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _TemperatureBarPainter oldDelegate) {
    return startFraction != oldDelegate.startFraction ||
        endFraction != oldDelegate.endFraction;
  }
}
