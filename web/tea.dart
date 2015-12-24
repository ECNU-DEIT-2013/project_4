import 'dart:html';
import 'dart:convert';

var teaname;
HttpRequest request;
var path = 'http://127.0.0.1:8080/tea';
void main(){
  print(teaname);


  if(teaname == null) {
    teaname = querySelector('#teacher').text;
    Tea_name;
    print(teaname);
  }


}
void Tea_name(Event e){

request = new HttpRequest();
  request
    ..open('GET', path)
    ..onReadyStateChange.listen(requestComplete)
    ..send('');

}

void requestComplete(_) {
  if (request.readyState == HttpRequest.DONE && request.status == 200) {
    teaname = request.responseText;
    print(teaname);
  }else if(request.readyState == HttpRequest.DONE &&
  request.status == 0){
    teaname = 'No server';
  }
}



