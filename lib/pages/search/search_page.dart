
import 'dart:io';

import 'package:facebook_audience_network/ad/ad_banner.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:services_app/data/repository/auth_repo.dart';
import 'package:services_app/data/repository/user_repo.dart';
import 'package:services_app/pages/search/search_controller.dart';
import 'package:services_app/widgets/my_icon_text_field.dart';
import 'package:services_app/widgets/search/filter_dialog.dart';
import 'package:services_app/widgets/search/search_progress.dart';
import 'package:services_app/widgets/search/search_text_field.dart';

import '../../utils/my_colors.dart';
import '../../utils/strings.dart';
import '../../widgets/mark/doctor_list_item.dart';
import '../../widgets/my_text.dart';
import '../home/admob.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // TODO: Add _kAdIndex
  static final _kAdIndex = 4;
  // TODO: Add _isAdLoaded
  bool _isAdLoaded = false;
  int _getDestinationItemIndex(int rawIndex) {
    if (rawIndex >= _kAdIndex && _isAdLoaded) {
      return rawIndex - 1;
    }
    return rawIndex;
  }

  @override
  void initState() {
    // TODO: implement initState
    FacebookAudienceNetwork.init(

    );
    _createInterstitialAd();
    super.initState();
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
  Widget currentAd = SizedBox(
    width: 0.0,
    height: 0.0,
  );
  showBannerAd() {
    setState(() {
      currentAd = FacebookBannerAd(
        // placementId: "YOUR_PLACEMENT_ID",
        placementId:
        "IMG_16_9_APP_INSTALL#2312433698835503_2964944860251047", //testid
        bannerSize: BannerSize.STANDARD,
        listener: (result, value) {
          print("Banner Ad: $result -->  $value");
        },
      );
    });
  }
  SearchController controller = Get.put(SearchController(
    authRepo: AuthRepo(),
    userRepo: UserRepo(),
  ));

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: MyColors.lightGrey,
        body: buildBody(),
      ),
    );
  }

  // build appbar
  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      leading: InkWell(
        onTap: () {
          // pop back to mark page
          Get.back();
        },
        child: Icon(
          Icons.arrow_back_ios,
          size: 24,
          color: MyColors.black54,
        ),
      ),
      title: MyText(
        text: Strings.search,
        fontWeight: FontWeight.w700,
        color: MyColors.black,
        size: 18,
      ),
      centerTitle: true,
      actions: [
      ],
    );
  }

  // build body
  Widget buildBody() {
    return Obx(() => Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        buildHeader(),
        controller.isProgressEnabled.value? SearchProgress() : buildUsersList(),
      ],
    ),
    );
  }

  // build header
  Widget buildHeader() {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 10, left: 20, right: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // back button
                    InkWell(
                      onTap: () {
                        // pop back to home page
                        Get.back();
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                        size: 24,
                        color: MyColors.black54,
                      ),
                    ),
                    const SizedBox(width: 0,),
                    MyText(
                      text: Strings.search,
                      fontWeight: FontWeight.w700,
                      color: MyColors.black,
                      size: 18,
                    ),
                  ],
                ),
                buildFilterIcon(),
              ],
            ),
            const SizedBox(height: 10,),
            // search field and filter icon button
            buildSearchTextField(),
          ],
        ),
      ),
    );
  }

  // build search text field
  Widget buildSearchTextField() {
    return SearchTextField(
      textEditingController: controller.searchEditingController,
      hint: Strings.search,
      focusNode: controller.searchFocusNode,
      nextFocusNode: null,
      textInputAction: TextInputAction.done,
      icon: Icons.search,
      textInputType: TextInputType.text,
      error: null,
      onChanged: (value) {
        controller.search(value.toString().toLowerCase());
      },
    );
  }

  // build filter icon
  Widget buildFilterIcon() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: InkWell(
        onTap: () {
          // show filter dialog
          showFilterDialog();
        },
        child: /*Icon(
          Icons.filter_alt_outlined,
          color: MyColors.black54,
          size: 24,
        ),*/
        Image.asset(
          "assets/images/filter.jpeg",
          width: 24,
          height: 24,
        ),
      ),
    );
  }

  // build doctor list
  Widget buildUsersList() {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: Obx(
          () => ListView.separated(
            separatorBuilder: (context, index) {
              if (index!=0&&index%2==0)
                return Container(
                  margin: EdgeInsets.only(top: 20),
                  child: FacebookNativeAd(
                    placementId: "IMG_16_9_APP_INSTALL#2312433698835503_2964953543583512",
                    adType: NativeAdType.NATIVE_AD,
                    width: double.infinity,
                    height: 180,
                    backgroundColor: Colors.blue,
                    titleColor: Colors.white,
                    descriptionColor: Colors.white,
                    buttonColor: Colors.deepPurple,
                    buttonTitleColor: Colors.white,
                    buttonBorderColor: Colors.white,
                    keepAlive: true, //set true if you do not want adview to refresh on widget rebuild
                    keepExpandedWhileLoading: false, // set false if you want to collapse the native ad view when the ad is loading
                    expandAnimationDuraion: 300, //in milliseconds. Expands the adview with animation when ad is loaded
                    listener: (result, value) {
                      print("Native Ad: $result --> $value");
                    },
                  ),
                );
              return SizedBox(height: 0,);
            },
            itemCount: controller.users.value.length + (_isAdLoaded ? 1 : 0),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return  Padding(
                padding: const EdgeInsets.only(top: 20),
                child: DoctorListItem(
                  user: controller.users.value[index],
                  point: controller.users.value[index].authUserPoints,
                  onClick: () {
_showInterstitialAd();
                  },
                  onPointSelect: (value) {
                    // on points selected
                    // update points
                    controller.updatePoints(controller.users.value[index], value);
                  },
                  onFilterClick: () {
_showInterstitialAd();
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // show filter dialog
  void showFilterDialog() {
    Get.defaultDialog(
      content: Obx(() => FilterDialog(
        groupValue: controller.filterGroupValue.value,
        onChanged: (value) {
          print("value: ${value}");
          controller.filterGroupValue.value = value;
        },
        onApply: (value) {
          controller.filterGroupValue.value = value;
        },
      ),),
      title: Strings.filter,
      titlePadding: const EdgeInsets.all(10),
      backgroundColor: Colors.white,
      barrierDismissible: true,
      radius: 20,
    );
  }
}
