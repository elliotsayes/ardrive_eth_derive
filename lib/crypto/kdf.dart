import 'dart:convert';
import 'dart:typed_data';

import 'package:arweave/arweave.dart';
import 'package:cryptography/cryptography.dart';
import 'package:uuid/uuid.dart';

// ardrive-web/lib/services/crypto/crypto.dart
final sha256 = Sha256();

// ardrive-web/lib/services/crypto/keys.dart
const keyByteLength = 256 ~/ 8;
final hkdf = Hkdf(hmac: Hmac(sha256), outputLength: keyByteLength);

// ardrive-web/lib/services/crypto/keys.dart
// Protocol changes:
// - `message` format changed to be human readable for non-Arweave wallets
//   Arweave wallets are unchanged, so it is backwards compatible
Future<SecretKey> deriveDriveKey(
  Wallet wallet,
  String driveId,
  String password,
) async {
  // Old:
  // final message =
  //   Uint8List.fromList(utf8.encode('drive') + Uuid.parse(driveId));
  
  // New:
  final message = wallet.chainCode == ChainCode.Arweave
    ? Uint8List.fromList(utf8.encode('drive') + Uuid.parse(driveId))
    : Uint8List.fromList(utf8.encode('ArDrive Drive-Id: $driveId'));
  
  final walletSignature = await wallet.sign(message);

  return hkdf.deriveKey(
    secretKey: SecretKey(walletSignature),
    info: utf8.encode(password),
    nonce: Uint8List(1),
  );
}