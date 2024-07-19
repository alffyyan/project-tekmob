import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

extension ContextUtil on BuildContext {
  void clearAndNavigate(String path) {
    while (canPop() == true) {
      pop();
    }
    pushReplacement(path);
  }
}