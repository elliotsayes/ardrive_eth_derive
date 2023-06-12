import 'dart:async';

import 'package:ardrive_eth_phase_2/crypto/kdf.dart';
import 'package:arweave/arweave.dart';
import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class DriveKeyPage extends StatefulWidget {
  const DriveKeyPage({
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
  State<DriveKeyPage> createState() => _DriveKeyPageState();
}

class _DriveKeyPageState extends State<DriveKeyPage> {
  String walletAddress = 'Loading...';
  String driveId = '00000000-0000-0000-0000-000000000000';
  String drivePassword = 'testpassword';
  String driveKey = '...';

  @override
  void initState() {
    super.initState();
    widget.wallet.getAddress().then((value) => setState(() {
      walletAddress = value;
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

  void newDriveId() {
    setState(() {
      driveId = Uuid().v4();
    });
  }

  void runDeriveDriveKey() async {
    final driveKeySecret =
        await deriveDriveKey(widget.wallet, driveId, drivePassword);
    final driveKeyData = await driveKeySecret.extractBytes();
    setState(() {
      driveKey = hex.encode(driveKeyData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: backInterceptor,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Drive Key'),
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
                      walletAddress,
                      style: Theme.of(context).textTheme.labelLarge,
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
              Text(
                'Drive ID:',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SelectableText(
                    driveId,
                    style: Theme.of(context).textTheme.labelLarge,
                    textAlign: TextAlign.center,
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    tooltip: 'Refresh',
                    onPressed: newDriveId,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                  // obscureText: true,
                  initialValue: drivePassword,
                  onChanged: (newDrivePassword) {
                    setState(() {
                      // print('newDrivePassword: $newDrivePassword');
                      drivePassword = newDrivePassword;
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
                        content: Text('Please check your Wallet app & confirm sign.'),
                      ),
                    );
                    runDeriveDriveKey();
                  },
                  textTheme: ButtonTextTheme.primary,
                  color: Colors.blueAccent,
                  elevation: 5,
                  child: const Text('Derive Drive Key'),
                ),
              ),
              Text(
                'Drive Key:',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              SelectableText(
                driveKey,
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
