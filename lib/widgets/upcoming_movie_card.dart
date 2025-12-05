import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/movie.dart';

class UpcomingMovieCard extends StatelessWidget {
  final Movie movie;
  final bool isSelected;
  final VoidCallback onTap;

  const UpcomingMovieCard({
    super.key,
    required this.movie,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // ANIMATION CONSTANTS
    const duration = Duration(milliseconds: 350);
    const curve = Curves.easeOutCubic;

    // Use TERTIARY color (Gold/Amber) for Upcoming items instead of Green
    final activeColor = colorScheme.tertiary;

    final borderSide = BorderSide(
      color: isSelected ? activeColor : Colors.transparent,
      width: 3,
    );

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: duration,
        curve: curve,
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.fromBorderSide(borderSide),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: activeColor.withAlpha(80),
                blurRadius: 20,
                spreadRadius: 0,
              )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(9),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // -------------------------------
              // LAYER 1: Poster (Greyscale hint?)
              // -------------------------------
              AnimatedScale(
                scale: isSelected ? 1.1 : 1.0,
                duration: duration,
                curve: curve,
                child: CachedNetworkImage(
                  imageUrl: movie.mediumCoverImage,
                  fit: BoxFit.cover,
                  // Optional: Color filter to make upcoming movies look slightly different
                  color: isSelected ? null : Colors.black.withOpacity(0.2),
                  colorBlendMode: BlendMode.darken,
                  placeholder: (context, url) => Container(color: const Color(0xFF212121)),
                  errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.grey),
                ),
              ),

              // -------------------------------
              // LAYER 2: "COMING SOON" Badge
              // -------------------------------
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  decoration: BoxDecoration(
                    color: activeColor, // Gold background
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))
                    ],
                  ),
                  child: Text(
                    "COMING SOON",
                    style: TextStyle(
                      color: colorScheme.onTertiary, // Black text usually
                      fontSize: 8,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),

              // -------------------------------
              // LAYER 3: Overlay info
              // -------------------------------
              IgnorePointer(
                ignoring: !isSelected,
                child: AnimatedOpacity(
                  opacity: isSelected ? 1.0 : 0.0,
                  duration: duration,
                  curve: curve,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.5),
                          Colors.black.withOpacity(0.9),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // No Star Rating for upcoming
                        const Icon(Icons.access_time_filled, color: Colors.white70, size: 32),
                        const SizedBox(height: 8),

                        Text(
                          movie.title,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          "${movie.year}",
                          style: TextStyle(
                            color: activeColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),

                        const Spacer(),

                        // Passive Button
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white30),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Center(
                            child: Text(
                              "Not Yet Available",
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // -------------------------------
              // LAYER 4: Footer (Visible when NOT selected)
              // -------------------------------
              AnimatedOpacity(
                opacity: isSelected ? 0.0 : 1.0,
                duration: duration,
                curve: curve,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
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
}