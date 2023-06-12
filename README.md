# ardrive_eth_derive

A Proof of Concept in Flutter for deriving ArFS drive keys from Metamask Ethereum Wallets, on Android & Web

## Running the demo

### Android

#### Setup

1. Install Metamask app. If running on emulator, download an `.apk` from github (e.g. [6.4.0](https://github.com/MetaMask/metamask-mobile/releases/tag/v6.4.0) release), and drag & drop the file into the emulator window.
2. Generate or import a new ethereum key

#### Run

1. Tap the 'WalletConnect' button, then tap connect
2. Your wallet application (e.g. Metamask) should open, tap Connect & the flutter app should auto-proceed to the 'Drive Key' screen
3. Tap the 'Derive Drive Key' button
4. Switch back to your wallet application, and click sign on the message
5. Observe the key

### Web

#### Setup

1. Enable extensions on Flutter dev chrome by following these instructions: https://stackoverflow.com/a/71747975
2. Run `flutter run -d chrome` to launch Flutter dev chrome.
3. Install the Metamask Chrome extension in that same chrome window: https://chrome.google.com/webstore/detail/metamask/nkbihfbeogaeaoehlefnkodbefgpgknn
4. Generate or import your key into metamask
5. Reload the flutter application

#### Run

1. If using WalletConnect, follow the same instructions for mobile, except instead of clicking Connect in the modal, scan the QR code from your mobile wallet application (top right button in Metamask mobile app)
2. If using the Metamask button, follow the on screen instructions from the extension when it pops up.

## Important source files

- [lib/crypto/wallet.dart](lib/crypto/wallet.dart)
  - Code for generating Ethereum signatures for both WalletConnect
    & Metamask browser API. See notes on signing method & password field.
- [lib/crypto/kdf.dart](lib/crypto/kdf.dart)
  - Code for generating ArFS Drive Key. See notes on updated encoding
    of signed message.
- [lib/widgets/walletconnect.dart](lib/widgets/walletconnect.dart)
  - Widget to manage WalletConnect connection process.
- [lib/widgets/metamask.dart](lib/widgets/metamask.dart)
  - Widget to manage Metamask browser extension connection process.
