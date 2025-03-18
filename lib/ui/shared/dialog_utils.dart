import 'package:flutter/material.dart';

Future<bool?> showConfirmDialog(BuildContext context, String message) {
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      icon: const Icon(Icons.warning),
      title: const Text('Are you sure?'),
      content: Text(
        message,
        style: TextStyle(fontSize: 18),
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: ActionButton(
                actionText: 'Yes',
                color: Theme.of(context).colorScheme.primary,
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
              ),
            ),
            Expanded(
              child: ActionButton(
                actionText: 'No',
                color: const Color.fromARGB(255, 150, 10, 0),
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Future<void> showErrorDialog(BuildContext context, String message) {
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      icon: const Icon(Icons.error),
      title: const Text('An Error Occurred!'),
      content: Text(
        message,
        style: TextStyle(fontSize: 18),
      ),
      actions: <Widget>[
        ActionButton(
          onPressed: () {
            Navigator.of(ctx).pop();
          },
          actionText: 'Okay',
          color: Theme.of(context).colorScheme.primary,
        ),
      ],
    ),
  );
}

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.actionText,
    required this.onPressed,
    required this.color,
  });

  final String actionText;
  final void Function() onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        actionText,
        style: TextStyle(
          color: color,
          fontSize: 24,
        ),
      ),
    );
  }
}
