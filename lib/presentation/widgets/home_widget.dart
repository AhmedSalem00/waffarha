import 'package:flutter/material.dart';
import 'package:waffarha/data/models/product_model.dart';
import 'package:waffarha/presentation/widgets/image_widget.dart';

class HomeWidget extends StatelessWidget {
  final Product photo;
  const HomeWidget({Key? key, required this.photo}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // debugPrint('thumbnailUrl${photo.thumbnailUrl}');
    // debugPrint('title${photo.title}');
    // debugPrint('ID${photo.id}');
    // debugPrint('Url${photo.url}');

    return Row(
      children: [
        MyImageWidget(imageUrl: photo.thumbnailUrl??''),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(photo.title.toString()),
              Text(photo.albumId.toString()),
            ],
          ),
        ),
      ],
    );
  }
}
