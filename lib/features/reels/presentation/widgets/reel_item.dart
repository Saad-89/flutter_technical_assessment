import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

// Import your actual domain entities
import '../../domain/entities/reel.dart';

class ReelItem extends StatefulWidget {
  final Reel reel;
  final bool isActive;
  final VoidCallback onLike;
  final VoidCallback onShare;
  final VoidCallback onComment;
  final VoidCallback onUserProfile;

  const ReelItem({
    super.key,
    required this.reel,
    required this.isActive,
    required this.onLike,
    required this.onShare,
    required this.onComment,
    required this.onUserProfile,
  });

  @override
  State<ReelItem> createState() => _ReelItemState();
}

class _ReelItemState extends State<ReelItem> {
  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;
  bool _showPlayButton = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  @override
  void didUpdateWidget(ReelItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _playVideo();
      } else {
        _pauseVideo();
      }
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  void _initializeVideo() async {
    try {
      // Use cdnUrl for video playback
      _videoController = VideoPlayerController.network(widget.reel.cdnUrl);
      await _videoController!.initialize();

      if (mounted) {
        setState(() {
          _isVideoInitialized = true;
        });

        if (widget.isActive) {
          _playVideo();
        }
      }
    } catch (e) {
      print('Error initializing video: $e');
    }
  }

  void _playVideo() {
    if (_videoController != null && _isVideoInitialized) {
      _videoController!.play();
      _videoController!.setLooping(true);
    }
  }

  void _pauseVideo() {
    if (_videoController != null && _isVideoInitialized) {
      _videoController!.pause();
    }
  }

