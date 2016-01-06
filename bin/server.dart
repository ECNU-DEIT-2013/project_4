import 'dart:io';
import 'package:sqljocky/sqljocky.dart';
import 'dart:convert';
import 'dart:math' show Random;

var pool;
List randomlist;
List list, course;
//list为返回登录界面的数据，course中包含课程信息
List stuinf,selectstu;
//stuinf中包含教师选择课程后的全部学生信息
HttpRequest request;
String num, password;
//登录学号，密码
var cnum, cname,name,sname;
//从数据库中获取到的课程编号，课程名，（教师/学生）登录时姓名，学生姓名
String coursename;
//接收tea传递的课程名
var stu_number,stu_name,stu_major,stu_ab;
//学生学号，学生姓名，学生缺席次数
Random randomNumber;
int length_stuinf;
var stuRandomNumber;
main() async {
  pool = new ConnectionPool(      //连接数据库
      host: '52.193.39.90',
      port: 3306,
      user: 'dec2013stu',
      password: 'dec2013stu',
      db: 'stu_10130340227',
      max: 10);
  var server = await HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 8080);
  print("Serving at ${server.address}:${server.port}");
  server.listen((HttpRequest request) async {
    if (request.uri.path == "/login") {     //响应index.dart
      await login(request);
    }
    if (request.uri.path == "/tea" || request.uri.path == "/stu") {     //tea.dart中显示教师姓名和课程名称
        await handleGET(request);
       }
    if(request.uri.path == "/allname"){     //根据教师端传来的课程名，获取所有学生信息
       await allname(request);
      }
    if(request.uri.path == "/rollname"){
      await rollname(request);
    }
    if(request.uri.path == '/absence'){
      await absence(request);
    }
    if(request.uri.path == '/stuabsence'){
      await stuabsence(request);
    }
  });
}

login(HttpRequest request) async {
  var data;course = new List();
  addCorsHeaders(request.response);
  try {
    data = await request.transform(UTF8.decoder.fuse(JSON.decoder)).first;
  } catch (e) {
   print('Request listen error:$e');
  }
  print(data[0]);   //测试是否收到登录界面传来的学号
  print(data[1]);   //测试是否收到密码
  num = data[0];
  var passwords =
  await pool.query('select SNAME,PASSWORD from S where SNUM = $num');   //选择学生姓名，密码
    passwords.forEach((row) async {
    print('Password: ${row[1]}');   //显示学号对应的密码
    name = '${row[0]}';   //name为获取的姓名
    password = '${row[1]}';   //password为获取的密码
    if (data[1] == password) {    //判断客户端传入的密码是否与数据库中的密码相同
      list = [1, '$name'];    //设置list，区别学生登录与教师登录
      course = [name];    //将name添加至course，以便handleGET使用
      var Course =      //获取课程信息
      await pool.query('select SC.CNUM,C.CNAME from C,SC where C.CNUM = SC.CNUM AND SC.SNUM = $num');
      await Course.forEach((row) {
    cnum = '${row[0]}';   //课程编号
    cname = '${row[1]}';    //课程名字
    course.add("$cname");   //添加课程名字至course
  });
  print(course);    //测试
    } else if (data[1] != password) {
      list = [3, '错误'];
    }
  });
  var passwordt =
  await pool.query('select TNAME,PASSWORD from T where TNUM = $num');   //选择教师姓名，密码
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
        cnum = '${row[0]}';
        cname = '${row[1]}';
        course.add("$cname");
      });
      print(course);
    } else if (data[1] != password) {
      list = [3, "'错误'"];
    }
  });
  request.response
    ..write(JSON.encode(list))      //list中含有1/2/3，分别代表学生登录成功/教师登录成功/登录失败
    ..close();
}     //登录，课程信息
handleGET(HttpRequest request)async{
  addCorsHeaders(request.response);
  request.response.write(JSON.encode(course)); //上传至网页
  request.response.close();
}
allname(HttpRequest request) async {
 // var coursename;
  addCorsHeaders(request.response);
  try {
    coursename = await request.transform(UTF8.decoder.fuse(JSON.decoder)).first;
  } catch (e) {
    print('Error:$e');
  }
  print(coursename);
    stuinf = new List();
var student_name = await pool.query(
      'select S.SNUM,S.SNAME,SC.OB from S,SC,C where S.SNUM = SC.SNUM AND SC.CNUM = C.CNUM AND C.CNAME = "$coursename"');
  await student_name.forEach((row) {
    stu_number = '${row[0]}';
    stu_name = '${row[1]}';
    stu_ab = '${row[2]}';
    List stu_inf = ["$stu_number","$stu_name","$stu_ab"];
    stuinf.add(stu_inf);
  });
  print(stuinf);
  request.response.write(JSON.encode(stuinf));
  request.response.close();
}      //学生信息
rollname(HttpRequest request) async {
 length_stuinf = stuinf.length;   //使随机数的范围在选课人数之内
  stuRandomNumber = new Random().nextInt(length_stuinf);  //获取随机数
 selectstu = stuinf[stuRandomNumber];
 addCorsHeaders(request.response);
 request.response.write(JSON.encode(stuinf[stuRandomNumber]));
 request.response.close();
}   //随机点名
absence(HttpRequest request) async{
  addCorsHeaders(request.response);
  var studentnumber,studentab,stuab;
  studentnumber = selectstu[0];
  studentab = selectstu[2];
  int stu_ab1;
  stu_ab1 = int.parse(studentab);
  stu_ab1 = stu_ab1 + 1;
  print(stu_ab1);
  pool.query(
      'UPDATE SC,C SET SC.OB = $stu_ab1 WHERE SC.CNUM = C.CNUM AND C.CNAME = "$coursename" AND SC.SNUM = "$studentnumber"'
  );
  request.response.write(JSON.encode(stu_ab1));
  request.response.close();
}
stuabsence(HttpRequest request) async {
  addCorsHeaders(request.response);
  try {
    coursename = await request.transform(UTF8.decoder.fuse(JSON.decoder)).first;
  } catch (e) {
    print('Error:$e');
  }
  print(coursename);
  var student_name = await pool.query(
      'select SC.OB from S,SC,C where C.CNAME = "$coursename" AND SC.CNUM = C.CNUM AND SC.SNUM = S.SNUM AND S.SNAME = "$name"');
  await student_name.forEach((row) {
    stu_ab = '${row[0]}';
    print(stu_ab);
  });
  request.response.write(JSON.encode('$stu_ab'));
  request.response.close();
}      //学生信息
void addCorsHeaders(HttpResponse res) {
  res.headers.add("Access-Control-Allow-Origin", "*");
  res.headers.add("Access-Control-Allow-Methods", "POST, GET, OPTIONS");
  res.headers.add("Access-Control-Allow-Headers",
  "Origin, X-Requested-With, Content-Type, application/json");
}