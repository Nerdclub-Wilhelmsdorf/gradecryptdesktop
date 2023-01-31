import 'dart:ffi';
import 'dart:io';
import 'package:alert_dialog/alert_dialog.dart';
import 'package:gradecryptdesktop/csvdropdowns.dart';
import 'package:gradecryptdesktop/gccsv.dart';
import 'package:kt_dart/kt.dart';
import 'package:path/path.dart' as p;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gradecryptdesktop/main.dart';
import 'package:fast_csv/fast_csv_ex.dart' as fast_csv;

class CSVGUI extends StatefulWidget {
  const CSVGUI({super.key});

  @override
  State<CSVGUI> createState() => _CSVGUIState();
}

var usePoints = false;
var ColumnsImported = 0;
var CodeIDenabled = true;
var filepath;

pickSaveFile() async {
  String? outputFile = await FilePicker.platform.saveFile(
    dialogTitle: 'Tabelle speichern:',
    fileName: 'tabelle.csv',
  );
  print(outputFile);
  if (outputFile == null) {
    return false;
  } else {
    return outputFile;
  }
}

class _CSVGUIState extends State<CSVGUI> {
  var csvPath;
  var fileImportSucess = false;

  readFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      var extension = p.extension(file.toString());
      extension = extension.substring(0, extension.length - 1);
      if (extension.toString() == ".csv") {
        parse(readFileSync(file.toString()));
        filepath = file.toString();
      } else {
        showError("Fehler: Datei muss CSV sein.");
      }
    } else {}
  }

  showError(message) async {
    return alert(context, title: Text(message));
  }

  parse(input) {
    var csv_parsed = fast_csv.parse(input, separator: ',');
    print("$csv_parsed + till here");
    for (final row in csv_parsed) {
      if (csv_parsed.length <= 1) {
        showError(
            "Ihre Datei verfügt nur über eine Zeile. Sollte dies gewollt sein, ignorieren sie diese Nachricht, anderfalls achten sie darauf, dass Elemente mit `,` getrennt sein müssen.");
        fileImportSucess = true;
      } else {
        fileImportSucess = true;
      }
      if (row.length < 3) {
        showError(
            "Ihre Datei verfügt nicht über die Mindestzahl von 3 Spalten, sollte sich diese Nachricht mit ihrem Tabellenkalkulationsprgramm wieder sprechen, überprüfen sie die Konventionen für CSV auf unserer Website");
        fileImportSucess = false;
        break;
      }
      print(row.length);

      ColumnsImported = row.length;

      break;
    }
    setState(() {});
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
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: accentColor,
            title: Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back),
                    color: DarkOn == true ? Colors.black : Colors.white),
                Spacer(),
                Text(
                  "Tabelle einlesen",
                  textScaleFactor: 1.5,
                  style: TextStyle(
                      color: DarkOn == true ? Colors.black : Colors.white),
                ),
              ],
            ),
          ),
          body: Center(
            child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Spacer(),
                        TextButton(
                          onPressed: fileImportSucess == true
                              ? null
                              : () {
                                  readFile();
                                },
                          child: Text("Datei auswählen.."),
                        ),
                        IconButton(
                          onPressed: (() {
                            fileImportSucess = false;
                            usePoints = false;
                            CodeIDenabled = true;
                            setState(() {});
                          }),
                          icon: Icon(Icons.highlight_remove_outlined),
                          color: Colors.red,
                        ),
                        Spacer(),
                      ],
                    )),
                Spacer(),
                Visibility(
                  visible: fileImportSucess,
                  child: SizedBox(
                    height: 400,
                    width: 400,
                    child: Column(
                      children: [
                        Spacer(),
                        Row(
                          children: [
                            Spacer(),
                            Text("CodeID verwenden:"),
                            Checkbox(
                                value: CodeIDenabled,
                                onChanged: ((value) {
                                  CodeIDenabled = !CodeIDenabled;
                                  setState(() {});
                                })),
                            Spacer()
                          ],
                        ),
                        Row(
                          children: [
                            Spacer(),
                            Text("Name"),
                            Text("   "),
                            Container(
                              child: const DropDownButtonName(),
                            ),
                            Spacer()
                          ],
                        ),
                        Row(
                          children: [
                            Spacer(),
                            Text("Note"),
                            Text("   "),
                            Container(
                              child: const DropDownButtonGrade(),
                            ),
                            Spacer()
                          ],
                        ),
                        Row(
                          children: [
                            Spacer(),
                            Text("Schlüssel"),
                            Text("   "),
                            Container(
                              child: const DropDownButtonKey(),
                            ),
                            Spacer()
                          ],
                        ),
                        Visibility(
                          visible: !(ColumnsImported < 5),
                          child: Row(
                            children: [
                              Spacer(),
                              Text("Punkte verwenden:"),
                              Checkbox(
                                  value: usePoints,
                                  onChanged: ((value) {
                                    usePoints = !usePoints;

                                    setState(() {});
                                  })),
                              Spacer()
                            ],
                          ),
                        ),
                        Visibility(
                          visible: usePoints,
                          child: Row(
                            children: [
                              Spacer(),
                              Text("Erreichte Punkte"),
                              Text("   "),
                              Container(
                                child: const DropDownButtonRP(),
                              ),
                              Spacer()
                            ],
                          ),
                        ),
                        Visibility(
                          visible: usePoints,
                          child: Row(
                            children: [
                              Spacer(),
                              Text("Maximalpunktzahl"),
                              Text("   "),
                              Container(
                                child: const DropDownButtonMP(),
                              ),
                              Spacer()
                            ],
                          ),
                        ),
                        Spacer(),
                        TextButton(
                          onPressed: (() async {
                            if (!validateCSVconfig()) {
                              showError(
                                  "Fehler: Jede Spalte darf nur mit einem Wert belegt werden.");
                            } else {
                              try {
                                var pathSave = await pickSaveFile();
                                if (pathSave != false) {
                                  WriteToFile(exportCSV(), pathSave);
                                }
                              } catch (e) {
                                print(e);
                                showError(
                                    "Etwas ist schief gelaufen. Bitte überprüfen sie die CSV konventionen auf unserer Website");
                              }
                            }
                          }),
                          child: Text("Exportieren"),
                        )
                      ],
                    ),
                  ),
                ),
                Spacer()
              ],
            ),
          ),
        ));
  }

  bool validateCSVconfig() {
    if (usePoints) {
      final dropdowns = [
        dropdownValueGrade,
        dropdownValueKey,
        dropdownValueMP,
        dropdownValueRP,
        dropdownValueName
      ].toImmutableList();
      final duplicates = dropdowns.duplicates;
      if (duplicates != [].toImmutableList()) {
        return false;
      } else {
        return true;
      }
    } else {
      final dropdowns = [
        dropdownValueGrade,
        dropdownValueKey,
        dropdownValueName
      ].toImmutableList();
      final duplicates = dropdowns.duplicates;
      if (duplicates != [].toImmutableList()) {
        return false;
      } else {
        return true;
      }
    }
  }

  exportCSV() {
    if (usePoints) {
      return useCSV(
          filepath.substring(7, filepath.length - 1),
          int.parse(dropdownValueKey),
          int.parse(dropdownValueGrade),
          int.parse(dropdownValueName),
          CodeIDenabled,
          int.parse(dropdownValueRP),
          int.parse(dropdownValueMP));
    } else {
      return useCSV(
          filepath.substring(7, filepath.length - 1),
          int.parse(dropdownValueKey),
          int.parse(dropdownValueGrade),
          int.parse(dropdownValueName),
          CodeIDenabled,
          0,
          0);
    }
  }
}

extension KtListExtensions<T> on KtList<T> {
  KtList<T> get duplicates => toMutableList()..removeAll(toSet().toList());
}

readFileSync(path) {
  String contents =
      new File(path.substring(7, path.length - 1)).readAsStringSync();
  return contents;
}

Future<File> WriteToFile(String grades, path) async {
  final file = await File(path);
  // Write the file
  return file.writeAsString(grades);
}

List<String> CountArray(number) {
  List<String> Count = [];
  for (int i = 0; i < number; i++) {
    Count.add((i + 1).toString());
  }
  return Count;
}
