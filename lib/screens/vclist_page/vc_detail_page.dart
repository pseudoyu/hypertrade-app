import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hyper_app/helper/launch_url.dart';
import 'package:hyper_app/helper/str2list.dart';
import 'package:hyper_app/models/vc_info.dart';
import 'package:hyper_app/screens/vclist_page/views/like_button.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class VCDetailPage extends StatelessWidget {
  final VcInfoData item;

  const VCDetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(item.ventureCapitalName ?? '')),
      floatingActionButton: LikeButton(item: item),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildContactInfo(),
                  const SizedBox(height: 16),
                  Text(
                    item.description ?? '',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(
                    label: 'Location',
                    value: item.location,
                    icon:
                        const Icon(PhosphorIconsFill.mapPin, color: Colors.red),
                  ),
                  _buildSectorsGrid(
                    label: 'Check size range(s)',
                    value: item.checkSizeRanges,
                    icon: const Icon(PhosphorIconsFill.money,
                        color: Colors.green),
                  ),
                  _buildSectorsGrid(
                    label: 'Rounds they invest in',
                    value: item.roundsTheyInvestIn,
                    icon:
                        const Icon(PhosphorIconsFill.graph, color: Colors.blue),
                  ),
                  _buildSectorsGrid(
                    label: 'Rounds they lead',
                    value: item.roundsTheyLead,
                    icon: const Icon(PhosphorIconsFill.trendUp,
                        color: Colors.orange),
                  ),
                  _buildSectorsGrid(
                    label: 'Sectors they invest in',
                    value: item.sectorsTheyInvestIn,
                    icon: const Icon(PhosphorIconsFill.listHeart,
                        color: Colors.red),
                  ),
                  _buildSectorsGrid(
                    label: 'Geographies they invest in',
                    value: item.geographiesTheyInvestIn,
                    icon: const Icon(PhosphorIconsFill.globe,
                        color: Colors.blueGrey),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(top: 16),
                    color: Colors.grey.shade200,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Data by Harmonic',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 192, 192, 192),
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Image.network(
                              item.vcAvatar ?? "",
                              width: 25,
                              height: 25,
                            ),
                          ],
                        ),
                        if (!item.unicornInvestments!
                            .contains('No items found.'))
                          _buildLinkTagGrid(
                            label: 'Unicorn investments',
                            value: item.unicornInvestments,
                            icon: const Icon(PhosphorIconsFill.rocket,
                                color: Colors.blue),
                          ),
                        _buildSectorsGrid(
                          label: 'Top 3 verticals',
                          value: item.top3Verticals,
                          icon: const Icon(PhosphorIconsFill.rowsPlusTop,
                              color: Colors.blue),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(context) {
    return Stack(
      children: [
        SizedBox(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).width / 2,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                item.vcAvatar ?? "",
                fit: BoxFit.cover,
                color:
                    const Color.fromARGB(255, 171, 244, 255).withOpacity(0.4),
                colorBlendMode: BlendMode.lighten,
              ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 70.0, sigmaY: 150.0),
                child: Container(
                  color: Colors.black.withOpacity(0), // 透明色用于显示模糊效果
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 16,
          bottom: 24,
          child: SizedBox(
            width: 80,
            height: 80,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16), // 设置圆角半径
              child: Image.network(
                item.vcAvatar ?? "",
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Positioned(
          left: 120,
          bottom: 24,
          child: Text(
            item.ventureCapitalName ?? 'Alpaca VC',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildContactInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFCC00),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow(label: 'Best Contact', value: item.bestWayToGetInTouch),
          const SizedBox(height: 12),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () => launchAll(item.website),
                icon: const Icon(Icons.language,
                    color: Color.fromARGB(255, 224, 224, 224)),
                label: const Text(
                  'Fund Website',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => launchAll(item.twitter),
                icon: const PhosphorIcon(
                  PhosphorIconsFill.twitterLogo,
                  color: Colors.blue,
                ),
              ),
              IconButton(
                onPressed: () => launchAll(item.linkedin),
                icon: const PhosphorIcon(
                  PhosphorIconsFill.linkedinLogo,
                  color: Colors.blue,
                ),
              ),
              IconButton(
                onPressed: () => launchAll(item.crunchbase),
                icon: const Icon(Icons.data_usage, color: Colors.blue),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required String label,
    String? value,
    Icon? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          icon ?? const Text(''), // Display the icon
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 200),
            child: Text(value ?? ''),
          ),
          const SizedBox(width: 16)
        ],
      ),
    );
  }

  Widget _buildSectorsGrid({
    required String label,
    String? value,
    Icon? icon,
  }) {
    late List<String> sectorList;

    if (value != null) {
      sectorList = parseStringToList(value).cast<String>();
    } else {
      sectorList = [];
    }

    return Padding(
      padding: const EdgeInsets.only(top: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                icon,
                const SizedBox(width: 8),
              ],
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: -8,
            children: sectorList.map((sector) {
              return Chip(
                label: Text(
                  sector.toString().trim(),
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkTagGrid({
    required String label,
    String? value,
    Icon? icon,
  }) {
    late List<Map<String, dynamic>> sectorList;

    if (value != null) {
      sectorList = parseStringToDictList(value);
    } else {
      sectorList = [];
    }

    return Padding(
      padding: const EdgeInsets.only(top: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                icon,
                const SizedBox(width: 8),
              ],
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: -8,
            children: sectorList.map((sector) {
              return Chip(
                label: Text(
                  sector["name"].toString().trim(),
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
