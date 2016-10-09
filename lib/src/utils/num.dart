part of ose_utils;

bool isNumeric(dynamic input) {
  return num.parse(input.toString(), (e) => null) != null;
}
