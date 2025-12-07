import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/movie.dart';

class YtsMovieCard extends StatelessWidget {
  final Movie movie;
  final bool isSelected;
  final IconData savedIcon;
  final Color savedColor;
  final VoidCallback onCardTap;
  final VoidCallback onDetailsTap;
  final VoidCallback onSaveTap;
  final bool isShortText;

  const YtsMovieCard({
    super.key,
    required this.movie,
    required this.isSelected,
    required this.savedIcon,
    required this.savedColor,
    required this.onCardTap,
    required this.onDetailsTap,
    required this.onSaveTap,
    this.isShortText = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // ANIMATION CONFIGURATION
    const duration = Duration(milliseconds: 800); // Slower, smoother time
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
                          Colors.black.withAlpha(190),
                          Colors.black.withAlpha(200),
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
                        Row(
                          children: [
                            // View Details Button (Expanded)
                            Expanded(
                              child: SizedBox(
                                height: 40,
                                child: ElevatedButton(
                                  onPressed: onDetailsTap,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: colorScheme.primary,
                                    foregroundColor: colorScheme.onPrimary,
                                    padding: EdgeInsets.zero, // Compact text
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0,
                                    ),
                                    child: Text(
                                      isShortText ? "View" : "View Details",
                                      maxLines: 1,
                                      style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 8),

                            // Save Button (Icon Only)
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(
                                  70,
                                ), // Glass effect
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: IconButton(
                                icon: Icon(
                                  savedIcon,
                                  color: savedColor,
                                  size: 20,
                                ),
                                onPressed:
                                    onSaveTap, // <--- Call the save function
                                padding: EdgeInsets.zero,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // -------------------------------
              // LAYER 4: Title (Fade Out)
              // -------------------------------
              IgnorePointer(
                ignoring: isSelected,
                child: AnimatedOpacity(
                  opacity: isSelected ? 0.0 : 1.0,
                  duration: duration,
                  curve: curve,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 8,
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
                        textAlign: TextAlign.start,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
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
        color: Colors.black.withAlpha(160),
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
