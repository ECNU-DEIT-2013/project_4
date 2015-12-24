import 'dart:html';
import 'dart:async';
import 'dart:convert';

var teacher;
HttpRequest request;
var Data;
var path = 'http://127.0.0.1:8080/tea';
main() async {
  teacher = querySelector('#teachername').text;
  querySelector('#teachername').onClick.listen(tea_show);
  print(teacher);
}

void tea_show(Event e) {
  request = new HttpRequest();
  request
    ..open('GET', path)
    ..onReadyStateChange.listen(TeaShow)
    ..send('');
}

void TeaShow(_) {
  if (request.readyState == HttpRequest.DONE && request.status == 200) {
    Data = JSON.decode(request.responseText);
    querySelector('#teachername').text = Data;
  } else if (request.readyState == HttpRequest.DONE && request.status == 0) {
    querySelector('#teachername').text = 'No server';
  }
}
