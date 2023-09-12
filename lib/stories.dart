import 'package:component_library/component_library.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ios_human_interface/cubit/app_cubit.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

import 'package:ios_human_interface/l10n/ios_human_interface_localizations.dart';

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

class StoriesRoutesNames {
  static const wellcome = 'wellcome';
  static const content = 'content';
  static const imageView = 'image-view';
}
