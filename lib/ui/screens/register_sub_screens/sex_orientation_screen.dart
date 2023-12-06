import 'package:flutter/material.dart';
import 'package:soltalk/util/constants.dart';

class SexOrientationScreen extends StatefulWidget {
  final Function(String) onChanged;

  const SexOrientationScreen({super.key, required this.onChanged});

  @override
  SexOrientationScreenState createState() => SexOrientationScreenState();
}

class SexOrientationScreenState extends State<SexOrientationScreen> {
  var soValue = kSexOrientationList[kSexOrientationIndex];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            Text(
              'Sexual orientation is',
              style: Theme.of(context).textTheme.displaySmall,
            ),
          ],
        ),
        Expanded(
          child: Center(
            child: 
            Container(
                  height: 45,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      value: soValue,
                      items: kSexOrientationList.map((String item) {
                        return DropdownMenuItem<String>(
                          child: Text(item, style: TextStyle(color: Colors.white),),
                          value: item,
                        );
                      }).toList(),
                      onChanged: (value) {
                        print('value==> ${value}');
                        if(value != null && value != soValue){
                          setState(() {
                          soValue = value;
                          });

                          widget.onChanged(value);
                        }
                       
                      },
                      isExpanded: true,
                    ),
                  ),
                ),
            
            /*NumberPicker(
              itemWidth: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                value: so,
                minValue: 0,
                maxValue: 120,
                onChanged: (value) => {
                      setState(() {
                        age = value;
                      }),
                      widget.onChanged(value)
                    }),*/
          ),
        ),
      ],
    );
  }
}
