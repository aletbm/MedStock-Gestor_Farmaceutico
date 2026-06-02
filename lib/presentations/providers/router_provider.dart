import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:medstock/presentations/providers/session_provider.dart';

class RouterNotifier extends ChangeNotifier{
  final Ref _ref;
  RouterNotifier(this._ref){
    _ref.listen(sessionProvider, (context, state) => notifyListeners());
  }
}

final routerNotifierProvider = ChangeNotifierProvider((ref) => RouterNotifier(ref));
