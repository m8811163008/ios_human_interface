import 'package:component_library/component_library.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ios_human_interface/cubit/app_cubit.dart';
import 'package:lorem_ipsum/lorem_ipsum.dart';
import 'package:storybook_flutter/storybook_flutter.dart';
import 'package:flutter_native_text_view/flutter_native_text_view.dart';

import 'package:ios_human_interface/l10n/ios_human_interface_localizations.dart';
import 'package:webview_flutter/webview_flutter.dart';

List<Story> get stories {
  return [
    Story(
      name: StoriesRoutesNames.wellcome,
      builder: (context) {
        context.read<AppCubit>().updateAppbarTitle(StoriesRoutesNames.wellcome);
        return const WellcomeStory();
      },
    ),
    Story(
      name: '${StoriesRoutesNames.content}/${StoriesRoutesNames.imageView}',
      builder: (context) {
        context
            .read<AppCubit>()
            .updateAppbarTitle(StoriesRoutesNames.imageView);
        return ImageView(
          isShowText: context.knobs.boolean(
            label: 'show text legibility',
            initial: false,
          ),
        );
      },
    ),
    Story(
      name: '${StoriesRoutesNames.content}/${StoriesRoutesNames.textView}',
      builder: (context) {
        context.read<AppCubit>().updateAppbarTitle(StoriesRoutesNames.textView);
        return TextView();
      },
    ),
    Story(
      name: '${StoriesRoutesNames.content}/${StoriesRoutesNames.webView}',
      builder: (context) {
        context.read<AppCubit>().updateAppbarTitle(StoriesRoutesNames.webView);
        return WebView();
      },
    ),
  ];
}