  void _togglePlayPause() {
    if (_videoController != null && _isVideoInitialized) {
      if (_videoController!.value.isPlaying) {
        _videoController!.pause();
        setState(() {
          _showPlayButton = true;
        });

        // Hide play button after 2 seconds
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              _showPlayButton = false;
            });
          }
        });
      } else {
        _videoController!.play();
        setState(() {
          _showPlayButton = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          // Video Player
          Positioned.fill(
            child: GestureDetector(
              onTap: _togglePlayPause,
              child: _isVideoInitialized
                  ? AspectRatio(
                      aspectRatio: _videoController!.value.aspectRatio,
                      child: VideoPlayer(_videoController!),
                    )
                  : Container(
                      color: Colors.grey[900],
                      child: const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    ),
            ),
          ),

          // Play/Pause Button Overlay
          if (_showPlayButton)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(
                  child: Icon(Icons.play_arrow, color: Colors.white, size: 80),
                ),
              ),
            ),

          // Right Side Actions
          Positioned(
            right: 12,
            bottom: 80,
            child: Column(
              children: [
                // Like Button
                _buildActionButton(
                  icon: widget.reel.isLiked
                      ? Icons.favorite
                      : Icons.favorite_border,
                  label: _formatCount(widget.reel.totalLikes),
                  onTap: widget.onLike,
                  isActive: widget.reel.isLiked,
                ),
                const SizedBox(height: 20),

                // Comment Button
                _buildActionButton(
                  icon: Icons.chat_bubble_outline,
                  label: _formatCount(widget.reel.totalComments),
                  onTap: widget.onComment,
                ),
                const SizedBox(height: 20),

                // Share Button
                _buildActionButton(
                  icon: Icons.share,
                  label: 'Share',
                  onTap: widget.onShare,
                ),
                const SizedBox(height: 20),

                // More Options
                _buildActionButton(
                  icon: Icons.more_vert,
                  label: '',
                  onTap: () {
                    // Show more options
                  },
                ),
              ],
            ),
          ),

          // Bottom User Info
          Positioned(
            left: 12,
            right: 80,
            bottom: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Info
                GestureDetector(
                  onTap: widget.onUserProfile,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage:
                            widget.reel.user.profilePictureCdn.isNotEmpty
                            ? NetworkImage(widget.reel.user.profilePictureCdn)
                            : null,
                        child: widget.reel.user.profilePictureCdn.isEmpty
                            ? const Icon(Icons.person, color: Colors.white)
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  widget.reel.user.fullname.isNotEmpty
                                      ? widget.reel.user.fullname
                                      : widget.reel.user.username,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                // Note: Your User model doesn't have isVerified field
                                // If you want to show verification, add it to your User model
                              ],
                            ),
                            Text(
                              '@${widget.reel.user.username}',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Caption/Description
                if (widget.reel.description != null &&
                    widget.reel.description!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    widget.reel.description!,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],

                // Title (if you want to show it)
                if (widget.reel.title.isNotEmpty &&
                    widget.reel.description != widget.reel.title) ...[
                  const SizedBox(height: 4),
                  Text(
                    widget.reel.title,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isActive ? Colors.red : Colors.white,
              size: 28,
            ),
          ),
          if (label.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }
}

// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

// // Import your actual domain entities
// import '../../domain/entities/reel.dart';
// // If you have a separate User entity, import it too:
// // import '../../domain/entities/user.dart';

// class ReelItem extends StatefulWidget {
//   final Reel reel;
//   final bool isActive;
//   final VoidCallback onLike;
//   final VoidCallback onShare;
//   final VoidCallback onComment;
//   final VoidCallback onUserProfile;

//   const ReelItem({
//     super.key,
//     required this.reel,
//     required this.isActive,
//     required this.onLike,
//     required this.onShare,
//     required this.onComment,
//     required this.onUserProfile,
//   });

//   @override
//   State<ReelItem> createState() => _ReelItemState();
// }

// class _ReelItemState extends State<ReelItem> {
//   VideoPlayerController? _videoController;
//   bool _isVideoInitialized = false;
//   bool _showPlayButton = false;

//   @override
//   void initState() {
//     super.initState();
//     _initializeVideo();
//   }

//   @override
//   void didUpdateWidget(ReelItem oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.isActive != oldWidget.isActive) {
//       if (widget.isActive) {
//         _playVideo();
//       } else {
//         _pauseVideo();
//       }
//     }
//   }

//   @override
//   void dispose() {
//     _videoController?.dispose();
//     super.dispose();
//   }

//   void _initializeVideo() async {
//     try {
//       _videoController = VideoPlayerController.network(widget.reel.url);
//       await _videoController!.initialize();

//       if (mounted) {
//         setState(() {
//           _isVideoInitialized = true;
//         });

//         if (widget.isActive) {
//           _playVideo();
//         }
//       }
//     } catch (e) {
//       print('Error initializing video: $e');
//     }
//   }

//   void _playVideo() {
//     if (_videoController != null && _isVideoInitialized) {
//       _videoController!.play();
//       _videoController!.setLooping(true);
//     }
//   }

//   void _pauseVideo() {
//     if (_videoController != null && _isVideoInitialized) {
//       _videoController!.pause();
//     }
//   }

//   void _togglePlayPause() {
//     if (_videoController != null && _isVideoInitialized) {
//       if (_videoController!.value.isPlaying) {
//         _videoController!.pause();
//         setState(() {
//           _showPlayButton = true;
//         });

//         // Hide play button after 2 seconds
//         Future.delayed(const Duration(seconds: 2), () {
//           if (mounted) {
//             setState(() {
//               _showPlayButton = false;
//             });
//           }
//         });
//       } else {
//         _videoController!.play();
//         setState(() {
//           _showPlayButton = false;
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.black,
//       child: Stack(
//         children: [
//           // Video Player
//           Positioned.fill(
//             child: GestureDetector(
//               onTap: _togglePlayPause,
//               child: _isVideoInitialized
//                   ? AspectRatio(
//                       aspectRatio: _videoController!.value.aspectRatio,
//                       child: VideoPlayer(_videoController!),
//                     )
//                   : Container(
//                       color: Colors.grey[900],
//                       child: const Center(
//                         child: CircularProgressIndicator(color: Colors.white),
//                       ),
//                     ),
//             ),
//           ),

//           // Play/Pause Button Overlay
//           if (_showPlayButton)
//             Positioned.fill(
//               child: Container(
//                 color: Colors.black.withOpacity(0.3),
//                 child: const Center(
//                   child: Icon(Icons.play_arrow, color: Colors.white, size: 80),
//                 ),
//               ),
//             ),

//           // Right Side Actions
//           Positioned(
//             right: 12,
//             bottom: 80,
//             child: Column(
//               children: [
//                 // Like Button
//                 _buildActionButton(
//                   icon: widget.reel.isLiked
//                       ? Icons.favorite
//                       : Icons.favorite_border,
//                   label: _formatCount(widget.reel.totalLikes),
//                   onTap: widget.onLike,
//                   isActive: widget.reel.isLiked,
//                 ),
//                 const SizedBox(height: 20),

//                 // Comment Button
//                 _buildActionButton(
//                   icon: Icons.chat_bubble_outline,
//                   label: _formatCount(widget.reel.totalComments),
//                   onTap: widget.onComment,
//                 ),
//                 const SizedBox(height: 20),

//                 // Share Button
//                 _buildActionButton(
//                   icon: Icons.share,
//                   label: 'Share',
//                   onTap: widget.onShare,
//                 ),
//                 const SizedBox(height: 20),

//                 // More Options
//                 _buildActionButton(
//                   icon: Icons.more_vert,
//                   label: '',
//                   onTap: () {
//                     // Show more options
//                   },
//                 ),
//               ],
//             ),
//           ),

//           // Bottom User Info
//           Positioned(
//             left: 12,
//             right: 80,
//             bottom: 20,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // User Info
//                 GestureDetector(
//                   onTap: widget.onUserProfile,
//                   child: Row(
//                     children: [
//                       CircleAvatar(
//                         radius: 20,
//                         backgroundImage: widget.reel.user.profilePicture != null
//                             ? NetworkImage(widget.reel.user.profilePicture!)
//                             : null,
//                         child: widget.reel.user.profilePicture == null
//                             ? const Icon(Icons.person, color: Colors.white)
//                             : null,
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               children: [
//                                 Text(
//                                   widget.reel.user.fullname ??
//                                       widget.reel.user.username,
//                                   style: const TextStyle(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                                 if (widget.reel.user.isFollow) ...[
//                                   const SizedBox(width: 4),
//                                   const Icon(
//                                     Icons.verified,
//                                     color: Colors.blue,
//                                     size: 16,
//                                   ),
//                                 ],
//                               ],
//                             ),
//                             Text(
//                               '@${widget.reel.user.username}',
//                               style: TextStyle(
//                                 color: Colors.grey[400],
//                                 fontSize: 14,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 // Caption
//                 if (widget.reel.metaDescription != null &&
//                     widget.reel.metaDescription!.isNotEmpty) ...[
//                   const SizedBox(height: 8),
//                   Text(
//                     widget.reel.metaDescription!,
//                     style: const TextStyle(color: Colors.white, fontSize: 14),
//                     maxLines: 3,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ],
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildActionButton({
//     required IconData icon,
//     required String label,
//     required VoidCallback onTap,
//     bool isActive = false,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: Colors.black.withOpacity(0.3),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(
//               icon,
//               color: isActive ? Colors.red : Colors.white,
//               size: 28,
//             ),
//           ),
//           if (label.isNotEmpty) ...[
//             const SizedBox(height: 4),
//             Text(
//               label,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 12,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }

//   String _formatCount(int count) {
//     if (count >= 1000000) {
//       return '${(count / 1000000).toStringAsFixed(1)}M';
//     } else if (count >= 1000) {
//       return '${(count / 1000).toStringAsFixed(1)}K';
//     }
//     return count.toString();
//   }
// }
