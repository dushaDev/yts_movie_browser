import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/movie.dart';

class YtsMovieCard extends StatelessWidget {
  final Movie movie;
  final bool isSelected;
  final VoidCallback onCardTap;
  final VoidCallback onDetailsTap;

  const YtsMovieCard({
    super.key,
    required this.movie,
    required this.isSelected,
    required this.onCardTap,
    required this.onDetailsTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // ANIMATION CONFIGURATION
    const duration = Duration(milliseconds: 850); // Slower, smoother time
    const curve = Curves.easeOutCubic; // Starts fast, slows down gently

    final borderSide = BorderSide(
      color: isSelected ? colorScheme.primary : Colors.transparent,
      width: 3,
    );

    return GestureDetector(
      onTap: onCardTap,
      child: AnimatedContainer(
        duration: duration,
        curve: curve,
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.fromBorderSide(borderSide),
          borderRadius: BorderRadius.circular(12), // Slightly more rounded
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: colorScheme.primary.withAlpha(80), // Soft glow
                blurRadius: 20, // Spread the glow out more
                spreadRadius: 0,
              ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(9), // Match inner radius
          child: Stack(
            fit: StackFit.expand,
            children: [
              // -------------------------------
              // LAYER 1: The Zooming Poster
              // -------------------------------
              AnimatedScale(
                scale: isSelected ? 1.1 : 1.0, // Zoom in 10% when selected
                duration: duration,
                curve: curve,
                child: CachedNetworkImage(
                  imageUrl: movie.mediumCoverImage,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      Container(color: const Color(0xFF212121)),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.error, color: Colors.grey),
                ),
              ),

              // -------------------------------
              // LAYER 2: Quality Tags
              // -------------------------------
              Positioned(
                top: 8,
                right: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildQualityBadge(context, "720p"),
                    const SizedBox(height: 4),
                    _buildQualityBadge(context, "1080p"),
                  ],
                ),
              ),

              // -------------------------------
              // LAYER 3: Dark Overlay (Fade In)
              // -------------------------------
              IgnorePointer(
                ignoring: !isSelected,
                child: AnimatedOpacity(
                  opacity: isSelected ? 1.0 : 0.0,
                  duration: duration,
                  curve: curve,
                  child: Container(
                    // We use a gradient here for a cooler look than plain black
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.6),
                          Colors.black.withOpacity(0.9),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Animated Star Scale
                        AnimatedScale(
                          scale: isSelected ? 1.0 : 0.0, // Pop the star in
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.elasticOut, // Bouncy effect for star
                          child: Icon(
                            Icons.star,
                            color: colorScheme.tertiary,
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${movie.rating} / 10",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          movie.genres.isNotEmpty
                              ? movie.genres.first
                              : "Action",
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: onDetailsTap,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.primary,
                              foregroundColor: colorScheme.onPrimary,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              "View Details",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // -------------------------------
              // LAYER 4: Title (Fade Out)
              // -------------------------------
              AnimatedOpacity(
                opacity: isSelected ? 0.0 : 1.0,
                duration: duration,
                curve: curve,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 4,
                    ),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black],
                      ),
                    ),
                    child: Text(
                      movie.title,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQualityBadge(BuildContext context, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        border: Border.all(color: Colors.white30, width: 0.5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
