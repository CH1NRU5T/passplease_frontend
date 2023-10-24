const String BASE_URL = 'https://jb657c4r-3000.inc1.devtunnels.ms';
// const String BASE_URL = 'https://passplease-backend.onrender.com';
String secretKeyToString(List<int> secretKey) {
  StringBuffer sb = StringBuffer();
  for (var element in secretKey) {
    var val = element.toRadixString(16);
    if (val.length == 1) {
      sb.write('0');
      sb.write(val);
    } else {
      sb.write(val);
    }
  }
  return sb.toString();
}
