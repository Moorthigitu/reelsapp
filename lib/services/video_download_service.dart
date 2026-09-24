import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class VideoDownloadService {
  static final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'User-Agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36',
        'Accept': '*/*',
      },
    ),
  );

  static final Map<String, Future<File?>> _activeDownloads = {};

  /// Returns cached local video File if it exists on disk, or null immediately without blocking
  static Future<File?> getCachedFile(String reelId) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/reels_cache/$reelId.mp4');
      if (await file.exists() && (await file.length()) > 0) {
        return file;
      }
    } catch (_) {}
    return null;
  }

  /// Downloads video in background using Dio for disk caching (non-blocking for video player)
  static Future<File?> downloadInBackground(String videoUrl, String reelId) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final cacheDir = Directory('${tempDir.path}/reels_cache');
      if (!await cacheDir.exists()) {
        await cacheDir.create(recursive: true);
      }

      final file = File('${cacheDir.path}/$reelId.mp4');

      if (await file.exists() && (await file.length()) > 0) {
        return file;
      }

      if (_activeDownloads.containsKey(reelId)) {
        return await _activeDownloads[reelId];
      }

      final downloadFuture = _downloadVideoFile(videoUrl, file);
      _activeDownloads[reelId] = downloadFuture;

      final result = await downloadFuture;
      _activeDownloads.remove(reelId);
      return result;
    } catch (e) {
      debugPrint('VideoDownloadService background error for reel $reelId: $e');
      _activeDownloads.remove(reelId);
      return null;
    }
  }

  static Future<File?> _downloadVideoFile(String videoUrl, File targetFile) async {
    final tempFilePath = '${targetFile.path}.tmp';
    final tempFile = File(tempFilePath);

    try {
      await _dio.download(
        videoUrl,
        tempFilePath,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: true,
        ),
      );

      if (await tempFile.exists() && (await tempFile.length()) > 0) {
        if (await targetFile.exists()) {
          await targetFile.delete();
        }
        await tempFile.rename(targetFile.path);
        debugPrint('Dio cached video to disk: ${targetFile.path}');
        return targetFile;
      }
    } catch (e) {
      if (await tempFile.exists()) {
        try {
          await tempFile.delete();
        } catch (_) {}
      }
    }
    return null;
  }

  /// Trigger background preloading of upcoming videos using Dio
  static void preloadVideo(String videoUrl, String reelId) {
    downloadInBackground(videoUrl, reelId);
  }
}

