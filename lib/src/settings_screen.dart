import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

import 'settings.dart';

T getDefaultValue<T>(String settingsKey, T defaultValue) {
  final Settings settings = Settings();
  if (settings.containsKey(settingsKey)) {
    final storedValue = settings.getValue(settingsKey);
    print('storedValue: $storedValue type: ${storedValue.runtimeType}');
    print('defaultValue: $defaultValue type: ${defaultValue.runtimeType}');
    if (storedValue is T) {
      return storedValue;
    }
  }
  return defaultValue;
}

/// [SettingsScreen] is a simple Screen widget that may contain Tiles or other
/// widgets.
///
///
/// * Parameters:
///
/// title (required) - Appbar title in Scaffold.
/// children (required) - Content of the screen, body of the Scaffold.
/// confirmText - If not null, a confirmation dialog will appear with this
///   text by opening the screen.
/// confirmModalTitle - Title of the confirmation dialog. Default: Confirmation.
/// confirmModalCancelCaption - Caption of the cancel button in the confirmation
///   dialog. Default: Cancel.
/// confirmModalConfirmCaption - Caption of the confirm button in the
///   confirmation dialog. Default: Confirm.
///
///
/// * Examples:
///
/// 1) The following example shows how you can create an empty settings screen
/// with a title.
/// SettingsScreen(
///   title: 'Application Settings',
///   children: <Widget>[],
/// );
///
/// 2) Inside the parameter called children you can define settings tiles and
/// other widgets. In this example we create a screen with a simple
/// [CheckboxSettingsTile] in it.
/// SettingsScreen(
///   title: 'Application Settings',
///   children: <Widget>[
///     CheckboxSettingsTile(
///       settingsKey: 'key-of-your-setting',
///       title: 'This is a simple Checkbox',
///     ),
///   ],
/// );
///
class SettingsScreen extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final String confirmText;
  final String confirmModalTitle;
  final String confirmModalCancelCaption;
  final String confirmModalConfirmCaption;

  SettingsScreen({
    @required this.title,
    @required this.children,
    this.confirmText,
    this.confirmModalTitle,
    this.confirmModalCancelCaption,
    this.confirmModalConfirmCaption,
  });

  @override
  Widget build(BuildContext context) {
    return _ConfirmableScreen(
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: ListView.builder(
          itemCount: children.length,
          itemBuilder: (BuildContext context, int index) {
            return children[index];
          },
        ),
      ),
      confirmText: confirmText,
      confirmModalTitle: confirmModalTitle,
      confirmModalCancelCaption: confirmModalCancelCaption,
      confirmModalConfirmCaption: confirmModalConfirmCaption,
    );
  }
}

/// [SettingsToggleScreen] is a screen widget similar to [SettingsScreen], but
/// additionally, it contains a built-in Checkbox at the beginning of its body.
/// Therefore, it requires a settingKey to save its value.
///
///
/// * Parameters:
///
/// title (required) - Appbar title in Scaffold.
/// settingKey (required) - Key name for the checkbox value.
/// children (required) - Content of the screen, body of the Scaffold.
/// childrenIfOff - Content of the screen if the checkbox is off. If null,
///   parameter 'children' will be used both cases.
/// defaultValue - Default value of the checkbox. Default: false. Please note,
///   until the user does not change the value, retrieving it via [Settings]
///   will return null.
/// subtitle - The title of the checkbox. Default: On.
/// subtitleIfOff - The title of the checkbox if it is off. If null, parameter
///   called 'subtitle' will be used both cases.
/// confirmText - If not null, a confirmation dialog will appear with this
///   text by enabling or disabling the checkbox.
/// confirmTextToEnable - If not null, a confirmation dialog will appear with
///   this text by enabling the checkbox. It overrides the behaviour of
///   'confirmText'.
/// confirmTextToDisable - If not null, a confirmation dialog will appear with
///   this text by disabling the checkbox. It overrides the behaviour of
///   'confirmText'.
/// confirmModalTitle - Title of the confirmation dialog. Default: Confirmation.
/// confirmModalCancelCaption - Caption of the cancel button in the confirmation
///   dialog. Default: Cancel.
/// confirmModalConfirmCaption - Caption of the confirm button in the
///   confirmation dialog. Default: Confirm.
///
///
/// * Examples:
///
/// 1) The following example shows how you can create an empty settings toggle
/// screen with a title.
/// SettingsToggleScreen(
///   settingKey: 'key-of-your-setting',
///   title: 'Title',
///   children: <Widget>[],
/// );
///
/// 2) In this example, we create a settings toggle screen using more
/// parameters and with children widgets according to its state.
/// SettingsToggleScreen(
///   settingKey: 'key-of-your-setting',
///   title: 'Title',
///   defaultValue: true,
///   subtitle: 'Enabled',
///   subtitleIfOff: 'Disabled',
///   children: <Widget>[
///     SettingsContainer(
///       child: Text('This is enabled! :)'),
///     ),
///   ],
///   childrenIfOff: <Widget>[
///     SettingsContainer(
///       child: Text('Tap the checkbox to enable.'),
///     ),
///   ],
/// );
class SettingsToggleScreen extends StatelessWidget {
  final String settingKey;
  final bool defaultValue;
  final String title;
  final String subtitle;
  final String subtitleIfOff;
  final List<Widget> children;
  final List<Widget> childrenIfOff;
  final String confirmText;
  final String confirmTextToEnable;
  final String confirmTextToDisable;
  final String confirmModalTitle;
  final String confirmModalCancelCaption;
  final String confirmModalConfirmCaption;

  SettingsToggleScreen({
    @required this.title,
    @required this.settingKey,
    @required this.children,
    this.childrenIfOff,
    this.defaultValue = false,
    this.subtitle = "On",
    this.subtitleIfOff = "Off",
    this.confirmText,
    this.confirmTextToEnable,
    this.confirmTextToDisable,
    this.confirmModalTitle,
    this.confirmModalCancelCaption,
    this.confirmModalConfirmCaption,
  });

  @override
  Widget build(BuildContext context) {
    return Settings().onBoolChanged(
      settingKey: settingKey,
      defaultValue: defaultValue,
      childBuilder: (BuildContext context, bool value) {
        return _ConfirmableScreen(
          child: SettingsScreen(
            title: title,
            children: _buildChildren(
              value,
              value == false && childrenIfOff != null
                  ? childrenIfOff
                  : children,
            ),
            confirmText: confirmText,
          ),
        );
      },
    );
  }

  List<Widget> _buildChildren(bool value, List<Widget> children) {
    List<Widget> elements = [
      SwitchSettingsTile(
        settingKey: settingKey,
        title:
            value == false && subtitleIfOff != null ? subtitleIfOff : subtitle,
        defaultValue: getDefaultValue<bool>(settingKey, defaultValue),
        confirmText: confirmText,
        confirmTextToEnable: confirmTextToEnable,
        confirmTextToDisable: confirmTextToDisable,
        confirmModalTitle: confirmModalTitle,
        confirmModalCancelCaption: confirmModalCancelCaption,
        confirmModalConfirmCaption: confirmModalConfirmCaption,
      ),
    ];
    elements.addAll(children);
    return elements;
  }
}

/// [SettingsTileGroup] is a widget that groups settings tiles and other
/// widgets together with a group title.
///
///
/// * Parameters:
///
/// title (required) - Title of the group
/// subtitle - Subtitle of the group. It can be used to share some information
///   about the group.
/// children (required) - Settings tiles or other widgets that are in the
///   group.
/// visibleIfKey - If not null, the group will only be visible if the value
///   of the given settings key is true.
///   See more in the documentation: Conditional Logic.
/// visibleByDefault - If visibleIfKey is not null and the value of the given
///   key is not saved yet then this value will be the default value.
///   Default: true.
///
///
/// * Examples:
///
/// 1) The following example shows how you can create a group with a simple
/// [CheckboxSettingsTile].
/// SettingsTileGroup(
///   title: 'Group title',
///   children: <Widget>[
///     CheckboxSettingsTile(
/// 		  settingKey: 'key-of-your-setting',
/// 			title: 'This is a simple Checkbox',
/// 		),
/// 	],
/// );
///
class SettingsTileGroup extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Widget> children;
  final String visibleIfKey;
  final bool visibleByDefault;

  SettingsTileGroup({
    @required this.title,
    this.subtitle,
    @required this.children,
    this.visibleIfKey,
    this.visibleByDefault = true,
  });

  @override
  Widget build(BuildContext context) {
    if (visibleIfKey == null) {
      return _buildChild(context);
    }
    return Settings().onBoolChanged(
      settingKey: visibleIfKey,
      defaultValue: visibleByDefault,
      childBuilder: (BuildContext context, bool visible) {
        return (visible ?? false) ? _buildChild(context) : Container();
      },
    );
  }

  Widget _buildChild(BuildContext context) {
    List<Widget> elements = <Widget>[
      Container(
        padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 22.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title.toUpperCase(),
            style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ];

    if (subtitle != null) {
      elements.addAll([
        Container(
          padding: const EdgeInsets.all(16.0),
          child: Align(alignment: Alignment.centerLeft, child: Text(subtitle)),
        ),
        _SettingsTileDivider(),
      ]);
    }
    elements.addAll(children);
    return Column(
      children: elements,
    );
  }
}

