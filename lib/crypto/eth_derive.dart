import 'package:arweave/arweave.dart';
import 'package:bip39/bip39.dart' as bip39;

Future<String> signatureToBip39Mnemonnic(String signatureHex) async {
  return bip39.entropyToMnemonic(signatureHex);
}

Future<Wallet> bip39MnemonnicToWallet(String bip39Mnemonnic) async {
  return await Wallet.createWalletFromMnemonic(bip39Mnemonnic);
}
