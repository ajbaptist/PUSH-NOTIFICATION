import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class Utils {
  Future<String> downloadFile({String? url, String? filename}) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = "${directory.path}/$filename";
    final response = await http.get(Uri.parse(url!));
    final file = await File(path);

    await file.writeAsBytes(response.bodyBytes);
    return path;
  }
}
