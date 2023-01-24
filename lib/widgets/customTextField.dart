import 'package:flutter/material.dart';
import 'package:living_plant/config/config.dart';

class customTextField extends StatelessWidget {
  final TextEditingController? textEditingController;
  final Icon? icon;
  bool? isSecure = false;
  final TextInputType? textInputType;
  final Widget? widget;
  bool? enabledEdit = true;
  final String? hint;

  customTextField(
      {super.key,
      this.enabledEdit,
      this.icon,
      this.isSecure,
      this.textEditingController,
      this.textInputType,
      this.hint,
      this.widget});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: textEditingController,
        obscureText: isSecure!,
        cursorColor: LivingPlant.primaryColor,
        keyboardType: textInputType,
        decoration: InputDecoration(
          isCollapsed: false,
          isDense: true,
          enabled: enabledEdit!,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color: LivingPlant.primaryColor,
            ),
          ),
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
