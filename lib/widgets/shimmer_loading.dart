import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

// --- CONFIGURATION ---
final Color _baseColor = Colors.grey[900]!; // Dark background for shimmer
final Color _highlightColor = Colors.grey[800]!; // Lighter wave color

// ==========================================
// 1. POPULAR SHIMMER (Horizontal)
// ==========================================
class PopularShimmer extends StatelessWidget {
  const PopularShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            itemCount: 4,
            itemBuilder: (_, __) => Padding(
              padding: const EdgeInsets.only(right: 10),
              // We wrap each card individually to ensure sharp edges
              child: Shimmer.fromColors(
                baseColor: _baseColor,
                highlightColor: _highlightColor,
                child: _buildDetailedCardPlaceholder(width: 140, height: 220),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ==========================================
// 2. LATEST SHIMMER (Grid)
// ==========================================
class LatestShimmer extends StatelessWidget {
  const LatestShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 7,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 2 / 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (_, __) => Shimmer.fromColors(
                baseColor: _baseColor,
                highlightColor: _highlightColor,
                child: _buildDetailedCardPlaceholder(
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Helper: Draws the Card with Image, Title Line, and Rating Line
Widget _buildDetailedCardPlaceholder({
  required double width,
  required double height,
}) {
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      // The background border container (simulating the card edge)
      border: Border.all(color: Colors.white24),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. POSTER IMAGE AREA (Takes up most space)
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white, // This part shimmers
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
          ),
        ),

        // 2. TEXT / DETAILS AREA
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Line
              Container(
                height: 12,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white, // This part shimmers
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 6), // Transparent gap (Does not shimmer)
              // Metadata Line (Year / Rating)
              Row(
                children: [
                  Container(
                    height: 10,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    height: 10,
                    width: 30,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
