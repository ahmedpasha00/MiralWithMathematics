import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CousttomTextFormFiled extends StatefulWidget {
  final String hintText;
  final IconData icon;
  final Color themeColor;
  final TextEditingController? controller;
  final bool isPassword;
  final FocusNode? focusNode;
  final VoidCallback? onTap;
  final TextInputType? keyboardType;


  const CousttomTextFormFiled({
    super.key,
    required this.hintText,
    required this.icon,
    required this.themeColor,
    this.controller,
    this.isPassword = false, this.focusNode, this.onTap, this.keyboardType,
  });

  @override
  State<CousttomTextFormFiled> createState() => _CousttomTextFormFiledState();
}

class _CousttomTextFormFiledState extends State<CousttomTextFormFiled> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // جعل العرض مرن بناءً على التصميم
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        // استخدام .r للحواف عشان تحافظ على شكلها الدائري في كل الشاشات
        borderRadius: BorderRadius.circular(25.r),
        boxShadow: [
          BoxShadow(
            color: widget.themeColor.withOpacity(0.2),
            blurRadius: 15.r, // جعل التوهج ريسبونسف
            offset: Offset(0, 8.h), // إزاحة الظل للأسفل ريسبونسف
          ),
        ],
      ),
      child: TextFormField(
        controller: widget.controller,
        obscureText: _obscureText,
        focusNode:widget.focusNode,
        onTap: widget.onTap,
        keyboardType: widget.keyboardType,
        // استخدام .sp للخطوط عشان تكبر وتصغر مع إعدادات النظام والموبايل
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          hintText: widget.hintText,

          hintStyle: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 14.sp,
          ),
          // أيقونة البداية ريسبونسف بـ .sp
          prefixIcon: Icon(
            widget.icon,
            color: widget.themeColor,
            size: 22.sp,
          ),

          suffixIcon: widget.isPassword
              ? IconButton(
            // تصغير حجم أيقونة العين لتناسب الشاشات
            iconSize: 20.sp,
            icon: Icon(
              _obscureText ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          )
              : null,

          filled: true,
          fillColor: Colors.white,
          // تحديد الحشو الداخلي بشكل متناسب
          contentPadding: EdgeInsets.symmetric(
            horizontal: 15.w,
            vertical: 15.h,
          ),

          // الحواف (Borders) بسمك يتناسب مع حجم الشاشة
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.r),
            borderSide: BorderSide(
              color: widget.themeColor.withOpacity(0.4),
              width: 2.w, // سمك الخط ريسبونسف
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.r),
            borderSide: BorderSide(
              color: widget.themeColor,
              width: 2.5.w, // سمك الخط عند التركيز
            ),
          ),
          // إطار الخطأ لو حبيت تضيف Validator لاحقاً
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.r),
            borderSide: BorderSide(color: Colors.red, width: 1.w),
          ),
        ),
      ),
    );
  }
}