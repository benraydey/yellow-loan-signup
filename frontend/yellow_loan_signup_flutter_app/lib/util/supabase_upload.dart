import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

const String supabaseUrl = 'https://fhkrgvwsnxzqsbwrjqef.supabase.co';
const String supabaseAnonKey = 'sb_publishable_6EX3p_lVyDZY6SLWVuWgkw_Iuxpx8xo';
const String bucketName = 'proof-documents';

Future<String?> uploadFileToSupabase({
  required List<int> fileBytes,
  required String fileName,
}) async {
  try {
    final client = Supabase.instance.client;
    final fileId = const Uuid().v4();
    final fileExtension = fileName.split('.').last;
    final remoteName = '$fileId.$fileExtension';

    await client.storage
        .from(bucketName)
        .uploadBinary(
          remoteName,
          Uint8List.fromList(fileBytes),
        );

    return fileId;
  } on StorageException catch (e) {
    throw 'Upload failed: ${e.message}';
  } catch (e) {
    throw 'Upload failed: $e';
  }
}
