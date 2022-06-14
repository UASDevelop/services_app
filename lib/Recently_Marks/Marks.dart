import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
class SubmitMarks extends StatelessWidget{


  SubmitMarks({
 required this.Editcontorller,
    required this.maxlength,
    required this.Color,
    required this.Onchagne,
    required this.padding,
});
   TextEditingController Editcontorller;
   int maxlength;
  var  Color=Colors.grey.shade800;
  Function ?Onchagne;
  Padding padding=Padding(padding: EdgeInsets.all(30)) ;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: Editcontorller,
          onChanged: (value){
            Onchagne!=value;
          },
        )
      ],
    );
  }
}