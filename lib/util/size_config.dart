import 'package:flutter/cupertino.dart';

class SizeConfig {
  SizeConfig._();

  static double screenHeight=0;
  static double screenWidth=0;
  static double blockSizeHorizontal=0;
  static double blockSizeVertical=0;

  static void init(BoxConstraints constraints, Orientation orientation) {
    if (orientation == Orientation.portrait) {
      screenWidth = constraints.maxWidth;
      screenHeight = constraints.maxHeight;
      print("portrait height === > $screenHeight");
      print("portrait width === > $screenWidth");
    } else {
      screenHeight = constraints.maxWidth;
      screenWidth = constraints.maxHeight;
      print("landscape height === > $screenHeight");
      print("landscape width === > $screenWidth");
    }
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;

    print("block height === > $blockSizeVertical");
    print("block width === > $blockSizeHorizontal");
  }

  static double setSp(num size) => size * blockSizeVertical;
  static double setHeight(num size) => size * blockSizeVertical;
  static double setWidth(num size) => size * blockSizeHorizontal;
}

extension SizeExtensionInteger on num {
  num get t => SizeConfig.setSp(this);
  num get h => SizeConfig.setHeight(this);
  num get w => SizeConfig.setWidth(this);
}
