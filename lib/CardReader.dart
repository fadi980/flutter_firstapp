import 'package:nfc_manager/nfc_manager.dart';
import 'package:event/event.dart';
import 'dart:async';

class CardReader {

  bool nfc_Available = false;
  String CardID = '';
  String NFC_Message = '';

  final CardDetectedEvent = Event<CardDetectedEventArgs>();
  final ScanningStoppedEvent = Event<ScanningStoppedEventArgs>();

  Timer ScanningTimeoutTimer = Timer(const Duration(seconds: 10), (){});

  void StopScanning(){
    NfcManager.instance.stopSession(alertMessage: 'Scanning stopped',errorMessage: 'Scanning Time Out');
    ScanningStoppedEvent.broadcast(ScanningStoppedEventArgs());
  }

  Future<void> isNFCAvailable() async {

    //WidgetsFlutterBinding.ensureInitialized(); // Required for the line below
    bool isNfcAvalible = await NfcManager.instance.isAvailable();

    nfc_Available = isNfcAvalible;

  }

  Future<void> listenForNFCEvents() async {
    print('Start NFC session');
    ScanningTimeoutTimer = Timer(const Duration(seconds: 10), StopScanning);

    NfcManager.instance.startSession(
        onDiscovered: (NfcTag tag) async {
          print('Tag detected');
          var idl = tag.data.values.first['identifier'];
          CardID = '';
          for(int i = 0; i < 7; i++){
            CardID = '$CardID:${int.parse(idl[i].toString()).toRadixString(16).toUpperCase().padLeft(2, '0')}';
          }
          CardID = CardID.substring(1);
          print(CardID);
          CardDetectedEvent.broadcast(CardDetectedEventArgs(CardID));
          NfcManager.instance.stopSession();
        }
    );
    print('NFC session started');
  }

}

class CardDetectedEventArgs extends EventArgs{
  String cardID;

  CardDetectedEventArgs(this.cardID);
}

class ScanningStoppedEventArgs extends EventArgs{

}