
import 'package:flutter/material.dart';

class MetamaskButton extends StatefulWidget {
  const MetamaskButton({super.key});

  @override
  State<MetamaskButton> createState() => _MetamaskButtonState();
}

class _MetamaskButtonState extends State<MetamaskButton> {
  String text = 'Extension only on web';
  bool buttonEnabled = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: null,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'MetaMask',
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
              color: Theme.of(context).disabledColor,
            ),
          ),
          Text(
            text,
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
              color: Theme.of(context).disabledColor,
            ),
          ),
        ],
      ),
    );
  }
}
