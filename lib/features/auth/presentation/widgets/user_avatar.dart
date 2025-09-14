
// lib/features/users/presentation/widgets/user_avatar.dart
//
// Reusable circular avatar widget with optional edit overlay.
// Requires: supabase_flutter, image_picker
//
// pubspec.yaml (add):
// dependencies:
//   image_picker: ^1.1.1
//
// Storage: create bucket 'avatars' (public or use signed URLs) in Supabase,
// then allow uploads. Adjust bucket name if needed.

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

typedef AvatarChanged = void Function(String? publicUrl);

class UserAvatar extends StatefulWidget {
  const UserAvatar({
    super.key,
    required this.size,
    this.imageUrl,
    this.isEditable = false,
    this.onChanged,
    this.bucket = 'avatars',
  });

  final double size;
  final String? imageUrl;
  final bool isEditable;
  final AvatarChanged? onChanged;
  final String bucket;

  @override
  State<UserAvatar> createState() => _UserAvatarState();
}

class _UserAvatarState extends State<UserAvatar> {
  String? _previewUrl;
  bool _uploading = false;

  Future<void> _pickAndUpload() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery, maxWidth: 1024, imageQuality: 85);
      if (picked == null) return;

      setState(() => _uploading = true);

      final sb = Supabase.instance.client;
      final user = sb.auth.currentUser;
      if (user == null) throw Exception('Not signed in');

      final file = File(picked.path);
      final ext = picked.path.split('.').last.toLowerCase();
      final path = '${user.id}/${DateTime.now().millisecondsSinceEpoch}.$ext';

      // Upload to storage bucket
      await sb.storage.from(widget.bucket).upload(path, file, fileOptions: const FileOptions(upsert: true));

      // Get public URL (or use signed URL in production if bucket is private)
      final publicUrl = sb.storage.from(widget.bucket).getPublicUrl(path);

      setState(() {
        _previewUrl = publicUrl;
        _uploading = false;
      });
      widget.onChanged?.call(publicUrl);
    } catch (e) {
      setState(() => _uploading = false);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Upload avatar gagal: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final url = _previewUrl ?? widget.imageUrl;
    final size = widget.size;
    final radius = size / 2;

    final avatar = CircleAvatar(
      radius: radius,
      backgroundImage: (url != null && url.isNotEmpty) ? NetworkImage(url) : null,
      child: (url == null || url.isEmpty) ? Icon(Icons.person, size: radius) : null,
    );

    if (!widget.isEditable) return avatar;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        avatar,
        Positioned(
          right: -2,
          bottom: -2,
          child: InkWell(
            onTap: _uploading ? null : _pickAndUpload,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
                boxShadow: const [BoxShadow(blurRadius: 4, color: Colors.black26)],
              ),
              child: _uploading
                  ? SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Theme.of(context).colorScheme.onPrimary))
                  : Icon(Icons.edit, size: 16, color: Theme.of(context).colorScheme.onPrimary),
            ),
          ),
        ),
      ],
    );
  }
}
