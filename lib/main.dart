import 'dart:math';
import 'dart:typed_data';

import "package:flutter/material.dart";
import 'package:gradecryptdesktop/CodeID.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr/qr.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:io';
import 'package:image/image.dart' as imagepub;
import "package:screenshot/screenshot.dart";
import 'dart:core';
import 'package:shared_preferences/shared_preferences.dart';
import 'editlistitems.dart';
import 'dart:convert';
var useCodeID = true;
//defines enterys for dropdown menu
List<DropdownMenuItem<String>> get dropdownItems {
  List<DropdownMenuItem<String>> menuItems = const[
    DropdownMenuItem(child: Text("Dezimal"), value: "decimal"),
    DropdownMenuItem(child: Text("Viertel"), value: "quarter"),
    DropdownMenuItem(child: Text("Halbe"), value: "half"),
    DropdownMenuItem(child: Text("Ganz"), value: "full"),
  ];
  return menuItems;
}

List<DropdownMenuItem<String>> get DropDownCalc {
  List<DropdownMenuItem<String>> menuItems = [
    DropdownMenuItem(child: Text("Normal"), value: "normal"),
    DropdownMenuItem(child: Text("Notenrechner"), value: "calc"),
  ];
  return menuItems;
}

//defining inintial variables
var theme;
var DarkOn;
var Dark = false;
var AverageGrade;
List<double> Average = [];
var DropdownValue = "quarter";
var DropdownValueCalc = "normal";
bool DropdownDisabled = false;
bool AverageVisible = false;
bool PointsEnabled = false;
var isChecked = false;
bool GradeEnabled = true;
final accentColor = Color.fromARGB(255, 76, 130, 164);
bool save_isvisible = false;
BigInt e = BigInt.from(0);
BigInt n = BigInt.from(0);
String selectedValue = "quarter";
String selectedValueCalc = "normal";

//main function to call App layout
main() {
  WidgetsFlutterBinding.ensureInitialized();
  SetThemeMode();
  runApp(MaterialApp(home: MainWindow()));
}

void SetThemeMode() async {
  final prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey("dark") == false) {
    prefs.setBool("dark", false);
    DarkOn = false;
    Dark = false;
    theme = ThemeMode.dark;
  }
  if (prefs.getBool("dark") == false) {
    DarkOn = false;
    Dark = false;
    theme = ThemeMode.light;
  } else if (prefs.getBool("dark") == true) {
    DarkOn = true;
    Dark = true;
    theme = ThemeMode.dark;
  }
}

void ModeChanged() async {
  final prefs = await SharedPreferences.getInstance();
  if (DarkOn == true) {
    prefs.setBool("dark", true);
  } else {
    prefs.setBool("dark", false);
  }
}

//mainwindow class. The MainWindow itself just redirects to the State (see Flutter Stateful/Stateles Widgets)
class MainWindow extends StatefulWidget {
  const MainWindow({Key? key}) : super(key: key);
  @override
  State<MainWindow> createState() => _MainWindowState();
}

String QrData = "x";
double QrSize = 0;
String CodeID = "";
double codeIDscale = 0;
//_MainState is where all the widgets are defined
class _MainWindowState extends State<MainWindow> {
  final gradecontroler = TextEditingController();
  final encryptedcontroller = TextEditingController();
  final keycontroller = TextEditingController();
  final maxpointscontroler = TextEditingController();
  final reachedpointscontroler = TextEditingController();
  final gradepointsreachedcontroller = TextEditingController();
  final gradepointsmaxcontroller = TextEditingController();

