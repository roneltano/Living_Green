import 'package:flutter/material.dart';
import 'package:living_plant/config/config.dart';

class customTextFieldRegsiterPage extends StatelessWidget {
  final TextEditingController? textEditingController;
  final Icon? icon;
  bool? isSecure = false;
  final TextInputType? textInputType;
  final Widget? widget;
  bool? enabledEdit = true;
  final String? hint;

  customTextFieldRegsiterPage({
    super.key,
    this.enabledEdit,
    this.icon,
    this.isSecure,
    this.textEditingController,
    this.textInputType,
    this.hint,
    this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6), color: Colors.white),
      child: TextField(
        controller: textEditingController,
        obscureText: isSecure!,
        cursorColor: LivingPlant.primaryColor,
        keyboardType: textInputType,
        enabled: enabledEdit,
        decoration: InputDecoration(
          filled: true,
          isCollapsed: false,
          isDense: true,
          suffixIcon: widget,
          suffixIconColor: LivingPlant.primaryColor,
          suffixStyle: const TextStyle(color: LivingPlant.primaryColor),
          border: InputBorder.none,
          hintText: hint,
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color: LivingPlant.primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
