import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jawlah/api/config.dart';
import 'package:jawlah/public/globals.dart' as globals;

Map<String, dynamic> api_connect_post_response_sync(
    String url,
    String unencodedPath,
    Map<String, String> header,
    Map<String, dynamic> requestBody) {
  Map<String, dynamic> responseList = {
    '1': {
      'title': '1عنوان1',
      'by_user_name': 'اسم مستخدم11',
      'is_checked': true
    },
    '2': {
      'title': 'عنوان22',
      'by_user_name': 'اسم مستخدم22',
      'is_checked': false
    },
  };

  Uri uri;
  if (useHttps) {
    uri = Uri.https(url, unencodedPath);
  } else {
    uri = Uri.http(url, unencodedPath);
  }

  http
      .post(
    uri,
    headers: header,
    body: jsonEncode(requestBody),
  )
      .then((response) {
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      responseList = jsonDecode(response.body);
      //return response_list;
    } else {
      throw Exception(
          'We were not able to successfully download the json data.');
    }
  });

  return responseList;
}

Future<Map<String, dynamic>> api_connect_post_request_custom(
    String url,
    String unencodedPath,
    Map<String, String> header,
    Map<String, dynamic> postData) async {
  Uri uri;
  if (useHttps) {
    uri = Uri.https(url, unencodedPath);
  } else {
    uri = Uri.http(url, unencodedPath);
  }

  final response = await http.post(
    uri,
    headers: header,
    body: jsonEncode(postData),
  );
  print(response.statusCode);
  print(response.body);

  if (response.statusCode == 200) {
    Map<String, dynamic> responseList = jsonDecode(response.body);
    return responseList;
  } else {
    throw Exception('We were not able to successfully download the json data.');
  }
}

Future<Map<String, dynamic>> api_connect_post_request(
    Map<String, dynamic> postData) async {
  Uri uri;
  if (useHttps) {
    uri = Uri.https(config_URL, config_unencodedPath);
  } else {
    uri = Uri.http(config_URL, config_unencodedPath);
  }

  final response = await http.post(
    uri,
    headers: config_post_headers,
    body: jsonEncode(postData),
  );
  print(response.statusCode);
  print(response.body);

  if (response.statusCode == 200) {
    Map<String, dynamic> responseList = jsonDecode(response.body);
    return responseList;
  } else {
    throw Exception('We were not able to successfully download the json data.');
  }
}

Future<http.Response> api_connect_http_post_response(
    Map<String, dynamic> postData) async {
  Uri uri;
  if (useHttps) {
    uri = Uri.https(config_URL, config_unencodedPath);
  } else {
    uri = Uri.http(config_URL, config_unencodedPath);
  }

  final response = await http.post(
    uri,
    headers: config_post_headers,
    body: jsonEncode(postData),
  );
  return response;
}

Future<http.Response> api_connect_http_get_response(String urlParameters) {
  if (useHttps) {
    return http.get(Uri.parse(
        "https://" + config_URL + config_unencodedPath + urlParameters));
  } else {
    return http.get(Uri.parse(
        "http://" + config_URL + config_unencodedPath + urlParameters));
  }
}

Future<int> uploadImage(String imagePath) async {
  Uri uri;
  if (useHttps) {
    uri = Uri.https(config_URL, config_unencodedPath_upload_img);
  } else {
    uri = Uri.http(config_URL, config_unencodedPath_upload_img);
  }

  //final uri = Uri.parse(config_URL+config_unencodedPath_upload_img);//old

  var request = http.MultipartRequest('POST', uri);
  request.fields['current_user_id'] = globals.current_user_id.toString();
  var pic = await http.MultipartFile.fromPath("image", imagePath);
  request.files.add(pic);
  var response = await request.send();

  if (response.statusCode == 200) {
    print('Image Uploded');
    return 1;
  } else {
    print('Image Not Uploded');
    return 0;
  }
}
