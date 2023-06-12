import 'dart:async';

import 'package:ardrive_eth_derive/crypto/eth_derive.dart';
import 'package:ardrive_eth_derive/crypto/kdf.dart';
import 'package:arweave/arweave.dart';
import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class EthDerivePage extends StatefulWidget {
  const EthDerivePage({
    super.key,
    required this.wallet,
    this.onBack,
  });

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final Wallet wallet;
  final FutureOr<void> Function()? onBack;

  @override
  State<EthDerivePage> createState() => _EthDerivePageState();
}

class _EthDerivePageState extends State<EthDerivePage> {
  String ethWalletAddress = 'Loading...';
  String signatureMessage = 'ArDrive Key';
  String bip39Phrase = '...';
  String arweaveWalletAddress = '...';

  @override
  void initState() {
    super.initState();
    widget.wallet.getAddress().then((value) => setState(() {
          ethWalletAddress = value;
        }));
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> backInterceptor() async {
    await widget.onBack?.call();
    return true;
  }

  void runDeriveArweaveWallet() async {
    final ethSignature = await ethSignMessage(widget.wallet, signatureMessage);
    print('ethSignature: $ethSignature');

    final _bip39Phrase = await signatureToBip39Mnemonnic(ethSignature);
    print('_bip39Phrase: $_bip39Phrase');
    setState(() {
      bip39Phrase = _bip39Phrase;
    });

    // delay to allow UI to update
    await Future.delayed(const Duration(milliseconds: 100));

    // this causes the UI to hang for several minutes on web
    final arweaveWallet = await bip39MnemonnicToWallet(_bip39Phrase);
    final _arweaveWalletAddress = await arweaveWallet.getAddress();
    print('_arweaveWalletAddress: $_arweaveWalletAddress');
    setState(() {
      arweaveWalletAddress = _arweaveWalletAddress;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: backInterceptor,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Eth Derive'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                  children: [
                    Text(
                      '${widget.wallet.runtimeType} address:',
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    SelectableText(
                      ethWalletAddress,
                      style: Theme.of(context).textTheme.labelLarge,
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Signature Message',
                  ),
                  // obscureText: true,
                  initialValue: signatureMessage,
                  onChanged: (newSignatureMessage) {
                    setState(() {
                      signatureMessage = newSignatureMessage;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: MaterialButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Please check your Wallet app & confirm sign.'),
                      ),
                    );
                    runDeriveArweaveWallet();
                  },
                  textTheme: ButtonTextTheme.primary,
                  color: Colors.blueAccent,
                  elevation: 5,
                  child: const Text('Derive Arweave Wallet'),
                ),
              ),
              Text(
                'Bip39 Phrase:',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              SelectableText(
                bip39Phrase,
                style: Theme.of(context).textTheme.labelLarge,
                textAlign: TextAlign.center,
              ),
              Text(
                'Arweave Wallet Address:',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              SelectableText(
                arweaveWalletAddress,
                style: Theme.of(context).textTheme.labelLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
