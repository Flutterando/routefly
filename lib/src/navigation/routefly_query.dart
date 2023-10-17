/// Route Parameters
class RouteflyQuery {
  final Map<String, dynamic> _data;
  final Map<String, String> params;
  final dynamic arguments;

  RouteflyQuery(this.params, this._data, this.arguments);

  dynamic operator [](String key) {
    return _data[key];
  }
}
