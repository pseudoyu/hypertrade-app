import 'dart:convert';

List<dynamic> parseStringToList(String input) {
  // 移除首尾的方括号
  String trimmed = input.substring(1, input.length - 1);

  // 替换单引号为双引号，以便使用JSON解码
  trimmed = trimmed.replaceAll("'", "\"");

  // 使用JSON解码来分割字符串
  List<dynamic> list = json.decode('[$trimmed]');

  // 返回解析后的列表
  return list;
}

List<Map<String, dynamic>> parseStringToDictList(String input) {
  if (input.contains("No items found.")) {
    return [];
  }
  // 移除首尾的方括号
  String trimmed = input.substring(1, input.length - 1);

  // 替换单引号为双引号，以便使用JSON解码
  trimmed = trimmed.replaceAll("'", "\"");

  // 使用JSON解码来解析为字典列表
  List<Map<String, dynamic>> dictList =
      List<Map<String, dynamic>>.from(json.decode('[$trimmed]'));

  // 返回解析后的字典列表
  return dictList;
}

// void main() {
//   String input = "['26 % Life sciences & healthcare', '17 % Business services', '15 % Consumer products and services']";
//   List<String> parsedList = parseStringToList(input);
//   print(parsedList);
// }