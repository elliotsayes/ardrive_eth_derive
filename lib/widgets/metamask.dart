import 'dart:html';

import 'package:ardrive_eth_phase_2/crypto/wallet.dart';
import 'package:ardrive_eth_phase_2/pages/drive_key.dart';
import 'package:flutter/material.dart';
import 'package:js/js.dart';
import 'package:webthree/browser.dart';
import 'package:webthree/webthree.dart';

@JS()
@anonymous
class JSrawRequestParams {
  external String get chainId;

  // Must have an unnamed factory constructor with named arguments.
  external factory JSrawRequestParams({String chainId});
}

class MetamaskButton extends StatefulWidget {
  const MetamaskButton({super.key});

  @override
  State<MetamaskButton> createState() => _MetamaskButtonState();
}

class _MetamaskButtonState extends State<MetamaskButton> {
  String text = 'Ready';
  bool buttonEnabled = true;

  late final Ethereum eth;
  late final Web3Client client;

  @override
  void initState() {
    super.initState();

    final maybeEth = window.ethereum;
    if (maybeEth == null) {
      text = 'MetaMask is not available';
      buttonEnabled = false;
      return;
    } else {
      eth = maybeEth;
      eth.stream('disconnect').forEach((element) {
        setState(() {
          text = 'Disconnected';
          buttonEnabled = true;
        });
      });
      client = Web3Client.custom(eth.asRpcService());
    }
  }

  void metamaskConnect() async {
    // Try to initiate connection
    setState(() {
      buttonEnabled = false;
    });
    final nav = Navigator.of(context);
    final credentials = await eth.requestAccount();
    if (!eth.isConnected()) {
      setState(() {
        text = "Error, not connected";
      });
      return;
    }

    final address = credentials.address;
    setState(() {
      text = "Connected: ${address.hex}";
    });

    await Future.delayed(const Duration(seconds: 1));

    final wallet = EthJsWallet(credentials, address.hex);

    void cleanup() {
      print('Metamask cleanup');
      // TODO: Disconnect from Metamask
      setState(() {
        text = 'Ready';
        buttonEnabled = true;
      });
    }

    nav.push(
      MaterialPageRoute(
        builder: (context) => DriveKeyPage(
          wallet: wallet,
          onBack: cleanup,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: buttonEnabled ? metamaskConnect : null,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'MetaMask',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Text(
            text,
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ],
      ),
    );
  }
}
