import 'package:flutter/material.dart';
import 'package:hyper_app/provider/vclist_provider.dart';
import 'package:hyper_app/theme/colors.dart';
import 'package:hyper_app/theme/text_style.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class CustomSearchBar extends StatefulWidget {
  final FloatingSearchBarController fsc;
  const CustomSearchBar({
    super.key,
    required this.fsc,
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final List<String> _searchSuggestion = [
    "Homebrew",
    "v1.vc",
    "OSS",
    "Bee",
  ];

  @override
  Widget build(BuildContext context) {
    return FloatingSearchBar(
      controller: widget.fsc,
      // hint: '${S.of(context).search}...',
      hint: 'search...',
      clearQueryOnClose: false,
      scrollPadding: const EdgeInsets.only(top: 16.0, bottom: 56.0),
      transitionDuration: const Duration(milliseconds: 400),
      borderRadius: BorderRadius.circular(16.0),
      transitionCurve: Curves.easeInOut,
      accentColor: primaryBlue,
      hintStyle: regularText,
      queryStyle: regularText,
      physics: const BouncingScrollPhysics(),
      automaticallyImplyDrawerHamburger: false,
      automaticallyImplyBackButton: false,
      elevation: 2.0,
      debounceDelay: const Duration(milliseconds: 500),
      onQueryChanged: (query) {},
      onSubmitted: (query) async {
        if (query != "") {
          widget.fsc.close();
          await Provider.of<VcInfoProvider>(context, listen: false)
              .searchVcInfos(query);
        }
      },
      leadingActions: [
        IconButton(
          icon: const PhosphorIcon(
            PhosphorIconsRegular.slidersHorizontal,
          ), // Drawer 的图标
          onPressed: () {
            Scaffold.of(context).openDrawer(); // 打开 Drawer
          },
        ),
      ],
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        const FloatingSearchBarAction(
          showIfOpened: false,
          child: PhosphorIcon(
            PhosphorIconsBold.magnifyingGlass,
            color: primaryBlue,
          ),
        ),
        FloatingSearchBarAction.icon(
          showIfClosed: false,
          showIfOpened: true,
          icon: const PhosphorIcon(
            PhosphorIconsBold.x,
            color: primaryBlue,
          ),
          onTap: () {
            if (widget.fsc.query.isEmpty) {
              widget.fsc.close();
            } else {
              widget.fsc.clear();
            }
          },
        ),
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Material(
            color: Colors.white,
            elevation: 4.0,
            child: ListView.separated(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: _searchSuggestion.length,
              itemBuilder: (context, index) {
                String data = _searchSuggestion[index];
                return InkWell(
                  onTap: () async {
                    widget.fsc.query = data;
                    widget.fsc.close();
                    await Provider.of<VcInfoProvider>(context, listen: false)
                        .searchVcInfos(data);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(22.0),
                    child: Row(
                      children: [
                        const PhosphorIcon(PhosphorIconsFill.mapPin),
                        const SizedBox(width: 22.0),
                        Text(data, style: mediumText),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => const Divider(
                thickness: 1.0,
                height: 0.0,
              ),
            ),
          ),
        );
      },
    );
  }
}
