import 'dart:convert';
import 'dart:io';
import "CodeID.dart";
import 'package:fast_csv/fast_csv_ex.dart' as fast_csv;

useCSV(path, key_row, grade_row, name_row, usecodeid, reachedp_row, maxp_row) {
  List<String> grades = [];
  var csv_file = readFileSync(path);
  var csv_parsed = fast_csv.parse(csv_file, separator: ',');
  for (final row in csv_parsed) {
    final key = row[key_row - 1];
    final grade = row[grade_row - 1];
    final name = row[name_row - 1];
    if (reachedp_row == 0 || maxp_row == 0) {
      if (usecodeid) {
        grades.add("$name,$key,$grade,${csvReturnEncrypted(grade, key, true)}");
      } else {
        grades
            .add("$name,$key,$grade,${csvReturnEncrypted(grade, key, false)}");
      }
    } else {
      final reached = row[reachedp_row-1];
      print(reached);
      final max = row[maxp_row-1];
      print("$maxp_row, $reachedp_row");
      print("$reached,$max");
      if (usecodeid) {
        grades.add(
            "$name,$key,$grade,$reached,$max,${csvReturnEncryptedPoints(grade,reached, max, key, true)}");
      } else {
        grades.add(
            "$name,$key,$grade,$reached,$max,${csvReturnEncryptedPoints(grade,reached, max, key, false)}");
      }
    }
  }
  return (grades.join("\n"));
}

csvReturnEncrypted(String grade, String key, bool codeID) {
  if (grade.contains(",")) {
    grade = replaceCharAt(grade, grade.indexOf(","), ".");
  }
  var nV =
      BigInt.parse(key.substring(key.indexOf("'") + 1, key.length), radix: 36);
  var eV = BigInt.parse(key.substring(0, key.indexOf("'")), radix: 36);
  var encryptedRaw = csvRsa(grade, nV, eV);
  return csvFormat(encryptedRaw, key, codeID);
}

csvReturnEncryptedPoints(
    String grade, String reached, String max, String key, bool codeID) {
  if (grade.contains(",")) {
    grade = replaceCharAt(grade, grade.indexOf(","), ".");
  }
  print(key);
  var nV =
      BigInt.parse(key.substring(key.indexOf("'") + 1, key.length), radix: 36);
      print(nV);
  var eV = BigInt.parse(key.substring(0, key.indexOf("'")), radix: 36);
  print(eV);
  var encryptedRaw = csvRsa(grade, nV, eV);
  var reachedRaw = csvRsa(reached, nV, eV);
  var maxRaw = csvRsa(max, nV, eV);
    print(maxRaw);
    print(reachedRaw);
  return csvFormatPoints(encryptedRaw, key, reachedRaw, maxRaw, codeID);
}

String csvRsa(String grade, nI, eI) {
  var gradeDouble = double.parse(grade);
  var gradeInt = int.parse((gradeDouble * 100).round().toString());
  BigInt gradeBig = BigInt.parse(gradeInt.toString());
  BigInt eBig = eI;
  BigInt nBig = nI;
  BigInt encryptedBig = gradeBig.modPow(eBig, nBig);
  return encryptedBig.toString();
}

csvFormatPoints(encrypted, publicKey, reachedp, maxp, usecodeid) {
  var encData;
  if (!usecodeid) {
    encData =
        "p:${gradecryptPub(publicKey)}:${gradecrypt(encrypted)}:${gradecrypt(reachedp)}:${gradecrypt(maxp)}";
  } else {
    encData =
        "r:${gradecryptPub(publicKey)}:${gradecrypt(encrypted)}:${gradecrypt(reachedp)}:${gradecrypt(maxp)}:${GetCodeID()}";
  }

  Codec<String, String> stringToBase64 = utf8.fuse(base64);
  var encrypted64 = stringToBase64.encode(encData);
  return encrypted64;
}

csvFormat(encrypted, publicKey, usecodeid) {
  var encData;
  if (usecodeid) {
    encData =
        "i:${gradecryptPub(publicKey)}:${gradecrypt(encrypted)}:${GetCodeID()}";
  } else {
    encData = "g:${gradecryptPub(publicKey)}:${gradecrypt(encrypted)}";
  }

  Codec<String, String> stringToBase64 = utf8.fuse(base64);
  var encrypted64 = stringToBase64.encode(encData);
  return encrypted64;
}

String gradecrypt(plain) {
  return BigInt.parse(plain.toString()).toRadixString(16);
}

String gradecryptPub(plain) {
  final bytes = utf8.encode(plain);
  final base64Str = base64.encode(bytes);
  return base64Str;
}

String replaceCharAt(String oldString, int index, String newChar) {
  return oldString.substring(0, index) +
      newChar +
      oldString.substring(index + 1);
}

readFileSync(path) {
  String contents = new File(path).readAsStringSync();
  return contents;
}

Future<File> WriteToFile(String grades, path) async {
  final file = await File(path);

  // Write the file
  return file.writeAsString(grades);
}
