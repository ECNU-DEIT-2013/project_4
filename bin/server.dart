import 'dart:io';
import 'package:sqljocky/sqljocky.dart';
import 'dart:convert';
import 'dart:async';
import 'package:rest_frame/rest_frame.dart';

var pool;
List list, course, teacourse,stuinf,stu_inf;
HttpRequest request;
var names, cnumber, cname,num;
var stu_number,stu_name,stu_major,stu_ob;
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
    }
  names = list[1];
    if (request.uri.path == "/tea") {
      await studentname(request);
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
  num = data[0];
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
        cnumber = '${row[0]}';
        cname = '${row[1]}';
        print('Course: ${row[1]}');
        teacourse = [cnumber, cname];
        print(teacourse);
      });
    } else if (data[1] != password) {
      list = [3, "'错误'"];
    }
  });
  request.response
    ..write(JSON.encode(list))
    ..close();
}

studentname(HttpRequest request) async {
  addCorsHeaders(request.response);
  request.response
    ..headers.contentType = new ContentType("application", "json", charset: "utf-8");
  request.response.write('[');
  request.response.write(JSON.encode(names));
  request.response.write(',');

  stuinf = new List();
  var student_name = await pool.query(
      'select S.SNUM,S.SNAME,S.MAJOR,SC.OB from S,SC,C where S.SNUM = SC.SNUM AND SC.CNUM = C.CNUM AND C.TNUM = $num');
    await student_name.forEach((row) {
      //print('Student: ${row[0]},${row[1]},${row[2]},${row[3]}');
      stu_number = '${row[0]}';
      stu_name = '${row[1]}';
      stu_major = '${row[2]}';
      stu_ob = '${row[3]}';
      stuinf = ["$stu_number, $stu_name, $stu_major, $stu_ob"];
      print(stuinf);
      request.response.write(JSON.encode(stuinf));
      request.response.write(',');
    });
  request.response.write(']');
  request.response.close();
}

void addCorsHeaders(HttpResponse res) {
  res.headers.add("Access-Control-Allow-Origin", "*");
  res.headers.add("Access-Control-Allow-Methods", "POST, GET, OPTIONS");

  res.headers.add("Access-Control-Allow-Headers",
      "Origin, X-Requested-With, Content-Type, application/json");
}
