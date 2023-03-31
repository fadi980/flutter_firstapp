import "dart:convert";
import "dart:math";
import "package:http/http.dart";

class Customer {
  String CardID = '--';
  String CustomerName = '--';
  String PhoneNo = '--';
  String MembershipDate = '--';
  int MembershipLevel = 0;
  String Message = '';
  var rnd = Random();

  Future<void> readCustomerInfo(String CardID) async
  {
    Response respone = await get(Uri.parse('http://192.168.68.58/customers.htm'));
    //Response respone = await get(Uri.parse('http://worldtimeapi.org/api/timezone/America/Argentina/Salta'));
    print('BODY: ${respone.body}');
    Map data = jsonDecode(respone.body);
    CustomerName = data["Name"];
    PhoneNo = data["PhoneNo"];
    MembershipDate = data["MembershipDate"];
    print(CustomerName);
  }

  void reset(){
    CardID = '-';
    CustomerName = '-';
    PhoneNo = '-';
    MembershipDate = '-';
    MembershipLevel = 0;
  }
}