class WellcomeStory extends StatelessWidget {
  const WellcomeStory({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = IosHumanInterfaceLocalizations.of(context);
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: l10n.introPageWellcomeMessage,
            style: context.textStyle,
          ),
          const TextSpan(text: '\n'),
          TextSpan(
            text: l10n.projectName,
            // style: context.textStyle.copyWith(
            //   fontWeight: FontWeight.w700,
            //   color: context.textStyle.color,
            // ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}

class ImageView extends StatefulWidget {
  const ImageView({
    super.key,
    this.isShowText = false,
  });
  final bool isShowText;
  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView>
    with SingleTickerProviderStateMixin {
  final _controller = TransformationController();
  late TapDownDetails _tapDownDetails;
  late AnimationController _animationController;
  Animation<Matrix4>? _animation;
  final _imagekey = GlobalKey();
  Size _size = Size.zero;
  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getShaderPoition();
    });
  }

  void _getShaderPoition() {
    final renderBox = _imagekey.currentContext!.findRenderObject() as RenderBox;

    setState(() {
      _size = renderBox.size;
    });
  }

  Widget get _sampleImage => Image.asset(
        'assets/image_view.jpeg',
        key: _imagekey,
        width: MediaQuery.of(context).size.width,
      );

  Widget get _sampleImageWithShader => IntrinsicHeight(
        child: Stack(
          alignment: Alignment.center,
          children: [
            ShaderMask(
              shaderCallback: (bounds) {
                return LinearGradient(
                  colors: [
                    CupertinoColors.black.withOpacity(0),
                    CupertinoColors.black.withOpacity(1)
                  ],
                  begin: Alignment.center,
                  end: Alignment.bottomCenter,
                ).createShader(bounds);
              },
              blendMode: BlendMode.srcOver,
              child: _sampleImage,
            ),
            SizedBox.fromSize(
              size: _size,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    'Text ligibility',
                    style: context.textStyle.copyWith(
                      fontSize: 16.0,
                      color: CupertinoColors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: GestureDetector(
        onDoubleTapDown: (details) => _tapDownDetails = details,
        onDoubleTap: _handleDoubleTap,
        child: InteractiveViewer(
          // boundaryMargin: EdgeInsets.all(16),
          transformationController: _controller,
          child: widget.isShowText ? _sampleImageWithShader : _sampleImage,
        ),
      ),
    );
  }

  void _handleDoubleTap() async {
    if (_controller.value != Matrix4.identity()) {
      await _animationController.reverse();

      _animation?.removeListener(_animationLinstener);

      _controller.value = Matrix4.identity();
    } else {
      final position = _tapDownDetails.localPosition;
      final endMatrix = Matrix4.identity()
        ..translate(-position.dx, -position.dy)
        ..scale(2.0);
      _animation =
          Matrix4Tween(begin: Matrix4.identity(), end: endMatrix).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Curves.decelerate,
          reverseCurve: Curves.fastOutSlowIn,
        ),
      );
      _animation?.addListener(_animationLinstener);
      await _animationController.forward();
    }
  }

  void _animationLinstener() {
    setState(() {
      _controller.value = _animation!.value;
    });
  }
}

class TextView extends StatelessWidget {
  const TextView({super.key});

  @override
  Widget build(BuildContext context) {
    String exampleText = '👍 consectetur sampel text component ios ☺️👍';
    exampleText += loremIpsum(words: 600, paragraphs: 5);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: 200,
        child: CupertinoScrollbar(
          child: SingleChildScrollView(
            child: NativeTextView(
              exampleText,
              style: TextStyle(
                color: CupertinoColors.label,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class WebView extends StatefulWidget {
  const WebView({super.key});

  @override
  State<WebView> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  late final WebViewController _controller;
  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(CupertinoColors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) {
            debugPrint('Page finished loading: $url');
            setState(() {
              //_controller;
              _buildNavigationActions();
            });
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('''
              Page resource error:
              code: ${error.errorCode}
              description: ${error.description}
              errorType: ${error.errorType}
              isForMainFrame: ${error.isForMainFrame}
          ''');
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              debugPrint('blocking navigation to ${request.url}');
              return NavigationDecision.prevent;
            }
            debugPrint('allowing navigation to ${request.url}');
            return NavigationDecision.navigate;
          },
          onUrlChange: (UrlChange change) {
            debugPrint('url changed to ${change.url}');
          },
        ),
      );
  }

  void _buildNavigationActions() async {
    final canGoBack = await _controller.canGoBack();
    final canGoForward = await _controller.canGoForward();
    final actions = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildNavigationButton(
          canGoBack ? () => _controller.goBack() : null,
          Icon(
            CupertinoIcons.back,
            color: !canGoBack ? CupertinoColors.inactiveGray : null,
          ),
        ),
        SizedBox(
          width: 8.0,
        ),
        _buildNavigationButton(
          () => _controller.reload(),
          Icon(
            CupertinoIcons.refresh,
          ),
        ),
        SizedBox(
          width: 8.0,
        ),
        _buildNavigationButton(
          canGoForward ? () => _controller.goForward() : null,
          Icon(
            CupertinoIcons.forward,
            color: !canGoForward ? CupertinoColors.inactiveGray : null,
          ),
        ),
      ],
    );
    context.read<AppCubit>().updateAppbarActions(actions);
  }

  Widget _buildNavigationButton(void Function()? onTap, Icon icon) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox.square(
        dimension: 48.0,
        child: icon,
      ),
    );
  }

  @override
  void deactivate() {
    context.read<AppCubit>().updateAppbarActions(SizedBox());
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    // _buildNavigationActions();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CupertinoButton(
          onPressed: () => _controller.loadRequest(
            Uri.parse('https://flutter.dev'),
          ),
          child: Text('Start surfing'),
        ),
        Expanded(child: WebViewWidget(controller: _controller)),
      ],
    );
  }
}

class StoriesRoutesNames {
  static const wellcome = 'wellcome';
  static const content = 'content';
  static const imageView = 'image-view';
  static const textView = 'text-view';
  static const webView = 'web-view';
}
