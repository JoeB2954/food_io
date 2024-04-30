import 'package:http/http.dart' as http;
import 'package:googleapis/vision/v1.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class VisionService {

  Future<void> detectTextUri(String uri) async {
    //Load service account credentials from json file
    String jsonString = await rootBundle.loadString('assets/foodio-421918-294b200bcba1.json');
    Map<String, dynamic> json = jsonDecode(jsonString);

    String private_key = json['private_key'];
    String client_email = json['client_email'];
    String token_uri = json['token_uri'];

    // Authenticate using service account credentials
    var credentials = ServiceAccountCredentials.fromJson({
      "private_key": private_key,
      "client_email": client_email,
      "token_uri": token_uri,
    });
    

    var client = await clientViaServiceAccount(credentials, [VisionApi.cloudVisionScope]);
    var vision = VisionApi(client);

    // Construct the image object
    var image = Image();
    image.source = ImageSource();
    image.source!.imageUri = uri;

    // Perform text detection
    var response = await vision.images.annotate(ImageRequest()..requests = [AnnotateImageRequest()..image = image]);

    // Process the response
    if (response.responses != null && response.responses!.isNotEmpty) {
      var texts = response.responses![0].textAnnotations;
      if (texts != null) {
        print("Texts:");
        for (var text in texts) {
          print('\n"${text.description}"');
          var vertices = text.boundingPoly!.vertices
              .map((vertex) => "(${vertex.x},${vertex.y})")
              .toList();
          print("Bounds: ${vertices.join(',')}");
        }
      }
    }

    // Close the client to release resources
    client.close();
  }
}
