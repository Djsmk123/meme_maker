import 'dart:io';

class AdHelper{
  static String get bannerAdUnitId{
    if(Platform.isAndroid)
      {
         return "ca-app-pub-2176311180103137/5865332202";
        //return const String.fromEnvironment("AndroidAddId");
      }
    else if(Platform.isIOS){
      return const String.fromEnvironment("iOSAddId");
    }
    else {
     throw UnsupportedError('UnSupported Platform');
    }
  }
  static String get intersitialAdsId{
    if(Platform.isAndroid)
    {
      return const String.fromEnvironment("AndroidAddId");
    }
    else if(Platform.isIOS){
      return const String.fromEnvironment("iOSAddId");
    }
    else {
      throw UnsupportedError('UnSupported Platform');
    }
  }

}