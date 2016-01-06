import 'dart:html';
import 'dart:convert';

//var teacher, teacourse;
//var val;
int i;    //Data中的第i个数
Event e;    //定义全局变量e
HttpRequest request;
List Data;      //接收教师姓名，课程的list
//List StuData;
var course_name;   //获取选中的课程名称
var stu_name,stu_number,stu_ab;     //学生姓名，学号，缺席次数
var mycourse, coursename;   //mycourse代表select中的下拉值，coursename为select的id
var yes,no;   //按钮yes,no
var path = 'http://127.0.0.1:8080/tea';
var path_allname = 'http://127.0.0.1:8080/allname';
var path_rollname = 'http://127.0.0.1:8080/rollname';
var path_absence = 'http://127.0.0.1:8080/absence';
main() async {
  teaname_show(e);      //主函数中直接调用函数，显示教师信息，同步调用
  coursename = querySelector('#coursename');
  querySelector('#sub_logout').onClick.listen((Event e)=>window.open("index.html","点名系统"));   //退出登录跳转至登录界面
  querySelector('#sub_logout').onClick.listen((MouseEvent e)=>window.close);   //退出登录关闭此界面
  querySelector('#coursename').onChange.listen(changecou);    //选择课程后执行changecou函数
  querySelector('#sub_rollname').onClick.listen(stuname);   //随机点名执行stuname函数
  stu_name = querySelector('#stu_name');
  stu_number = querySelector('#stu_number');
  stu_ab = querySelector('#stu_ab');
}
void teaname_show(Event e) {
  request = new HttpRequest();
  request
    ..open('GET', path)
    ..onLoadEnd.listen(TeaShow)
    ..send();
}   //连接服务器，获取教师姓名，课程名
changecou(Event e){
  course_name = document.getElementById('coursename').value;
  print(course_name);
  request = new HttpRequest();
  request.open('POST',path_allname);
  request.send(JSON.encode(course_name));
}     //获取选中的课程名称，并传入服务器
TeaShow(_) {
  course_name = new List();
  if (request.readyState == HttpRequest.DONE && request.status == 200) {
    Data = JSON.decode(request.responseText);     //Data接收服务器传来的数据
    querySelector('#teachername').text = Data[0] + "您好！";   //显示欢迎词，添加教师姓名
    mycourse = new Element.html('<option value="''">...</option>');   //select中第一个值
    querySelector('#coursename').children.add(mycourse);    //添加mycourse
    for (i = 1; i < Data.length; i++) {
      mycourse = new Element.html('<option value="' + Data[i] + '">'+ Data[i] +'</option>');    //添加课程名
      querySelector('#coursename').children.add(mycourse);
    }
    print(course_name);  //测试是否成功获取全部课程名
  } else if (request.readyState == HttpRequest.DONE && request.status == 0) {
    querySelector('#teachername').text = 'No server';   //监测是否有错误
  }
} //显示教师姓名，课程名下拉框
stuname(Event e){
  request = new HttpRequest();
  request
    ..open('GET', path_rollname)
    ..onReadyStateChange.listen(Random_name)
    ..send('');
}     //连接服务器，获取服务器中给的随机学生的信息
Random_name(_){
  if (request.status == 200) {
    List<String> namelist = JSON.decode(request.responseText);    //namelist接收服务器传来的数据
    stu_number.text= namelist[0];   //显示学生学号
    stu_name.text = namelist[1];     //显示学生姓名
    stu_ab.text = namelist[2];    //显示学生缺席次数
    querySelector('#infor').text = '本次课堂是否缺席？';   //显示提示信息
    querySelector('#yes').text = '是';
    querySelector('#no').text = '否';    //显示判断按钮
    querySelector('#yes').onClick.listen(abyes);    //点击按钮yes为学生添加缺席记录，点击no无反应
  }else{
    stu_name.text = 'ERROR:${request.status}';
  }
}     //随机学生信息的显示
abyes(Event e) {
  request = new HttpRequest();
  request
    ..open('POST',path_absence)
    ..onReadyStateChange.listen(absence)
    ..send('1');
} //yes按钮点击一次，为学生增加一次缺席次数，上传至服务器
absence(_) async {
  var abcishu,abcishu1;
  if (request.status == 200) {
    abcishu = JSON.decode(request.responseText);
    abcishu1 = abcishu.toString();
    querySelector('#stu_ab').text = abcishu1;
  }else{
    stu_name.text = 'ERROR:${request.status}';
  }
}