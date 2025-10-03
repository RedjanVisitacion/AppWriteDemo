import 'package:appwrite/appwrite.dart';

// Appwrite config (copy from Console > Connect snippet)
const String appwriteProjectId = '68df737e0017257f9f6b';
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
        databaseId: '68df75dc0013fc930f8a',     // Database ID
        collectionId: '68df7606002ebbac8cf9',   // Collection ID
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
