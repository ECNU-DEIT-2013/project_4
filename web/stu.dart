import 'dart:convert';
import 'dart:async';
import 'dart:html';
var path = 'http://127.0.0.1:8080/tea';
var classname;
void main() {
  var httpRequest = new HttpRequest();
  httpRequest
    ..open('Get', path)
    ..onLoadEnd.listen((e) => student_name(httpRequest))
    ..send();
}
student_name(HttpRequest request) {
  if (request.status == 200) {
    querySelector('#student')..text = JSON.decode(request.responseText) + '同学，你好！';
  }
  else {
    querySelector("#student").text="error";
  }
}   //显示“XX同学，你好”