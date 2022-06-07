import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdmobAD extends StatefulWidget {
  const AdmobAD({Key? key}) : super(key: key);

  @override
  _AdmobADState createState() => _AdmobADState();
}

class _AdmobADState extends State<AdmobAD> {
  BannerAd? myBanner;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myBanner = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      size: AdSize.largeBanner,
      request: AdRequest(),
      listener: BannerAdListener(),
    );
    myBanner!.load();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child:Container(
          height: 130,
          child: Center(child: AdWidget(ad: myBanner!,))) ,
    );
  }
}
