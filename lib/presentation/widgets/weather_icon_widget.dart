import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_weather/core/constants/api_constants.dart';

class WeatherIconWidget extends StatelessWidget {
  final String iconCode;
  final double size;

  const WeatherIconWidget({
    super.key,
    required this.iconCode,
    this.size = 64,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: ApiConstants.iconUrl(iconCode),
      width: size,
      height: size,
      fit: BoxFit.contain,
      placeholder: (context, url) => SizedBox(
        width: size,
        height: size,
        child: const Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      errorWidget: (context, url, error) => Icon(
        Icons.cloud,
        size: size * 0.6,
        color: Colors.white70,
      ),
    );
  }
}
