import 'dart:math';

dynamic cantor(x, y) {
  var mm = (x + y) * (x + y + 1) / 2 + y;
  return mm;
}

// inverse of cantor
dynamic inv_cantor1(z) {
  var t = ((sqrt(8 * z + 1) - 1) / 2).floor();
  var x = t * (t + 3) / 2 - z;
  var y = z - t * (t + 1) / 2;
  
  return x;
}
dynamic inv_cantor2(z) {
  var t = ((sqrt(8 * z + 1) - 1) / 2).floor();
  var x = t * (t + 3) / 2 - z;
  var y = z - t * (t + 1) / 2;
  //convert y to int

  return y;
}
