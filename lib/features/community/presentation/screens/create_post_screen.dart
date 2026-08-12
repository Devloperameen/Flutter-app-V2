import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:safe/core/design/design.dart';
import 'package:safe/features/community/presentation/providers/community_provider.dart';

class CreatePostScreen extends ConsumerStatefulWidget {
  const CreatePostScreen({super.key});

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final _textController = TextEditingController();
  File? _imageFile;
  File? _videoFile;
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _submitPost() async {
    final text = _textController.text.trim();
    if (text.isEmpty && _imageFile == null && _videoFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post cannot be empty')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await ref.read(communityNotifierProvider.notifier).addPost(
            message: text,
            imageFile: _imageFile,
            videoFile: _videoFile,
          );
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create post: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _videoFile = null; // Can only attach one media type for simplicity
      });
    }
  }

  Future<void> _pickVideo(ImageSource source) async {
    final pickedFile = await _picker.pickVideo(source: source);
    if (pickedFile != null) {
      setState(() {
        _videoFile = File(pickedFile.path);
        _imageFile = null; // Can only attach one media type for simplicity
      });
    }
  }

  void _showMediaPickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Photo Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.video_library),
              title: const Text('Video Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickVideo(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.videocam),
              title: const Text('Record Video'),
              onTap: () {
                Navigator.pop(context);
                _pickVideo(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Create Post'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _submitPost,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Post', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  TextField(
                    controller: _textController,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: 'What do you want to talk about?',
                      border: InputBorder.none,
                      hintStyle: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  if (_imageFile != null) ...[
                    Stack(
                      alignment: Alignment.topRight,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            _imageFile!,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          color: Colors.white,
                          style: IconButton.styleFrom(backgroundColor: Colors.black54),
                          onPressed: () {
                            setState(() {
                              _imageFile = null;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                  if (_videoFile != null) ...[
                    Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Icon(Icons.video_file, size: 64, color: Colors.black54),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          color: Colors.white,
                          style: IconButton.styleFrom(backgroundColor: Colors.black54),
                          onPressed: () {
                            setState(() {
                              _videoFile = null;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            SafeArea(
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.add_photo_alternate_outlined),
                    color: theme.colorScheme.primary,
                    onPressed: _showMediaPickerOptions,
                    tooltip: 'Attach Media',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
