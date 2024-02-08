import 'package:flutter/material.dart';
import 'package:tulip_app/constant/constant.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{
  final String title;
  final VoidCallback? backButtonCallback;
  final bool showBackButton;
  final List<Widget>? actions;
  final Widget? leading;
  final bool implyStatus;
  const CustomAppBar({Key? key, required this.title,this.showBackButton= true, this.backButtonCallback, this.actions, this.leading, this.implyStatus=false}) : super(key: key);
  @override
  Size get preferredSize => const Size.fromHeight(56.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Constants.primaryColor,
      elevation: 3,
      leadingWidth: showBackButton ? null : 0,
      titleSpacing: 0,
      centerTitle: true,
      automaticallyImplyLeading: implyStatus,
      // leading: leading ?? Visibility(
      //   maintainSemantics: false,
      //   maintainSize: false,
      //   visible: showBackButton,
      //   child: GestureDetector(
      //       onTap: backButtonCallback ?? ()=> Navigator.pop(context),
      //       child: Padding(
      //         padding: const EdgeInsets.all(5.0),
      //         child: Container(
      //           alignment: Alignment.center,
      //             padding: const EdgeInsets.only(left: 7),
      //             child: Icon(Icons.arrow_back_ios,size: 19,color: Constants.white)),
      //       )
      //   ),
      // ),
      // automaticallyImplyLeading: showBackButton,
      title: Text(title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Constants.white
      ),
      ),
      actions: actions,
    );
  }

}
