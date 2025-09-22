import 'package:flutter/material.dart';
import 'package:hyper_app/models/vc_info.dart';
import 'package:hyper_app/screens/vclist_page/vc_detail_page.dart';

class VcInfoCard extends StatelessWidget {
  final VcInfoData item;
  const VcInfoCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          item.ventureCapitalName ?? 'No Name',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              item.description ?? 'No Description',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              'Location: ${item.location ?? 'Unknown'}',
              style: const TextStyle(color: Colors.blueAccent),
            ),
          ],
        ),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(item.vcAvatar ?? ''),
          radius: 30,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VCDetailPage(item: item),
            ),
          );
        },
      ),
    );
  }
}
