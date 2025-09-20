import 'package:flutter/material.dart';
import 'package:goodealz/core/helper/extensions/assetss_widgets.dart';
import 'package:shimmer/shimmer.dart';

class BannerShimmer extends StatelessWidget {
  const BannerShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.5),
      highlightColor: Colors.grey.withOpacity(0.3),
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: 22.cBorder,
        color: Colors.white,
        ),

      ),
    );
  }
}

class SellingFastShimmer extends StatelessWidget {
  const SellingFastShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey.withOpacity(0.5),
          highlightColor: Colors.grey.withOpacity(0.3),
          child: Container(
            height: 10,
            width: 90,
            decoration: BoxDecoration(
              // borderRadius: 22.cBorder,
            color: Colors.grey.withOpacity(0.7),
            ),

          ),
        ),
        const SizedBox(height: 15,),
        SizedBox(
          height: 200,
          child: ListView.separated(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            separatorBuilder: (context, index)=> const SizedBox(width: 10,),
            itemBuilder: (context, index)=>
                Shimmer.fromColors(
              baseColor: Colors.grey.withOpacity(0.5),
              highlightColor: Colors.grey.withOpacity(0.3),
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: 15.cBorder,
                  color: Colors.grey.withOpacity(0.7),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class SoldOutShimmer extends StatelessWidget {
  const SoldOutShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey.withOpacity(0.5),
          highlightColor: Colors.grey.withOpacity(0.3),
          child: Container(
            height: 10,
            width: 90,
            decoration: BoxDecoration(
              // borderRadius: 22.cBorder,
            color: Colors.grey.withOpacity(0.7),
            ),

          ),
        ),
        const SizedBox(height: 15,),
        SizedBox(
          height: 410,
          child: ListView.separated(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 2,
            separatorBuilder: (context, index)=> const SizedBox(height: 10,),
            itemBuilder: (context, index)=>
                Shimmer.fromColors(
              baseColor: Colors.grey.withOpacity(0.5),
              highlightColor: Colors.grey.withOpacity(0.3),
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: 15.cBorder,
                  color: Colors.grey.withOpacity(0.7),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class ExploreProductShimmer extends StatelessWidget {
  const ExploreProductShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Shimmer.fromColors(
              baseColor: Colors.grey.withOpacity(0.5),
              highlightColor: Colors.grey.withOpacity(0.3),
              child: Container(
                height: 10,
                width: 90,
                decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.7),
                ),
              ),
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey.withOpacity(0.5),
              highlightColor: Colors.grey.withOpacity(0.3),
              child: Container(
                height: 10,
                width: 50,
                decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.7),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15,),
        SizedBox(
          height: 200,
          child:
                Shimmer.fromColors(
              baseColor: Colors.grey.withOpacity(0.5),
              highlightColor: Colors.grey.withOpacity(0.3),
              child: Container(
                padding: const EdgeInsets.all(20),
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: 15.cBorder,
                  color: Colors.grey.withOpacity(0.5)
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 50,
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: 22.cBorder,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),

        )
      ],
    );
  }
}

class SearchShimmer extends StatelessWidget {
  const SearchShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey.withOpacity(0.5),
          highlightColor: Colors.grey.withOpacity(0.3),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: 15.cBorder,
            color: Colors.grey.withOpacity(0.5),
            ),
            child: Row(
              children: [
                Container(
                  height: 30,
                  width: 30,
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: 10,),
                Container(
                  height: 10,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: 22.cBorder,
                    color: Colors.white,
                  ),
                ),
              ],
            ),

          ),
        ),
      ],
    );
  }
}

class WinnerShimmer extends StatelessWidget {
  const WinnerShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Shimmer.fromColors(
              baseColor: Colors.grey.withOpacity(0.5),
              highlightColor: Colors.grey.withOpacity(0.3),
              child: Container(
                height: 10,
                width: 90,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.7),
                ),
              ),
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey.withOpacity(0.5),
              highlightColor: Colors.grey.withOpacity(0.3),
              child: Container(
                height: 10,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.7),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15,),
        SizedBox(
          height: 130,
          child: ListView.separated(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 2,
            separatorBuilder: (context, index)=> const SizedBox(height: 10,),
            itemBuilder: (context, index)=>
                Shimmer.fromColors(
                  baseColor: Colors.grey.withOpacity(0.5),
                  highlightColor: Colors.grey.withOpacity(0.3),
                  child:Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: 15.cBorder,
                      color: Colors.grey.withOpacity(0.5),
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 30,
                          width: 30,
                          decoration: const BoxDecoration(
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 10,),
                        Container(
                          height: 10,
                          width: 170,
                          decoration: BoxDecoration(
                            borderRadius: 22.cBorder,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),

                  ),
                ),
          ),
        )
      ],
    );
  }
}
