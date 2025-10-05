import 'package:appwrite/appwrite.dart';

// Appwrite config (copy from Console > Connect snippet)
const String appwriteProjectId = '68e1f67e00351fa231a2';
// IMPORTANT: Must point to REST API path, not the console. Example: http://localhost/v1
const String appwriteEndpoint = 'http://localhost/v1';

class AppwriteService {
  late Client client;
  late Databases databases;

  AppwriteService() {
    client = Client()
      ..setEndpoint(appwriteEndpoint) // ✅ Correct REST API endpoint
      ..setProject(appwriteProjectId); // ✅ Your Appwrite Project ID

    databases = Databases(client);
  }

  Future<void> insertUser(String name, int age) async {
    try {
      final result = await databases.createDocument(
        databaseId: '68e1f76100216a226388',     // Database ID
        collectionId: '68e1f77e00200eeb541f',   // Collection ID
        documentId: ID.unique(),
        data: {
          'name': name,
          'age': age,
        },
      );
      print("✅ Document inserted successfully: $result");
    } catch (e) {
      // Surface the raw message so you can see Appwrite errors like Invalid Origin or Permissions
      print("❌ Error inserting document: $e");
      rethrow; // so your UI sees the error too
    }
  }
}