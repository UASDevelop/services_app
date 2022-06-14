

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:services_app/data/repository/user_repo.dart';
import 'package:services_app/pages/home/home_controller.dart';
import 'package:get/get.dart';
import 'package:services_app/utils/my_colors.dart';
import 'package:services_app/utils/my_routes.dart';
import 'package:services_app/utils/strings.dart';
import 'package:services_app/utils/utils.dart';
import 'package:services_app/widgets/cirlce_image.dart';
import 'package:services_app/widgets/mark/terms_dialog.dart';
import 'package:services_app/widgets/my_btn.dart';
import 'package:services_app/widgets/my_text.dart';
import 'package:services_app/widgets/text_btn.dart';


class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  HomeController controller = Get.put(HomeController(
    userRepo: UserRepo(),
  ));
  late BuildContext context;
 BannerAd? myBanner;
@override
  void initState() {
  // TODO: implement initState
  super.initState();
  myBanner = BannerAd(
    adUnitId: 'ca-app-pub-3940256099942544/6300978111',
    size: AdSize.banner,
    request: AdRequest(),
    listener: BannerAdListener(),
  );
  myBanner!.load();
  _createInterstitialAd();
}

  static final AdRequest request = AdRequest(
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );
  int maxFailedLoadAttempts = 3;
  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;

  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: Platform.isAndroid
            ? 'ca-app-pub-3940256099942544/1033173712'
            : 'ca-app-pub-3940256099942544/4411468910',
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
              _createInterstitialAd();
            }
          },
        ));
  }

  void _showInterstitialAd() {
    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }
  @override
  Widget build(BuildContext context) {
    this.context = context;
    return SafeArea(
      child: Scaffold(

        backgroundColor: MyColors.lightGrey,
        body: buildBody(),
      ),
    );
  }

  // build body contents
  Widget buildBody() {
    return Column(

      children: [

        // header & main center contents
        Expanded(
          child: Stack(
            children: [
              buildHeader(),
              buildMainContents(),
            ],
          ),
        ),
        // build Footer (Share app button)
        buildFooter(),
      ],
    );
  }

  // build header
  Widget buildHeader() {
    return Container(
      width: double.infinity,
      height: (Get.height / 2.0),
      padding: const EdgeInsets.only(top: 40),
      decoration: BoxDecoration(
        color: MyColors.primaryColor,
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: MyText(
              text: Strings.appName

              ,
              size: 24,
              color: MyColors.white,
              fontFamilty: "Roboto",
              fontWeight: FontWeight.w700,
            ),
          ),

          Container(
            margin: EdgeInsets.only(top: 3),
              height: 50,
              child: Center(child: AdWidget(ad: myBanner!,))),
        ],
      ),
    );
  }

  // build main contents
  Widget buildMainContents() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 100, left: 20, right: 20),
        child: Card(
          elevation: 5,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            child: Obx(
              () => Column(
                mainAxisSize: MainAxisSize.min,
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // header (image, name and tic)
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                        child: Row(
                          children: [
                            // user image
                            CircleImage(
                              imageUrl: controller.user.value != null?
                              controller.user.value!.image : null,
                              size: 50,
                              onClick: () {
                                // on profile
                                onProfile();
                              },
                            ),
                            const SizedBox(width: 10,),
                            // user name
                            MyText(
                              text: controller.user.value != null
                                  && controller.user.value!.name != null?
                              controller.user.value!.name! : "",
                              fontFamilty: "Roboto",
                              color: MyColors.black,
                              fontWeight: FontWeight.w500,
                              size: 16,
                            ),
                            const Spacer(),
                            Image.asset(
                              "assets/images/Icon.png",
                              width: 60,
                              height: 70,
                            ),
                          ],
                        ),
                      ),
                      // horizontal line
                      Container(
                        width: double.infinity,
                        height: 2,
                        color: Colors.grey[300],
                      ),
                    ],
                  ),
                  const SizedBox(height: 50,),
                  // percentage circle
                  CircularPercentIndicator(
                    radius: 100.0,
                    lineWidth: 10.0,
                    percent: (controller.pointsInPercent.value / 100.0),
                    center: MyText(
                      text: controller.pointsInPercent.value.toStringAsFixed(1) + "%",
                      size: 24,
                      color: MyColors.black,
                      fontFamilty: "Roboto",
                      fontWeight: FontWeight.w500,
                    ),
                    progressColor: MyColors.primaryColor,
                  ),
                  const SizedBox(height: 20,),
                  // Mark & Terms button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Mark button
                      TextBtn(
                        onClick: () {
                          // on Mark
                          // _showInterstitialAd();
                          onMark();
                        },
                        label: Strings.mark.toUpperCase(),
                        underline: false,
                        fontWeight: FontWeight.w500,
                        color: MyColors.primaryColor,
                      ),
                      const SizedBox(width: 10,),
                      // vertical line
                      Container(
                        height: 20,
                        width: 2,
                        color: MyColors.black,
                      ),
                      const SizedBox(width: 10,),
                      // Terms button
                      TextBtn(
                        onClick: () {
                          // on Terms button
                          // show terms dialog
                          showTermsDialog();
                        },
                        label: Strings.terms.toUpperCase(),
                        underline: false,
                        fontWeight: FontWeight.w500,
                        color: MyColors.primaryColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // build footer button
  Widget buildFooter() {
    // Share app button
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 40),
      child: SizedBox(
        width: 220,
        child: MyBtn(
            onClick: () {
              // on share
              // _showInterstitialAd();
              onShareApp();
            },
            color: MyColors.primaryColor,
            label: Strings.shareToFriends,
            textColor: MyColors.white,
            radius: 5,
          ),
      ),
    );
  }

  // show terms dialog
  void showTermsDialog() {
    //Get.dialog(MessageViewDialog(message: controller.fullMessage));
    /*Get.defaultDialog(
      content: TermsDialog(message: Strings.termsText),
      title: Strings.terms,
      titlePadding: const EdgeInsets.all(10),
      backgroundColor: Colors.white,
      barrierDismissible: true,
      radius: 20,
    );*/
    showDialog(context: context, builder: (_) {
      return AlertDialog(
        content: TermsDialog(message: Strings.termsText,),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))
        ),
      );
    });
  }

  // on Mark click
  void onMark() async {
    await MyRoutes.navigateToMarkPage();
    controller.getAuthUser(); // get auth user
    print("get auth user");
  }

  // on profile click
  void onProfile() async {
    await MyRoutes.navigateToProfilePage();
    controller.getAuthUser();
  }

  // on share app click
  void onShareApp() {
    Utils.showErrorSnackbar("The app is not published yet");
  }
}
