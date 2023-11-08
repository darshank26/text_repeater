import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:share/share.dart';

import '../AdHelper/adshelper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  TextEditingController textEditingController = TextEditingController();
  TextEditingController countEditingController = TextEditingController();
  var output;


  Future<void>? _launched;

  late BannerAd _bannerAd;

  bool _isBannerAdReady = false;

  bool _isChecked = true;
  String _currText = '';

  var checkRepeater = 2;


  var RepeaterLogics = [
    RepeaterLogic(false, "Repeat Text with Space"),
    RepeaterLogic(true, "Repeat Text with new Line"),
    RepeaterLogic(false, "Repeat Text with Vertical space")
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(textEditingController.text.toString().isEmpty)
    {
      textEditingController.text = "I Love You ❤️ 🥰\n";
      countEditingController.text = 100.toString();
      output = textEditingController.text.toString()*(countEditingController.text !='' ? int.parse(countEditingController.text) : 0);

    }
    else
    {
      output = textEditingController.text.toString()*(countEditingController.text !='' ? int.parse(countEditingController.text) : 0);
    }

    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitIdOfHomeScreen,
      request: AdRequest(),
      size: AdSize.largeBanner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );
    _bannerAd.load();
  }


  @override
  void didChangeDependencies() {
    // final EstateSearch estate =
    //     ModalRoute.of(context)!.settings.arguments as EstateSearch;
    //
    // RepeaterLogics = estate.rooms!;

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
    _bannerAd.dispose();
  }

  @override
  Widget build(BuildContext context) {


    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        title:  Text(
            "Text Repeater",
            textAlign: TextAlign.center,
            style: GoogleFonts.mochiyPopOne(textStyle: TextStyle(fontSize: 24,color: Colors.white,fontWeight: FontWeight.w400,letterSpacing: 0.6))

        ),
        actions: [
          GestureDetector(
            onTap: () {
              refreshData();
            },
            child: Padding(padding: EdgeInsets.all(10.0),
                child: Icon(Icons.refresh,size: 30,color: Colors.white,)
    ),
          ),


        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top:30,left: 20,right:20),
              child: TextField(
                controller: textEditingController,
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(35.0),
                    ),
                    borderSide: BorderSide(
                        color: Colors.blueAccent, width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(35.0),
                    ),
                    borderSide: BorderSide(
                        color: Colors.blueAccent, width: 1.0),
                  ),
                  labelText: 'Type your text here',
                  hintText: 'Type your text here',
                  labelStyle: TextStyle(color: Colors.black54,fontWeight: FontWeight.w600,fontSize: 18,

                  ),
                  hintStyle: TextStyle(color: Colors.black12),

                ),
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.only(left:20.0),
              child: Text(
                  "How Many time you want to Repeat text ? ",
                  style: GoogleFonts.mochiyPopOne(textStyle: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.w400,))
              ),
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left:24.0),
                  child: SizedBox(
                    width: 120.0,
                    child: Expanded(
                      child: TextField(
                        keyboardType: TextInputType. number,
                        controller: countEditingController,
                        inputFormatters: <TextInputFormatter>[
                          // for below version 2 use this
                          FilteringTextInputFormatter.allow(RegExp(r'[1-9]')),
                          FilteringTextInputFormatter.digitsOnly

                        ],                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(35.0),
                            ),
                            borderSide: BorderSide(
                                color: Colors.blueAccent, width: 1.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(35.0),
                            ),
                            borderSide: BorderSide(
                                color: Colors.blueAccent, width: 1.0),
                          ),
                          labelText: 'Count',
                          hintText: 'Count',
                          labelStyle: TextStyle(color: Colors.black54,fontWeight: FontWeight.w600,fontSize: 18),
                          hintStyle: TextStyle(color: Colors.black12),

                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 15,),

                Expanded(
                  child: ElevatedButton(
                    onPressed: () async{
                      setState(() {

                        if(checkRepeater == 1)
                        {
                          output = (textEditingController.text.toString() + ' ')*(countEditingController.text !='' ? int.parse(countEditingController.text) : 0);

                        }
                        else if ( checkRepeater == 2 )
                        {
                          output = (textEditingController.text.toString() + '\n')*(countEditingController.text !='' ? int.parse(countEditingController.text) : 0);

                        }
                        else if (checkRepeater == 3)
                          {
                            output = (textEditingController.text.toString() + '\n\n')*(countEditingController.text !='' ? int.parse(countEditingController.text) : 0);

                          }

                      });
                    },
                    child: Text('Repeat text',
    style: GoogleFonts.mochiyPopOne(textStyle: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.w400,letterSpacing: 0.6))
                      ),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.blueAccent,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        textStyle: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600)),
                  ),
                ),
                SizedBox(width: 15,),

              ],

            ),
            SizedBox(height: 20,),
            if(_isBannerAdReady) ...[
              Container(
                width: _bannerAd.size.width.toDouble(),
                height: _bannerAd.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd),
              ),
            ],

            SizedBox(height: 20,),

            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left:24.0,right: 24.0, bottom: 10),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text('Final Repeated Text',
                            style: GoogleFonts.mochiyPopOne(textStyle: TextStyle(fontSize: 12,color: Colors.black87,fontWeight: FontWeight.w100,letterSpacing: 0.6))
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right:24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              final snackBar = SnackBar(content: Text("Text Copied successfully",
                              style: GoogleFonts.mochiyPopOne(textStyle: TextStyle(fontSize: 12,color: Colors.white,fontWeight: FontWeight.w100,letterSpacing: 1))),backgroundColor: Colors.blueAccent,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              copyData();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.copy_sharp,size: 25,color: Colors.grey.shade400,),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              shareData();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.share,size: 25,color: Colors.grey.shade400,),
                            ),
                          )

                        ],
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.only(left:24.0,right: 24.0,bottom: 20),
                  child: Container(
                    height: 350,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        border: Border.all(
                          color: Colors.grey.shade200,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RawScrollbar(
                        thumbColor: Colors.blueAccent.shade100,
                        radius: Radius.circular(20),
                        thickness: 7,
                        child: SingleChildScrollView(
                          child: Text(output.toString(),
                              style: GoogleFonts.mochiyPopOne(textStyle: TextStyle(fontSize: 15,color: Colors.black87,fontWeight: FontWeight.w100,letterSpacing: 0.6))
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )

          ],
        ),
      ),



      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: ()  async{
          setState(()  {

            showModalBottomSheet(
                context: context,
                builder: (BuildContext bc){
                  return StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        child:
                       return Container(
                          height: 200.0,
                          child: Column(
                            children: [
                              for (var item in RepeaterLogics)
                                CheckboxListTile(
                                  activeColor: Colors.blueAccent,
                                  title: Text('${item.name}',
                                      style: GoogleFonts.mochiyPopOne(textStyle: TextStyle(fontSize: 14,color: Colors.black87,fontWeight: FontWeight.w100,letterSpacing: 0.6))
                                  ),
                                  value: item.isSelected,
                                  onChanged: (value) {
                                    setState(() {
                                      item.isSelected = value!;


                                      if(item.name == "Repeat Text with Space")
                                        {
                                          checkRepeater = 1;
                                        }
                                      else if (item.name == "Repeat Text with new Line")
                                        {
                                          checkRepeater = 2;

                                        }
                                      else if (item.name == "Repeat Text with Vertical space")
                                      {
                                        checkRepeater = 3;

                                      }
                                       print(checkRepeater);
                                    });
                                  },
                                ),
                            ],
                          ),
                        );
                      }
                  );
                }
            );
          });

              },
        child: new Icon(Icons.settings,color: Colors.white,),
      ),

    );
  }




  void copyData() {
     Clipboard.setData(ClipboardData(text: output));
  }

  void shareData() {
    Share.share(output);
  }

  void refreshData() {
    setState(() {
      if(textEditingController.text.toString().isNotEmpty)
      {
        textEditingController.text = "I Love You ❤️ 🥰\n";
        countEditingController.text = 100.toString();
        output = textEditingController.text.toString()*(countEditingController.text !='' ? int.parse(countEditingController.text) : 0);
      }
      else
      {
        output = textEditingController.text.toString()*(countEditingController.text !='' ? int.parse(countEditingController.text) : 0);
      }

    });


  }




}

class RepeaterLogic {
  bool isSelected;
  String name;

  RepeaterLogic(this.isSelected, this.name);
}
