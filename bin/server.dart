import 'dart:io';
import 'package:sqljocky/sqljocky.dart';
import 'dart:convert';
import 'dart:async';
import 'package:rest_frame/rest_frame.dart';

var pool;
List list, course;
HttpRequest request;
var names, cnumber, cname;
main() async {
  pool = new ConnectionPool(
      host: '52.8.67.180',
      port: 3306,
      user: 'dec2013stu',
      password: 'dec2013stu',
      db: 'stu_10130340227',
      max: 10);
  var server = await HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 8080);
  print("Serving at ${server.address}:${server.port}");
  server.listen((HttpRequest request) async {
    if (request.uri.path == "/login") {
      await login(request);
      print(list);
      names = list[1];
      print(names);
    }

    if (request.uri.path == "/tea") {
      request.response.write(names);
      request.response.close();
    }
  });
}

login(HttpRequest request) async {
  var data;
  addCorsHeaders(request.response);
  try {
    data = await request.transform(UTF8.decoder.fuse(JSON.decoder)).first;
  } catch (e) {
    print('Request listen error:$e');
  }
  print(data[0]);
  print(data[1]);
  var num = data[0];
  String name, password;
  var passwords =
      await pool.query('select SNAME,PASSWORD from S where SNUM = $num');
  await passwords.forEach((row) {
    print('Password: ${row[1]}');
    name = '${row[0]}';
    password = '${row[1]}';
    if (data[1] == password) {
      list = [1, '$name'];
    } else if (data[1] != password) {
      list = [3, '错误'];
    }
  });

  var passwordt =
      await pool.query('select TNAME,PASSWORD from T where TNUM = $num');
  await passwordt.forEach((row) async {
    name = '${row[0]}';
    password = '${row[1]}';
    print('Password: ${row[1]}');
    if (data[1] == password) {
      list = [2, '$name'];
      var Course =
          await pool.query('select CNUM,CNAME from C where TNUM = $num');
      await Course.forEach((row) {
        //cnumber = '${row[0]}';cname = '${row[1]}';
        print('Course: ${row[1]}');
      });
    } else if (data[1] != password) {
      list = [3, "'错误'"];
    }
  });
  request.response
    ..write(JSON.encode(list))
    ..close();
}

void addCorsHeaders(HttpResponse res) {
  res.headers.add("Access-Control-Allow-Origin", "*");
  res.headers.add("Access-Control-Allow-Methods", "POST, GET, OPTIONS");

  res.headers.add("Access-Control-Allow-Headers",
      "Origin, X-Requested-With, Content-Type, application/json");
}
