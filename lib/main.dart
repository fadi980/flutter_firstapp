import 'dart:async';
import 'package:flutter/material.dart';
import 'package:app28_1/CardReader.dart';
import 'package:app28_1/customer.dart';
import 'package:app28_1/Theme/contants.dart';

void main() {
  runApp(MaterialApp(
    home: CIDReader(),
  ));
}

class CIDReader extends StatefulWidget {
  @override
  State<CIDReader> createState() => _CIDReaderState();
}

class _CIDReaderState extends State<CIDReader> {
  // A timer to always check NFC availability and update availability status
  Timer NFCReaderCheckTimer = Timer.periodic(const Duration(seconds: 3),(Timer timer){});

  // A timer to set time out for card detection when card read is selected
  Timer CardReadTimeoutTimer = Timer(const Duration(seconds: 5), (){});

  String CardID = '-';
  bool NFC_Available = false;
  bool NFC_Scanning = false;

  Color? AppBar_Color = AppColors.appBar_Normal;
  Color? Button_Color = AppColors.readButton_Inactive;

  CardReader reader = CardReader();
  Customer customer = Customer();

  void handleCheckNFCTimer(Timer timer) async {
    await CheckReader();
    //print('NFC check timer tick: ${DateTime.now()}');
  }

  void handleCardReadTimeoutTimer(){
    print('Card detection time out tick: ${DateTime.now()}');
  }

  Future<void> CheckReader() async {
    await reader.isNFCAvailable();
    if (reader.nfc_Available){
      if (!NFC_Scanning) {
        Button_Color = AppColors.readButton_Active;
      }
    }
    else{
      Button_Color = AppColors.readButton_Inactive;
    }

    setState(() {

    });
    print(reader.nfc_Available);
    NFC_Available = reader.nfc_Available;
  }

  Future<void> ReadCard() async {
    await reader.listenForNFCEvents();
    setState(() {

    });
  }

  void CardDetectedEventHandler(CardDetectedEventArgs? args) async {
    print('Event Handler: card detected ${args?.cardID}');
    CardID = (args?.cardID).toString();

    await customer.readCustomerInfo(CardID);

    setState(() {
    });
  }

  void ScanningStoppedEventHandler(ScanningStoppedEventArgs? args) async {
    print('Scanning timed out');
    NFC_Scanning = false;
    Button_Color = AppColors.readButton_Active;
  }

  @override
  void initState(){
    super.initState();
    print('Check NFC Reader');
    CheckReader();

    NFCReaderCheckTimer = Timer.periodic(const Duration(seconds: 3), handleCheckNFCTimer);
    //CardReadTimeoutTimer = Timer(Duration(seconds: 5), handleCardReadTimeoutTimer);

    setState(() {
    });

    reader.CardDetectedEvent.subscribe((args) {CardDetectedEventHandler(args);});
    reader.ScanningStoppedEvent.subscribe((args) {ScanningStoppedEventHandler(args);});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text('Customer ID'),
        centerTitle: true,
        backgroundColor: AppBar_Color,
        elevation: 0.0,
      ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: () async {
          if (NFC_Available) {
            await ReadCard();
            setState(() {
              print('clicked');
              customer.reset();
              NFC_Scanning = true;
              Button_Color = AppColors.readButton_Scanning;

            });
          }
          else {
            print('NFC is not active');
          }
        },
        backgroundColor: Button_Color,
        child: Icon(Icons.document_scanner, color: Colors.grey[900],),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: CircleAvatar(
                backgroundImage: const AssetImage('assets/vipcustomer.png'),
                backgroundColor: Colors.grey[900],
                radius: 80.0,
              ),
            ),
            const Text(
              'Name: ',
              style: TextStyle(
                color: Colors.grey,
                letterSpacing: 2.0,
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            Text(
              '${customer.CustomerName}',
              style: TextStyle(
                color: Colors.blue[300],
                letterSpacing: 2.0,
                fontWeight: FontWeight.bold,
                fontSize: 26.0,
              ),
            ),
            SizedBox(height: 20.0,),
            Text(
              'Phone No: ',
              style: TextStyle(
                color: Colors.grey,
                letterSpacing: 2.0,
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            Text(
              '${this.customer.PhoneNo}',
              style: TextStyle(
                color: Colors.blue[300],
                letterSpacing: 2.0,
                fontWeight: FontWeight.bold,
                fontSize: 26.0,
              ),
            ),
            SizedBox(height: 20.0,),
            Text(
              'Membership Date: ',
              style: TextStyle(
                color: Colors.grey,
                letterSpacing: 2.0,
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            Text(
              '${this.customer.MembershipDate}',
              style: TextStyle(
                color: Colors.blue[300],
                letterSpacing: 2.0,
                fontWeight: FontWeight.bold,
                fontSize: 26.0,
              ),
            ),
            SizedBox(height: 20.0,),
            Text(
              'Membership Level: ',
              style: TextStyle(
                color: Colors.grey,
                letterSpacing: 2.0,
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            Text(
              '${this.customer.MembershipLevel}',
              style: TextStyle(
                color: Colors.blue[300],
                letterSpacing: 2.0,
                fontWeight: FontWeight.bold,
                fontSize: 26.0,
              ),
            ),
            SizedBox(height: 60.0,),
            Text(
              'card id: ' + '$CardID',
              style: TextStyle(
                color: Colors.grey[600],
                letterSpacing: 2.0,
                //fontWeight: FontWeight.bold,
                fontSize: 12.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

