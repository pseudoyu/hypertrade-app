import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hyper_app/provider/vclist_provider.dart';
import 'package:hyper_app/theme/colors.dart';
import 'package:hyper_app/widgets/loading.dart';
import 'package:provider/provider.dart';

import '../../../theme/text_style.dart';

class EmptyPage extends StatelessWidget {
  const EmptyPage({super.key});

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
              'No results found',
              style: boldText.copyWith(color: primaryBlue),
            ),
          ),
          const SizedBox(height: 4.0),
          Center(
            child: Text(
              'Please try again or check your internet connection',
              style: mediumText.copyWith(color: Colors.grey.shade700),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16.0),
          Consumer<VcInfoProvider>(
            builder: (context, vcInfoProv, _) {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  textStyle: mediumText,
                  shape: const StadiumBorder(),
                ),
                onPressed: vcInfoProv.isLoading
                    ? null
                    : () async {
                        vcInfoProv.setLoading(true);
                        try {
                          await vcInfoProv.getVcInfos();
                        } finally {
                          vcInfoProv.setLoading(false);
                        }
                        if (context.mounted) {
                          context.go('/');
                        }
                      },
                child: vcInfoProv.isLoading
                    ? const LoadingWidget()
                    : const Text('Return Home'),
              );
            },
          ),
        ],
      ),
    );
  }
}
