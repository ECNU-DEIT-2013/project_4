import 'dart:io';
import 'package:sqljocky/sqljocky.dart';
import 'dart:convert';
import 'dart:async';
import 'package:rest_frame/rest_frame.dart';

var pool,decoded;
List list, course,namecourse;
List stuinf,stu_inf;
HttpRequest request;
var Name, cnumber, cname,num;
var stu_number,stu_name,stu_major,stu_ob;
main() async {
  pool = new ConnectionPool(      //连接数据库
      host: '52.8.67.180',
      port: 3306,
      user: 'dec2013stu',
      password: 'dec2013stu',
      db: 'stu_10130340227',
      max: 10);
  var server = await HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 8080);
  print("Serving at ${server.address}:${server.port}");
  server.listen((HttpRequest request) async {
    if (request.uri.path == "/login") {     //响应登录客户端
      await login(request);
    }
    if (request.uri.path == "/tea") {
        await studentname(request);
          request.response.write(JSON.encode(course)); //上传至网页
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
course = new List();
  var passwordt =
  await pool.query('select TNAME,PASSWORD from T where TNUM = $num');
  await passwordt.forEach((row) async {
    name = '${row[0]}';
    password = '${row[1]}';
    print('Password: ${row[1]}');
    if (data[1] == password) {
      list = [2, '$name'];
      course = [name];
      var Course =      //获取课程信息
      await pool.query('select CNUM,CNAME from C where TNUM = $num');
      await Course.forEach((row) {
        cname = '${row[1]}';
        //print('Course: ${row[1]}');
        course.add("$cname");
      });
      print(course);
    } else if (data[1] != password) {
      list = [3, "'错误'"];
    }
  });
  request.response
    ..write(JSON.encode(list))
    ..close();
}     //登录，课程信息

handleGET(HttpRequest request)async{
  var decoded;
  addCorsHeaders(request.response);
  try{
    decoded = await request.transform(UTF8.decoder.fuse(JSON.decoder)).first;
  }catch(e){
    print('ERROR:$e');
  }
  print(decoded);
  if(decoded.containsKey(course[1])){
    await studentname(request);
  }
}
studentname(HttpRequest request) async {
  var coursename;
  try {
    coursename = await request.transform(UTF8.decoder.fuse(JSON.decoder)).first;
  } catch (e) {
    print('Request listen error:$e');
  }
  addCorsHeaders(request.response);
  request.response
    ..headers.contentType = new ContentType("application", "json", charset: "utf-8");
  stuinf = new List();
  var student_name = await pool.query(        //学生信息
      'select S.SNUM,S.SNAME,S.MAJOR,SC.OB from S,SC,C where S.SNUM = SC.SNUM AND SC.CNUM = C.CNUM AND C.CNAME = $coursename AND C.TNUM = $num' );
  await student_name.forEach((row) {
    stu_number = '${row[0]}';
    stu_name = '${row[1]}';
    stu_major = '${row[2]}';
    stu_ob = '${row[3]}';
    stuinf.add('$stu_number,$stu_name,$stu_major,$stu_ob');
  });
}     //学生名单

void addCorsHeaders(HttpResponse res) {
  res.headers.add("Access-Control-Allow-Origin", "*");
  res.headers.add("Access-Control-Allow-Methods", "POST, GET, OPTIONS");

  res.headers.add("Access-Control-Allow-Headers",
  "Origin, X-Requested-With, Content-Type, application/json");
}