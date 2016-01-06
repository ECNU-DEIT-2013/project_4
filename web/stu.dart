import 'dart:html';
import 'dart:convert';
Event e;
HttpRequest request;
var host = '52.193.36.64';
var url = host + ':8080/tea';
var path_stuabsence = 'http://127.0.0.1:8080/stuabsence';
var course_name;
List Data,Data1;
var mycourse,coursename;
int i;
void main() {
  stuname_show(e);
  coursename = querySelector('#coursename');
  querySelector('#sub_logout').onClick.listen((Event e)=>window.open("index.html","点名系统"));   //退出登录跳转至登录界面
  querySelector('#sub_logout').onClick.listen((Event e)=>window.close);   //退出登录关闭此界面
  querySelector('#coursename').onChange.listen(changecou);
}
void stuname_show(Event e) {
  request = new HttpRequest();
  request
    ..open('GET', path)
    ..onLoadEnd.listen(StuShow)
    ..send();
}
StuShow(_) {
  course_name = new List();
  if (request.readyState == HttpRequest.DONE && request.status == 200) {
    Data = JSON.decode(request.responseText);     //Data接收服务器传来的数据
    querySelector('#studentname').text = Data[0] + "同学，你好！";   //显示欢迎词，添加教师姓名
    mycourse = new Element.html('<option value="''">...</option>');   //select中第一个值
    querySelector('#coursename').children.add(mycourse);    //添加mycourse
    for (i = 1; i < Data.length; i++) {
    mycourse = new Element.html('<option value="' + Data[i] + '">'+ Data[i]+'</option>');    //添加课程名
    querySelector('#coursename').children.add(mycourse);
      }
   print(course_name);  //测试是否成功获取全部课程名
    } else if (request.readyState == HttpRequest.DONE && request.status == 0) {
    querySelector('#studentname').text = 'No server';   //监测是否有错误
    }
}
changecou(Event e){
  course_name = document.getElementById('coursename').value;
  print(course_name);
  request = new HttpRequest();
  request
  ..open('POST',path_stuabsence)
  ..onReadyStateChange.listen(stu_absence)
  ..send(JSON.encode(course_name));
}
stu_absence(_){
  if (request.readyState == HttpRequest.DONE && request.status == 200) {
    querySelector('#absence').text = JSON.decode(request.responseText);
  }else if (request.readyState == HttpRequest.DONE && request.status == 0) {
    querySelector('#absence').text = 'No server';
  }
}