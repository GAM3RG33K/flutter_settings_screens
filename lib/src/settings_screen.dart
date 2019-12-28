import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'settings.dart';

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

  SettingsScreen({
    @required this.title,
    @required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView.builder(
        itemCount: children.length,
        itemBuilder: (BuildContext context, int index) {
          return children[index];
        },
      ),
    );
  }
}

class _SettingsTile<T> extends StatefulWidget {
  final String title;
  final String subtitle;
  final bool enabled;
  final Widget child;
  final Function onTap;

  _SettingsTile({
    @required this.title,
    this.subtitle = '',
    this.child,
    this.onTap,
    this.enabled = true,
  });

  @override
  __SettingsTileState<T> createState() => __SettingsTileState<T>();
}

class __SettingsTileState<T> extends State<_SettingsTile<T>> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Material(
          child: ListTile(
            title: Text(widget.title),
            subtitle: Text(widget.subtitle),
            enabled: widget.enabled,
            onTap: widget.enabled ? widget.onTap : null,
            trailing: widget.child,
            dense: true,
          ),
        ),
        _SettingsTileDivider(),
      ],
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
/// screen - A [SettingsScreen] or [SwitchSettingsTile] that will be opened
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
  final SettingsScreen screen;
  final bool enabled;

  SimpleSettingsTile({
    @required this.title,
    this.subtitle,
    this.screen,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return _SettingsTile(
      title: title,
      subtitle: subtitle,
      enabled: enabled,
      onTap: enabled
          ? () {
        if (screen == null) {
          return;
        }
        Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => screen,
        ));
      }
          : null,
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
  final List<Widget> children;

  SettingsContainer({
    this.children,
  });

  @override
  Widget build(BuildContext context) {
    return _buildChild();
  }

  Widget _buildChild() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
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

  SettingsTileGroup({
    @required this.title,
    this.subtitle,
    @required this.children,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> elements = <Widget>[
      Container(
        padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 22.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title.toUpperCase(),
            style: TextStyle(
              color: Theme
                  .of(context)
                  .accentColor,
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
    debugPrint('creating switch Tile with value: $value');
    return Switch(
      value: value,
      onChanged: enabled ? onChanged : null,
    );
  }
}

class _SettingsRadio<T> extends StatelessWidget {
  final T groupValue;
  final T value;
  final ValueChanged<T> onChanged;
  final bool enabled;

  _SettingsRadio({
    @required this.groupValue,
    @required this.value,
    @required this.onChanged,
    @required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return Radio<T>(
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

class _SettingsDropDown<T> extends StatelessWidget {
  final T value;
  final List<T> values;
  final ValueChanged<T> onChanged;
  final SimpleWidgetBuilder<T> child;
  final bool enabled;

  _SettingsDropDown({
    @required this.value,
    @required this.values,
    @required this.onChanged,
    this.child,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<T>(
      value: this.value,
      onChanged: enabled ? onChanged : null,
      underline: Container(),
      items: values.map<DropdownMenuItem<T>>(
            (T val) {
          return DropdownMenuItem<T>(
            child: child(val),
            value: val,
          );
        },
      ).toList(),
    );
  }
}

/// [SwitchSettingsTile] is a screen widget similar to [SettingsScreen], but
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
class SwitchSettingsTile extends StatelessWidget {
  final String settingKey;
  final bool defaultValue;
  final String title;
  final bool enabled;

  SwitchSettingsTile({
    @required this.title,
    @required this.settingKey,
    this.defaultValue = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return CacheChangeObserver<bool>(
      cacheKey: settingKey,
      defaultValue: defaultValue,
      builder:
          (BuildContext context, bool value, OnChangeCallBack<bool> onChange) {
        debugPrint('creating settings Tile: $settingKey');
        return _SettingsTile<bool>(
          title: title,
          subtitle: (enabled).toString(),
          onTap: () => onChange(!value),
          child: _SettingsSwitch(
            value: value,
            onChanged: onChange,
            enabled: enabled,
          ),
        );
      },
    );
  }
}

class CheckboxSettingsTile extends StatelessWidget {
  final String settingKey;
  final bool defaultValue;
  final String title;
  final bool enabled;

  CheckboxSettingsTile({
    @required this.title,
    @required this.settingKey,
    this.defaultValue = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return CacheChangeObserver<bool>(
      cacheKey: settingKey,
      defaultValue: defaultValue,
      builder:
          (BuildContext context, bool value, OnChangeCallBack<bool> onChange) {
        return _SettingsTile<bool>(
          title: title,
          subtitle: (enabled).toString(),
          onTap: () => onChange(!value),
          child: _SettingsCheckbox(
            value: value,
            onChanged: onChange,
            enabled: enabled,
          ),
        );
      },
    );
  }
}

class RadioSettingsTile<T> extends StatefulWidget {
  final String settingKey;
  final T selected;
  final Map<T, String> values;
  final String title;
  final bool enabled;

  RadioSettingsTile({
    @required this.title,
    @required this.settingKey,
    @required this.selected,
    @required this.values,
    this.enabled = true,
  });

  @override
  _RadioSettingsTileState<T> createState() => _RadioSettingsTileState<T>();
}

class _RadioSettingsTileState<T> extends State<RadioSettingsTile<T>> {
  T selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    return CacheChangeObserver<T>(
      cacheKey: widget.settingKey,
      defaultValue: selectedValue,
      builder: (BuildContext context, T value, OnChangeCallBack<T> onChange) {
        return Column(
          children: <Widget>[
            SimpleSettingsTile(
              title: widget.title,
              subtitle: widget.values[selectedValue],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: _buildRadioTiles(context, onChange),
            )
          ],
        );
      },
    );
  }

  Widget _buildRadioTiles(BuildContext context, OnChangeCallBack<T> onChange) {
    List<Widget> radioList =
    widget.values.entries.map<Widget>((MapEntry<T, String> entry) {
      return Padding(
        padding: const EdgeInsets.all(0.0),
        child: _SettingsTile<T>(
          title: entry.value,
          onTap: () => _onRadioChange(entry.key, onChange),
          child: _SettingsRadio<T>(
            value: entry.key,
            onChanged: widget.enabled
                ? (T newValue) {
              _onRadioChange(newValue, onChange);
            }
                : null,
            enabled: widget.enabled,
            groupValue: selectedValue,
          ),
        ),
      );
    }).toList();
    return Column(
      children: radioList,
    );
  }

  void _onRadioChange(T value, OnChangeCallBack<T> onChange) {
    selectedValue = value;
    onChange(value);
  }
}
