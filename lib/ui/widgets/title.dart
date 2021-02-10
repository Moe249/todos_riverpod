import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:todos_riverpod/utils/config.dart';

import 'lite_rolling_switch.dart';

class TodoTitle extends StatelessWidget {
  const TodoTitle({Key key}) : super(key: key);

  static const double _size = 86;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      // alignment: WrapAlignment.spaceBetween,
      // crossAxisAlignment: WrapCrossAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text(
          "Todos",
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: _size,
            fontWeight: FontWeight.w100,
          ),
        ),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: LiteRollingSwitch(
            value: true,
            animationDuration: Duration(milliseconds: 300),
            textOn: 'Dark',
            textOff: 'Light',
            textOffColor: Colors.black,
            colorOn: Theme.of(context).primaryColor,
            iconOffColor: Colors.black,
            colorOff: Theme.of(context).accentColor,
            iconOn: Icons.settings_display,
            iconOff: Icons.settings_display,
            textSize: 16.0,
            onTap: () {
              themeInstance.switchTheme();
            },
            onChanged: (bool state) {},
            onSwipe: () {
              themeInstance.switchTheme();
            },
          ),
        ),
      ],
    );
  }
}
