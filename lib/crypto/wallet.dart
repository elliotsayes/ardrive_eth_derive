import 'dart:async';
import 'dart:typed_data';

import 'package:arweave/arweave.dart';
import 'package:convert/convert.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:webthree/credentials.dart' hide Wallet;

class EthWalletConnectWallet extends Wallet {
  final WalletConnect connector;
  final String address;

  EthWalletConnectWallet(this.connector, this.address);

  @override
  ChainCode get chainCode => ChainCode.Ethereum;

  // Comparison of signing methods:
  // ❌ `sign`: Deprecated
  // ❌ `signTypedData`: Used to efficiently verify on-chain (unnecessary)
  // ✅ `personalSign`: Simplest, supports hardware wallets
  // See more: https://docs.metamask.io/wallet/how-to/sign-data/
  //
  // `password` is not needed, and does not affect the signature
  // See more: https://ethereum.stackexchange.com/a/69879
  @override
  Future<Uint8List> sign(Uint8List message, [String? password]) async {
    final provider = EthereumWalletConnectProvider(connector);
    final messageHex = '0x${hex.encode(message)}';
    print('messageHex: $messageHex');
    final signatureHex = await provider.personalSign(
      message: messageHex,
      address: address,
      password: password ?? '',
    );
    print('signatureHex: $signatureHex');
    return Uint8List.fromList(hex.decode(signatureHex.substring(2)));
  }

  @override
  Future<String> getAddress() {
    return Future.value(address);
  }

  @override
  Future<String> getOwner() {
    // Ethereum-signed txs appear to use the address as owner?
    // Will confirm in Phase 3
    // Source: https://github.com/Bundlr-Network/js-sdk/blob/main/src/web/currencies/ethereum.ts#L105
    return Future.value(address);
  }
}

class EthJsWallet extends Wallet {
  final CredentialsWithKnownAddress credentials;
  final String address;

  EthJsWallet(this.credentials, this.address);

  @override
  ChainCode get chainCode => ChainCode.Ethereum;

  // Eth JS wallet does not support password field
  @override
  Future<Uint8List> sign(Uint8List message) async {
    final signature = await credentials.signPersonalMessage(message);
    print('signature: $signature');
    return Future.value(signature);
  }

  @override
  Future<String> getAddress() {
    return Future.value(address);
  }

  @override
  Future<String> getOwner() {
    return Future.value(address);
  }
}