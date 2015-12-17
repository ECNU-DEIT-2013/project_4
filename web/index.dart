import 'dart:html';
import 'dart:convert';
import 'dart:async';

HttpRequest request;
String url = 'http://127.0.0.1:4040';
// Input fields
TextInputElement numberInput;
TextInputElement passwordInput;
//List list;
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
  List<String> list = [numberInput.value, passwordInput.value];
  e.preventDefault(); //suppress submit botton default behavior
  request.onReadyStateChange
      .listen(onData); //register callback to handle server response
  request.open('POST', url); //make request
  request.send(JSON.encode(list));
  //request.send('{"password":"${passwordInput.value}"}');
}

void onData(_) {
  if (request.readyState == HttpRequest.DONE && request.status == 200 &&
  request.responseText == '1' ) {

    window.open("stu.html", "点名系统（学生）");

  } else if (request.readyState == HttpRequest.DONE && request.status == 200 &&
  request.responseText == '2' ) {

    window.open("tea.html", "点名系统（教师）");

  } else{
    // Status is 0; most likely the server isn't running.
    querySelector('#fail')..text = '学（工）号或密码错误，请刷新后重新输入';
    querySelector('#number')..value = ' ';
    querySelector('#password')..value = ' ';
  }
}

void empty(Event e) {
  querySelector('#number')..value = ' ';
  querySelector('#password')..value = ' ';
}
