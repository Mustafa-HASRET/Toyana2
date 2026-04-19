import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadEventImage(File imageFile) async {
    final fileName = '${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split(Platform.pathSeparator).last}';
    final ref = _storage.ref().child('event_images/$fileName');

    final uploadTask = ref.putFile(imageFile);
    final snapshot = await uploadTask;

    return await snapshot.ref.getDownloadURL();
  }
}
