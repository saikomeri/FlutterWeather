import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoading extends StatelessWidget {
  const ShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.white.withOpacity(0.1),
      highlightColor: Colors.white.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 60),
            // City name placeholder
            _buildShimmerBox(width: 160, height: 24),
            const SizedBox(height: 24),
            // Temperature placeholder
            _buildShimmerBox(width: 120, height: 64),
            const SizedBox(height: 16),
            // Condition placeholder
            _buildShimmerBox(width: 140, height: 20),
            const SizedBox(height: 8),
            // High/Low placeholder
            _buildShimmerBox(width: 100, height: 16),
            const SizedBox(height: 40),
            // Hourly forecast placeholder
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: _buildShimmerBox(width: 70, height: 120, radius: 20),
                  );
                },
              ),
            ),
            const SizedBox(height: 32),
            // Daily forecast placeholder
            ...List.generate(5, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: _buildShimmerBox(
                  width: double.infinity,
                  height: 48,
                  radius: 12,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerBox({
    required double width,
    required double height,
    double radius = 8,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
