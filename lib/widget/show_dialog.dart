import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

showPopUpInfo({
  required bool success,
  String? title,
  String? description,
  String? labelButton,
  Function()? onPress,
}) {
  Get.dialog(
    Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 4),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12), color: Colors.white),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              success ? Icons.verified : Icons.error,
              size: 70.0,
            ),
            SizedBox(height: 3),
            Text(
              description ?? '',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(64.0),
                ),
              ),
              onPressed: onPress ?? Get.back,
              child: const Text("OK"),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    ),
    barrierDismissible: false,
  );
}

showToast({
  required String message,
  Color? color,
  Color? textColor,
  ToastGravity? gravity,
}) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: gravity ?? ToastGravity.BOTTOM,
    backgroundColor: color ?? Colors.red,
    textColor: textColor ?? Colors.white,
    fontSize: 14,
  );
}

showSnackBar({
  required String title,
  required String message,
  Color? color,
  Color? textColor,
  ToastGravity? gravity,
}) {
  Get.snackbar(
    title,
    message,
    colorText: textColor ?? Colors.white,
    backgroundColor: color ?? Colors.red,
    icon: const Icon(Icons.add_alert),
  );
}
