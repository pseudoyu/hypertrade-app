import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hyper_app/generated/l10n.dart';
import 'package:hyper_app/provider/vclist_provider.dart';
import 'package:hyper_app/theme/colors.dart';
import 'package:provider/provider.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

import '../../../theme/text_style.dart';

class RequestErrorDisplay extends StatelessWidget {
  const RequestErrorDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.sizeOf(context).width,
              minWidth: 100,
              maxHeight: MediaQuery.sizeOf(context).height / 3,
            ),
            child: Image.asset('assets/images/requestError.png'),
          ),
          Center(
            child: Text(
              'Hi',
              style: boldText.copyWith(color: primaryBlue),
            ),
          ),
          const SizedBox(height: 4.0),
          Center(
            child: Text(
              S.of(context).requestError,
              style: mediumText.copyWith(color: Colors.grey.shade700),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16.0),
          Consumer<VcInfoProvider>(builder: (context, vcInfoProv, _) {
            return SizedBox(
              width: MediaQuery.sizeOf(context).width / 2,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  textStyle: mediumText,
                  padding: const EdgeInsets.all(12.0),
                  shape: const StadiumBorder(),
                ),
                onPressed: vcInfoProv.isLoading
                    ? null
                    : () async {
                        context.goNamed('home', pathParameters: {'index': '0'});
                        await vcInfoProv.getVcInfos();
                      },
                child: const Text(
                  'Return Home',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class SearchErrorDisplay extends StatelessWidget {
  const SearchErrorDisplay({
    super.key,
    required this.fsc,
  });

  final FloatingSearchBarController fsc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.sizeOf(context).width,
              minWidth: 100,
              maxHeight: MediaQuery.sizeOf(context).height / 3,
            ),
            child: Image.asset('assets/images/searchError.png'),
          ),
          Center(
            child: Text(
              'Search Error',
              style: boldText.copyWith(color: primaryBlue),
            ),
          ),
          const SizedBox(height: 4.0),
          Center(
            child: Text(
              'Unable to find "${fsc.query}", check for typo or check your internet connection',
              style: mediumText.copyWith(color: Colors.grey.shade700),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16.0),
          Consumer<VcInfoProvider>(
            builder: (context, vcInfoProv, _) {
              return SizedBox(
                width: MediaQuery.sizeOf(context).width / 2,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    textStyle: mediumText,
                    padding: const EdgeInsets.all(12.0),
                    shape: const StadiumBorder(),
                  ),
                  onPressed: vcInfoProv.isLoading
                      ? null
                      : () async {
                          await vcInfoProv.getVcInfos();
                          // context.goNamed('home');
                        },
                  child: const Text('Return Home'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
