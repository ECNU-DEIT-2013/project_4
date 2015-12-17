import 'dart:io';
import 'package:sqljocky/sqljocky.dart';
import 'dart:convert';
import 'dart:async';
var pool;

main() async {
  pool = new ConnectionPool(
      host: '52.8.67.180',
      port: 3306,
      user: 'dec2013stu',
      password: 'dec2013stu',
      db: 'stu_10130340227',
      max: 10);
  var server = await HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 4040);
  print("Serving at ${server.address}:${server.port}");
  await comRequest(server);
}

comRequest(HttpServer requests) async {
  await for (HttpRequest request in requests) {
        handlePost(request);
  }
}

handlePost(HttpRequest request) async {
 /* var results = await pool.query('select SNUM from S ');
  List list = new List();
  await results.forEach((row) {
    print('Number: ${row[0]}');
    //   var json1 = JSON.encode(row);
    list.add('Number:${row[0]}');
  });
  print(list);    */
  var data;
  addCorsHeaders(request.response);
  try {
    data = await request.transform(UTF8.decoder.fuse(JSON.decoder)).first;

  } catch (e) {
    print('Request listen error:$e');
  }
  print(data[0]);
  var num = data[0];
  print(num);
 List liststu = new List();
    var password = await pool.query('select PASSWORD from S where SNUM = $num');
  await password.forEach((row) {
    print('Password: ${row[0]}');
       //var spassword = JSON.encode(row);
  liststu.add('${row[0]}');
  if(data[1] == liststu[0]){
    print(liststu);
  request.response
    ..write('1')
    ..close();
  }else if(data[1] != liststu[0]){
    request.response
    ..write('')
    ..close();
  }
  });
  List listtea = new List();
  var passwordt = await pool.query('select PASSWORD from T where TNUM = "$num"');
 await  passwordt.forEach((row){
    print('Passwordtea:${row[0]}');
    listtea.add('${row[0]}');
    if(data[1] == listtea[0]){
      print(listtea);
      request.response
        ..write('2')
        ..close();
      }else if(data[1] != listtea[0]){
      request.response
        ..write('')
        ..close();
    }
  });


}

void addCorsHeaders(HttpResponse res) {
  res.headers.add("Access-Control-Allow-Origin", "*");
  res.headers.add("Access-Control-Allow-Methods", "POST, GET, OPTIONS");
  res.headers.add("Access-Control-Allow-Headers",
      "Origin, X-Requested-With, Content-Type, Accept");
}
