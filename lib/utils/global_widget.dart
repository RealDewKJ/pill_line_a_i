import 'package:flutter/material.dart';

class GlobalWidget {
  static Future<dynamic> showModalMethod(BuildContext context, Widget widget, [bool? tapExit]) {
    return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: tapExit ?? false,
      enableDrag: tapExit ?? false,
      context: context,
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: widget,
        );
      },
    );
  }
}
