import 'dart:convert';
import 'dart:typed_data';

import 'package:arweave/arweave.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:convert/convert.dart';
import 'package:cryptography/cryptography.dart';

import 'stub_web_wallet.dart' // stub implementation
    if (dart.library.html) 'web_wallet.dart';

// ardrive-web/lib/services/crypto/crypto.dart
final sha256 = Sha256();

Future<Uint8List> ethSignMessage(Wallet wallet, String message) async {
  final messageData = Uint8List.fromList(utf8.encode(message));
  final walletSignature = await wallet.sign(messageData);
  // final walletSignatureHex = hex.encode(walletSignature);
  return walletSignature;
}

Future<String> signatureToBip39Mnemonnic(Uint8List signature) async {
  final signatureSha256 = await sha256.hash(signature);
  final signatureSha256Data = Uint8List.fromList(signatureSha256.bytes);
  final signatureHex = hex.encode(signatureSha256Data);
  final bip39Mnemonnic = bip39.entropyToMnemonic(signatureHex);
  return bip39Mnemonnic;
}

Future<Wallet> bip39MnemonnicToWallet(String bip39Mnemonnic) async {
  final wallet = await generateWalletFromMnemonic(bip39Mnemonnic);
  return wallet;
}