class _SettingsTile extends StatefulWidget {
  final String title;
  final String subtitle;
  final Icon icon;
  final Widget leading;
  final Widget widget;
  final Widget child;
  final Widget screen;
  final String visibleIfKey;
  final String enabledIfKey;
  final bool visibleByDefault;
  final Function onTap;

  _SettingsTile({
    @required this.title,
    this.subtitle,
    this.icon,
    this.leading,
    this.widget,
    this.child,
    this.screen,
    this.visibleIfKey,
    this.enabledIfKey,
    this.visibleByDefault = true,
    this.onTap,
  });

  @override
  State<StatefulWidget> createState() => __SettingsTileState();
}

class __SettingsTileState extends State<_SettingsTile>
    with _Confirmable, _Enableable {
  @override
  void initState() {
    super.initState();
    if (widget.visibleIfKey != null) {
      Future.delayed(Duration.zero, () {
        Settings().pingBool(widget.visibleIfKey, widget.visibleByDefault);
      });
    }
    if (widget.enabledIfKey != null) {
      Future.delayed(Duration.zero, () {
        Settings().pingBool(widget.enabledIfKey, widget.visibleByDefault);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.visibleIfKey == null) {
      return _wrapEnableable(context);
    }
    return Settings().onBoolChanged(
      settingKey: widget.visibleIfKey,
      defaultValue: widget.visibleByDefault,
      childBuilder: (BuildContext context, bool visible) {
        return visible ? _wrapEnableable(context) : Container();
      },
    );
  }

  Widget _wrapEnableable(BuildContext context) {
    return wrapEnableable(
      context: context,
      enabledIfKey: widget.enabledIfKey,
      visibleByDefault: widget.visibleByDefault,
      childBuilder: (BuildContext context, bool enabled) {
        return _buildChild(context, enabled);
      },
    );
  }

  Widget _buildChild(BuildContext context, bool enabled) {
    return Column(
      children: <Widget>[
        Material(
          child: ListTile(
            leading: widget.icon ?? widget.leading,
            title: Text(widget.title),
            subtitle: _buildSubtitle(),
            onTap: _shouldDisableTap(enabled)
                ? null
                : () {
                    _handleTap(context);
                  },
            trailing: widget.widget,
            enabled: enabled,
          ),
        ),
        _SettingsTileDivider(),
      ],
    );
  }

  bool _shouldDisableTap(bool enabled) =>
      (widget.screen == null &&
          widget.widget == null &&
          widget.onTap == null) ||
      enabled == false;

  Widget _buildSubtitle() {
    Widget subtitleWidget =
        widget.subtitle != null ? Text(widget.subtitle) : null;
    if (widget.child == null) {
      return subtitleWidget;
    }
    if (subtitleWidget == null) {
      return widget.child;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        subtitleWidget,
        widget.child,
      ],
    );
  }

  _handleTap(BuildContext context) {
    if (widget.screen != null) {
      Navigator.push(
        context,
        CupertinoPageRoute(builder: (context) => widget.screen),
      );
    } else {
      widget.onTap?.call();
    }
  }
}

/// [ExpansionSettingsTile] is a widget that groups settings tiles and other
/// widgets together with a group title and can be expanded or closed.
///
///
/// * Parameters:
///
/// title (required) - Title of the settings tile.
/// icon - Optional [Icon] on the left side.
/// children (required) - Settings tiles or other widgets that will be under
///   this tile.
/// initiallyExpanded - If true, it will be expanded by default. Default: true.
/// visibleIfKey - If not null, the group will only be visible if the value
///   of the given settings key is true.
///   See more in the documentation: Conditional Logic.
/// visibleByDefault - If visibleIfKey is not null and the value of the given
///   key is not saved yet then this value will be the default value.
///   Default: true.
///
///
/// * Examples:
///
/// 1) The following example shows how you can create a simple
/// [ExpansionSettingsTile] with a [CheckboxSettingsTile].
/// ExpansionSettingsTile(
///	  title: 'You can expand & close',
///	  children: <Widget>[
///		  CheckboxSettingsTile(
///			  settingKey: 'key-of-your-setting',
///			  title: 'This is a simple Checkbox',
///		  ),
///	  ],
/// );
class ExpansionSettingsTile extends StatelessWidget {
  final String title;
  final Icon icon;
  final List<Widget> children;
  final String visibleIfKey;
  final bool visibleByDefault;
  final bool initiallyExpanded;

  ExpansionSettingsTile({
    @required this.title,
    this.icon,
    @required this.children,
    this.initiallyExpanded = false,
    this.visibleIfKey,
    this.visibleByDefault = true,
  });

  @override
  Widget build(BuildContext context) {
    if (visibleIfKey == null) {
      return _buildChild(context);
    }
    return Settings().onBoolChanged(
      settingKey: visibleIfKey,
      defaultValue: visibleByDefault,
      childBuilder: (BuildContext context, bool visible) {
        return (visible ?? false) ? _buildChild(context) : Container();
      },
    );
  }

  Widget _buildChild(BuildContext context) {
    return ExpansionTile(
      title: Text(title),
      children: children,
      leading: icon,
      initiallyExpanded: initiallyExpanded,
    );
  }
}

class _SettingsTileDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 0.0,
    );
  }
}

/// [SimpleSettingsTile] is a simple settings tile that can open a new screen
/// by tapping it.
///
///
/// * Parameters:
///
/// title (required) - Title of the tile.
/// subtitle - Subtitle of the tile.
/// icon - Optional [Icon] on the left side.
/// screen - A [SettingsScreen] or [SettingsToggleScreen] that will be opened
///   by tapping the tile. If it is null, the tile will do nothing.
/// visibleIfKey - If not null, the tile will only be visible if the value
///   of the given settings key is true.
///   See more in the documentation: Conditional Logic.
/// enabledIfKey - If not null, the tile will only be enabled if the value
///   of the given settings key is true.
///   See more in the documentation: Conditional Logic.
/// visibleByDefault - If visibleIfKey is not null and the value of the given
///   key is not saved yet then this value will be the default value.
///   Default: true.
///
///
/// * Examples:
///
/// 1) The following example shows how you can create a SimpleSettingsTile that
/// open a new Screen by tapping it.
/// SimpleSettingsTile(
///   title: 'Advanced',
///   subtitle: 'More, advanced settings.'
///   screen: SomeSettingsScreen(
///     title: 'Sub menu',
///     children: <Widget>[
///       CheckboxSettingsTile(
///         settingsKey: 'key-of-your-setting',
///         title: 'This is a simple Checkbox',
///       ),
///     ],
///   ),
/// );
class SimpleSettingsTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Icon icon;
  final Widget screen;
  final String visibleIfKey;
  final String enabledIfKey;
  final bool visibleByDefault;

  SimpleSettingsTile({
    @required this.title,
    this.subtitle,
    this.icon,
    this.screen,
    this.visibleIfKey,
    this.enabledIfKey,
    this.visibleByDefault = true,
  });

  @override
  Widget build(BuildContext context) {
    return _SettingsTile(
      title: title,
      subtitle: subtitle,
      icon: icon,
      screen: screen,
      visibleIfKey: visibleIfKey,
      enabledIfKey: enabledIfKey,
      visibleByDefault: visibleByDefault,
    );
  }
}

