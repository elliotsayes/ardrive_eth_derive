import 'dart:convert';
import 'dart:typed_data';

import 'package:arweave/arweave.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:convert/convert.dart';

Future<String> ethSignMessage(Wallet wallet, String message) async {
  final messageData = Uint8List.fromList(utf8.encode(message));
  final walletSignature = await wallet.sign(messageData);
  final walletSignatureHex = hex.encode(walletSignature);
  return walletSignatureHex;
}

Future<String> signatureToBip39Mnemonnic(String signatureHex) async {
  final bip39Mnemonnic = bip39.entropyToMnemonic(signatureHex);
  return bip39Mnemonnic;
}

Future<Wallet> bip39MnemonnicToWallet(String bip39Mnemonnic) async {
  final wallet = await Wallet.createWalletFromMnemonic(bip39Mnemonnic);
  return wallet;
}
