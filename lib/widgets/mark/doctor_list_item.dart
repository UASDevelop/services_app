
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:services_app/data/models/user.dart' as MyUser;
import 'package:services_app/utils/my_colors.dart';
import 'package:services_app/widgets/mark/coin_number.dart';
import 'package:services_app/widgets/my_text.dart';


class DoctorListItem extends StatelessWidget {


  DoctorListItem({
    required this.user,
    required this.onClick,
    required this.onPointSelect,
    required this.onFilterClick,
    required this.point,
});

  MyUser.User user;
  int point;
  Function onClick;
  Function onPointSelect;
  Function onFilterClick;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(15),),
        color: MyColors.grey300,
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            // filter icon
            //buildFilterIconBtn(),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // image
            GestureDetector(
                onTap: (){


Navigator.push(context, MaterialPageRoute(builder: (context)=>PhotoView(imageProvider: user.image != null && user.image!.isNotEmpty? NetworkImage(user.image!) : const AssetImage(
                      "assets/images/image_placeholder.png",
                    ) as ImageProvider,)));
                },
                child: buildImage()),
                const SizedBox(width: 15,),
                // name, tag, coins selection
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // name
                      MyText(
                        text: user.name != null? user.name! : "",
                        size: 16,
                        color: MyColors.black,
                        fontWeight: FontWeight.w700,
                        maxLines: 1,
                        textOverflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5,),
                      // tag
                      user.company == null? const SizedBox(width: 0, height: 0,) : Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(5),),
                          color: MyColors.primaryColor,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          child: MyText(
                            text: user.company != null? user.company! : "",
                            color: MyColors.white,
                            fontFamilty: "Roboto",
                            size: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10,),
                      // build coins (numbers)
                      buildCoinNumbers(),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // build filter icon button
  Widget buildFilterIconBtn() {
    return Align(
      alignment: Alignment.topRight,
      child: InkWell(
        onTap: () {
          onFilterClick();
        },
        child: Icon(
          Icons.filter_alt_outlined,
          size: 24,
          color: MyColors.black54,
        ),
      ),
    );
  }

  // build image
  Widget buildImage() {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10),),
        image: DecorationImage(
          image: user.image != null && user.image!.isNotEmpty? NetworkImage(user.image!) : const AssetImage(
            "assets/images/image_placeholder.png",
          ) as ImageProvider,
            fit: BoxFit.cover,
        ),
      ),
    );
  }

  // build coin numbers view
  Widget buildCoinNumbers() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 0
        CoinNumber(
          onSelect: () {
            // on select 0
            onPointSelect(0);
          },
          number: 0,
          isSelected: point == 0? true : false,
        ),
        //const SizedBox(width: 8,),
        // 1
        CoinNumber(
          onSelect: () {
            // on select 1
            onPointSelect(1);
          },
          number: 1,
          isSelected: point == 1? true : false,
        ),
        //const SizedBox(width: 8,),
        // 2
        CoinNumber(
          onSelect: () {
            // on select 2
            onPointSelect(2);
          },
          number: 2,
          isSelected: point == 2? true : false,
        ),
        //const SizedBox(width: 8,),
        // 3
        CoinNumber(
          onSelect: () {
            // on select 3
            onPointSelect(3);
          },
          number: 3,
          isSelected: point == 3? true: false,
        ),
        //const SizedBox(width: 8,),
        // 4
        CoinNumber(
          onSelect: () {
            // on select 4
            onPointSelect(4);
          },
          number: 4,
          isSelected: point == 4? true : false,
        ),
        //const SizedBox(width: 8,),
        // 5
        CoinNumber(
          onSelect: () {
            // on select 5
            onPointSelect(5);
          },
          number: 5,
          isSelected: point == 5? true : false,
        ),
      ],
    );
  }
}