/// [CheckboxSettingsTile] is a settings tile with a Checkbox that can be
/// true or false.
///
///
/// * Parameters:
///
/// settingKey (required) - Key name for the checkbox value.
/// title (required) - Title of the tile.
/// defaultValue - Default value of the checkbox. Default: false. Please note,
///   until the user does not change the value, retrieving it via [Settings]
///   will return null.
/// subtitle - The subtitle of the checkbox. Default: On.
/// subtitleIfOff - The subtitle of the checkbox if it is off. If null, parameter
///   called 'subtitle' will be used both cases.
/// icon - Optional [Icon] on the left side.
/// screen - A [SettingsScreen] or [SettingsToggleScreen] that will be opened
///   by tapping the tile.
/// visibleIfKey - If not null, the tile will only be visible if the value
///   of the given settings key is true.
///   See more in the documentation: Conditional Logic.
/// enabledIfKey - If not null, the tile will only be enabled if the value
///   of the given settings key is true.
///   See more in the documentation: Conditional Logic.
/// visibleByDefault - If visibleIfKey is not null and the value of the given
///   key is not saved yet then this value will be the default value.
///   Default: true.
/// confirmText - If not null, a confirmation dialog will appear with this
///   text by enabling or disabling the checkbox.
/// confirmTextToEnable - If not null, a confirmation dialog will appear with
///   this text by enabling the checkbox. It overrides the behaviour of
///   'confirmText'.
/// confirmTextToDisable - If not null, a confirmation dialog will appear with
///   this text by disabling the checkbox. It overrides the behaviour of
///   'confirmText'.
/// confirmModalTitle - Title of the confirmation dialog. Default: Confirmation.
/// confirmModalCancelCaption - Caption of the cancel button in the confirmation
///   dialog. Default: Cancel.
/// confirmModalConfirmCaption - Caption of the confirm button in the
///   confirmation dialog. Default: Confirm.
///
///
/// * Examples:
///
/// 1) The following example shows how you can create a tile with checkbox.
/// CheckboxSettingsTile(
///	  settingsKey: 'key-of-your-setting',
///	  title: 'This is a Checkbox',
/// );
///
/// 2) In this example, we create a tile using more parameters.
/// CheckboxSettingsTile(
///   settingsKey: 'wifi_status',
/// 	title: 'Wi-Fi',
/// 	subtitle: 'Connected.',
/// 	subtitleIfOff: 'To see available networks, turn on Wi-Fi.',
/// 	screen: SettingsToggleScreen(
/// 		settingsKey: 'wifi_status',
/// 		subtitle: 'Connected',
/// 		subtitleIfOff: 'To see available networks, turn on Wi-Fi.',
/// 		children: <Widget>[
/// 			SettingsContainer(
/// 				children: <Widget>[
/// 					Text('Put some widgets or tiles here.'),
/// 				],
/// 			),
/// 		],
/// 		children: <Widget>[
/// 			SettingsContainer(
/// 				children: <Widget>[
/// 					Text('You are offline.'),
/// 					Text('Put some widgets or tiles here.'),
/// 				],
/// 			),
/// 		],
/// 	),
/// );
///
/// 3) In this example, the second checkbox will only be enabled if the first
/// one is also. The third checkbox will only be visible if the first one is
/// as well.
/// CheckboxSettingsTile(
/// 	settingsKey: 'checkbox1',
/// 	title: 'Checkbox1',
/// );
/// CheckboxSettingsTile(
/// 	settingsKey: 'checkbox2',
/// 	title: 'Checkbox2',
/// 	subtitle: 'Checkbox1 is enabled, therefore it is enabled.',
/// 	subtitleIfOff: 'Checkbox1 is disabled, therefore it is disabled as well.',
/// 	enabledIfKey: 'checkbox1',
/// );
/// CheckboxSettingsTile(
/// 	settingsKey: 'checkbox3',
/// 	title: 'Checkbox3',
/// 	subtitle: 'Checkbox1 is enabled, therefore it is visible.',
/// 	visibleIfKey: 'checkbox1',
/// );
class CheckboxSettingsTile extends StatefulWidget {
  final String settingKey;
  final String title;
  final bool defaultValue;
  final String subtitle;
  final String subtitleIfOff;
  final Icon icon;
  final Widget screen;
  final String visibleIfKey;
  final String enabledIfKey;
  final bool visibleByDefault;
  final String confirmText;
  final String confirmTextToEnable;
  final String confirmTextToDisable;
  final String confirmModalTitle;
  final String confirmModalCancelCaption;
  final String confirmModalConfirmCaption;

  CheckboxSettingsTile({
    @required this.settingKey,
    @required this.title,
    this.defaultValue = false,
    this.subtitle,
    this.subtitleIfOff,
    this.icon,
    this.screen,
    this.visibleIfKey,
    this.enabledIfKey,
    this.visibleByDefault = true,
    this.confirmText,
    this.confirmTextToEnable,
    this.confirmTextToDisable,
    this.confirmModalTitle,
    this.confirmModalCancelCaption,
    this.confirmModalConfirmCaption,
  });

  @override
  State<StatefulWidget> createState() => _CheckboxSettingsTileState();
}

