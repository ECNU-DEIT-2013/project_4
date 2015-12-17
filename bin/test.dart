
import 'dart:io';
import '../packages/sqljocky/sqljocky.dart';
import 'dart:convert';
import 'dart:async';

main() async {
  var pool = new ConnectionPool(
      host: '52.8.67.180',
      port: 3306,
      user: 'dec2013stu',
      password: 'dec2013stu',
      db: 'stu_10130340227',
      max: 10);
  var results = await pool.query('select SPASSWORD from S where SNUM = "1001"');
  List list = new List();
  await results.forEach((row) {
    print('Number: ${row[0]}');
    //   var json1 = JSON.encode(row);
    list.add('Number:${row[0]}');
  });
  return list;
  var server = await HttpServer.bind(InternetAddress.LOOPBACK_IP_V4,4041);
  print("Serving at ${server.address}:${server.port}");
}

