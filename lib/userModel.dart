import 'dart:collection';

import 'package:flutter/cupertino.dart';

class UserModel extends ChangeNotifier {
  /// Internal, private state of the cart.
  final Map<String, String?> _items = {'userId': null, 'name': null, 'email': null};

  /// An unmodifiable view of the items in the list.
  UnmodifiableMapView<String, String?> get items => UnmodifiableMapView(_items);

  /// Adds [item] to list. This and [removeAll] are the only ways to modify the
  /// list from the outside.
  void changeValue(String itemName, String? itemValue) {
    _items.update(itemName, (value) => value = itemValue);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }
}
