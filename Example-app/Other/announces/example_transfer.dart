import 'package:xpx_chain_sdk/xpx_sdk.dart';

/// Simple Transactions API request
void main() async {
  const baseUrl = 'http://bctestnet1.brimstone.xpxsirius.io:3000';

  /// Creating a client instance
  /// xpx_chain_sdk uses the Dart's native HttpClient.
  /// Depending on the platform, you may want to use either
  /// the one which comes from dart:io or the BrowserClient
  /// example:
  /// 1- import 'package:http/browser_client.dart';
  /// 2- var client = newClient(config,  BrowserClient());
  final client = SiriusClient.fromUrl(baseUrl, null);

  final generationHash = await client.generationHash;

  final networkType = await client.networkType;

  /// Create an Account from a given Private key.
  final account = Account.fromPrivateKey(
      '5D3E959EB0CD69CC1DB6E9C62CB81EC52747AB56FA740CF18AACB5003429AD2E',
      networkType);

  /// Create an Address from a given Public key.
  final recipient =
      Address.fromRawAddress('VC4A3Z6ALFGJPYAGDK2CNE2JAXOMQKILYBVNLQFS');

  /// Create a  transaction type transfer
  final tx = TransferTransaction(
      // The maximum amount of time to include the transaction in the blockchain.
      Deadline(hours: 1),
      // The Address of the recipient account.
      recipient,
      // The List of mosaic to be sent.
      [xpxRelative(2)],
      // The transaction message of 1024 characters.
      PlainMessage(payload: 'Transfer From ProximaX Rust SDK"'),
      networkType);

  final stx = account.sign(tx, generationHash);

  try {
    final restTx = await client.transaction.announce(stx);
    print(restTx);
    print('Signer: ${account.publicAccount.publicKey}');
    print('HashTxn: ${stx.hash}');
  } on Exception catch (e) {
    print('Exception when calling Transaction->Announce: $e\n');
  }
}
