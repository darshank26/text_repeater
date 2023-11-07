import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:text_repeater/utils/constants.dart';


import 'AdHelper/adshelper.dart';
import 'homescreen/HomeScreen.dart';

//<a href="https://www.freepik.com/free-vector/whistle_3139469.htm#fromView=search&term=whistle&page=1&position=1&track=sph&regularType=vector">Image by rawpixel.com</a> on Freepik

AppOpenAd? openAd;

Future<void> loadAd() async {
  await AppOpenAd.load(adUnitId: AdHelper.bannerAdUnitIdOfHomeScreen, request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
          onAdLoaded: (ad){
            openAd = ad;
            openAd!.show();
          },
          onAdFailedToLoad: (error){
            print('open ad load failed $error');
          }),
      orientation: AppOpenAd.orientationPortrait);
}


// void showAd()
// {
//   if(openAd == null)
//   {
//     print('trying to show before loading');
//     loadAd();
//     return;
//   }
//   openAd!.fullScreenContentCallback = FullScreenContentCallback(
//       onAdShowedFullScreenContent: (ad) {
//         print('onAdShowedFullScreenContent');
//       },
//       onAdFailedToShowFullScreenContent: (ad,error)
//       {
//         ad.dispose();
//         print('failed to load $error');
//         openAd = null;
//         loadAd();
//       },
//       onAdDismissedFullScreenContent: (ad)
//       {
//         ad.dispose();
//         print('onAdWillDismissFullScreenContent');
//         openAd = null;
//         loadAd();
//       }
//   );
//   openAd!.show();
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(MyApp());

  MobileAds.instance.initialize();

  // showAd();

  // loadAd();
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _debugLabelString = "";

  late String _emailAddress;

  late String _externalUserId;

  bool _enableConsentButton = false;

  bool _requireConsent = true;


  @override
  void initState() {
    super.initState();
    initPlatformState();
    _handleConsent();
    // _handleSendNotification();
    // showAd();


  }

  Future<void> initPlatformState() async {
    if (!mounted) return;
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    OneSignal.shared.setRequiresUserPrivacyConsent(_requireConsent);
    var settings = {
      OSiOSSettings.autoPrompt: false,
      OSiOSSettings.promptBeforeOpeningPushUrl: true
    };

    // OneSignal.shared
    //     .setNotificationReceivedHandler((OSNotification notification) {
    //   this.setState(() {
    //     _debugLabelString =
    //     "Received notification: \n${notification.jsonRepresentation().replaceAll("\\n", "\n")}";
    //   });
    // });

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      this.setState(() {
        _debugLabelString =
        "Opened notification: \n${result.notification.jsonRepresentation().replaceAll("\\n", "\n")}";
      });
    });

    OneSignal.shared
        .setInAppMessageClickedHandler((OSInAppMessageAction action) {
      this.setState(() {
        _debugLabelString =
        "In App Message Clicked: \n${action.jsonRepresentation().replaceAll("\\n", "\n")}";
      });
    });

    OneSignal.shared
        .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
      // print("SUBSCRIPTION STATE CHANGED: ${changes.jsonRepresentation()}");
    });

    OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
      // print("PERMISSION STATE CHANGED: ${changes.jsonRepresentation()}");
    });

    OneSignal.shared.setEmailSubscriptionObserver(
            (OSEmailSubscriptionStateChanges changes) {
          // print("EMAIL SUBSCRIPTION STATE CHANGED ${changes.jsonRepresentation()}");
        });

    // NOTE: Replace with your own app ID from https://www.onesignal.com
    await OneSignal.shared
        .setAppId("850db707-ce52-4a96-9a5d-51e14d2681aa");

    // OneSignal.shared
    //     .setInFocusDisplayType(OSNotificationDisplayType.notification);
  }

  void _handleConsent() {
    print("Setting consent to true");
    OneSignal.shared.consentGranted(true);
  }

  // void _handleSendNotification() async {
  //   var status = await OneSignal.shared.getPermissionSubscriptionState();
  //   var playerId = status.subscriptionStatus.userId;
  // }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Text Repeater',
      home: IntroSplashScreen(),
    );
  }
}

class IntroSplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<IntroSplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds:5 ), ()=>
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen())));
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Text Repeater',
      home: Scaffold(
        backgroundColor:ksplashback,
        body: Container(
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/logo.png',
                      height: 280,
                      width: 280,
                      alignment: Alignment.center,),
                    SizedBox(height: 10,),
                    Text(
                        "Text Repeater",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.mochiyPopOne(textStyle: TextStyle(fontSize: 35,color: Colors.white,fontWeight: FontWeight.w400,letterSpacing: 0.5))

                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        "Designed & Developed By - Darshan Komu",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.mochiyPopOne(textStyle: TextStyle(fontSize: 12,color: Colors.white,fontWeight: FontWeight.w600,))

                    ),
                  ),
                ),
              ),

            ],
          ),
        ),

      ),

    );
  }

}
