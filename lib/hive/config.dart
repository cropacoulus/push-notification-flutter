import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

Future putData(data) async {
  await Hive.box('users').clear();

  //insert data
  for (var d in data) {
    Hive.box('users').add(d);
  }
}

Future openBox() async {
  
  return;
}
