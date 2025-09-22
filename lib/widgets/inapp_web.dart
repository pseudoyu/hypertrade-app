import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebViewComponent extends StatefulWidget {
  final String initialUrl;
  final String? title;
  final String? hideElementsScript;

  const WebViewComponent({
    super.key,
    required this.initialUrl,
    this.title,
    this.hideElementsScript,
  });

  @override
  WebViewComponentState createState() => WebViewComponentState();
}

class WebViewComponentState extends State<WebViewComponent> {
  InAppWebViewController? webViewController;
  bool _isLoading = true;
  double _progress = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF0891B2),
                    Color(0xFF00D2FF),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.trending_up,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    widget.title ?? 'Trading',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF374151),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.refresh,
                color: Color(0xFF00D2FF),
                size: 20,
              ),
              onPressed: () {
                webViewController?.reload();
              },
            ),
          ),
        ],
        iconTheme: const IconThemeData(color: Color(0xFF64748B)),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1E293B),
              Color(0xFF0F172A),
            ],
          ),
        ),
        child: Column(
          children: [
            if (_isLoading)
              Container(
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFF374151),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: LinearProgressIndicator(
                  value: _progress,
                  backgroundColor: Colors.transparent,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF00D2FF),
                  ),
                ),
              ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF374151),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00D2FF).withValues(alpha: 0.1),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: InAppWebView(
                    initialUrlRequest: URLRequest(
                      url: WebUri(widget.initialUrl),
                    ),
                    initialSettings: InAppWebViewSettings(
                      horizontalScrollBarEnabled: false,
                      disableHorizontalScroll: true,
                      supportZoom: false,
                      builtInZoomControls: false,
                      displayZoomControls: false,
                      transparentBackground: true,
                    ),
                    onWebViewCreated: (controller) {
                      webViewController = controller;
                      controller.addUserScript(
                        userScript: UserScript(
                          source: '''
                            document.body.style.overflowX = "hidden";
                            document.documentElement.style.backgroundColor = "#0F172A";
                            document.body.style.backgroundColor = "#0F172A";
                          ''',
                          injectionTime: UserScriptInjectionTime.AT_DOCUMENT_END,
                        ),
                      );
                    },
                    onProgressChanged: (controller, progress) {
                      setState(() {
                        _progress = progress / 100.0;
                        _isLoading = progress < 100;
                      });
                    },
                    onLoadStart: (controller, url) {
                      setState(() {
                        _isLoading = true;
                        _progress = 0.0;
                      });
                    },
                    onLoadStop: (controller, url) async {
                      setState(() {
                        _isLoading = false;
                        _progress = 1.0;
                      });
                      
                      if (widget.hideElementsScript != null) {
                        await controller.evaluateJavascript(
                          source: widget.hideElementsScript!,
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
