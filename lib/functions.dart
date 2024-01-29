import 'package:http/http.dart' as http;

fetchdata(String url) async{
  final response= await http.get(Uri.parse(url));
  print(response.body);
  return response.body;

}