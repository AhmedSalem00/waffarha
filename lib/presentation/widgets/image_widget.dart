import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class MyImageWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final String imageUrl;
  final String? placeholderImage;
  final String? errorImage;
  final BoxFit? fit;

  const MyImageWidget({super.key,
    required this.imageUrl,
    this.placeholderImage,
    this.errorImage,
    this.fit, this.width, this.height,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      width:width??90 ,
      height:width??90 ,
      imageUrl: imageUrl,
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),

          ),
        ),
      ),
      errorWidget: (context, url, error) => Image.asset(errorImage ?? 'assets/images', fit: BoxFit.cover),
      fit: fit ?? BoxFit.cover,
    );
  }
}