class _CheckboxSettingsTileState extends State<CheckboxSettingsTile>
    with _Confirmable, _Enableable {
  bool value;

  @override
  void initState() {
    super.initState();
    value = widget.defaultValue;
    Future.delayed(Duration.zero, () {
      Settings().pingBool(widget.settingKey, widget.defaultValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    return wrapEnableable(
      context: context,
      enabledIfKey: widget.enabledIfKey,
      visibleByDefault: widget.visibleByDefault,
      childBuilder: (BuildContext context, bool enabled) {
        return Settings().onBoolChanged(
          settingKey: widget.settingKey,
          defaultValue:
              getDefaultValue<bool>(widget.settingKey, widget.defaultValue),
          childBuilder: (BuildContext context, bool value) {
            return _SettingsTile(
              title: widget.title,
              subtitle: value == true || widget.subtitleIfOff == null
                  ? widget.subtitle
                  : widget.subtitleIfOff,
              icon: widget.icon,
              screen: widget.screen,
              visibleIfKey: widget.visibleIfKey,
              enabledIfKey: widget.enabledIfKey,
              visibleByDefault: widget.visibleByDefault,
              onTap: () => _onChanged(!value),
              widget: _SettingsCheckbox(
                value: value,
                onChanged: _onChanged,
                enabled: enabled,
              ),
            );
          },
        );
      },
    );
  }

  void _onChanged(bool newValue) {
    confirm(
      context: context,
      oldValue: value,
      newValue: newValue,
      onConfirm: () {
        setState(() {
          value = newValue;
          Settings().save(widget.settingKey, value);
        });
      },
      confirmText: widget.confirmText,
      confirmTextToEnable: widget.confirmTextToEnable,
      confirmTextToDisable: widget.confirmTextToDisable,
      confirmModalTitle: widget.confirmModalTitle,
      confirmModalConfirmCaption: widget.confirmModalConfirmCaption,
      confirmModalCancelCaption: widget.confirmModalCancelCaption,
    );
  }
}

/// [SwitchSettingsTile] is a settings tile with a Switch that can be
/// true or false.
///
///
/// * Parameters:
///
/// settingKey (required) - Key name for the switch value.
/// title (required) - Title of the tile.
/// defaultValue - Default value of the switch. Default: false. Please note,
///   until the user does not change the value, retrieving it via [Settings]
///   will return null.
/// subtitle - The subtitle of the switch. Default: On.
/// subtitleIfOff - The subtitle of the switch if it is off. If null, parameter
///   called 'subtitle' will be used both cases.
/// icon - Optional [Icon] on the left side.
/// screen - A [SettingsScreen] or [SettingsToggleScreen] that will be opened
///   by tapping the tile.
/// visibleIfKey - If not null, the tile will only be visible if the value
///   of the given settings key is true.
///   See more in the documentation: Conditional Logic.
/// enabledIfKey - If not null, the tile will only be enabled if the value
///   of the given settings key is true.
///   See more in the documentation: Conditional Logic.
/// visibleByDefault - If visibleIfKey is not null and the value of the given
///   key is not saved yet then this value will be the default value.
///   Default: true.
/// confirmText - If not null, a confirmation dialog will appear with this
///   text by enabling or disabling the checkbox.
/// confirmTextToEnable - If not null, a confirmation dialog will appear with
///   this text by enabling the checkbox. It overrides the behaviour of
///   'confirmText'.
/// confirmTextToDisable - If not null, a confirmation dialog will appear with
///   this text by disabling the checkbox. It overrides the behaviour of
///   'confirmText'.
/// confirmModalTitle - Title of the confirmation dialog. Default: Confirmation.
/// confirmModalCancelCaption - Caption of the cancel button in the confirmation
///   dialog. Default: Cancel.
/// confirmModalConfirmCaption - Caption of the confirm button in the
///   confirmation dialog. Default: Confirm.
///
///
/// * Examples:
///
/// 1) The following example shows how you can create a tile with switch.
/// SwitchSettingsTile(
///	  settingsKey: 'key-of-your-setting',
///	  title: 'This is a Switch',
/// );
///
/// 2) In this example, we create a tile using more parameters.
/// SwitchSettingsTile(
///   settingsKey: 'wifi_status',
/// 	title: 'Wi-Fi',
/// 	subtitle: 'Connected.',
/// 	subtitleIfOff: 'To see available networks, turn on Wi-Fi.',
/// 	screen: SettingsToggleScreen(
/// 		settingsKey: 'wifi_status',
/// 		subtitle: 'Connected',
/// 		subtitleIfOff: 'To see available networks, turn on Wi-Fi.',
/// 		children: <Widget>[
/// 			SettingsContainer(
/// 				children: <Widget>[
/// 					Text('Put some widgets or tiles here.'),
/// 				],
/// 			),
/// 		],
/// 		children: <Widget>[
/// 			SettingsContainer(
/// 				children: <Widget>[
/// 					Text('You are offline.'),
/// 					Text('Put some widgets or tiles here.'),
/// 				],
/// 			),
/// 		],
/// 	),
/// );
///
/// 3) In this example, the second checkbox will only be enabled if the first
/// one is also. The third switch will only be visible if the first one is
/// as well.
/// SwitchSettingsTile(
/// 	settingsKey: 'switch1',
/// 	title: 'switch1',
/// );
/// SwitchSettingsTile(
/// 	settingsKey: 'switch2',
/// 	title: 'Switch2',
/// 	subtitle: 'Switch1 is enabled, therefore it is enabled.',
/// 	subtitleIfOff: 'Switch1 is disabled, therefore it is disabled as well.',
/// 	enabledIfKey: 'Switch1',
/// );
/// SwitchSettingsTile(
/// 	settingsKey: 'switch3',
/// 	title: 'Switch3',
/// 	subtitle: 'Switch1 is enabled, therefore it is visible.',
/// 	visibleIfKey: 'switch1',
/// );
class SwitchSettingsTile extends StatefulWidget {
  final String settingKey;
  final bool defaultValue;
  final String title;
  final String subtitle;
  final String subtitleIfOff;
  final Icon icon;
  final Widget screen;
  final String visibleIfKey;
  final String enabledIfKey;
  final bool visibleByDefault;
  final String confirmText;
  final String confirmTextToEnable;
  final String confirmTextToDisable;
  final String confirmModalTitle;
  final String confirmModalCancelCaption;
  final String confirmModalConfirmCaption;

  SwitchSettingsTile({
    @required this.settingKey,
    @required this.title,
    this.defaultValue = false,
    this.subtitle,
    this.subtitleIfOff,
    this.icon,
    this.screen,
    this.visibleIfKey,
    this.enabledIfKey,
    this.visibleByDefault = true,
    this.confirmText,
    this.confirmTextToEnable,
    this.confirmTextToDisable,
    this.confirmModalTitle,
    this.confirmModalCancelCaption,
    this.confirmModalConfirmCaption,
  });

  @override
  State<StatefulWidget> createState() => _SwitchSettingsTileState();
}

class _SwitchSettingsTileState extends State<SwitchSettingsTile>
    with _Confirmable, _Enableable {
  bool value;

  @override
  void initState() {
    super.initState();
    value = widget.defaultValue;
    Future.delayed(Duration.zero, () {
      Settings().pingBool(widget.settingKey, widget.defaultValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    return wrapEnableable(
      context: context,
      enabledIfKey: widget.enabledIfKey,
      visibleByDefault: widget.visibleByDefault,
      childBuilder: (BuildContext context, bool enabled) {
        return Settings().onBoolChanged(
          settingKey: widget.settingKey,
          defaultValue:
              getDefaultValue<bool>(widget.settingKey, widget.defaultValue),
          childBuilder: (BuildContext context, bool value) {
            return _SettingsTile(
              title: widget.title,
              subtitle: value == true || widget.subtitleIfOff == null
                  ? widget.subtitle
                  : widget.subtitleIfOff,
              icon: widget.icon,
              screen: widget.screen,
              visibleIfKey: widget.visibleIfKey,
              visibleByDefault: widget.visibleByDefault,
              onTap: () => _onChanged(!value),
              widget: _SettingsSwitch(
                value: value,
                onChanged: _onChanged,
                enabled: enabled,
              ),
            );
          },
        );
      },
    );
  }

  void _onChanged(bool newValue, [update = true]) {
    confirm(
      context: context,
      oldValue: value,
      newValue: newValue,
      onConfirm: () {
        if (update) {
          setState(() {
            _change(newValue);
          });
        } else {
          _change(newValue);
        }
      },
      confirmText: widget.confirmText,
      confirmTextToEnable: widget.confirmTextToEnable,
      confirmTextToDisable: widget.confirmTextToDisable,
      confirmModalTitle: widget.confirmModalTitle,
      confirmModalConfirmCaption: widget.confirmModalConfirmCaption,
      confirmModalCancelCaption: widget.confirmModalCancelCaption,
    );
  }

  void _change(bool newValue) {
    value = newValue;
    Settings().save(widget.settingKey, value);
  }
}

/// [RadioSettingsTile] consist of a tile with title and subtitle and additional
/// tiles according to the given key set.
///
///
/// * Parameters:
///
/// settingKey (required) - Key name for the tile value.
/// title (required) - Title of the tile.
/// values (required) - Key-name pairs, eg.: {'first': 'First option you can
///   choose'}
/// defaultKey - Default key from the key set. Please note,
///   until the user does not change the value, retrieving it via [Settings]
///   will return null.
/// subtitle - The subtitle of the tile. Please note, if 'expandable' is true, it
///   is unused.
/// subtitleIfOff - The subtitle of the tile if it has not value yet. If null,
///   parameter called 'subtitle' will be used both cases. Please note, if
///   'expandable' is true, it is unused.
/// icon - Optional [Icon] on the left side.
/// screen - A [SettingsScreen] or [SettingsToggleScreen] that will be opened
///   by tapping the tile.
/// visibleIfKey - If not null, the tile will only be visible if the value
///   of the given settings key is true.
///   See more in the documentation: Conditional Logic.
/// enabledIfKey - If not null, the tile will only be enabled if the value
///   of the given settings key is true.
///   See more in the documentation: Conditional Logic.
/// visibleByDefault - If visibleIfKey is not null and the value of the given
///   key is not saved yet then this value will be the default value.
///   Default: true.
/// expandable - If true, it will behave like an [ExpansionSettingsTile].
///   Default: false.
/// initiallyExpanded - As an [ExpansionSettingsTile], you can choose it to be
///   expanded or not by default. Default: true
/// confirmText - If not null, a confirmation dialog will appear with this
///   text by enabling or disabling the checkbox.
/// confirmModalTitle - Title of the confirmation dialog. Default: Confirmation.
/// confirmModalCancelCaption - Caption of the cancel button in the confirmation
///   dialog. Default: Cancel.
/// confirmModalConfirmCaption - Caption of the confirm button in the
///   confirmation dialog. Default: Confirm.
///
///
/// * Examples:
///
/// 1) The following example shows how you can create a simple radio seggings
/// tile.
/// RadioSettingsTile(
/// 	settingKey: 'key-of-your-setting',
/// 	title: 'Select one option',
/// 	values: {
/// 		'a': 'Option A',
/// 		'b': 'Option B',
/// 		'c': 'Option C',
/// 		'd': 'Option D',
/// 	},
/// );
class RadioSettingsTile extends StatefulWidget {
  final String settingKey;
  final String title;
  final Map<String, String> values;
  final defaultKey;
  final String subtitle;
  final String subtitleIfOff;
  final Icon icon;
  final Widget screen;
  final String visibleIfKey;
  final String enabledIfKey;
  final bool visibleByDefault;
  final bool expandable;
  final bool initiallyExpanded;
  final String confirmText;
  final String confirmModalTitle;
  final String confirmModalCancelCaption;
  final String confirmModalConfirmCaption;

  RadioSettingsTile({
    @required this.settingKey,
    @required this.title,
    @required this.values,
    this.defaultKey,
    this.subtitle,
    this.subtitleIfOff,
    this.icon,
    this.screen,
    this.visibleIfKey,
    this.enabledIfKey,
    this.visibleByDefault = true,
    this.expandable = false,
    this.initiallyExpanded = false,
    this.confirmText,
    this.confirmModalTitle,
    this.confirmModalCancelCaption,
    this.confirmModalConfirmCaption,
  });

  @override
  State<StatefulWidget> createState() => _RadioSettingsTileState();
}

class _RadioSettingsTileState extends State<RadioSettingsTile>
    with _Confirmable, _Enableable {
  String selectedKey;
  String selectedTitle;

  @override
  void initState() {
    super.initState();
    selectedKey = widget.defaultKey;
    Future.delayed(Duration.zero, () {
      Settings().pingString(widget.settingKey, widget.defaultKey);
    });
  }

  @override
  Widget build(BuildContext context) {
    return wrapEnableable(
      context: context,
      enabledIfKey: widget.enabledIfKey,
      visibleByDefault: widget.visibleByDefault,
      childBuilder: (BuildContext context, bool enabled) {
        return Settings().onStringChanged(
          settingKey: widget.settingKey,
          defaultValue: getDefaultValue<String>(widget.settingKey, selectedKey),
          childBuilder: (BuildContext context, String value) {
            _change(value);
            List<Widget> elements = List<Widget>();
            elements.add(_buildTile(value, enabled));
            if (widget.values != null &&
                widget.values.isNotEmpty &&
                !widget.expandable) {
              elements.addAll(_buildChildren(value, enabled));
            }
            return Column(children: elements);
          },
        );
      },
    );
  }

  Widget _buildTile(String groupValue, bool enabled) {
    String subtitle = selectedTitle != null
        ? widget.subtitle ?? selectedTitle
        : widget.subtitleIfOff;
    return widget.expandable
        ? ExpansionSettingsTile(
            title: widget.title,
            icon: widget.icon,
            visibleIfKey: widget.visibleIfKey,
            visibleByDefault: widget.visibleByDefault,
            initiallyExpanded: widget.initiallyExpanded,
            children: _buildChildren(groupValue, enabled),
          )
        : _SettingsTile(
            title: widget.title,
            subtitle: subtitle,
            icon: widget.icon,
            screen: widget.screen,
            visibleIfKey: widget.visibleIfKey,
            visibleByDefault: widget.visibleByDefault,
          );
  }

  List<Widget> _buildChildren(String groupValue, bool enabled) {
    List<Widget> elements = List<Widget>();
    widget.values.forEach((optionKey, optionName) {
      elements.add(_SimpleRadioSettingsTile(
        title: optionName,
        value: optionKey,
        groupValue: groupValue,
        onChanged: _onChanged,
        enabled: enabled,
      ));
    });
    return elements;
  }

  String _getNameByKey(String key) =>
      widget.values.containsKey(key) ? widget.values[key] : null;

  void _onChanged(String newKey) {
    confirm(
      context: context,
      oldValue: selectedKey,
      newValue: newKey,
      onConfirm: () {
        setState(() {
          _change(newKey);
          Settings().save(widget.settingKey, selectedKey);
        });
      },
      confirmText: widget.confirmText,
      confirmModalTitle: widget.confirmModalTitle,
      confirmModalConfirmCaption: widget.confirmModalConfirmCaption,
      confirmModalCancelCaption: widget.confirmModalCancelCaption,
    );
  }

  void _change(String newKey) {
    selectedKey = newKey;
    selectedTitle = _getNameByKey(selectedKey);
  }
}

class _SimpleRadioSettingsTile extends StatelessWidget {
  final String title;
  final String value;
  final String groupValue;
  final ValueChanged<String> onChanged;
  final bool enabled;

  _SimpleRadioSettingsTile({
    @required this.title,
    @required this.value,
    @required this.groupValue,
    @required this.onChanged,
    @required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return _SettingsTile(
      title: title,
      onTap: () => onChanged(this.value),
      widget: _SettingsRadio(
        groupValue: groupValue,
        value: value,
        onChanged: onChanged,
        enabled: enabled,
      ),
    );
  }
}

/// [SliderSettingsTile] is a settings tile with a slider within a given range.
///
///
/// * Parameters:
///
/// settingKey (required) - Key name for the slider value.
/// title (required) - Title of the tile.
/// defaultValue - Default value of the slider. Default: 0.0. Please note,
///   until the user does not change the value, retrieving it via [Settings]
///   will return null.
/// minValue - Minimal value of the slider. Default: 0.0
/// maxValue - Maximal value of the slider. Default: 100.0
/// step - Determines the size or amount of each interval or step the slider
///   takes between the min and max. The full specified value range of the
///   slider (max - min) should be evenly divisible by the step. Default: 1.0
/// subtitle - The subtitle of the tile.
/// icon - Optional [Icon] on the left side.
/// minIcon - Optional [Icon] on the left side of the slider.
/// maxIcon - Optional [Icon] on the right side of the slider. If null, the
///   current value of the slider will be shown instead.
/// visibleIfKey - If not null, the tile will only be visible if the value
///   of the given settings key is true.
///   See more in the documentation: Conditional Logic.
/// enabledIfKey - If not null, the tile will only be enabled if the value
///   of the given settings key is true.
///   See more in the documentation: Conditional Logic.
/// visibleByDefault - If visibleIfKey is not null and the value of the given
///   key is not saved yet then this value will be the default value.
///   Default: true.
/// confirmText - If not null, a confirmation dialog will appear with this
///   text by enabling or disabling the checkbox.
/// confirmModalTitle - Title of the confirmation dialog. Default: Confirmation.
/// confirmModalCancelCaption - Caption of the cancel button in the confirmation
///   dialog. Default: Cancel.
/// confirmModalConfirmCaption - Caption of the confirm button in the
///   confirmation dialog. Default: Confirm.
///
///
/// * Examples:
///
/// 1) The following example shows how you can create a tile with a slider.
/// SliderSettingsTile(
/// 	settingKey: 'key-of-your-setting',
/// 	title: 'Brightness',
/// 	minIcon: Icon(Icons.brightness_4),
/// 	maxIcon: Icon(Icons.brightness_7),
/// );
///
/// 2) In this example, we create a slider tile using more parameters.
/// SliderSettingsTile(
///   settingKey: 'key-of-your-setting',
///   title: 'Rate this app',
///   subtitle: 'How would you rate this app in a 5 to 1 scale?',
///   minValue: 1.0,
///   maxValue: 5.0,
///   step: 1.0,
/// );
class SliderSettingsTile extends StatefulWidget {
  final String settingKey;
  final String title;
  final double defaultValue;
  final double minValue;
  final double maxValue;
  final double step;
  final String subtitle;
  final Icon icon;
  final Icon minIcon;
  final Icon maxIcon;
  final String visibleIfKey;
  final String enabledIfKey;
  final bool visibleByDefault;
  final String confirmText;
  final String confirmTextToEnable;
  final String confirmTextToDisable;
  final String confirmModalTitle;
  final String confirmModalCancelCaption;
  final String confirmModalConfirmCaption;

  SliderSettingsTile({
    @required this.settingKey,
    @required this.title,
    this.defaultValue = 0.0,
    this.minValue = 0.0,
    this.maxValue = 100.0,
    this.step = 1.0,
    this.subtitle,
    this.icon,
    this.minIcon,
    this.maxIcon,
    this.visibleIfKey,
    this.enabledIfKey,
    this.visibleByDefault = true,
    this.confirmText,
    this.confirmTextToEnable,
    this.confirmTextToDisable,
    this.confirmModalTitle,
    this.confirmModalCancelCaption,
    this.confirmModalConfirmCaption,
  });

  @override
  State<StatefulWidget> createState() => _SliderSettingsTileState();
}

class _SliderSettingsTileState extends State<SliderSettingsTile>
    with _Confirmable, _Enableable {
  double value;

  @override
  void initState() {
    super.initState();
    value = widget.defaultValue;
    Future.delayed(Duration.zero, () {
      Settings().pingDouble(widget.settingKey, widget.defaultValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    return wrapEnableable(
      context: context,
      enabledIfKey: widget.enabledIfKey,
      visibleByDefault: widget.visibleByDefault,
      childBuilder: (BuildContext context, bool enabled) {
        return Settings().onDoubleChanged(
          settingKey: widget.settingKey,
          defaultValue: getDefaultValue<double>(widget.settingKey, value),
          childBuilder: (BuildContext context, double value) {
            return _SettingsTile(
              title: widget.title,
              subtitle: widget.subtitle,
              icon: widget.icon,
              visibleIfKey: widget.visibleIfKey,
              visibleByDefault: widget.visibleByDefault,
              child: _SettingsSlider(
                value: value,
                min: widget.minValue,
                max: widget.maxValue,
                step: widget.step,
                onChanged: _onChanged,
                enabled: enabled,
                leading: widget.minIcon ?? Container(),
                trailing: widget.maxIcon ?? Container(),
              ),
            );
          },
        );
      },
    );
  }

  void _onChanged(double newValue) {
    confirm(
      context: context,
      oldValue: value,
      newValue: newValue,
      onConfirm: () {
        setState(() {
          value = newValue;
          Settings().save(widget.settingKey, value);
        });
      },
      confirmText: widget.confirmText,
      confirmTextToEnable: widget.confirmTextToEnable,
      confirmTextToDisable: widget.confirmTextToDisable,
      confirmModalTitle: widget.confirmModalTitle,
      confirmModalConfirmCaption: widget.confirmModalConfirmCaption,
      confirmModalCancelCaption: widget.confirmModalCancelCaption,
    );
  }
}

class _ModalSettingsTile extends StatefulWidget {
  final String settingKey;
  final String defaultValue;
  final String title;
  final String subtitle;
  final Icon icon;
  final Widget leading;
  final String visibleIfKey;
  final String enabledIfKey;
  final bool visibleByDefault;
  final Function valueToTitle;
  final Function buildChild;
  final bool refreshStateOnChange;
  final ValueChanged<String> onChanged;
  final String cancelCaption;
  final String okCaption;
  final String confirmText;
  final String confirmTextToEnable;
  final String confirmTextToDisable;
  final String confirmModalTitle;
  final String confirmModalCancelCaption;
  final String confirmModalConfirmCaption;
  final Function valueMap;
  final obfuscateSubtitle;

  _ModalSettingsTile({
    @required this.settingKey,
    this.defaultValue,
    @required this.title,
    this.subtitle,
    this.icon,
    this.leading,
    this.visibleIfKey,
    this.enabledIfKey,
    this.visibleByDefault = true,
    @required this.valueToTitle,
    @required this.buildChild,
    this.refreshStateOnChange = true,
    this.onChanged,
    this.cancelCaption = "Cancel",
    this.okCaption = "Ok",
    this.confirmText,
    this.confirmTextToEnable,
    this.confirmTextToDisable,
    this.confirmModalTitle,
    this.confirmModalCancelCaption,
    this.confirmModalConfirmCaption,
    this.valueMap,
    this.obfuscateSubtitle = false,
  });

  @override
  __ModalSettingsTileState createState() => __ModalSettingsTileState();
}

class __ModalSettingsTileState extends State<_ModalSettingsTile>
    with _Confirmable, _Enableable {
  String value;

  @override
  void initState() {
    super.initState();
    value = widget.defaultValue;
    Future.delayed(Duration.zero, () {
      Settings().pingString(widget.settingKey, widget.defaultValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    return wrapEnableable(
      context: context,
      enabledIfKey: widget.enabledIfKey,
      visibleByDefault: widget.visibleByDefault,
      childBuilder: (BuildContext context, bool enabled) {
        return Settings().onStringChanged(
          settingKey: widget.settingKey,
          defaultValue:
              getDefaultValue<String>(widget.settingKey, widget.defaultValue),
          childBuilder: (BuildContext context, String value) {
            return _SettingsTile(
              title: widget.title,
              subtitle: _getSubtitle(value),
              icon: widget.icon,
              leading: widget.leading,
              visibleIfKey: widget.visibleIfKey,
              enabledIfKey: widget.enabledIfKey,
              visibleByDefault: widget.visibleByDefault,
              onTap: enabled
                  ? () {
                      _openModal(context, value);
                    }
                  : null,
            );
          },
        );
      },
    );
  }

  String _getSubtitle(String value) {
    return widget.valueToTitle(value) != null
        ? widget.subtitle ??
            (!widget.obfuscateSubtitle
                ? widget.valueToTitle(value)
                : value.isNotEmpty
                    ? widget.valueToTitle('●' * value.length)
                    : "Not Set")
        : null;
  }

  void _onChanged(String newValue) {
    confirm(
      context: context,
      oldValue: value,
      newValue: newValue,
      onConfirm: () {
        setState(() {
          value =
              widget.valueMap != null ? widget.valueMap(newValue) : newValue;
          Settings().save(widget.settingKey, value);
          widget.onChanged?.call(value);
        });
      },
      confirmText: widget.confirmText,
      confirmTextToEnable: widget.confirmTextToEnable,
      confirmTextToDisable: widget.confirmTextToDisable,
      confirmModalTitle: widget.confirmModalTitle,
      confirmModalConfirmCaption: widget.confirmModalConfirmCaption,
      confirmModalCancelCaption: widget.confirmModalCancelCaption,
    );
  }

  void _openModal(BuildContext context, String value) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _SettingsModal(
          title: widget.title,
          onSelected: _onChanged,
          initialValue: value,
          buildChild: widget.buildChild,
          refreshStateOnChange: widget.refreshStateOnChange,
          cancelCaption: widget.cancelCaption,
          okCaption: widget.okCaption,
        );
      },
    );
  }
}

class _SettingsModal extends StatefulWidget {
  final String title;
  final Function buildChild;
  final String initialValue;
  final ValueChanged<String> onSelected;
  final bool refreshStateOnChange;
  final String cancelCaption;
  final String okCaption;

  _SettingsModal({
    @required this.title,
    @required this.buildChild,
    @required this.initialValue,
    @required this.onSelected,
    this.refreshStateOnChange,
    this.cancelCaption = "Cancel",
    this.okCaption = "Ok",
  });

  @override
  __SettingsModalState createState() => __SettingsModalState();
}

class __SettingsModalState extends State<_SettingsModal> {
  String value;

  @override
  void initState() {
    super.initState();
    value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: widget.buildChild(value, _onChanged),
      actions: <Widget>[
        FlatButton(
          child: Text(
            widget.cancelCaption,
            style: TextStyle(color: Theme.of(context).disabledColor),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text(widget.okCaption),
          onPressed: () {
            Navigator.of(context).pop();
            widget.onSelected(value);
          },
        ),
      ],
    );
  }

  void _onChanged(String newValue) {
    if (widget.refreshStateOnChange) {
      setState(() {
        _handleChange(newValue);
      });
    } else {
      _handleChange(newValue);
    }
  }

  void _handleChange(String newValue) {
    value = newValue;
  }
}

/// [RadioPickerSettingsTile] is a simple tile that launches a modal dialog
/// with radio buttons.
///
///
/// * Parameters:
///
/// settingKey (required) - Key name for the tile value.
/// title (required) - Title of the tile.
/// values (required) - Key-name pairs, eg.: {'first': 'First option you can
///   choose'}
/// defaultKey - Default key from the key set. Please note,
///   until the user does not change the value, retrieving it via [Settings]
///   will return null.
/// subtitle - The subtitle of the tile.
/// icon - Optional [Icon] on the left side.
/// cancelCaption - Caption of the Cancel button. Default: Cancel.
/// okCaption - Caption of the Ok button. Default: Ok.
/// visibleIfKey - If not null, the tile will only be visible if the value
///   of the given settings key is true.
///   See more in the documentation: Conditional Logic.
/// enabledIfKey - If not null, the tile will only be enabled if the value
///   of the given settings key is true.
///   See more in the documentation: Conditional Logic.
/// visibleByDefault - If visibleIfKey is not null and the value of the given
///   key is not saved yet then this value will be the default value.
///   Default: true.
///
///
/// * Examples:
///
/// 1) The following example shows how you can create a tile that launches
/// a modal dialog with radio buttons.
/// RadioPickerSettingsTile(
/// 	settingsKey: 'key-of-your-setting',
/// 	title: 'Choose one in the modal dialog',
/// 	values: {
/// 		'a': 'Option A',
/// 		'b': 'Option B',
/// 		'c': 'Option C',
/// 		'd': 'Option D',
/// 	},
/// 	defaultKey: 'b',
/// );
class RadioPickerSettingsTile extends StatelessWidget {
  final String settingKey;
  final String title;
  final String subtitle;
  final Map<String, String> values;
  final String defaultKey;
  final Icon icon;
  final String cancelCaption;
  final String okCaption;
  final String visibleIfKey;
  final String enabledIfKey;
  final bool visibleByDefault;

  RadioPickerSettingsTile({
    @required this.settingKey,
    @required this.title,
    @required this.values,
    this.defaultKey,
    this.subtitle,
    this.icon,
    this.cancelCaption = "Cancel",
    this.okCaption = "Ok",
    this.visibleIfKey,
    this.enabledIfKey,
    this.visibleByDefault = true,
  });

  @override
  Widget build(BuildContext context) {
    return _ModalSettingsTile(
      settingKey: settingKey,
      title: title,
      subtitle: subtitle,
      icon: icon,
      defaultValue: getDefaultValue<String>(settingKey, defaultKey),
      valueToTitle: (String key) => values[key],
      visibleIfKey: visibleIfKey,
      enabledIfKey: enabledIfKey,
      visibleByDefault: visibleByDefault,
      buildChild: (String value, Function onChanged) {
        // TODO: Scroll to the selected value.
        return Container(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            //controller: scrollController,
            itemCount: values.length,
            itemBuilder: (BuildContext context, int index) {
              String key = values.keys.toList()[index];
              return _SimpleRadioSettingsTile(
                title: values[key],
                value: key,
                groupValue: value,
                onChanged: onChanged,
                enabled: true,
              );
            },
          ),
        );
      },
      cancelCaption: cancelCaption,
      okCaption: okCaption,
    );
  }
}

/// [TextFieldModalSettingsTile] is a simple tile that launches a modal dialog
/// with a text input.
///
///
/// * Parameters:
///
/// settingKey (required) - Key name for the tile value.
/// title (required) - Title of the tile.
/// defaultValue - Default value of the input Default: ''. Please note,
///   until the user does not change the value, retrieving it via [Settings]
///   will return null.
/// subtitle - The subtitle of the tile.
/// icon - Optional [Icon] on the left side.
/// cancelCaption - Caption of the Cancel button. Default: Cancel.
/// okCaption - Caption of the Ok button. Default: Ok.
/// keyboardType - The type of information for which to optimize the text input
///   control. See more at [TextInputType].
/// visibleIfKey - If not null, the tile will only be visible if the value
///   of the given settings key is true.
///   See more in the documentation: Conditional Logic.
/// enabledIfKey - If not null, the tile will only be enabled if the value
///   of the given settings key is true.
///   See more in the documentation: Conditional Logic.
/// visibleByDefault - If visibleIfKey is not null and the value of the given
///   key is not saved yet then this value will be the default value.
///   Default: true.
/// obscureText - If true, susbtitle and textinputfield will be black dots.
///
///
/// * Examples:
///
/// 1) The following example shows how you can create a tile that launches
/// a modal dialog with a text input.
/// TextFieldModalSettingsTile(
/// 	settingsKey: 'key-of-your-setting',
/// 	title: 'Type something',
/// );
///
/// 2) In this example, we create a text field modal tile using more parameters.
/// By giving an emailAddress keyboardType, the phone's keyboard will be
/// optimized to type email addresses easily.
/// TextFieldModalSettingsTile(
/// 	settingsKey: 'key-of-your-setting',
/// 	title: 'Type your email',
/// 	defaultValue: 'This is by default.',
/// 	cancelCaption: 'Cancel',
/// 	okCaption: 'Save Email',
/// 	keyboardType: TextInputType.emailAddress,
/// );

class TextFieldModalSettingsTile extends StatelessWidget {
  final String settingKey;
  final String title;
  final String subtitle;
  final String defaultValue;
  final Icon icon;
  final String cancelCaption;
  final String okCaption;
  final TextInputType keyboardType;
  final String visibleIfKey;
  final String enabledIfKey;
  final bool visibleByDefault;
  final bool obscureText;

  TextFieldModalSettingsTile({
    @required this.settingKey,
    @required this.title,
    this.defaultValue,
    this.subtitle,
    this.icon,
    this.cancelCaption = "Cancel",
    this.okCaption = "Ok",
    this.keyboardType,
    this.visibleIfKey,
    this.enabledIfKey,
    this.visibleByDefault = true,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return _ModalSettingsTile(
      settingKey: settingKey,
      title: title,
      subtitle: subtitle,
      obfuscateSubtitle: obscureText,
      icon: icon,
      defaultValue: getDefaultValue<String>(settingKey, defaultValue),
      valueToTitle: (String key) => key,
      refreshStateOnChange: false,
      visibleIfKey: visibleIfKey,
      enabledIfKey: enabledIfKey,
      visibleByDefault: visibleByDefault,
      buildChild: (String value, Function onChanged) {
        TextEditingController _controller = TextEditingController();
        _controller.text = value;
        _controller.addListener(() {
          onChanged(_controller.text);
        });
        return TextFormField(
          autofocus: true,
          controller: _controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
        );
      },
      cancelCaption: cancelCaption,
      okCaption: okCaption,
    );
  }
}

class _ColorWidget {
  String _valueToTitle(String value) {
    String color = "00000000";
    try {
      color = value.split('0x')[1].split(')')[0];
    } catch (e, s) {
      print('_valueToTitle(): caught exception $e: $s');
    }
    return "0x$color";
  }

  Color _getColorByString(String value) {
    Color color = Colors.black;
    try {
      color = Color(int.parse(value.split('0x')[1].split(')')[0], radix: 16));
    } catch (e, s) {
      print('_getColorByString(): caught exception $e: $s');
    }
    return color;
  }
}

class _ColorPickerSettingsTile extends StatelessWidget with _ColorWidget {
  final String settingKey;
  final String title;
  final String subtitle;
  final String defaultValue;
  final Icon icon;
  final String visibleIfKey;
  final String enabledIfKey;
  final bool visibleByDefault;
  final String cancelCaption;
  final String okCaption;
  final Function childBuilder;
  final Function valueToTitle;
  final String confirmText;
  final String confirmModalTitle;
  final String confirmModalCancelCaption;
  final String confirmModalConfirmCaption;

  _ColorPickerSettingsTile({
    @required this.settingKey,
    @required this.title,
    this.defaultValue,
    this.subtitle,
    this.icon,
    this.visibleIfKey,
    this.enabledIfKey,
    this.visibleByDefault = true,
    this.cancelCaption = "Cancel",
    this.okCaption = "Ok",
    @required this.childBuilder,
    @required this.valueToTitle,
    this.confirmText,
    this.confirmModalTitle,
    this.confirmModalCancelCaption,
    this.confirmModalConfirmCaption,
  });

  @override
  Widget build(BuildContext context) {
    return Settings().onStringChanged(
      settingKey: settingKey,
      defaultValue: defaultValue,
      childBuilder: (BuildContext context, String value) {
        Widget leading = Container(
          width: 40.0,
          height: 40.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50.0),
            color: _getColorByString(value),
          ),
        );
        return _ModalSettingsTile(
          settingKey: settingKey,
          title: title,
          subtitle: subtitle,
          icon: icon,
          leading: leading,
          defaultValue: getDefaultValue<String>(settingKey, defaultValue),
          visibleIfKey: visibleIfKey,
          enabledIfKey: enabledIfKey,
          visibleByDefault: visibleByDefault,
          valueToTitle: valueToTitle,
          valueMap: (String value) => _valueToTitle(value),
          refreshStateOnChange: false,
          buildChild: childBuilder,
          cancelCaption: cancelCaption,
          okCaption: okCaption,
          confirmText: confirmText,
          confirmModalTitle: confirmModalTitle,
          confirmModalConfirmCaption: confirmModalConfirmCaption,
          confirmModalCancelCaption: confirmModalCancelCaption,
        );
      },
    );
  }
}

/// [MaterialColorPickerSettingsTile] is a tile that launches a modal dialog
/// where the user can pick any Material color.
///
///
/// * Parameters:
///
/// settingKey (required) - Key name for the tile value.
/// title (required) - Title of the tile.
/// defaultValue - Default color. Default: '0x00000000'. Please note,
///   until the user does not change the value, retrieving it via [Settings]
///   will return null.
/// subtitle - The subtitle of the tile. If null, the selected color value
///   will be shown.
/// icon - Optional [Icon] on the left side. If null, the selected color will
///   be visible.
/// cancelCaption - Caption of the Cancel button. Default: Cancel.
/// okCaption - Caption of the Ok button. Default: Ok.
/// visibleIfKey - If not null, the tile will only be visible if the value
///   of the given settings key is true.
///   See more in the documentation: Conditional Logic.
/// enabledIfKey - If not null, the tile will only be enabled if the value
///   of the given settings key is true.
///   See more in the documentation: Conditional Logic.
/// visibleByDefault - If visibleIfKey is not null and the value of the given
///   key is not saved yet then this value will be the default value.
///   Default: true.
/// confirmText - If not null, a confirmation dialog will appear with this
///   text by enabling or disabling the checkbox.
/// confirmModalTitle - Title of the confirmation dialog. Default: Confirmation.
/// confirmModalCancelCaption - Caption of the cancel button in the confirmation
///   dialog. Default: Cancel.
/// confirmModalConfirmCaption - Caption of the confirm button in the
///   confirmation dialog. Default: Confirm.
///
/// * Examples:
///
/// 1) The following example shows how you can create a tile that launches
/// a modal dialog with a Material color picker.
/// MaterialColorPickerSettingsTile(
/// 	settingsKey: 'key-of-your-setting',
/// 	title: 'Color Picker',
/// );
///
/// 2) In this example, we create the same tile but using more of its parameter.
/// MaterialColorPickerSettingsTile(
/// 	settingsKey: 'key-of-your-setting',
/// 	title: 'Material Color Picker',
/// 	cancelCaption: 'Keep the old value',
/// 	okCaption: 'Select new',
/// 	confirmText: 'Are you sure want to modify the previously selected color?',
/// 	confirmModalTitle: 'Are you sure?',
/// 	confirmModalCancelCaption: 'Keep the old one',
/// 	confirmModalConfirmCaption: 'Yes, I am sure',
/// );
class MaterialColorPickerSettingsTile extends StatelessWidget
    with _ColorWidget {
  final String settingKey;
  final String title;
  final String subtitle;
  final String defaultValue;
  final Icon icon;
  final String visibleIfKey;
  final String enabledIfKey;
  final bool visibleByDefault;
  final String cancelCaption;
  final String okCaption;
  final String confirmText;
  final String confirmModalTitle;
  final String confirmModalCancelCaption;
  final String confirmModalConfirmCaption;

  MaterialColorPickerSettingsTile({
    @required this.settingKey,
    @required this.title,
    this.defaultValue,
    this.subtitle,
    this.icon,
    this.visibleIfKey,
    this.enabledIfKey,
    this.visibleByDefault = true,
    this.cancelCaption = "Cancel",
    this.okCaption = "Ok",
    this.confirmText,
    this.confirmModalTitle,
    this.confirmModalCancelCaption,
    this.confirmModalConfirmCaption,
  });

  @override
  Widget build(BuildContext context) {
    return Settings().onStringChanged(
      settingKey: settingKey,
      defaultValue: defaultValue,
      childBuilder: (BuildContext context, String value) {
        return _ColorPickerSettingsTile(
          settingKey: settingKey,
          title: title,
          subtitle: subtitle,
          defaultValue: getDefaultValue<String>(settingKey, value),
          icon: icon,
          visibleIfKey: visibleIfKey,
          enabledIfKey: enabledIfKey,
          visibleByDefault: visibleByDefault,
          cancelCaption: cancelCaption,
          okCaption: okCaption,
          valueToTitle: (String key) => _valueToTitle(key),
          childBuilder: (String value, Function onChanged) {
            return MaterialColorPicker(
                onColorChange: (Color color) {
                  onChanged(color.toString());
                },
                onMainColorChange: (ColorSwatch color) {
                  // Handle main color changes
                },
                selectedColor: _getColorByString(_valueToTitle(value)));
          },
          confirmText: confirmText,
          confirmModalTitle: confirmModalTitle,
          confirmModalConfirmCaption: confirmModalConfirmCaption,
          confirmModalCancelCaption: confirmModalCancelCaption,
        );
      },
    );
  }
}

/// [SettingsContainer] is a widget that helps its child or children to fit in
/// the settings screen. It is helpful if you want to place other widgets than
/// settings tiles in the settings screen body.
///
///
/// * Parameters:
///
/// child - A [StatelessWidget] or a [StatefulWidget].
/// children - A [List] of [StatelessWidget]s or [StatefulWidget]s.
///   One of them must not be null.
/// visibleIfKey - If not null, the tile will only be visible if the value
///   of the given settings key is true.
///   See more in the documentation: Conditional Logic.
/// visibleByDefault - If visibleIfKey is not null and the value of the given
///   key is not saved yet then this value will be the default value.
///   Default: true.
///
/// * Examples:
///
/// 1) The following example shows you how you can create a container with one
/// [Text] widget.
/// SettingsContainer(
/// 	child: Text('Hello world'),
/// );
///
/// 2) In this example, we create a container with multiple [Text] widgets.
/// SettingsContainer(
/// 	children: <Widget>[
/// 		Text('First line'),
/// 		Text('Second line'),
/// 	],
/// );
class SettingsContainer extends StatelessWidget {
  final Widget child;
  final List<Widget> children;
  final String visibleIfKey;
  final bool visibleByDefault;

  SettingsContainer({
    this.child,
    this.children,
    this.visibleIfKey,
    this.visibleByDefault = true,
  });

  @override
  Widget build(BuildContext context) {
    if (visibleIfKey == null) {
      return _buildChild();
    }
    return Settings().onBoolChanged(
      settingKey: visibleIfKey,
      defaultValue: visibleByDefault,
      childBuilder: (BuildContext context, bool visible) {
        return visible ? _buildChild() : Container();
      },
    );
  }

  Widget _buildChild() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: child ??
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
    );
  }
}

class _SettingsCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool enabled;

  _SettingsCheckbox({
    @required this.value,
    @required this.onChanged,
    @required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: value,
      onChanged: enabled ? onChanged : null,
    );
  }
}

class _SettingsSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool enabled;

  _SettingsSwitch({
    @required this.value,
    @required this.onChanged,
    @required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: value,
      onChanged: enabled ? onChanged : null,
    );
  }
}

class _SettingsRadio extends StatelessWidget {
  final String groupValue;
  final String value;
  final ValueChanged<String> onChanged;
  final bool enabled;

  _SettingsRadio({
    @required this.groupValue,
    @required this.value,
    @required this.onChanged,
    @required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return Radio(
      groupValue: groupValue,
      value: value,
      onChanged: enabled ? onChanged : null,
    );
  }
}

class _SettingsSlider extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final double step;
  final ValueChanged<double> onChanged;
  final Widget leading;
  final Widget trailing;
  final bool enabled;

  _SettingsSlider({
    @required this.value,
    @required this.min,
    @required this.max,
    @required this.step,
    @required this.onChanged,
    this.leading,
    this.trailing,
    @required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        leading,
        Expanded(
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: (max - min) ~/ (step) + 1,
            onChanged: enabled ? onChanged : null,
          ),
        ),
        trailing,
      ],
    );
  }
}

class _ConfirmableScreen extends StatefulWidget {
  final Widget child;
  final String confirmText;
  final String confirmModalTitle;
  final String confirmModalCancelCaption;
  final String confirmModalConfirmCaption;

  _ConfirmableScreen({
    @required this.child,
    this.confirmText,
    this.confirmModalTitle,
    this.confirmModalCancelCaption,
    this.confirmModalConfirmCaption,
  });

  @override
  __ConfirmableScreenState createState() => __ConfirmableScreenState();
}

class __ConfirmableScreenState extends State<_ConfirmableScreen>
    with _Confirmable {
  @override
  void initState() {
    super.initState();

    // We need to delay the initialization of the Confirm Alert by one frame
    // to be able to use the context.
    Future.delayed(Duration.zero, () {
      confirm(
        context: context,
        onCancel: () {
          Navigator.of(context).pop();
        },
        confirmText: widget.confirmText,
        confirmModalTitle: widget.confirmModalTitle,
        confirmModalCancelCaption: widget.confirmModalCancelCaption,
        confirmModalConfirmCaption: widget.confirmModalConfirmCaption,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class _Confirmable {
  confirm({
    @required BuildContext context,
    oldValue,
    newValue,
    Function onConfirm,
    Function onCancel,
    String confirmText,
    String confirmTextToEnable,
    String confirmTextToDisable,
    String confirmModalTitle,
    String confirmModalCancelCaption,
    String confirmModalConfirmCaption,
  }) {
    if (newValue == false &&
        oldValue != newValue &&
        confirmTextToDisable != null) {
      return _showDialog(
        context: context,
        onCancel: onCancel,
        onConfirm: onConfirm,
        confirmText: confirmTextToDisable,
        confirmModalTitle: confirmModalTitle,
        confirmModalCancelCaption: confirmModalCancelCaption,
        confirmModalConfirmCaption: confirmModalConfirmCaption,
      );
    }
    if (newValue == true &&
        oldValue != newValue &&
        confirmTextToEnable != null) {
      return _showDialog(
        context: context,
        onCancel: onCancel,
        onConfirm: onConfirm,
        confirmText: confirmTextToEnable,
        confirmModalTitle: confirmModalTitle,
        confirmModalCancelCaption: confirmModalCancelCaption,
        confirmModalConfirmCaption: confirmModalConfirmCaption,
      );
    }
    if (confirmText != null &&
        (newValue != oldValue || (newValue == null && oldValue == null))) {
      return _showDialog(
        context: context,
        onCancel: onCancel,
        onConfirm: onConfirm,
        confirmText: confirmText,
        confirmModalTitle: confirmModalTitle,
        confirmModalCancelCaption: confirmModalCancelCaption,
        confirmModalConfirmCaption: confirmModalConfirmCaption,
      );
    }
    onConfirm?.call();
  }

  Future<Widget> _showDialog({
    @required BuildContext context,
    Function onConfirm,
    Function onCancel,
    String confirmText,
    String confirmModalTitle,
    String confirmModalCancelCaption,
    String confirmModalConfirmCaption,
  }) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: confirmModalTitle == ""
              ? null
              : Text(confirmModalTitle ?? "Confirm"),
          content: Text(confirmText),
          actions: <Widget>[
            confirmModalCancelCaption == ""
                ? Container()
                : FlatButton(
                    child: Text(
                      confirmModalCancelCaption ?? "Cancel",
                      style: TextStyle(color: Theme.of(context).disabledColor),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      return onCancel?.call();
                    },
                  ),
            confirmModalConfirmCaption == ""
                ? Container()
                : FlatButton(
                    child: Text(confirmModalConfirmCaption ?? "Ok"),
                    onPressed: () {
                      Navigator.of(context).pop();
                      return onConfirm?.call();
                    },
                  ),
          ],
        );
      },
    );
  }
}

class _Enableable {
  Widget wrapEnableable({
    @required BuildContext context,
    @required String enabledIfKey,
    @required bool visibleByDefault,
    @required Function childBuilder,
  }) {
    if (enabledIfKey == null) {
      return childBuilder(context, visibleByDefault);
    }
    return __onEnabledChanged(
      context: context,
      enabledIfKey: enabledIfKey,
      visibleByDefault: visibleByDefault,
      childBuilder: childBuilder,
    );
  }

  StreamBuilder<bool> __onEnabledChanged({
    @required BuildContext context,
    @required String enabledIfKey,
    @required bool visibleByDefault,
    @required Function childBuilder,
  }) {
    return Settings().onBoolChanged(
      settingKey: enabledIfKey,
      defaultValue: visibleByDefault,
      childBuilder: (BuildContext context, bool enabled) {
        return childBuilder(context, enabled);
      },
    );
  }
}
