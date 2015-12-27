import 'dart:html';
import 'dart:async';
import 'dart:convert';

var teacher,teacourse;
int i;
HttpRequest request;
List Data;
List StuData;
List course_name,choosecou;
Event e;
var mycourse,coursename;
List option_course;
var path = 'http://127.0.0.1:8080/tea';
main() async {
  await teaname_show(e);
  //coursename = querySelector('#coursename');
 //coursename =document. DataListElement('coursename').Item;
 // print(coursename);
}
void teaname_show(Event e) {
  request = new HttpRequest();
  request
    ..open('GET', path)
    ..onReadyStateChange.listen(TeaShow)
    ..send('');
}
void student_name(Event e){
  request = new HttpRequest();
  request
    ..open('POST',path)
    ..onReadyStateChange.listen(Stuname)
    ..send(JSON.encode(Data[1]));
}
void TeaShow(_) {
  course_name = new List();
 if (request.readyState == HttpRequest.DONE && request.status == 200) {
   Data = JSON.decode(request.responseText);
   print(Data.length);
   querySelector('#teachername').text = Data[0] + "您好！";
   for (i = 1;i < Data.length;i++) {
     mycourse = new Element.html('<option value="' + Data[i] + '"></option>');
     querySelector('#coursename').children.add(mycourse);
     //  OptionElement option = new OptionElement();
   }
   for (int j = 1;j < Data.length;j++) {
     var data = Data[j];
     course_name.add('$data');
   }print(course_name);
 } else if (request.readyState == HttpRequest.DONE && request.status == 0) {
    querySelector('#teachername').text = 'No server';
  }
  //option_course.onChange.listen(student_name);
}     //显示课程名称
void Stuname(_){
  if (request.readyState == HttpRequest.DONE && request.status == 200) {
    StuData = JSON.decode(request.responseText);
    print(StuData);
  } else if (request.readyState == HttpRequest.DONE && request.status == 0) {
    print('error');
  }
}


