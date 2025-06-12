// import 'package:flutter/material.dart';
// import 'package:get/get.dart' as GetPackage;

// // ErrorDialogManager class to handle multiple errors
// class ErrorDialogManager {
//   static final ErrorDialogManager _instance = ErrorDialogManager._internal();
//   factory ErrorDialogManager() => _instance;
//   ErrorDialogManager._internal();

//   final List<String> _errorQueue = [];
//   bool _isDialogVisible = false;

//   void addError(String error) {
//     _errorQueue.add(error);
//     _showErrorDialogIfNeeded();
//   }

//   Future<void> _showErrorDialogIfNeeded() async {
//     if (_isDialogVisible || _errorQueue.isEmpty) return;

//     _isDialogVisible = true;
//     try {
//       await showDialog(
//         context: GetPackage.Get.overlayContext!,
//         barrierDismissible: false,
//         builder: (BuildContext context) {
//           return Theme(
//             data: ThemeData(useMaterial3: true),
//             child: AlertDialog(
//               title: Row(
//                 children: [
//                   const Icon(Icons.error_outline, color: Colors.red),
//                   const SizedBox(width: 8),
//                   const Text("Errors Occurred", style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500)),
//                 ],
//               ),
//               content: SizedBox(
//                 width: double.maxFinite,
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Flexible(
//                       child: ListView.builder(
//                         shrinkWrap: true,
//                         itemCount: _errorQueue.length,
//                         itemBuilder: (context, index) {
//                           return Card(
//                             child: ListTile(
//                               leading: Text("${index + 1}.", style: const TextStyle(fontWeight: FontWeight.bold)),
//                               title: Text(_errorQueue[index], style: const TextStyle(fontSize: 14)),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               actions: <Widget>[
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     ElevatedButton.icon(
//                       style: ElevatedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                       ),
//                       icon: const Icon(Icons.refresh),
//                       label: const Text("Retry All"),
//                       onPressed: () {
//                         _clearErrorsAndClose(context);
//                         // Implement your retry logic here
//                       },
//                     ),
//                     ElevatedButton.icon(
//                       style: ElevatedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                       ),
//                       icon: const Icon(Icons.close),
//                       label: const Text("Close All"),
//                       onPressed: () => _clearErrorsAndClose(context),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           );
//         },
//       );
//     } finally {
//       _isDialogVisible = false;
//     }
//   }

//   void _clearErrorsAndClose(BuildContext context) {
//     _errorQueue.clear();
//     Navigator.of(context).pop();
//   }
// }