  Uint8List? bytes;
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    encryptedcontroller.dispose();
    gradecontroler.dispose();
    keycontroller.dispose();
    maxpointscontroler.dispose();
    reachedpointscontroler.dispose();
    gradepointsmaxcontroller.dispose();
    gradepointsreachedcontroller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          brightness: Brightness.light,
          /* light theme settings */
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          /* dark theme settings */
        ),
        themeMode: theme,
        //basic layout of the window (ListView, Container, Align, TextField, repeat-)
        home: Scaffold(
            appBar: AppBar(
              backgroundColor: accentColor,
              title: Text(
                "Gradecrypt Verschlüsselung",
                textScaleFactor: 1.5,
                style: TextStyle(
                    color: DarkOn == true ? Colors.black : Colors.white),
              ),
            ),
            body: ListView(children: <Widget>[
              Container(
                margin: const EdgeInsets.all(10.0),
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Öffentlicher Schlüssel:",
                          textScaleFactor: 3,
                        )),
                    Spacer(),
                    DropdownButton(
                        items: DropDownCalc,
                        value: selectedValueCalc,
                        onChanged: (String? newValue) {
                          DropDownChanged();
                          setState(() {
                            selectedValueCalc = newValue!;
                            DropdownValueCalc = selectedValueCalc;
                            ModeChange(selectedValueCalc);
                          });
                        }),
                    IconButton(onPressed: (){
                      setState(() {
                  useCodeID = !useCodeID;
                      });
                    }, icon: useCodeID ?  Icon(Icons.lock) : Icon(Icons.no_encryption)),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            Dark = !Dark;
                            if (Dark == true) {
                              theme = ThemeMode.dark;
                              DarkOn = true;
                              ModeChanged();
                            } else {
                              theme = ThemeMode.light;
                              DarkOn = false;
                              ModeChanged();
                            }
                          });
                        },
                        icon: Dark
                            ? Icon(Icons.dark_mode_outlined)
                            : Icon(Icons.dark_mode)),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10.0),
                padding: const EdgeInsets.all(10.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: SizedBox(
                    width: 500,
                    child: TextField(
                      //every TextField has a controller attached to it for manipulating/fetching the data
                      controller: keycontroller,
                      onChanged: (text) {
                        ;
                      },
                      //text field for entering key
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
                    child: Visibility(
                      visible: PointsEnabled,
                      child: Text(
                        //title for "calculating grade" section... obv.
                        "Note errechnen:",
                        textScaleFactor: 3,
                      ),
                    )),
              ),
              //a row layout for the Points, the DropDown menu and the Checkbox
              Visibility(
                visible: PointsEnabled,
                child: Row(
                  children: [
                    //the reached points entry
                    Container(
                      margin: const EdgeInsets.all(10.0),
                      padding: const EdgeInsets.all(10.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: SizedBox(
                          width: 225,
                          child: TextField(
                            enabled: PointsEnabled,
                            controller: reachedpointscontroler,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Beispiel: 32",
                            ),
                          ),
                        ),
                      ),
                    ),
                    //the "/" between the reached and max points
                    Text(
                      "/",
                      textScaleFactor: 2,
                    ),
                    //the max points entry
                    Container(
                      margin: const EdgeInsets.all(10.0),
                      padding: const EdgeInsets.all(10.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: SizedBox(
                          width: 225,
                          child: TextField(
                            enabled: PointsEnabled,
                            controller: maxpointscontroler,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "40",
                            ),
                          ),
                        ),
                      ),
                    ),
                    //the dropdown menu for choosing the steps
                    DropdownButton(
                        value: selectedValue,
                        items: dropdownItems,
                        onChanged: DropdownDisabled == true
                            ? (String? newValue) {
                                DropDownChanged();
                                setState(() {
                                  selectedValue = newValue!;
                                  DropdownValue = selectedValue;
                                });
                              }
                            : null),
                  ],
                ),
              ),
              //title for grade entry section
              Visibility(
                visible: true,
                child: Container(
                  margin: const EdgeInsets.all(10.0),
                  padding: const EdgeInsets.all(10.0),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Note:",
                        textScaleFactor: 3,
                      )),
                ),
              ),
              //grade entry section :D
              Visibility(
                visible: true,
                child: Container(
                  margin: const EdgeInsets.all(10.0),
                  padding: const EdgeInsets.all(10.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: SizedBox(
                      width: 500,
                      child: TextField(
                        enabled: GradeEnabled,
                        controller: gradecontroler,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Beispiel: 5.5",
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Visibility(
                visible: GradeEnabled,
                child: Container(
                  margin: const EdgeInsets.all(10.0),
                  padding: const EdgeInsets.all(10.0),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Punkte:",
                        textScaleFactor: 3,
                      )),
                ),
              ),
              Visibility(
                  visible: GradeEnabled,
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(10.0),
                        padding: const EdgeInsets.all(10.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: SizedBox(
                            width: 225,
                            child: TextField(
                              controller: gradepointsreachedcontroller,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Beispiel: 32",
                              ),
                            ),
                          ),
                        ),
                      ),
                      Text(
                        "/",
                        textScaleFactor: 2,
                      ),
                      Container(
                        margin: const EdgeInsets.all(10.0),
                        padding: const EdgeInsets.all(10.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: SizedBox(
                            width: 225,
                            child: TextField(
                              controller: gradepointsmaxcontroller,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "40",
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
              //title for encrypted grade field
              Container(
                margin: const EdgeInsets.all(10.0),
                padding: const EdgeInsets.all(10.0),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Verschlüsselt:",
                      textScaleFactor: 3,
                    )),
              ),
              //encrypted grade field >:D
              Container(
                margin: const EdgeInsets.all(10.0),
                padding: const EdgeInsets.all(10.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: SizedBox(
                    width: 500,
                    child: TextField(
                      onChanged: (text) {
                        WriteToQr();
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
              //the qr view
              Container(
                margin: const EdgeInsets.all(10.0),
                padding: const EdgeInsets.all(10.0),
                child: Align(
                  alignment: Alignment.center,
                  child: CodeQR(),
                ),
              ),
              //"Save" button is only visible, if boolean save_isvisible == true
              Visibility(
                visible: save_isvisible,
                child: Container(
                  margin: const EdgeInsets.all(10.0),
                  padding: const EdgeInsets.all(10.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      child: Text("Save",
                          style: TextStyle(
                              color: DarkOn == true
                                  ? Color.fromARGB(255, 100, 255, 218)
                                  : Color.fromARGB(255, 30, 136, 229))),
                      //flutter buttons require a "onPressed" function to be defined.
                      //in this case, the "onPress" screenshots the Qr_view Widget and calls the "saveImage" funtion to
                      //save the image, as well as calling the "_showMyDialog", to show the save dialog.
                      //in the Webversion, this is replaced by a Download function/dialog (see url_launcher)
                      onPressed: () async {
                        final controller = ScreenshotController();

                        final bytes =
                            await controller.captureFromWidget(Qr_view());
                        setState(() => this.bytes = bytes);
                        saveImage(bytes);
                        _showMyDialog();
                      },
                    ),
                  ),
                ),
              )
            ]),
            //the floating Action button containing the "encrypt button" itself, the edit average dialog and clear average button.
            //and the average itself as text ofc :) (Thank me for this heart-warming commentary)
            floatingActionButton: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              verticalDirection: VerticalDirection.up,
              mainAxisSize: MainAxisSize.max,
              children: [
                //a spacer to align everything to the right, (these things are very useful)
                Spacer(),
                Visibility(
                  //all the buttons and the text releated to Average is only visible when AverageVisible == true
                  //we don't support calculating an average from only grades, as this is only an approximation to a true
                  //average which is useless.
                  visible: AverageVisible,
                  //the "clear average button"
                  child: IconButton(
                    onPressed: () {
                      AverageVisible = false;
                      Average = [];
                      AverageGrade = 0;
                      setState(() {});
                    },
                    //if you have a lot of time, go through all the blue underlined code pieces, and do what flutter wants.
                    icon: Icon(Icons.clear),
                    color: Color.fromARGB(255, 189, 81, 74),
                  ),
                ),
                Visibility(
                    //the button for editing the average
                    visible: AverageVisible,
                    child: IconButton(
                      icon: Icon(Icons.edit_note),
                      onPressed: () => _showEditDialog(),
                    )),
                //the average text itself
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Visibility(
                    visible: AverageVisible,
                    child: Text(
                      "Durchschnitt: $AverageGrade",
                      textScaleFactor: 2.1,
                    ),
                  ),
                ),
                //the real floating action button in all his beauty
                SizedBox(
                  height: 100,
                  width: 100,
                  child: FloatingActionButton(
                    child: Icon(
                      Icons.key,
                      size: 40,
                    ),
                    backgroundColor: accentColor,
                    onPressed: () {
                      if (gradecontroler.text.contains(",")) {
                        gradecontroler.text = replaceCharAt(gradecontroler.text,
                            gradecontroler.text.indexOf(","), ".");
                      }
                      try {
                        //this one is interesting. I'll go through all the lines that arent self-explaining
                        if (isChecked == true) {
                          if (reachedpointscontroler.text != null) {
                            if (double.parse(reachedpointscontroler.text) >
                                double.parse(maxpointscontroler.text)) {
                              //if the reached points are higher than the reachable points (Teachers do all weird stuff with their grades)
                              //the average calculator just uses the maxpoints, otherwise the grade calculation would be screwed
                              Average.add(
                                  double.parse(maxpointscontroler.text));
                            } else if (double.parse(
                                    reachedpointscontroler.text) <
                                0) {
                              Average.add(0);
                              //if the reached points are below zero (Average latin test) the average just uses 0 as value.
                            } else {
                              Average.add(
                                  //if non of this nonsense happens, the reached points will just be added to the average
                                  double.parse(reachedpointscontroler.text));
                            }
                            //I just copied this bit, so i have absolutly no clue why it works, but it calculates the sum of all entrys from the average
                            AverageGrade = usePoints(((Average.reduce(
                                        (a, b) => a + b)) /
                                    Average.length)
                                //then it is divided by the length of average, so the amount of entrys in the Average list (thats where I understand it again)
                                .toString());
                          }
                          if (AverageGrade != null && Average.length > 1) {
                            AverageVisible = true;
                          } //so if the amount of entrys in average is higher than 1, we set AverageVisible to true. (Making the Average-stuff visible)
                        }
                        //tl;dr: a ton of logic for edge cases that might never get used
                        n = BigInt.parse(
                            keycontroller.text.substring(
                                keycontroller.text.indexOf("'") + 1,
                                keycontroller.text.length),
                            radix: 36);
                        e = BigInt.parse(
                            keycontroller.text
                                .substring(0, keycontroller.text.indexOf("'")),
                            radix: 36);
                        //as we use cantor's method for merging two integers order sensitive, we use this method
                        //for unpairing them.
                        QrData = encryptedcontroller.text;
                        if(useCodeID){
                          setState(() {
                            codeIDscale = 1;
                            CodeID = GetCodeID();
                          });
                          QrSize = 200;

                        }else{
                          codeIDscale = 0;
                          QrSize = 200;

                        }
                        QrSize = 200;                                                  QrSize = 200;

                        //if points arent used, the text in the grade textbox is just encrypted and pasted in the encrypted
                        //text field
                        if (isChecked == false) {
                          encryptedcontroller.text = rsa(gradecontroler.text);
                        } else {
                          //but if they are, a few clever things happen
                          encryptedcontroller.text =
                              rsa(usePoints(reachedpointscontroler.text));
                          var gradecontrolertext = double.parse(
                              usePoints(reachedpointscontroler.text));
                          if (DropdownValue == "decimal") {
                            //if the dropdown menu is set to "decimal, we just paste the calculated result"
                            gradecontroler.text = gradecontrolertext.toString();
                          } else if (DropdownValue == "quarter") {
                            //if we use use quarters, a pretty cool formula is used, so the decimal result
                            //is multiplied by 4, rounded to an integer and divided by 4 again.
                            gradecontroler.text =
                                ((gradecontrolertext * 4).round() / 4)
                                    .toString();
                          } else if (DropdownValue == "half") {
                            //for half numbers, we do the same, but with two
                            gradecontroler.text =
                                ((gradecontrolertext * 2).round() / 2)
                                    .toString();
                          } else if (DropdownValue == "full") {
                            //for full numbers, the result is just rounded to the closest integer.
                            gradecontroler.text =
                                gradecontrolertext.round().toString();
                          }
                          encryptedcontroller.text = rsa(gradecontroler.text);
                        }
                        save_isvisible = true;
                        setState(() {
                          WriteToQr();
                        });
                      } catch (e) {}
                    },
                  ),
                ),
              ],
            )));
  }

  //the data that is written to the code
  void WriteToQr() {
    if (isChecked == false) {
      if (gradepointsmaxcontroller.text != "" ||
          gradepointsmaxcontroller.text != "") {
        try {
          if(useCodeID){
                    QrData =
              "r:${gradecryptPub(keycontroller.text)}:${gradecrypt(encryptedcontroller.text)}:${gradecrypt(rsa(gradepointsreachedcontroller.text))}:${gradecrypt(rsa(gradepointsmaxcontroller.text))}:$CodeID";
          }else{
          QrData =
              "p:${gradecryptPub(keycontroller.text)}:${gradecrypt(encryptedcontroller.text)}:${gradecrypt(rsa(gradepointsreachedcontroller.text))}:${gradecrypt(rsa(gradepointsmaxcontroller.text))}";

          }
        } catch (e) {
          if(useCodeID){
                  QrData =
            "r:${gradecryptPub(keycontroller.text)}:${gradecrypt(encryptedcontroller.text)}:$CodeID";
          }else{
                     QrData =
    "g:${gradecryptPub(keycontroller.text)}:${gradecrypt(encryptedcontroller.text)}";

          }

        }
      } else {
        if(useCodeID){
                  QrData =
            "i:${gradecryptPub(keycontroller.text)}:${gradecrypt(encryptedcontroller.text)}:$CodeID";

        }else{
                  QrData =
            "g:${gradecryptPub(keycontroller.text)}:${gradecrypt(encryptedcontroller.text)}";

        }
      }
    } else {
      QrData =
          "p:${gradecryptPub(keycontroller.text)}:${gradecrypt(encryptedcontroller.text)}:${gradecrypt(rsa(reachedpointscontroler.text))}:${gradecrypt(rsa(maxpointscontroler.text))}";
    }
  }

  //a function for converting every given number to a base-16 number.
  String gradecrypt(plain) {
    return BigInt.parse(plain.toString()).toRadixString(16);
  }

  String gradecryptPub(plain) {
    final bytes = utf8.encode(plain);
    final base64Str = base64.encode(bytes);
    return base64Str;
  }

  //the heart of gradecrypt, the rsa encryption itself. you might check this paper by the IEEE https://ieeexplore.ieee.org/abstract/document/6021216
  String rsa(String grade) {
    var gradeDouble = double.parse(grade);
    var gradeInt = int.parse((gradeDouble * 100).round().toString());
    BigInt gradeBig = BigInt.parse(gradeInt.toString());
    BigInt eBig = e;
    BigInt nBig = n;
    BigInt encryptedBig = gradeBig.modPow(eBig, nBig);
    return encryptedBig.toString();
  }
  Widget CodeQR() => Column(
    children: [
      SelectableText(CodeID, textScaleFactor: codeIDscale),
      Qr_view()
    ],
  );
  Widget Qr_view() => QrImage(
        data: QrData,
        version: QrVersions.auto,
        size: QrSize,
        backgroundColor: Colors.white,
      );
//the dialog for getting the Document directory and save the qr there
  Future saveImage(Uint8List bytes) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final file = File("Code.jpg");
    file.writeAsBytes(bytes);
  }

  //the formula 6 - 5 (reachedpoints / maxpoints) is used to calculate the grade from points
  //if the reached points are bigger than the max points, it returns 1
  //if the reached points are smaller than 0 it returns 6
  String usePoints(String reachedpoints) {
    double CalculatedGrade = 6 -
        5 *
            (double.parse(reachedpoints) /
                (double.parse(maxpointscontroler.text)));
    CalculatedGrade = double.parse((CalculatedGrade).toStringAsFixed(2));
    if (double.parse(reachedpoints) > double.parse(maxpointscontroler.text)) {
      return "1.0";
    }
    if (double.parse(reachedpointscontroler.text) < 0) {
      return "6.0";
    }
    return CalculatedGrade.toString();
  }

  //when the CheckBox state changes, a few things happen (pretty self-explaining)
  void ModeChange(String mode) {
    if (mode == "normal") {
      DropdownDisabled = false;
      isChecked = false;
      GradeEnabled = true;
      PointsEnabled = false;
      AverageVisible = false;
      Average = [];
      maxpointscontroler.text = "";
      reachedpointscontroler.text = "";
      gradepointsmaxcontroller.text = "";
      gradepointsreachedcontroller.text = "";
    } else if (mode == "calc") {
      DropdownDisabled = true;
      isChecked = true;
      GradeEnabled = false;
      PointsEnabled = true;
      Average = [];
      maxpointscontroler.text = "";
      reachedpointscontroler.text = "";
      gradecontroler.text = "";
      gradepointsmaxcontroller.text = "";
      gradepointsreachedcontroller.text = "";
    }
  }

  //two empty functions.. i'm not gonna remove them. They may be useful in the future
  void Reset() {}
  void DropDownChanged() {}
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible:
          false, // user must tap button! //this aggressiv comment is not by me, but the guy I copied
      //this from is right. you can't close the Dialog without pressing the understood button.
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor:
              DarkOn == true ? Color.fromARGB(255, 48, 48, 48) : Colors.white,
          title: Text('Gespeichert',
              style: TextStyle(
                  color: DarkOn == true ? Colors.white : Colors.black)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Der QR Code als "Code.jpg" unter "Dokumente" gespeichert.',
                    style: TextStyle(
                        color: DarkOn == true ? Colors.white : Colors.black)),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Alles Klar!',
                  style: TextStyle(
                      color: DarkOn == true
                          ? Color.fromARGB(255, 100, 255, 218)
                          : Color.fromARGB(255, 30, 136, 229))),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //this one is quite interesting as well. i would recommend you checking flutters Documentation the the ListView.builder widget
  Future<void> _showEditDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor:
              DarkOn == true ? Color.fromARGB(255, 48, 48, 48) : Colors.white,
          title: Text(
            'Punkte',
            style:
                TextStyle(color: DarkOn == true ? Colors.white : Colors.black),
          ),
          content: Container(
            height: 280,
            width: 100,
            child: ListView.builder(
                reverse: true,
                itemCount: Average.length,
                itemBuilder: ((context, index) {
                  //I misspelled entry.
                  return ListEntery(
                    child: Average[index],
                    indexpos: index,
                  );
                })),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Alles Klar!',
                  style: TextStyle(
                      color: DarkOn == true
                          ? Color.fromARGB(255, 100, 255, 218)
                          : Color.fromARGB(255, 30, 136, 229))),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

String replaceCharAt(String oldString, int index, String newChar) {
  return oldString.substring(0, index) +
      newChar +
      oldString.substring(index + 1);
}
