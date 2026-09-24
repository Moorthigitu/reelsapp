import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../models/reel_model.dart';
import '../services/reel_data_provider.dart';
import '../services/storage_service.dart';
import '../services/video_download_service.dart';
import 'widgets/reel_player_widget.dart';
import 'widgets/comments_bottom_sheet.dart';

class ReelsFeedScreen extends StatefulWidget {
  const ReelsFeedScreen({super.key});

  @override
  State<ReelsFeedScreen> createState() => _ReelsFeedScreenState();
}

class _ReelsFeedScreenState extends State<ReelsFeedScreen> {
  final PageController _pageController = PageController();
  List<ReelModel> _reels = [];
  bool _isLoadingData = true;

  // Video Controller Map (index -> VideoPlayerController)
  final Map<int, VideoPlayerController> _controllers = {};
  final Map<int, bool> _initializing = {};

  int _currentPage = 0;
  bool _isMuted = false;

  @override
  void initState() {
    super.initState();
    _loadReelsAndInit();
  }

  Future<void> _loadReelsAndInit() async {
    // 1. Get 50 Reels
    final rawReels = ReelDataProvider.get50Reels();

    // 2. Apply saved likes and comments from SharedPreferences
    final restoredReels = await StorageService.applySavedStates(rawReels);

    if (!mounted) return;

    setState(() {
      _reels = restoredReels;
      _isLoadingData = false;
    });

    // 3. Initialize video preloading strategy for page 0
    _manageControllers(0);
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
    _manageControllers(index);
  }

  void _manageControllers(int index) {
    // Step A: Dispose and remove controllers outside the active window [index - 1, index + 2]
    final keysToRemove = <int>[];
    _controllers.forEach((i, controller) {
      if (i < index - 1 || i > index + 2) {
        controller.pause();
        controller.dispose();
        keysToRemove.add(i);
      }
    });

    for (var k in keysToRemove) {
      _controllers.remove(k);
      _initializing.remove(k);
    }

    // Step B: Ensure active window controllers [index - 1, index + 2] are initialized / preloaded
    for (int i = index - 1; i <= index + 2; i++) {
      if (i >= 0 && i < _reels.length) {
        if (!_controllers.containsKey(i) && _initializing[i] != true) {
          _initializeController(i);
        } else if (_controllers.containsKey(i)) {
          final controller = _controllers[i]!;
          if (controller.value.isInitialized) {
            controller.setVolume(_isMuted ? 0.0 : 1.0);
            if (i == index) {
              controller.play();
            } else {
              controller.pause();
            }
          }
        }
      }
    }

    // Step C: Trigger background Dio preloading for upcoming reels [index + 1 .. index + 3]
    for (int next = index + 1; next <= index + 3; next++) {
      if (next < _reels.length) {
        VideoDownloadService.preloadVideo(_reels[next].videoUrl, _reels[next].id);
      }
    }
  }

  Future<void> _initializeController(int index) async {
    _initializing[index] = true;
    final reel = _reels[index];

    VideoPlayerController? controller;

    // 1. Instant check: If video was ALREADY pre-downloaded by Dio to disk, load local file (0ms delay)
    final cachedFile = await VideoDownloadService.getCachedFile(reel.id);
    if (cachedFile != null) {
      try {
        controller = VideoPlayerController.file(cachedFile);
        await controller.initialize();
      } catch (e) {
        controller?.dispose();
        controller = null;
      }
    }

    // 2. If not cached locally, stream from network IMMEDIATELY without waiting for download
    if (controller == null || !controller.value.isInitialized) {
      controller?.dispose();
      controller = VideoPlayerController.networkUrl(
        Uri.parse(reel.videoUrl),
        httpHeaders: const {
          'User-Agent':
              'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36',
        },
      );

      // Trigger Dio background download for disk caching on future loops/views
      VideoDownloadService.downloadInBackground(reel.videoUrl, reel.id);

      try {
        await controller.initialize();
      } catch (e) {
        debugPrint('Primary video stream failed at index $index ($e). Using distinct fallback...');
        controller.dispose();
        controller = null;

        // Pick distinct fallback URL based on index so NO repeating bee.mp4 occurs
        final fallbackIndex = (index * 3 + 1) % ReelDataProvider.videoUrls.length;
        final fallbackUrl = ReelDataProvider.videoUrls[fallbackIndex];
        controller = VideoPlayerController.networkUrl(Uri.parse(fallbackUrl));

        try {
          await controller.initialize();
        } catch (fallbackErr) {
          debugPrint('Fallback network init failed at index $index ($fallbackErr)');
          controller.dispose();
          _initializing[index] = false;
          return;
        }
      }
    }

    controller.setLooping(true);
    controller.setVolume(_isMuted ? 0.0 : 1.0);

    if (!mounted) {
      controller.dispose();
      _initializing[index] = false;
      return;
    }

    // Check if controller index is still within active window [currentPage - 1, currentPage + 2]
    if (index >= _currentPage - 1 && index <= _currentPage + 2) {
      _controllers[index] = controller;
      if (index == _currentPage) {
        controller.play();
      } else {
        controller.pause();
      }
      setState(() {});
    } else {
      controller.dispose();
    }
    _initializing[index] = false;
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
    });

    _controllers.forEach((_, controller) {
      if (controller.value.isInitialized) {
        controller.setVolume(_isMuted ? 0.0 : 1.0);
      }
    });
  }

  void _toggleLike(int index) async {
    final reel = _reels[index];
    setState(() {
      reel.isLiked = !reel.isLiked;
      if (reel.isLiked) {
        reel.likeCount++;
      } else {
        reel.likeCount--;
      }
    });

    // Save like state to local storage
    await StorageService.saveLikeState(reel.id, reel.isLiked, reel.likeCount);
  }

  void _openCommentsBottomSheet(int index) {
    final reel = _reels[index];
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return CommentsBottomSheet(
          reel: reel,
          onCommentAdded: (newCount) {
            setState(() {
              reel.commentCount = newCount;
            });
          },
        );
      },
    );
  }

  void _shareReel(int index) {
    final reel = _reels[index];
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing @${reel.username}\'s reel link!'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.white,
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _controllers.forEach((_, controller) {
      controller.dispose();
    });
    _controllers.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isLoadingData
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.redAccent,
              ),
            )
          : PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              itemCount: _reels.length,
              onPageChanged: _onPageChanged,
              itemBuilder: (context, index) {
                final reel = _reels[index];
                final controller = _controllers[index];

                return ReelPlayerWidget(
                  reel: reel,
                  controller: controller,
                  isCurrentPage: index == _currentPage,
                  isMuted: _isMuted,
                  onToggleMute: _toggleMute,
                  onToggleLike: () => _toggleLike(index),
                  onOpenComments: () => _openCommentsBottomSheet(index),
                  onShare: () => _shareReel(index),
                );
              },
            ),
    );
  }
}
