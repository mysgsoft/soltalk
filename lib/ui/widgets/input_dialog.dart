import 'package:flutter/material.dart';
import 'package:soltalk/ui/widgets/bordered_text_field.dart';
import 'package:soltalk/util/constants.dart';

class InputDialog extends StatefulWidget {
  final String labelText;
  final Function(String) onSavePressed;
  final String startInputText;

  @override
  InputDialogState createState() => InputDialogState();

  const InputDialog({super.key, required this.labelText, required this.onSavePressed, this.startInputText = ''});
}

class InputDialogState extends State<InputDialog> {
  String inputText = '';
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    textController.text = widget.startInputText;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: kBackgroundColor,
      contentPadding: const EdgeInsets.all(16.0),
      content: BorderedTextField(
        textCapitalization: TextCapitalization.sentences,
        labelText: widget.labelText,
        autoFocus: true,
        keyboardType: TextInputType.text,
        onChanged: (value) => {inputText = value},
        textController: textController,
      ),
      actions: <Widget>[
        TextButton(
          //color: kColorPrimaryVariant,
          child: Text(
            'CANCEL',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          //color: kAccentColor,
          child: Text(
            'SAVE',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          onPressed: () {
            widget.onSavePressed(inputText);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
