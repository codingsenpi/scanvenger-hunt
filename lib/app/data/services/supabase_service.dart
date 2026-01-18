import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:scanvenger_hunt_2/app/data/models/team.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final _supabase = Supabase.instance.client;
  Future<String?> uploadImage({
    required XFile imageFile,
    required String teamId,
    required int mysteryIndex,
    required MysteryPart part,
  }) async {
    try {
      final file = File(imageFile.path);
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileExtension = imageFile.path.split('.').last;
      final fileName =
          '${teamId}_${mysteryIndex}_${part.name}_$timestamp.$fileExtension';
      await _supabase.storage.from('submissions').upload(
            fileName,
            file,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
          );
      final publicUrl =
          _supabase.storage.from('submissions').getPublicUrl(fileName);
      return publicUrl;
    } catch (e) {
      print('Error uploading image to Supabase: $e');
      return null;
    }
  }
}
