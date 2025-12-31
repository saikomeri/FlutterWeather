import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_weather/core/utils/weather_utils.dart';
import 'package:flutter_weather/data/models/forecast_model.dart';
import 'package:flutter_weather/presentation/providers/weather_provider.dart';
import 'package:flutter_weather/presentation/widgets/weather_icon_widget.dart';

class HourlyForecastWidget extends ConsumerWidget {
  final List<ForecastItem> hourlyItems;

  const HourlyForecastWidget({
    super.key,
    required this.hourlyItems,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unit = ref.watch(temperatureUnitProvider);
    final theme = Theme.of(context);

    if (hourlyItems.isEmpty) return const SizedBox.shrink();

    // Show next 24 hours (8 items at 3-hour intervals)
    final items = hourlyItems.take(8).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Hourly Forecast',
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final time = DateTime.fromMillisecondsSinceEpoch(
                item.dt * 1000,
              );
              final isNow = index == 0;

              return Container(
                width: 80,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 8,
                ),
                decoration: BoxDecoration(
                  color: isNow
                      ? Colors.white.withOpacity(0.2)
                      : Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: isNow
                      ? Border.all(color: Colors.white.withOpacity(0.3))
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      isNow
                          ? 'Now'
                          : '${time.hour.toString().padLeft(2, '0')}:00',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white70,
                        fontWeight: isNow ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                    WeatherIconWidget(
                      iconCode: item.icon,
                      size: 40,
                    ),
                    Text(
                      WeatherUtils.formatTemperature(item.temp, unit),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
