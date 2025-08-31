
import 'package:flutter/cupertino.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'validators.g.dart';

@riverpod
class PassShow extends _$PassShow {
  @override
  bool build({required int id}) {
    return true;
  }
  void toggle (){
    state = !state;
  }
}

@riverpod
class validateMode extends _$validateMode {
  @override
  AutovalidateMode build({required int id}) {
    return AutovalidateMode.disabled;
  }

  void change(){
    state = AutovalidateMode.onUserInteraction;
  }
}
