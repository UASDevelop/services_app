

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:services_app/data/repository/auth_repo.dart';
import 'package:services_app/data/repository/user_repo.dart';
import 'package:services_app/pages/home/admob.dart';
import 'package:services_app/pages/mark/mark_controller.dart';
import 'package:services_app/widgets/icon_btn.dart';
import 'package:get/get.dart';

import '../../data/models/user.dart';
import '../../utils/my_colors.dart';
import '../../utils/my_routes.dart';
import '../../utils/strings.dart';
import '../../widgets/mark/doctor_list_item.dart';
import '../../widgets/my_btn.dart';
import '../../widgets/my_text.dart';
import '../../widgets/progress_view.dart';
import '../../widgets/text_btn.dart';

class MarkPage extends StatefulWidget {

  MarkPage({Key? key}) : super(key: key);

  @override
  State<MarkPage> createState() => _MarkPageState();
}

class _MarkPageState extends State<MarkPage> {
  final Kestate=GlobalKey();

  MarkController controller = Get.put(MarkController(
    userRepo: UserRepo(),
    authRepo: AuthRepo(),
  ));

  late BuildContext context;
  static final _kAdIndex = 2;
  // TODO: Add _isAdLoaded
  bool _isAdLoaded = false;
  int _getDestinationItemIndex(int rawIndex) {
    if (rawIndex >= _kAdIndex && _isAdLoaded) {
      return rawIndex - 1;
    }
    return rawIndex;
  }
  BannerAd? myBanner;
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
      //  bottomNavigationBar:
        backgroundColor: MyColors.lightGrey,
        appBar: buildAppBar(),
        body: buildBody(),
      ),
    );
  }

  // build appbar
  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      // back button
      leading: IconBtn(
        onClick: () {
          Get.back();

        },
        icon: Icons.arrow_back_ios_outlined,
        color: MyColors.black54,
      ),
      title: MyText(
        text: Strings.mark.toUpperCase(),
        fontWeight: FontWeight.w700,
        color: MyColors.black,
        size: 18,
      ),
      centerTitle: true,
      actions: [
        // search icon button
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: IconBtn(
            onClick: () {
              // on Search
              onSearch();
              // _showInterstitialAd();

            },
            icon: Icons.search,
            color: MyColors.black54,
          ),
        ),
      ],
    );
  }

  // build body weather show progress or main body contents
  Widget buildBody() {
    return Obx(
          () => controller.isProgressEnabled.value
          ? ProgressView()
          : buildBodyContents(),
    );
  }

  // build main body contents
  Widget buildBodyContents() {
    return buildDoctorList();
  }

  // build doctor list
  Widget buildDoctorList() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
      child: ListView.separated(
        separatorBuilder: (context, index) {
          if (index!=0&&index%5==0||index==1)
            return AdmobAD();
          return SizedBox(height: 0,);
        },
        itemCount: controller.displayUsers.value.length,
        itemBuilder: (context, index) {
          User user = controller.displayUsers.value[index];

//:
          return Padding(
            padding: const EdgeInsets.only(top: 20),
            child: InkWell(
              onTap: (){

              },
              child: DoctorListItem(
                user: user,
                point: user.authUserPoints,
                onClick: () {
// _showInterstitialAd();
                },
                onPointSelect: (value) {
                  // _showInterstitialAd();
                  // on points selected
                  // update points
                  controller.updatePoints(user, value);
                },
                onFilterClick: () {
                  // _showInterstitialAd();
                },
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _createInterstitialAd();
    myBanner = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      size: AdSize.largeBanner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          // Releases an ad resource when it fails to load
          ad.dispose();

          print('Ad load failed (code=${error.code} message=${error.message})');
        },
      ),
    );
    myBanner!.load();
  }
  // build footer view
  void onSearch() async {
    await MyRoutes.navigateToSearchPage();
    controller.getUsers();
  }
}
