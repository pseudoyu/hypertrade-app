import 'package:flutter/material.dart';
import 'package:hyper_app/provider/collection_provider.dart';
import 'package:hyper_app/screens/common_page/empty_page/empty_page.dart';
import 'package:hyper_app/screens/common_page/error_page/request_error.dart';
import 'package:hyper_app/screens/vclist_page/vc_card_widget.dart';
import 'package:hyper_app/widgets/custom_shimmer.dart';
import 'package:provider/provider.dart';
import 'package:easy_refresh/easy_refresh.dart';

class CollectionVCListPage extends StatelessWidget {
  const CollectionVCListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Collection VC')),
      body: Consumer<CollectionProvider>(
        builder: (context, collectionVcProv, _) {
          if (collectionVcProv.isLoading) {
            return Center(
              child: CustomShimmer(
                height: 100.0,
                width: MediaQuery.of(context).size.width / 3,
                borderRadius: BorderRadius.circular(10.0),
              ),
            );
          }
          if (collectionVcProv.isRequestError) {
            return const RequestErrorDisplay();
          }
          return Stack(
            children: [
              Positioned.fill(
                top: 16,
                child: EasyRefresh(
                  footer: const ClassicFooter(
                    noMoreText: 'No more data',
                    failedText: 'Load failed, try again',
                  ),
                  // onLoad: () async {
                  //   if (!collectionVcProv.isLoading) {
                  //     await collectionVcProv.fetchLikeList();
                  //   }
                  // },
                  onRefresh: () async {
                    if (!collectionVcProv.isLoading) {
                      await collectionVcProv.fetchLikeList();
                    }
                  },
                  child: collectionVcProv.isLoading
                      ? Center(
                          child: CustomShimmer(
                            height: 100.0,
                            width: MediaQuery.of(context).size.width / 3,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        )
                      : collectionVcProv.likeList.isEmpty
                          ? const EmptyPage()
                          : collectionVcProv.isRequestError
                              ? const Center(
                                  child: Text('Failed to load VC info'))
                              : ListView.builder(
                                  itemCount: collectionVcProv.likeList.length,
                                  itemBuilder: (context, index) {
                                    var item = collectionVcProv.likeList[index];
                                    return VcInfoCard(item: item);
                                  },
                                ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
