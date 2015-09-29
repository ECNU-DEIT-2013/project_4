import 'dart:html';
import 'dart:math' as math;
void main() {
  querySelector('#sample_text_id')
    ..text = 'Click me!'
    ..onClick.listen(randomSelectStu);
  querySelector('#sample_add_id').text =addNumber(1,2).toString();

  querySelector('#sample_button_id')
    ..text = 'Add'
    ..onClick.listen(addTwoNumber);
}

int addNumber(x,y){
  return(x+y);
}
void addTwoNumber(MouseEvent event){
  vax x=int.parse(querySelector('#number_a').value);
  vax y=int.parse(querySelector('#number_b').value);
  querySelector('#sample_text_id2').text=addNumber(x,y).toString();
}

//void reverseText(MouseEvent event) {
 // var text = querySelector('#sample_text_id').text;
  //var buffer = new StringBuffer();
 // for (int i = text.length - 1; i >= 0; i--) {
 //   buffer.write(text[i]);
 // }
//  querySelector('#sample_text_id').text = buffer.toString();
//}

void randomSelectStu(MouseEvent event) {
  var stuMap={
    0:1213344345,
    1:6786876872
  };
  var random = new math.Random();

  var randomID=random.nextInt(2);
  var stuID=stuMap[randomID];
  querySelector('#sample_studentid_id').text =stuID.toString();
}
