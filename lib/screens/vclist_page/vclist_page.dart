import 'package:flutter/material.dart';
import 'package:hyper_app/provider/vclist_provider.dart';
import 'package:hyper_app/screens/common_page/empty_page/empty_page.dart';
import 'package:hyper_app/screens/common_page/error_page/request_error.dart';
import 'package:hyper_app/screens/vclist_page/vc_card_widget.dart';
import 'package:hyper_app/screens/vclist_page/custom_vc_search.dart';
import 'package:hyper_app/widgets/custom_shimmer.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:provider/provider.dart';
import 'package:easy_refresh/easy_refresh.dart';

class VCListPage extends StatelessWidget {
  final FloatingSearchBarController fsc;

  const VCListPage({super.key, required this.fsc});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<VcInfoProvider>(
        builder: (context, vcInfoProv, _) {
          if (vcInfoProv.isRequestError) return const RequestErrorDisplay();

          if (vcInfoProv.isSearchError) return SearchErrorDisplay(fsc: fsc);

          return Stack(
            children: [
              const Positioned.fill(
                  child: Padding(
                padding: EdgeInsets.only(top: 131, left: 16),
                child: Text('VCs recommendation for you'),
              )),
              Positioned.fill(
                top: 96,
                child: EasyRefresh(
                  footer: const ClassicFooter(
                    noMoreText: 'No more data',
                    failedText: 'Load failed, try again',
                  ),
                  onLoad: () async {
                    if (!vcInfoProv.isLoading) {
                      await vcInfoProv.getVcInfos(
                        offset: vcInfoProv.vcInfos.length,
                        notify: false,
                        loadmore: true,
                      );
                    }
                  },
                  onRefresh: () async {
                    if (!vcInfoProv.isLoading) {
                      await vcInfoProv.getVcInfos(
                        offset: vcInfoProv.vcInfos.length,
                        notify: false,
                      );
                    }
                  },
                  child: Consumer<VcInfoProvider>(
                    builder: (context, vcInfoProvider, child) {
                      if (vcInfoProvider.isLoading) {
                        return Center(
                          child: CustomShimmer(
                            height: 100.0,
                            width: MediaQuery.of(context).size.width / 3,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        );
                      } else if (vcInfoProvider.vcInfos.isEmpty) {
                        return const EmptyPage();
                      } else if (vcInfoProvider.isRequestError) {
                        return const Center(
                            child: Text('Failed to load VC info'));
                      } else {
                        return ListView.builder(
                          itemCount: vcInfoProvider.vcInfos.length,
                          itemBuilder: (context, index) {
                            var item = vcInfoProvider.vcInfos[index];
                            return VcInfoCard(item: item);
                          },
                        );
                      }
                    },
                  ),
                ),
              ),
              CustomSearchBar(fsc: fsc),
            ],
          );
        },
      ),
    );
  }
}
