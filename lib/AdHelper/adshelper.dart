import 'dart:io';

class AdHelper {

  static String get  appOpenAd {
    if (Platform.isAndroid) {
      // return 'ca-app-pub-2180535035689124/4914893719';
      return 'ca-app-pub-3940256099942544/3419835294';
    }  else {
      throw UnsupportedError('Unsupported platform');
    }
  }


  static String get bannerAdUnitIdOfHomeScreen {
    if (Platform.isAndroid) {
      // return 'ca-app-pub-2180535035689124/9177388575';
      return 'ca-app-pub-3940256099942544/6300978111';
    }  else {
      throw UnsupportedError('Unsupported platform');
    }
  }

}