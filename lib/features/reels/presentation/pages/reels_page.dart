import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/reels_bloc.dart';
import '../bloc/reels_event.dart';
import '../bloc/reels_state.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/reel_item.dart';

class ReelsPage extends StatefulWidget {
  const ReelsPage({super.key});

  @override
  State<ReelsPage> createState() => _ReelsPageState();
}

class _ReelsPageState extends State<ReelsPage> {
  late PageController _pageController;
  late ScrollController _scrollController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _scrollController = ScrollController();

    // Load initial reels
    context.read<ReelsBloc>().add(const LoadReelsEvent());

    // Set up scroll listener for pagination
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      context.read<ReelsBloc>().add(const LoadMoreReelsEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Reels',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // Implement search functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              // Implement more options
            },
          ),
        ],
      ),
      body: BlocConsumer<ReelsBloc, ReelsState>(
        listener: (context, state) {
          if (state is ReelsError && state.reels.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ReelsLoading) {
            return const CustomLoadingIndicator();
          }

          if (state is ReelsError && state.reels.isEmpty) {
            return CustomErrorWidget(
              message: state.message,
              onRetry: () {
                context.read<ReelsBloc>().add(
                  const LoadReelsEvent(refresh: true),
                );
              },
            );
          }

          if (state is ReelsLoaded ||
              state is ReelsRefreshing ||
              (state is ReelsError && state.reels.isNotEmpty)) {
            final reels = state is ReelsLoaded
                ? state.reels
                : state is ReelsRefreshing
                ? state.reels
                : (state as ReelsError).reels;

            if (reels.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.video_library_outlined,
                      size: 64,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No reels available',
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Pull to refresh',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              backgroundColor: Colors.black,
              color: Colors.white,
              onRefresh: () async {
                context.read<ReelsBloc>().add(const RefreshReelsEvent());
              },
              child: PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.vertical,
                itemCount:
                    reels.length +
                    (state is ReelsLoaded && state.isLoadingMore ? 1 : 0),
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });

                  // Trigger load more when reaching near end
                  if (index >= reels.length - 2) {
                    context.read<ReelsBloc>().add(const LoadMoreReelsEvent());
                  }

                  // Mark reel as viewed
                  if (index < reels.length) {
                    context.read<ReelsBloc>().add(
                      ReelViewedEvent(reelId: reels[index].id),
                    );
                  }
                },
                itemBuilder: (context, index) {
                  if (index >= reels.length) {
                    return const CustomLoadingIndicator();
                  }

                  return ReelItem(
                    reel: reels[index],
                    isActive: index == _currentIndex,
                    onLike: () {
                      context.read<ReelsBloc>().add(
                        ToggleLikeEvent(reelId: reels[index].id),
                      );
                    },
                    onShare: () {
                      // Implement share functionality
                      _showShareDialog(context, reels[index]);
                    },
                    onComment: () {
                      // Implement comment functionality
                      _showCommentsBottomSheet(context, reels[index]);
                    },
                    onUserProfile: () {
                      // Navigate to user profile
                      _navigateToUserProfile(context, reels[index].user);
                    },
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _showShareDialog(BuildContext context, reel) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Share Reel',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildShareOption(Icons.link, 'Copy Link'),
                _buildShareOption(Icons.message, 'WhatsApp'),
                _buildShareOption(Icons.share, 'More'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShareOption(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }

  void _showCommentsBottomSheet(BuildContext context, reel) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[600],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Comments',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: 10, // Replace with actual comments count
                  itemBuilder: (context, index) => ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    title: Text(
                      'User ${index + 1}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      'This is a sample comment ${index + 1}',
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Row(
                  children: [
                    Expanded(
                      child: TextField(
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Add a comment...',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Icon(Icons.send, color: Colors.blue),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToUserProfile(BuildContext context, user) {
    // Navigate to user profile page
    // Navigator.pushNamed(context, '/profile', arguments: user);

    // For now, show a simple dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          'User Profile',
          style: const TextStyle(color: Colors.white),
        ),
        content: Text(
          'Navigate to ${user.username ?? 'User'} profile',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
