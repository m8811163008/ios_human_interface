import 'package:component_library/component_library.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

import 'package:ios_human_interface/l10n/ios_human_interface_localizations.dart';

List<Story> get stories {
  return [
    Story(
      name: StoriesRoutesNames.wellcome,
      builder: (context) {
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
      },
    ),
  ];
}

class StoriesRoutesNames {
  static const wellcome = 'wellcome';
}
