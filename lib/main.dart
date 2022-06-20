
import "package:flutter/material.dart";
import 'package:gradecryptdesktop/cantor.dart';
import 'package:qr/qr.dart';
import 'package:qr_flutter/qr_flutter.dart';
double e = 0;
double n = 0;
main() {
  runApp(MaterialApp(home: MainWindow()));
}

class MainWindow extends StatefulWidget {
  const MainWindow({Key? key}) : super(key: key);

  @override
  State<MainWindow> createState() => _MainWindowState();
}

class _MainWindowState extends State<MainWindow> {
  final gradecontroler = TextEditingController();
  final encryptedcontroller = TextEditingController();
  final keycontroller = TextEditingController();
  String QrData = "x";
  double QrSize = 0;
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    encryptedcontroller.dispose();
    gradecontroler.dispose();
    keycontroller.dispose();
    super.dispose();
    super.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Demo",
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 88, 19, 100),
          title: Text("Gradecrypt Verschlüsselung",textScaleFactor: 1.5),
        ),
        body:  Column(
          mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
          Container(
              margin: const EdgeInsets.all(10.0),
              padding: const EdgeInsets.all(10.0),
              
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text("Öffentlicher Schlüssel:",textScaleFactor: 3,)),
              ),

            Container(
                            margin: const EdgeInsets.all(10.0),
              padding: const EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width: 500,
                  child: TextField(
                    controller: keycontroller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Vom Schüler erhaltener Schlüssel",
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10.0),
              padding: const EdgeInsets.all(10.0),
              
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text("Note:",textScaleFactor: 3,)),
              ),

            Container(
                            margin: const EdgeInsets.all(10.0),
              padding: const EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width: 500,
                  child: TextField(
                    controller: gradecontroler,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Beispiel: 5.5",
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10.0),
              padding: const EdgeInsets.all(10.0),
              
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text("Verschlüsselt:",textScaleFactor: 3,)),
              ),
              Container(
                            margin: const EdgeInsets.all(10.0),
              padding: const EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width: 500,
                  child: TextField(
                    onChanged: (text) {
                    encryptedcontroller.text = text;
                    },
                    controller: encryptedcontroller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Note in verschlüsselter Form",

                    ),
                  ),
                ),
              ),
            ),
              Container(
              margin: const EdgeInsets.all(10.0),
              padding: const EdgeInsets.all(10.0),
              
              child: Align(
                  alignment: Alignment.center,
                  child: QrImage(
                    data: QrData,
                    version: QrVersions.auto,
                    size: QrSize,
                  ),
              ),
            
              )
          ]),
                  
        
    
      floatingActionButton: SizedBox(
        height: 100,
        width: 100,
        child: FloatingActionButton(
          child: Icon(Icons.key, size: 40,),
          backgroundColor: Color.fromARGB(255, 88, 19, 100),
          onPressed: () {
            e = inv_cantor1(double.parse(keycontroller.text));
            n = inv_cantor2(double.parse(keycontroller.text));
            QrData = encryptedcontroller.text;
            QrSize = 200;
            print(n);
            print(e);
            setState(() {
              encryptedcontroller.text = gradecrypt(gradecontroler.text);
            });
          },
        
      ),
      
      )));

 

}
}

String gradecrypt(String grade) {
  var grade_double = double.parse(grade);
  var grade_int = int.parse((grade_double * 100).round().toString());
  BigInt grade_big = BigInt.parse(grade_int.toString());
  BigInt e_big = BigInt.parse(e.round().toString());
  BigInt n_big = BigInt.parse(n.round().toString());
  BigInt encrypted_big = grade_big.modPow(e_big, n_big);
  return encrypted_big.toString();
}