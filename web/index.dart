import 'dart:html';
import 'dart:convert';
import 'dart:async';

HttpRequest request;
var url = 'http://127.0.0.1:8080/login';
// Input fields
TextInputElement numberInput;
TextInputElement passwordInput;
List list;

main() {
  // Set up the input text areas.
  numberInput = querySelector('#number');
  passwordInput = querySelector('#password');
  // querySelector('#fail')..text = '欢迎登录点名系统！';
  //Data = {'number':numberInput.value,'password':passwordInput.value};
  querySelector('#sub1').onClick.listen(login);
  querySelector('#sub2').onClick.listen(empty);

}

void login(Event e) {

  request = new HttpRequest(); //create request object
  list = [numberInput.value, passwordInput.value];
  e.preventDefault(); //suppress submit botton default behavior
  request.onReadyStateChange
  .listen(onData); //register callback to handle server response
  request.open('POST', url); //make request
  request.send(JSON.encode(list));
  //request.send('{"password":"${passwordInput.value}"}');
}

void onData(_) {
  //print(request.responseText);
  if (request.readyState == HttpRequest.DONE && request.status == 200) {
    //querySelector('#fail')..text = JSON.decode(request.responseText);
    List<String> log = JSON.decode(request.responseText);
    print(log);
    if (log[0] == 1) {
      window.open("stu.html", "点名系统（学生）");
      querySelector('#fail')
        ..text = log[1] + '同学你好，你已登录成功，请耐心等待界面跳转';
      querySelector('#number')
        ..value = numberInput.value;
      querySelector('#password')
        ..value = passwordInput.value;
    }
    if (log[0] == 2) {
      window.open("tea.html", "点名系统（教师）");
      querySelector('#fail')
        ..text = log[1] + '你好，您已登录成功，请耐心等待界面跳转';
      querySelector('#number')
        ..value = numberInput.value;
      querySelector('#password')
        ..value = passwordInput.value;
    }
    if (log[0] == 3) {
      // Status is 0; most likely the server isn't running.
      querySelector('#fail')
        ..text = '学（工）号或密码错误，请重新输入';
      querySelector('#number')
        ..value = numberInput.value;
      querySelector('#password')
        ..value = passwordInput.value;
    }
  } else if (log[0] == null) {
    // Status is 0; most likely the server isn't running.
    querySelector('#fail')
      ..text = '欢迎登录点名系统！请耐心等待';
    querySelector('#number')
      ..value = numberInput.value;
    querySelector('#password')
      ..value = passwordInput.value;
  }
}


void empty(Event e) {
  querySelector('#number')
    ..value = '';
  querySelector('#password')
    ..value = '';
  querySelector('#fail')
    ..text = '欢迎登录点名系统,请输入学（工）号和密码';
}
