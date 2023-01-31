import 'package:flutter/material.dart';

import 'csvgui.dart';

String dropdownValueGrade = CountArray(ColumnsImported).first;
String dropdownValueName = CountArray(ColumnsImported).first;
String dropdownValueKey = CountArray(ColumnsImported).first;
String dropdownValueRP = CountArray(ColumnsImported).first;
String dropdownValueMP = CountArray(ColumnsImported).first;

class DropDownButtonGrade extends StatefulWidget {
  const DropDownButtonGrade({super.key});

  @override
  State<DropDownButtonGrade> createState() => _DropDownButtonGradeState();
}

class _DropDownButtonGradeState extends State<DropDownButtonGrade> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValueGrade,
      elevation: 16,
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValueGrade = value!;
        });
      },
      items: CountArray(ColumnsImported)
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

class DropDownButtonKey extends StatefulWidget {
  const DropDownButtonKey({super.key});

  @override
  State<DropDownButtonKey> createState() => _DropDownButtonKeyState();
}

class _DropDownButtonKeyState extends State<DropDownButtonKey> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValueKey,
      elevation: 16,
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValueKey = value!;
        });
      },
      items: CountArray(ColumnsImported)
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

class DropDownButtonName extends StatefulWidget {
  const DropDownButtonName({super.key});

  @override
  State<DropDownButtonName> createState() => _DropDownButtonNameState();
}

class _DropDownButtonNameState extends State<DropDownButtonName> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValueName,
      elevation: 16,
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValueName = value!;
        });
      },
      items: CountArray(ColumnsImported)
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

class DropDownButtonMP extends StatefulWidget {
  const DropDownButtonMP({super.key});

  @override
  State<DropDownButtonMP> createState() => _DropDownButtonMPState();
}

class _DropDownButtonMPState extends State<DropDownButtonMP> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValueMP,
      elevation: 16,
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValueMP = value!;
        });
      },
      items: CountArray(ColumnsImported)
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

class DropDownButtonRP extends StatefulWidget {
  const DropDownButtonRP({super.key});

  @override
  State<DropDownButtonRP> createState() => _DropDownButtonRPState();
}

class _DropDownButtonRPState extends State<DropDownButtonRP> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValueRP,
      elevation: 16,
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValueRP = value!;
        });
      },
      items: CountArray(ColumnsImported)
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
