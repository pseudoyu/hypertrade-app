import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Widget tokenImageWidget(String url, String name) {
  if (url.endsWith('.svg')) {
    return SvgPicture.network(
      url.replaceAll('_USDC', ""),
      placeholderBuilder: (context) => Container(
        width: 40,
        height: 40,
        color: Colors.grey[300],
        child: const Icon(Icons.image, color: Colors.grey),
      ),
      errorBuilder: (context, error, stackTrace) {
        // 获取代币名称的首字母
        final firstLetter = name.isNotEmpty ? name[0].toUpperCase() : '?';
        return Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue[100],
          ),
          child: Center(
            child: Text(
              firstLetter,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue[700],
              ),
            ),
          ),
        );
      },
    );
  } else {
    return Image.network(
      url,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          width: 40,
          height: 40,
          color: Colors.grey[300],
          child: const Icon(Icons.image, color: Colors.grey),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        // 获取代币名称的首字母
        final firstLetter = name.isNotEmpty ? name[0].toUpperCase() : '?';
        return Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue[100],
          ),
          child: Center(
            child: Text(
              firstLetter,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue[700],
              ),
            ),
          ),
        );
      },
    );
  }
}
