import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:flutter_settings_screens/src/utils/utils.dart';

import 'settings.dart';

/// [SettingsScreen] is a simple Screen widget that may contain Tiles or other
/// widgets.
///
/// * Example:
/// ```dart
/// SettingsScreen(
///   title: 'Application Settings',
///   children: <Widget>[
///     SettingsGroup(
///            title: 'Single Choice Settings',
///            children: <Widget>[
///              SwitchSettingsTile(
///                settingKey: 'key-wifi',
///                title: 'Wi-Fi',
///                enabledLabel: 'Enabled',
///                disabledLabel: 'Disabled',
///                leading: Icon(Icons.wifi),
///                onChange: (value) {
///                  debugPrint('key-wifi: $value');
///                },
///              ),
///              CheckboxSettingsTile(
///                settingKey: 'key-blue-tooth',
///                title: 'Bluetooth',
///                enabledLabel: 'Enabled',
///                disabledLabel: 'Disabled',
///                leading: Icon(Icons.bluetooth),
///                onChange: (value) {
///                  debugPrint('key-blue-tooth: $value');
///                },
///              ),
///              SwitchSettingsTile(
///                leading: Icon(Icons.developer_mode),
///                settingKey: 'key-switch-dev-mode',
///                title: 'Developer Settings',
///                onChange: (value) {
///                  debugPrint('key-switch-dev-mod: $value');
///                },
///                childrenIfEnabled: <Widget>[
///                  CheckboxSettingsTile(
///                    leading: Icon(Icons.adb),
///                    settingKey: 'key-is-developer',
///                    title: 'Developer Mode',
///                    onChange: (value) {
///                      debugPrint('key-is-developer: $value');
///                    },
///                  ),
///                  SwitchSettingsTile(
///                    leading: Icon(Icons.usb),
///                    settingKey: 'key-is-usb-debugging',
///                    title: 'USB Debugging',
///                    onChange: (value) {
///                      debugPrint('key-is-usb-debugging: $value');
///                    },
///                  ),
///                  SimpleSettingsTile(
///                    title: 'Root Settings',
///                    subtitle: 'These settings is not accessible',
///                    enabled: false,
///                  ),
///               ],
///             ),
///          ],
///       ),
///   ],
/// );
/// ```
class SettingsScreen extends StatelessWidget {
  /// Appbar title in Scaffold.
  final String title;

  /// Content of the screen, body of the Scaffold.
  final List<Widget> children;

  SettingsScreen({
    this.title = 'Settings',
    @required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: children.length,
        itemBuilder: (BuildContext context, int index) {
          return children[index];
        },
      ),
    );
  }
}

/// [_SettingsTile] is a Basic Building block for Any Settings widget.
///
/// This widget is container for any widget which is to be used for setting.
class _SettingsTile extends StatefulWidget {
  /// title string for the tile
  final String title;

  /// widget to be placed at first in the tile
  final Widget leading;

  /// subtitle string for the tile
  final String subtitle;

  /// flag to represent if the tile is accessible or not, if false user input is ignored
  final bool enabled;

  /// widget which is placed as the main element of the tile as settings UI
  final Widget child;

  /// call back for handling the tap event on tile
  final GestureTapCallback onTap;

  /// flag to show the child below the main tile elements
  final bool showChildBelow;

  _SettingsTile({
    @required this.title,
    @required this.child,
    this.subtitle = '',
    this.onTap,
    this.enabled = true,
    this.showChildBelow = false,
    this.leading,
  });

  @override
  __SettingsTileState createState() => __SettingsTileState();
}

class __SettingsTileState extends State<_SettingsTile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ListTile(
            leading: widget.leading,
            title: Text(
              widget.title,
              style: headerTextStyle(context),
            ),
            subtitle: widget.subtitle.isEmpty
                ? null
                : Text(
                    widget.subtitle,
                    style: subtitleTextStyle(context),
                  ),
            enabled: widget.enabled,
            onTap: widget.onTap,
            trailing: Visibility(
              visible: !widget.showChildBelow,
              child: widget.child,
            ),
            dense: true,
            // wrap only if the subtitle is longer than 70 characters
            isThreeLine: (widget.subtitle?.isNotEmpty ?? false) &&
                widget.subtitle.length > 70,
          ),
          Visibility(
            visible: widget.showChildBelow,
            child: widget.child,
          ),
          _SettingsTileDivider(),
        ],
      ),
    );
  }
}

/// [_SimpleHeaderTile] is a widget which is used to show Leading, Title and subtitle
/// of a [_SettingsTile] without the main child widget
class _SimpleHeaderTile extends StatefulWidget {
  /// title string for the tile
  final String title;

  /// subtitle string for the tile
  final String subtitle;

  /// widget to be placed at first in the tile
  final Widget leading;

  const _SimpleHeaderTile({
    Key key,
    this.title,
    this.subtitle = '',
    this.leading,
  }) : super(key: key);

  @override
  __SimpleHeaderTileState createState() => __SimpleHeaderTileState();
}

class __SimpleHeaderTileState extends State<_SimpleHeaderTile> {
  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      child: ListTile(
        title: Text(
          widget.title,
          style: headerTextStyle(context),
        ),
        subtitle: widget.subtitle.isNotEmpty
            ? Text(
                widget.subtitle,
                style: subtitleTextStyle(context),
              )
            : null,
        leading: widget.leading,
      ),
    );
  }
}

/// [_ExpansionSettingsTile] is a special setting widget which has two states.
///
/// Collapsed State:
///   In this state the settings tile would only show the Title,Subtitle and leading
///   widget
///
/// Expanded State:
///   In this state the settings tile would show all widgets in collapsed state,
///   but also the children widgets.
class _ExpansionSettingsTile extends StatefulWidget {
  final String title;
  final String subtitle;
  final bool enabled;
  final bool expanded;
  final Widget child;
  final Widget leading;

  _ExpansionSettingsTile({
    @required this.title,
    this.subtitle = '',
    this.child,
    this.enabled = true,
    this.expanded = false,
    this.leading,
  });

  @override
  _ExpansionSettingsTileState createState() => _ExpansionSettingsTileState();
}

class _ExpansionSettingsTileState extends State<_ExpansionSettingsTile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.enabled ? getExpansionTile() : getListTile();
  }

  Widget getListTile() {
    return _SettingsTile(
      title: widget.title,
      subtitle: widget.subtitle,
      enabled: false,
      child: Text(''),
      leading: widget.leading,
    );
  }

  Widget getExpansionTile() {
    return Material(
      child: ExpansionTile(
        title: Text(
          widget.title,
          style: headerTextStyle(context),
        ),
        leading: widget.leading,
        subtitle: Text(
          widget.subtitle,
          style: subtitleTextStyle(context),
        ),
        children: <Widget>[widget.child],
        initiallyExpanded: widget.expanded,
        childrenPadding: EdgeInsets.only(left: 8.0),
      ),
    );
  }
}

///[_ModalSettingsTile] is a widget which shows the given child widget inside a
/// dialog view.
///
/// This widget can be used to show a settings UI which is too big for a single
///  tile in the SettingScreen UI or a Setting tile which needs to be shown separately.
class _ModalSettingsTile extends StatefulWidget {
  final String title;
  final String subtitle;
  final bool enabled;
  final Widget leading;
  final List<Widget> children;
  final bool showConfirmation;
  final GestureTapCallback onCancel;
  final OnConfirmCallback onConfirm;

  _ModalSettingsTile({
    @required this.title,
    this.subtitle = '',
    this.children,
    this.enabled = true,
    this.leading,
    this.showConfirmation = false,
    this.onCancel,
    this.onConfirm,
  });

  @override
  __ModalSettingsTileState createState() => __ModalSettingsTileState();
}

class __ModalSettingsTileState extends State<_ModalSettingsTile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListTile(
        leading: widget.leading,
        title: Text(widget.title, style: headerTextStyle(context)),
        subtitle: Text(
          widget.subtitle,
          style: subtitleTextStyle(context),
        ),
        enabled: widget.enabled,
        onTap: () => _showWidget(context, widget.children),
        dense: true,
      ),
    );
  }

  void _showWidget(BuildContext context, List<Widget> children) {
    showDialog(
        context: context,
        builder: (dialogContext) {
          return SimpleDialog(
            title: Center(
              child: getTitle(),
            ),
            titlePadding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 2.0),
            children: _finalWidgets(dialogContext, children),
            contentPadding: EdgeInsets.zero,
          );
        });
  }

  List<Widget> _finalWidgets(
      BuildContext dialogContext, List<Widget> children) {
    if (widget.showConfirmation == null || !widget.showConfirmation) {
      return children;
    }
    return _addActionWidgets(dialogContext, children);
  }

  Widget getTitle() {
    return widget.leading != null
        ? Row(
            children: <Widget>[
              widget.leading,
              Text(widget.title, style: headerTextStyle(context)),
            ],
          )
        : Text(widget.title, style: headerTextStyle(context));
  }

  List<Widget> _addActionWidgets(
      BuildContext dialogContext, List<Widget> children) {
    final finalList = List<Widget>.from(children);
    finalList.add(ButtonBar(
      alignment: MainAxisAlignment.end,
      children: <Widget>[
        FlatButton(
          padding: EdgeInsets.zero,
          child:
              Text(MaterialLocalizations.of(dialogContext).cancelButtonLabel),
          onPressed: () {
            widget.onCancel?.call();
            _disposeDialog(dialogContext);
          },
        ),
        FlatButton(
          child: Text(MaterialLocalizations.of(dialogContext).okButtonLabel),
          padding: EdgeInsets.zero,
          onPressed: () async {
            bool closeDialog = true;
            if (widget.onConfirm != null) {
              closeDialog = await widget.onConfirm();
            }
            if (closeDialog) {
              _disposeDialog(dialogContext);
            }
          },
        )
      ],
    ));
    return finalList;
  }

  void _disposeDialog(BuildContext dialogContext) {
    Navigator.of(dialogContext).pop();
  }
}

/// [_SettingsTileDivider] is widget which is used as a Divide various settings
/// tile in a list
class _SettingsTileDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 0.0,
    );
  }
}

/// [_SettingsCheckbox] is a Settings UI version of the [Checkbox] widget.
class _SettingsCheckbox extends StatelessWidget {
  /// current state of the checkbox
  final bool value;

  /// on change callback to handle state change
  final OnChanged<bool> onChanged;

  /// flag which represents the state of the settings, if false the the tile will
  /// ignore all the user inputs
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

/// [_SettingsSwitch] is a Settings UI version of the [Switch] widget
class _SettingsSwitch extends StatelessWidget {
  /// current state of the switch
  final bool value;

  /// on change callback to handle state change
  final OnChanged<bool> onChanged;

  /// flag which represents the state of the settings, if false the the tile will
  /// ignore all the user inputs
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

/// [_SettingsRadio] is a Settings UI version of the [Radio] widgets
class _SettingsRadio<T> extends StatelessWidget {
  /// value of the selected radio in this group
  final T groupValue;

  /// value of the current radio widget
  final T value;

  /// on change callback to handle state change
  final OnChanged<T> onChanged;

  /// flag which represents the state of the settings, if false the the tile will
  /// ignore all the user inputs
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

/// [_SettingsDropDown] is a Settings UI version of the [DropdownButton]
class _SettingsDropDown<T> extends StatelessWidget {
  /// value of the selected in this dropdown
  final T selected;

  /// List of values for this dropdown
  final List<T> values;

  /// on change call back to handle selected value change
  final OnChanged<T> onChanged;

  /// single item builder for creating a [DropdownMenuItem]
  final ItemBuilder<T> itemBuilder;

  /// flag which represents the state of the settings, if false the the tile will
  /// ignore all the user inputs
  final bool enabled;

  _SettingsDropDown({
    @required this.selected,
    @required this.values,
    @required this.onChanged,
    this.itemBuilder,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.end,
      children: <Widget>[
        DropdownButton<T>(
          isDense: true,
          value: this.selected,
          onChanged: enabled ? onChanged : null,
          underline: Container(),
          items: values.map<DropdownMenuItem<T>>(
            (T val) {
              return DropdownMenuItem<T>(
                child: itemBuilder(val),
                value: val,
              );
            },
          ).toList(),
        ),
      ],
    );
  }
}

/// [_SettingsSlider] is a Settings UI version of [Slider] widget
class _SettingsSlider extends StatelessWidget {
  /// min value allowed for the slider
  final double min;

  /// max value allowed for the slider
  final double max;

  /// step value for slider interval
  final double step;

  /// current value of the slider
  final double value;

  /// on change callback to handle the value change when slider starts moving
  final OnChanged<double> onChangeStart;

  /// on change callback to handle the value change
  final OnChanged<double> onChanged;

  /// on change callback to handle the value change when slider stops moving
  final OnChanged<double> onChangeEnd;

  /// flag which represents the state of the settings, if false then the tile will
  /// ignore all the user inputs
  final bool enabled;

  _SettingsSlider({
    @required this.value,
    @required this.min,
    @required this.max,
    @required this.step,
    @required this.enabled,
    this.onChangeStart,
    this.onChanged,
    this.onChangeEnd,
  });

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: value,
      min: min,
      max: max,
      divisions: (max - min) ~/ (step),
      onChangeStart: enabled ? onChangeStart : null,
      onChanged: enabled ? onChanged : null,
      onChangeEnd: enabled ? onChangeEnd : null,
    );
  }
}

/// [_SettingsColorPicker] is a widget which allows picking colors
/// from pallet of colors
class _SettingsColorPicker extends StatelessWidget {
  /// title of the settings tile and color pallet dialog
  final String title;

  final String subtitle;

  /// current value of the slider
  final String value;

  /// on change callback to handle the value change
  final OnChanged<String> onChanged;

  /// flag which represents the state of the settings, if false the the tile will
  /// ignore all the user inputs
  final bool enabled;

  _SettingsColorPicker({
    @required this.value,
    @required this.onChanged,
    @required this.enabled,
    @required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return _SettingsTile(
      title: title,
      subtitle: subtitle != null && subtitle.isNotEmpty ? subtitle : value,
      enabled: enabled,
      onTap: () => _showColorPicker(context, value),
      child: FloatingActionButton(
        heroTag: null,
        backgroundColor: Utils.colorFromString(value),
        elevation: 0,
        onPressed: enabled ? () => _showColorPicker(context, value) : null,
      ),
    );
  }

  void _showColorPicker(BuildContext context, String value) {
    Widget dialogContent = MaterialColorPicker(
      shrinkWrap: true,
      selectedColor: Utils.colorFromString(value),
      onColorChange: (Color color) => onChanged(Utils.stringFromColor(color)),
    );

    showDialog(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: Text('Pick a Color'),
            content: dialogContent,
          );
        });
  }
}

/// [SimpleSettingsTile] is a simple settings tile that can open a new screen
/// by tapping the tile.
///
/// Example:
/// ```dart
/// SimpleSettingsTile(
///   title: 'Advanced',
///   subtitle: 'More, advanced settings.'
///   screen: SettingsScreen(
///     title: 'Sub menu',
///     children: <Widget>[
///       CheckboxSettingsTile(
///         settingsKey: 'key-of-your-setting',
///         title: 'This is a simple Checkbox',
///       ),
///     ],
///   ),
/// );
/// ```
class SimpleSettingsTile extends StatelessWidget {
  /// title string for the tile
  final String title;

  /// subtitle string for the tile
  final String subtitle;

  /// widget to be placed at first in the tile
  final Widget leading;

  /// flag which represents the state of the settings, if false the the tile will
  /// ignore all the user inputs
  final bool enabled;

  /// widget that will be displayed on tap of the tile
  final Widget child;

  final VoidCallback onTap;

  SimpleSettingsTile({
    @required this.title,
    this.subtitle,
    this.child,
    this.enabled = true,
    this.leading,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _SettingsTile(
      leading: leading,
      title: title,
      subtitle: subtitle,
      enabled: enabled,
      child: child != null ? getIcon(context) : Text(''),
      onTap: () => _handleTap(context),
    );
  }

  Widget getIcon(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.navigate_next),
      onPressed: enabled ? () => _handleTap(context) : null,
    );
  }

  void _handleTap(BuildContext context) {
    onTap?.call();

    if (child != null) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => child,
      ));
    }
  }
}

/// [ModalSettingsTile] is a widget which allows creating
/// a setting which shows the [children] in a [_ModalSettingsTile]
///
/// Example:
/// ```dart
///  ModalSettingsTile(
///    title: 'Quick setting dialog',
///    subtitle: 'Settings on a dialog',
///    children: <Widget>[
///      CheckboxSettingsTile(
///        settingKey: 'key-day-light-savings',
///        title: 'Daylight Time Saving',
///        enabledLabel: 'Enabled',
///        disabledLabel: 'Disabled',
///        leading: Icon(Icons.timelapse),
///      ),
///      SwitchSettingsTile(
///        settingKey: 'key-dark-mode',
///        title: 'Dark Mode',
///        enabledLabel: 'Enabled',
///        disabledLabel: 'Disabled',
///        leading: Icon(Icons.palette),
///      ),
///    ],
///  );
///
/// ```
///
class ModalSettingsTile extends StatelessWidget {
  /// title string for the tile
  final String title;

  /// subtitle string for the tile
  final String subtitle;

  /// widget to be placed at first in the tile
  final Widget leading;

  /// flag which represents the state of the settings, if false the the tile will
  /// ignore all the user inputs
  final bool enabled;

  /// List of widgets which are to be shown in the modal dialog
  final List<Widget> children;

  ModalSettingsTile({
    @required this.title,
    this.subtitle = '',
    this.children,
    this.enabled = true,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return _ModalSettingsTile(
      leading: leading,
      title: title,
      subtitle: subtitle,
      enabled: enabled,
      children: children,
    );
  }
}

/// [ExpandableSettingsTile] is wrapper widget which shows the
/// given [children] in an [_ExpansionSettingsTile]
///
/// Example:
/// ```dart
///  ExpandableSettingsTile(
///    title: 'Quick setting dialog2',
///    subtitle: 'Expandable Settings',
///    children: <Widget>[
///      CheckboxSettingsTile(
///        settingKey: 'key-day-light-savings',
///        title: 'Daylight Time Saving',
///        enabledLabel: 'Enabled',
///        disabledLabel: 'Disabled',
///        leading: Icon(Icons.timelapse),
///      ),
///      SwitchSettingsTile(
///        settingKey: 'key-dark-mode',
///        title: 'Dark Mode',
///        enabledLabel: 'Enabled',
///        disabledLabel: 'Disabled',
///        leading: Icon(Icons.palette),
///      ),
///    ],
///  );
///
/// ```
class ExpandableSettingsTile extends StatelessWidget {
  /// title string for the tile
  final String title;

  /// subtitle string for the tile
  final String subtitle;

  /// widget to be placed at first in the tile
  final Widget leading;

  /// flag which represents the state of the settings, if false the the tile will
  /// ignore all the user inputs
  final bool enabled;

  /// List of the widgets which are to be shown when tile is expanded
  final List<Widget> children;

  /// flag which represents the initial state of the tile, if true the tile state is
  /// set to expanded initially
  final bool expanded;

  ExpandableSettingsTile({
    @required this.title,
    this.subtitle = '',
    this.children,
    this.enabled = true,
    this.expanded = false,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return _ExpansionSettingsTile(
      leading: leading,
      title: title,
      subtitle: subtitle,
      enabled: enabled,
      child: SettingsContainer(
        children: children,
      ),
    );
  }
}

/// [SettingsContainer] is a widget that helps its child or children to fit in
/// the settings screen. It is helpful if you want to place other widgets than
/// settings tiles in the settings screen body.
/// Example:
/// ```dart
/// SettingsContainer(
/// 	children: <Widget>[
/// 		Text('First line'),
/// 		Text('Second line'),
///     Icon(Icons.palette),
/// 	],
/// );
/// ```
class SettingsContainer extends StatelessWidget {
  /// List of widgets which will be shown as Custom list of setting tile
  final List<Widget> children;

  /// flag to represent if this Container allows internal scrolling of the widgets
  /// along with the outer settings screen/container,
  /// if true, the list of widget inside are made scrollable
  final bool allowScrollInternally;

  final double leftPadding;

  SettingsContainer({
    this.children,
    this.allowScrollInternally = false,
    this.leftPadding = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return _buildChild();
  }

  Widget _buildChild() {
    Widget child =
        allowScrollInternally ? getList(children) : getColumn(children);
    return Padding(
      padding: EdgeInsets.only(
        top: 16.0,
      ),
      child: Material(
        child: Container(
          padding: EdgeInsets.only(left: leftPadding),
          child: child,
        ),
      ),
    );
  }

  Widget getList(List<Widget> children) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return children[index];
      },
      shrinkWrap: true,
      itemCount: children.length,
    );
  }

  Widget getColumn(List<Widget> children) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: children,
      crossAxisAlignment: CrossAxisAlignment.stretch,
    );
  }
}

/// [SettingsGroup] is a widget that contains multiple settings tiles and other
/// widgets together as a group and shows a title/name of that group.
///
/// All the children widget will have a small padding from the left and top
/// to provide a sense that they in a separate group from others
///
///  Example:
///
/// ```dart
/// SettingsGroup(
///    title: 'Group title',
///    children: <Widget>[
///       CheckboxSettingsTile(
///         settingKey: 'key-day-light-savings',
///         title: 'Daylight Time Saving',
///         enabledLabel: 'Enabled',
///         disabledLabel: 'Disabled',
///         leading: Icon(Icons.timelapse),
///       ),
///       SwitchSettingsTile(
///         settingKey: 'key-dark-mode',
///         title: 'Dark Mode',
///         enabledLabel: 'Enabled',
///         disabledLabel: 'Disabled',
///         leading: Icon(Icons.palette),
///       ),
///  	],
///  );
/// ```
class SettingsGroup extends StatelessWidget {
  /// title string for the tile
  final String title;

  /// subtitle string for the tile
  final String subtitle;

  /// List of the widgets which are to be shown under the title as a group
  final List<Widget> children;

  SettingsGroup({
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
            style: groupStyle(context),
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
    return Wrap(
      children: <Widget>[
        Column(
          children: elements,
        )
      ],
    );
  }

  TextStyle groupStyle(BuildContext context) {
    return TextStyle(
      color: Theme.of(context).accentColor,
      fontSize: 12.0,
      fontWeight: FontWeight.bold,
    );
  }
}

/// A Setting widget which allows user a text input in a [TextFormField]
///
/// This widget by default is a [_ModalSettingsTile]. Meaning, this input field
/// will be shown in a dialog view.
///
/// Example:
///
/// ```dart
/// TextInputSettingsTile(
///   title: 'User Name',
///   settingKey: 'key-user-name',
///   initialValue: 'admin',
///   validator: (String username) {
///     if (username != null && username.length > 3) {
///       return null;
///     }
///     return "User Name can't be smaller than 4 letters";
///   },
///   borderColor: Colors.blueAccent,
///   errorColor: Colors.deepOrangeAccent,
/// );
///
/// ```
///
///  OR
///
/// ``` dart
/// TextInputSettingsTile(
///   title: 'password',
///   settingKey: 'key-user-password',
///   obscureText: true,
///   validator: (String password) {
///     if (password != null && password.length > 6) {
///       return null;
///     }
///     return "Password can't be smaller than 7 letters";
///   },
///   borderColor: Colors.blueAccent,
///   errorColor: Colors.deepOrangeAccent,
/// );
/// ```
class TextInputSettingsTile extends StatefulWidget {
  /// Settings Key string for storing the text in cache (assumed to be unique)
  final String settingKey;

  /// initial value to be filled in the text field
  final String initialValue;

  /// title for the settings tile
  final String title;

  /// flag which represents the state of the settings, if false the the tile will
  /// ignore all the user inputs
  final bool enabled;

  /// flag which represents if the text field's data will be auto validated
  /// or not
  /// if true, the validation will be performed on all changes
  /// otherwise it will only happen if the `OK` button is clicked
  final bool autoValidate;

  /// Validation mode helps use customize the way the input text field is
  /// validated for proper input values.
  ///
  /// [AutovalidateMode.disabled] - Never auto validate, equivalent of `autoValidate = false`
  /// [AutovalidateMode.always] - Always auto validate, equivalent of `autoValidate = true`
  /// [AutovalidateMode.onUserInteraction] - Only auto validate if user interacts with it
  final AutovalidateMode autoValidateMode;

  /// flag which represents if the text field will be focused by default
  /// or not
  /// if true, then the text field will be in focus other wise it will not be
  /// in focus by default
  final bool autoFocus;

  /// on change callback for handling the value change
  final OnChanged<String> onChange;

  /// validator for input validation
  final FormFieldValidator<String> validator;

  /// flag which represents the state of obscureText in the [TextFormField]
  final bool obscureText;

  /// Color of the border of the [TextFormField]
  final Color borderColor;

  /// Color of the border of the [TextFormField], when there's an error
  /// or input is not passed through the validation
  final Color errorColor;

  TextInputSettingsTile({
    @required this.title,
    @required this.settingKey,
    this.initialValue = '',
    this.enabled = true,
    @Deprecated('Use autoValidateMode parameter which provide more specific '
        'behaviour related to auto validation. '
        'This feature was deprecated in accordance to flutter update v1.19.0 ') this.autoValidate = false,
    this.autoValidateMode,
    this.autoFocus = true,
    this.onChange,
    this.validator,
    this.obscureText = false,
    this.borderColor,
    this.errorColor,
  }) : assert(
  autoValidate == false ||
      autoValidate == true && autoValidateMode == null,
  'autoValidate and autoValidateMode should not be used together.');

  @override
  _TextInputSettingsTileState createState() => _TextInputSettingsTileState();
}

class _TextInputSettingsTileState extends State<TextInputSettingsTile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _controller;
  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return ValueChangeObserver<String>(
      cacheKey: widget.settingKey,
      defaultValue: widget.initialValue,
      builder:
          (BuildContext context, String value, OnChanged<String> onChanged) {
        _controller.text = value;
        return _ModalSettingsTile(
          title: widget.title,
          subtitle: widget.obscureText ? '' : value,
          children: <Widget>[
            _buildTextField(context, value, onChanged),
          ],
          showConfirmation: true,
          onConfirm: () => Future.value(_submitText(_controller.text)),
          onCancel: () {
            _controller.text = Settings.getValue(widget.settingKey, '');
          },
        );
      },
    );
  }

  Widget _buildTextField(
      BuildContext context, String value, OnChanged<String> onChanged) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: TextFormField(
          autofocus: widget.autoFocus,
          controller: _controller,
          focusNode: _focusNode,
          autovalidate: widget.autoValidate,
          autovalidateMode: autoValidateMode,
          enabled: widget.enabled,
          validator: widget.enabled ? widget.validator : null,
          onSaved: widget.enabled ? (value) => _onSave(value, onChanged) : null,
          obscureText: widget.obscureText,
          decoration: InputDecoration(
              errorStyle: TextStyle(
                color: widget.errorColor ?? Colors.red,
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
                borderSide: BorderSide(color: widget.errorColor ?? Colors.red),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
                borderSide: BorderSide(
                  color: widget.borderColor ?? Colors.blue,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
                borderSide: BorderSide(
                  color: widget.borderColor ?? Colors.blue,
                ),
              )),
        ),
      ),
    );
  }

  AutovalidateMode get autoValidateMode {
    var autoValidateMode = widget.autoValidateMode;
    autoValidateMode ??= widget.autoValidate
        ? AutovalidateMode.always
        : AutovalidateMode.disabled;
    return autoValidateMode;
  }

  bool _submitText(String newValue) {
    bool isValid = true;
    final state = _formKey.currentState;
    if (state != null) {
      isValid = state.validate() ?? false;
    }

    if (isValid) {
      state.save();
      return true;
    }

    return false;
  }

  void _onSave(String newValue, OnChanged<String> onChanged) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onChanged(newValue);
      if (widget.onChange != null) {
        widget.onChange(newValue);
      }
    });
  }
}

/// [SwitchSettingsTile] is a widget that has a [Switch] with given title,
/// subtitle and default value/status of the switch
///
/// This widget supports an additional list of widgets to display
/// when the switch is enabled. These optional list of widgets is accessed
/// through `childrenIfEnabled` property of this widget.
///
/// This widget works similar to [CheckboxSettingsTile].
///
///  Example:
///
/// ```dart
///  SwitchSettingsTile(
///   leading: Icon(Icons.developer_mode),
///   settingKey: 'key-switch-dev-mode',
///   title: 'Developer Settings',
///   onChange: (value) {
///     debugPrint('key-switch-dev-mod: $value');
///   },
///   childrenIfEnabled: <Widget>[
///     CheckboxSettingsTile(
///       leading: Icon(Icons.adb),
///       settingKey: 'key-is-developer',
///       title: 'Developer Mode',
///       onChange: (value) {
///         debugPrint('key-is-developer: $value');
///       },
///     ),
///     SwitchSettingsTile(
///       leading: Icon(Icons.usb),
///       settingKey: 'key-is-usb-debugging',
///       title: 'USB Debugging',
///       onChange: (value) {
///         debugPrint('key-is-usb-debugging: $value');
///       },
///     ),
///     SimpleSettingsTile(
///       title: 'Root Settings',
///       subtitle: 'These settings is not accessible',
///       enabled: false,
///     )
///   ],
///  );
///  ```
class SwitchSettingsTile extends StatelessWidget {
  final String settingKey;
  final bool defaultValue;
  final String title;
  final String subtitle;
  final bool enabled;
  final OnChanged<bool> onChange;
  final Widget leading;
  final String enabledLabel;
  final String disabledLabel;
  final List<Widget> childrenIfEnabled;

  /// This callback is used to allow custom interaction to confirm the changes
  /// made by the user, which by default is considered as an async operation
  /// so the return value must be a `Future<bool>`
  ///
  ///
  /// It can be used like this,
  /// ```dart
  /// confirmChangeCallback: () async {
  ///   var confirmChange = await showConfirmationDialog();
  ///   return confirmChange;
  /// },
  /// ```
  final OnConfirmCallback confirmChangeCallback;

  SwitchSettingsTile({
    @required this.title,
    @required this.settingKey,
    this.defaultValue = false,
    this.enabled = true,
    this.onChange,
    this.leading,
    this.enabledLabel = '',
    this.disabledLabel = '',
    this.childrenIfEnabled,
    this.subtitle = '',
    this.confirmChangeCallback,
  });

  @override
  Widget build(BuildContext context) {
    return ValueChangeObserver<bool>(
      cacheKey: settingKey,
      defaultValue: defaultValue,
      builder: (BuildContext context, bool value, OnChanged<bool> onChanged) {
        Widget mainWidget = _SettingsTile(
          leading: leading,
          title: title,
          subtitle: getSubtitle(value),
          onTap: () => onChanged(!value),
          enabled: enabled,
          child: _SettingsSwitch(
            value: value,
            onChanged: (value) => _onSwitchChange(context, value, onChanged),
            enabled: enabled,
          ),
        );

        Widget finalWidget = getFinalWidget(
          context,
          mainWidget,
          value,
          childrenIfEnabled,
        );
        return finalWidget;
      },
    );
  }

  Future<void> _onSwitchChange(BuildContext context, bool value,
      OnChanged<bool> onChanged) async {
    bool allowChange = await _processConfirmation(confirmChangeCallback);
    if (!allowChange) return;
    onChanged(value);
    if (onChange != null) {
      onChange(value);
    }
  }

  String getSubtitle(bool currentStatus) {
    if (subtitle != null && subtitle.isNotEmpty) {
      return subtitle;
    }
    String label = '';
    if (currentStatus && enabledLabel.isNotEmpty) {
      label = enabledLabel;
    }
    if (!currentStatus && disabledLabel.isNotEmpty) {
      label = disabledLabel;
    }
    return label;
  }

  Widget getFinalWidget(BuildContext context, Widget mainWidget,
      bool currentValue, List<Widget> childrenIfEnabled) {
    if (childrenIfEnabled == null || !currentValue) {
      return SettingsContainer(
        children: [mainWidget],
      );
    }
    List<Widget> _children = _getPaddedParentChildrenList(childrenIfEnabled);
    _children.insert(0, mainWidget);

    return SettingsContainer(
      children: _children,
    );
  }
}

/// [CheckboxSettingsTile] is a widget that has a [Checkbox] with given title,
/// subtitle and default value/status of the Checkbox
///
/// This widget supports an additional list of widgets to display
/// when the Checkbox is checked. These optional list of widgets is accessed
/// through `childrenIfEnabled` property of this widget.
///
/// This widget works similar to [SwitchSettingsTile].
///
///  Example:
///
/// ```dart
///  CheckboxSettingsTile(
///   leading: Icon(Icons.developer_mode),
///   settingKey: 'key-check-box-dev-mode',
///   title: 'Developer Settings',
///   onChange: (value) {
///     debugPrint('key-check-box-dev-mode: $value');
///   },
///   childrenIfEnabled: <Widget>[
///     CheckboxSettingsTile(
///       leading: Icon(Icons.adb),
///       settingKey: 'key-is-developer',
///       title: 'Developer Mode',
///       onChange: (value) {
///         debugPrint('key-is-developer: $value');
///       },
///     ),
///     SwitchSettingsTile(
///       leading: Icon(Icons.usb),
///       settingKey: 'key-is-usb-debugging',
///       title: 'USB Debugging',
///       onChange: (value) {
///         debugPrint('key-is-usb-debugging: $value');
///       },
///     ),
///   ],
///  );
///  ```
class CheckboxSettingsTile extends StatelessWidget {
  final String settingKey;
  final bool defaultValue;
  final String title;
  final String subtitle;
  final bool enabled;
  final OnChanged<bool> onChange;
  final Widget leading;
  final String enabledLabel;
  final String disabledLabel;
  final List<Widget> childrenIfEnabled;


  /// This callback is used to allow custom interaction to confirm the changes
  /// made by the user, which by default is considered as an async operation
  /// so the return value must be a `Future<bool>`
  ///
  ///
  /// It can be used like this,
  /// ```dart
  /// confirmChangeCallback: () async {
  ///   var confirmChange = await showConfirmationDialog();
  ///   return confirmChange;
  /// },
  /// ```
  final OnConfirmCallback confirmChangeCallback;

  CheckboxSettingsTile({
    @required this.title,
    @required this.settingKey,
    this.defaultValue = false,
    this.enabled = true,
    this.onChange,
    this.leading,
    this.enabledLabel = '',
    this.disabledLabel = '',
    this.childrenIfEnabled,
    this.subtitle = '',
    this.confirmChangeCallback,
  });

  @override
  Widget build(BuildContext context) {
    return ValueChangeObserver<bool>(
      cacheKey: settingKey,
      defaultValue: defaultValue,
      builder: (BuildContext context, bool value, OnChanged<bool> onChanged) {
        var mainWidget = _SettingsTile(
          leading: leading,
          title: title,
          enabled: enabled,
          subtitle: getSubtitle(value),
          onTap: () => _onCheckboxChange(!value, onChanged),
          child: _SettingsCheckbox(
            value: value,
            onChanged: (value) => _onCheckboxChange(value, onChanged),
            enabled: enabled,
          ),
        );

        Widget finalWidget = getFinalWidget(
          context,
          mainWidget,
          value,
          childrenIfEnabled,
        );
        return finalWidget;
      },
    );
  }

  Future<void> _onCheckboxChange(bool value, OnChanged<bool> onChanged) async {
    bool allowChange = await _processConfirmation(confirmChangeCallback);
    if (!allowChange) return;
    onChanged(value);
    if (onChange != null) {
      onChange(value);
    }
  }

  String getSubtitle(bool currentStatus) {
    if (subtitle != null && subtitle.isNotEmpty) {
      return subtitle;
    }

    String label = '';
    if (currentStatus && enabledLabel.isNotEmpty) {
      label = enabledLabel;
    }
    if (!currentStatus && disabledLabel.isNotEmpty) {
      label = disabledLabel;
    }
    return label;
  }

  Widget getFinalWidget(BuildContext context, Widget mainWidget,
      bool currentValue, List<Widget> childrenIfEnabled) {
    if (childrenIfEnabled == null || !currentValue) {
      return SettingsContainer(
        children: [mainWidget],
      );
    }
    List<Widget> _children = _getPaddedParentChildrenList(childrenIfEnabled);
    _children.insert(0, mainWidget);

    return SettingsContainer(
      children: _children,
    );
  }
}

/// [RadioSettingsTile] is a widget that has a list of [Radio] widgets with given title,
/// subtitle and default/group value which determines which Radio will be selected
/// initially.
///
/// This widget support Any type of values which should be put in the preference.
/// However, since any types of the value is supported, the input for this widget
/// is a Map to the required values with their string representation.
///
/// For example if the required value type is a boolean then the values map can
/// be as following:
///  <bool, String> {
///     true: 'Enabled',
///     false: 'Disabled'
///  }
///
/// So, if the `Enabled` value radio is selected then the value `true` will be
/// stored in the preference
///
/// Complete Example:
///
/// ```dart
/// RadioSettingsTile<int>(
///   title: 'Preferred Sync Period',
///   settingKey: 'key-radio-sync-period',
///   values: <int, String>{
///     0: 'Never',
///     1: 'Daily',
///     7: 'Weekly',
///     15: 'Fortnight',
///     30: 'Monthly',
///   },
///   selected: 0,
///   onChange: (value) {
///     debugPrint('key-radio-sync-period: $value days');
///   },
/// )
/// ```
class RadioSettingsTile<T> extends StatefulWidget {
  final String settingKey;
  final T selected;
  final Map<T, String> values;
  final String title;
  final String subtitle;
  final bool enabled;
  final bool showTitles;
  final OnChanged<T> onChange;
  final Widget leading;


  /// This callback is used to allow custom interaction to confirm the changes
  /// made by the user, which by default is considered as an async operation
  /// so the return value must be a `Future<bool>`
  ///
  ///
  /// It can be used like this,
  /// ```dart
  /// confirmChangeCallback: () async {
  ///   var confirmChange = await showConfirmationDialog();
  ///   return confirmChange;
  /// },
  /// ```
  final OnConfirmCallback confirmChangeCallback;

  RadioSettingsTile({
    @required this.title,
    @required this.settingKey,
    @required this.selected,
    @required this.values,
    this.enabled = true,
    this.onChange,
    this.leading,
    this.showTitles,
    this.subtitle = '',
    this.confirmChangeCallback,
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

  Future<void> _onRadioChange(T value, OnChanged<T> onChanged) async {
    bool allowChange = await _processConfirmation(widget.confirmChangeCallback);
    if (!allowChange) return;
    selectedValue = value;
    onChanged(value);
    widget.onChange?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    return ValueChangeObserver<T>(
      cacheKey: widget.settingKey,
      defaultValue: selectedValue,
      builder: (BuildContext context, T value, OnChanged<T> onChanged) {
        return SettingsContainer(
          children: <Widget>[
            Visibility(
              visible: showTitles,
              child: _SimpleHeaderTile(
                title: widget.title,
                subtitle: widget.subtitle != null && widget.subtitle.isNotEmpty
                    ? widget.subtitle
                    : widget.values[selectedValue],
                leading: widget.leading,
              ),
            ),
            _buildRadioTiles(context, value, onChanged)
          ],
        );
      },
    );
  }

  bool get showTitles => widget.showTitles ?? true;

  Widget _buildRadioTiles(
      BuildContext context, T groupValue, OnChanged<T> onChanged) {
    List<Widget> radioList =
        widget.values.entries.map<Widget>((MapEntry<T, String> entry) {
      return _SettingsTile(
        title: entry.value,
        onTap: () => _onRadioChange(entry.key, onChanged),
        enabled: widget.enabled,
        child: _SettingsRadio<T>(
          value: entry.key,
          onChanged: (T newValue) {
            _onRadioChange(newValue, onChanged);
          },
          enabled: widget.enabled,
          groupValue: groupValue,
        ),
      );
    }).toList();
    return Column(
      children: radioList,
    );
  }
}

/// [DropDownSettingsTile] is a widget that has a list of [DropdownMenuItem]s
/// with given title, subtitle and default/group value which determines
/// which value will be set to selected initially.
///
/// This widget support Any type of values which should be put in the preference.
///
/// However, since any types of the value is supported, the input for this widget
/// is a Map to the required values with their string representation.
///
/// For example if the required value type is a boolean then the values map can
/// be as following:
///  <bool, String> {
///     true: 'Enabled',
///     false: 'Disabled'
///  }
///
/// So, if the `Enabled` value is selected then the value `true` will be
/// stored in the preference
///
/// Complete Example:
///
/// ```dart
/// DropDownSettingsTile<int>(
///   title: 'E-Mail View',
///   settingKey: 'key-dropdown-email-view',
///   values: <int, String>{
///     2: 'Simple',
///     3: 'Adjusted',
///     4: 'Normal',
///     5: 'Compact',
///     6: 'Squeezed',
///   },
///   selected: 2,
///   onChange: (value) {
///     debugPrint('key-dropdown-email-view: $value');
///   },
/// );
/// ```
class DropDownSettingsTile<T> extends StatefulWidget {
  final String settingKey;
  final T selected;
  final Map<T, String> values;
  final String title;
  final String subtitle;
  final bool enabled;
  final OnChanged<T> onChange;


  /// This callback is used to allow custom interaction to confirm the changes
  /// made by the user, which by default is considered as an async operation
  /// so the return value must be a `Future<bool>`
  ///
  ///
  /// It can be used like this,
  /// ```dart
  /// confirmChangeCallback: () async {
  ///   var confirmChange = await showConfirmationDialog();
  ///   return confirmChange;
  /// },
  /// ```
  final OnConfirmCallback confirmChangeCallback;

  DropDownSettingsTile({
    @required this.title,
    @required this.settingKey,
    @required this.selected,
    @required this.values,
    this.enabled = true,
    this.onChange,
    this.subtitle = '',
    this.confirmChangeCallback,
  });

  @override
  _DropDownSettingsTileState<T> createState() =>
      _DropDownSettingsTileState<T>();
}

class _DropDownSettingsTileState<T> extends State<DropDownSettingsTile<T>> {
  T selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    return ValueChangeObserver<T>(
      cacheKey: widget.settingKey,
      defaultValue: selectedValue,
      builder: (BuildContext context, T value, OnChanged<T> onChanged) {
        return SettingsContainer(
          children: <Widget>[
            _SettingsTile(
              title: widget.title,
              subtitle: widget.subtitle,
              enabled: widget.enabled,
              child: _SettingsDropDown<T>(
                selected: value,
                values: widget.values.keys.toList().cast<T>(),
                onChanged: (T newValue) {
                  _handleDropDownChange(newValue, onChanged);
                },
                enabled: widget.enabled,
                itemBuilder: (T value) {
                  return Text(widget.values[value]);
                },
              ),
            )
          ],
        );
      },
    );
  }

  Future<void> _handleDropDownChange(T value, OnChanged<T> onChanged) async {
    bool allowChange = await _processConfirmation(widget.confirmChangeCallback);
    if (!allowChange) return;
    selectedValue = value;
    onChanged(value);
    widget.onChange?.call(value);
  }
}

/// [SliderSettingsTile] is a widget that has a slider given title,
/// subtitle and default value which determines what the slider's position
/// will be set initially.
///
/// This widget supports double and integer type of values which should be put in the preference.
///
/// Example:
///
/// ```dart
/// SliderSettingsTile(
///  title: 'Volume',
///  settingKey: 'key-slider-volume',
///  defaultValue: 20,
///  min: 0,
///  max: 100,
///  step: 1,
///  leading: Icon(Icons.volume_up),
///  onChange: (value) {
///    debugPrint('key-slider-volume: $value');
///  },
/// );
/// ```
class SliderSettingsTile extends StatefulWidget {
  final String settingKey;
  final double defaultValue;
  final String title;
  final String subtitle;
  final bool enabled;
  final bool eagerUpdate;
  final double min;
  final double max;
  final double step;
  final OnChanged<double> onChange;
  final OnChanged<double> onChangeStart;
  final OnChanged<double> onChangeEnd;
  final Widget leading;

  SliderSettingsTile({
    @required this.title,
    @required this.settingKey,
    this.defaultValue = 0.0,
    this.enabled = true,
    this.eagerUpdate = true,
    @required this.min,
    @required this.max,
    this.step = 1.0,
    this.onChange,
    this.onChangeStart,
    this.onChangeEnd,
    this.leading,
    this.subtitle = '',
  });

  @override
  _SliderSettingsTileState createState() => _SliderSettingsTileState();
}

class _SliderSettingsTileState extends State<SliderSettingsTile> {
  double currentValue;

  @override
  void initState() {
    super.initState();
    currentValue = widget.defaultValue;
  }

  @override
  Widget build(BuildContext context) {
    return ValueChangeObserver<double>(
      cacheKey: widget.settingKey,
      defaultValue: currentValue,
      builder:
          (BuildContext context, double value, OnChanged<double> onChanged) {
        debugPrint('creating settings Tile: ${widget.settingKey}');
        return SettingsContainer(
          children: <Widget>[
            _SimpleHeaderTile(
              title: widget.title,
              subtitle: widget.subtitle != null && widget.subtitle.isNotEmpty
                  ? widget.subtitle
                  : value.toString(),
              leading: widget.leading,
            ),
            _SettingsSlider(
              onChanged: (newValue) =>
                  _handleSliderChanged(newValue, onChanged),
              onChangeStart: (newValue) =>
                  _handleSliderChangeStart(newValue, onChanged),
              onChangeEnd: (newValue) =>
                  _handleSliderChangeEnd(newValue, onChanged),
              enabled: widget.enabled,
              value: value,
              max: widget.max,
              min: widget.min,
              step: widget.step,
            ),
            _SettingsTileDivider(),
          ],
        );
      },
    );
  }

  void _updateWidget(double newValue, OnChanged<double> onChanged) {
    currentValue = newValue;
    onChanged(newValue);
  }

  void _handleSliderChanged(double newValue, OnChanged<double> onChanged) {
    _updateWidget(newValue, onChanged);
    widget.onChange?.call(newValue);
  }

  void _handleSliderChangeStart(double newValue, OnChanged<double> onChanged) {
    _updateWidget(newValue, onChanged);
    widget.onChangeStart?.call(newValue);
  }

  void _handleSliderChangeEnd(double newValue, OnChanged<double> onChanged) {
    _updateWidget(newValue, onChanged);
    widget.onChangeEnd?.call(newValue);
  }
}

/// [ColorPickerSettingsTile] is a widget which allows user to
/// select the a color from a set of Material color choices.
///
/// Since, [Color] is an in-memory object type, the serialized version
/// of the value of this widget will be a Hex value [String] of the selected
/// color.
///
/// This conversion string <-> color, makes this easy to check/debug the values
/// from the storage/preference manually.
///
/// The color panel shown in the widget is provided by `flutter_material_color_picker` library.
///
/// Example:
///
/// ```dart
///  ColorPickerSettingsTile(
///    settingKey: 'key-color-picker',
///    title: 'Accent Color',
///    defaultValue: Colors.blue,
///    onChange: (value) {
///      debugPrint('key-color-picker: $value');
///    },
///  );
/// ```
class ColorPickerSettingsTile extends StatefulWidget {
  final String settingKey;
  final String defaultStringValue;
  final Color defaultValue;
  final String title;
  final String subtitle;
  final bool enabled;
  final OnChanged<Color> onChange;


  /// This callback is used to allow custom interaction to confirm the changes
  /// made by the user, which by default is considered as an async operation
  /// so the return value must be a `Future<bool>`
  ///
  ///
  /// It can be used like this,
  /// ```dart
  /// confirmChangeCallback: () async {
  ///   var confirmChange = await showConfirmationDialog();
  ///   return confirmChange;
  /// },
  /// ```
  final OnConfirmCallback confirmChangeCallback;

  ColorPickerSettingsTile({
    @required this.title,
    @required this.settingKey,
    this.defaultValue,
    this.enabled = true,
    this.onChange,
    this.defaultStringValue = '#ff000000',
    this.subtitle = '',
    this.confirmChangeCallback,
  });

  @override
  _ColorPickerSettingsTileState createState() =>
      _ColorPickerSettingsTileState();
}

class _ColorPickerSettingsTileState extends State<ColorPickerSettingsTile> {
  String currentValue;

  @override
  void initState() {
    super.initState();

    if (widget.defaultValue != null) {
      currentValue = Utils.stringFromColor(widget.defaultValue);
    } else {
      currentValue = widget.defaultStringValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueChangeObserver<String>(
      cacheKey: widget.settingKey,
      defaultValue: currentValue,
      builder:
          (BuildContext context, String value, OnChanged<String> onChanged) {
        debugPrint('creating settings Tile: ${widget.settingKey}');
        return _SettingsColorPicker(
          title: widget.title,
          value: value,
          enabled: widget.enabled,
          onChanged: (color) => _handleColorChanged(color, onChanged),
        );
      },
    );
  }

  Future<void> _handleColorChanged(String color,
      OnChanged<String> onChanged) async {
    bool allowChange = await _processConfirmation(widget.confirmChangeCallback);
    if (!allowChange) return;
    currentValue = color;
    onChanged(color);
    if (widget.onChange != null) {
      var colorFromString = Utils.colorFromString(color);
      widget.onChange(colorFromString);
    }
  }
}

/// [RadioModalSettingsTile] widget is the dialog version of the
/// [RadioSettingsTile] widget.
///
/// Meaning this widget is similar to a [RadioSettingsTile] shown in a dialog.
///
/// Use of this widget is similar to the [RadioSettingsTile], only the displayed
/// widget will be in a different position. i.e instead of the settings screen,
/// it will be shown in a dialog above the settings screen.
///
/// Example:
/// ```dart
/// RadioModalSettingsTile<int>(
///   title: 'Preferred Sync Period',
///   settingKey: 'key-radio-sync-period',
///   values: <int, String>{
///     0: 'Never',
///     1: 'Daily',
///     7: 'Weekly',
///     15: 'Fortnight',
///     30: 'Monthly',
///   },
///   selected: 0,
///   onChange: (value) {
///     debugPrint('key-radio-sync-period: $value days');
///   },
/// );
/// ```
///
class RadioModalSettingsTile<T> extends StatefulWidget {
  final String settingKey;
  final T selected;
  final Map<T, String> values;
  final String title;
  final String subtitle;
  final bool enabled;
  final bool showTitles;
  final OnChanged<T> onChange;


  /// This callback is used to allow custom interaction to confirm the changes
  /// made by the user, which by default is considered as an async operation
  /// so the return value must be a `Future<bool>`
  ///
  ///
  /// It can be used like this,
  /// ```dart
  /// confirmChangeCallback: () async {
  ///   var confirmChange = await showConfirmationDialog();
  ///   return confirmChange;
  /// },
  /// ```
  final OnConfirmCallback confirmChangeCallback;

  RadioModalSettingsTile({
    @required this.title,
    @required this.settingKey,
    @required this.selected,
    @required this.values,
    this.enabled = true,
    this.showTitles = false,
    this.onChange,
    this.subtitle = '',
    this.confirmChangeCallback,
  });

  @override
  _RadioModalSettingsTileState<T> createState() =>
      _RadioModalSettingsTileState<T>();
}

class _RadioModalSettingsTileState<T> extends State<RadioModalSettingsTile<T>> {
  T selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.selected;
  }

  Future<void> _onRadioChange(T value, OnChanged<T> onChanged) async {
    bool allowChange = await _processConfirmation(widget.confirmChangeCallback);
    if (!allowChange) return;
    selectedValue = value;
    onChanged(value);
    widget.onChange?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    return ValueChangeObserver<T>(
      cacheKey: widget.settingKey,
      defaultValue: selectedValue,
      builder: (BuildContext context, T value, OnChanged<T> onChanged) {
        return _ModalSettingsTile(
          children: <Widget>[
            RadioSettingsTile(
              title: '',
              showTitles: widget.showTitles,
              enabled: widget.enabled,
              values: widget.values,
              settingKey: widget.settingKey,
              onChange: (value) => _onRadioChange(value, onChanged),
              selected: value,
            ),
          ],
          title: widget.title,
          subtitle: widget.subtitle != null && widget.subtitle.isNotEmpty
              ? widget.subtitle
              : widget.values[value],
        );
      },
    );
  }
}

/// [SliderModalSettingsTile] widget is the dialog version of the
/// [SliderSettingsTile] widget.
///
/// Meaning this widget is similar to a [SliderSettingsTile] shown in a dialog.
///
/// Use of this widget is similar to the [SliderSettingsTile], only the displayed
/// widget will be in a different position. i.e instead of the settings screen,
/// it will be shown in a dialog above the settings screen.
///
/// Example:
/// ```dart
/// SliderSettingsTile(
///  title: 'Volume',
///  settingKey: 'key-slider-volume',
///  defaultValue: 20,
///  min: 0,
///  max: 100,
///  step: 1,
///  leading: Icon(Icons.volume_up),
///  onChange: (value) {
///    debugPrint('key-slider-volume: $value');
///  },
/// );
/// ```
///
class SliderModalSettingsTile extends StatefulWidget {
  final String settingKey;
  final double defaultValue;
  final String title;
  final String subtitle;
  final bool enabled;
  final double min;
  final double max;
  final double step;
  final OnChanged<double> onChange;
  final OnChanged<double> onChangeStart;
  final OnChanged<double> onChangeEnd;

  SliderModalSettingsTile({
    @required this.title,
    @required this.settingKey,
    this.defaultValue = 0.0,
    this.enabled = true,
    @required this.min,
    @required this.max,
    this.step = 0.0,
    this.onChange,
    this.onChangeStart,
    this.onChangeEnd,
    this.subtitle = '',
  });

  @override
  _SliderModalSettingsTileState createState() =>
      _SliderModalSettingsTileState();
}

class _SliderModalSettingsTileState extends State<SliderModalSettingsTile> {
  double currentValue;

  @override
  void initState() {
    super.initState();
    currentValue = widget.defaultValue;
  }

  @override
  Widget build(BuildContext context) {
    return ValueChangeObserver<double>(
      cacheKey: widget.settingKey,
      defaultValue: currentValue,
      builder:
          (BuildContext context, double value, OnChanged<double> onChanged) {
        debugPrint('creating settings Tile: ${widget.settingKey}');
        return SettingsContainer(
          children: <Widget>[
            _ModalSettingsTile(
              title: widget.title,
              subtitle: widget.subtitle != null && widget.subtitle.isNotEmpty
                  ? widget.subtitle
                  : value.toString(),
              children: <Widget>[
                _SettingsSlider(
                  onChanged: (double newValue) =>
                      _handleSliderChanged(newValue, onChanged),
                  onChangeStart: (double newValue) =>
                      _handleSliderChangeStart(newValue, onChanged),
                  onChangeEnd: (double newValue) =>
                      _handleSliderChangeEnd(newValue, onChanged),
                  enabled: widget.enabled,
                  value: value,
                  max: widget.max,
                  min: widget.min,
                  step: widget.step,
                )
              ],
            ),
          ],
        );
      },
    );
  }

  void _handleSliderChanged(double newValue, OnChanged<double> onChanged) {
    _updateWidget(newValue, onChanged);
    widget.onChange?.call(newValue);
  }

  void _handleSliderChangeStart(double newValue, OnChanged<double> onChanged) {
    _updateWidget(newValue, onChanged);
    widget.onChangeStart?.call(newValue);
  }

  void _handleSliderChangeEnd(double newValue, OnChanged<double> onChanged) {
    _updateWidget(newValue, onChanged);
    widget.onChangeEnd?.call(newValue);
  }

  void _updateWidget(double newValue, OnChanged<double> onChanged) {
    currentValue = newValue;
    onChanged(newValue);
  }
}

/// [SimpleRadioSettingsTile] is a simpler version of
/// the [RadioSettingsTile].
///
/// Instead of a Value-String map, this widget just takes a list
/// of String values.
///
/// Example:
/// ```dart
/// SimpleRadioSettingsTile(
///   title: 'Sync Settings',
///   settingKey: 'key-radio-sync-settings',
///   values: <String>[
///     'Never',
///     'Daily',
///     'Weekly',
///     'Fortnight',
///     'Monthly',
///   ],
///   selected: 'Daily',
///   onChange: (value) {
///     debugPrint('key-radio-sync-settings: $value');
///   },
/// );
/// ```
class SimpleRadioSettingsTile extends StatelessWidget {
  final String settingKey;
  final String selected;
  final List<String> values;
  final String title;
  final String subtitle;
  final bool enabled;
  final OnChanged<String> onChange;


  /// This callback is used to allow custom interaction to confirm the changes
  /// made by the user, which by default is considered as an async operation
  /// so the return value must be a `Future<bool>`
  ///
  ///
  /// It can be used like this,
  /// ```dart
  /// confirmChangeCallback: () async {
  ///   var confirmChange = await showConfirmationDialog();
  ///   return confirmChange;
  /// },
  /// ```
  final OnConfirmCallback confirmChangeCallback;

  SimpleRadioSettingsTile({
    @required this.title,
    @required this.settingKey,
    @required this.selected,
    @required this.values,
    this.enabled = true,
    this.onChange,
    this.subtitle = '',
    this.confirmChangeCallback,
  });

  @override
  Widget build(BuildContext context) {
    return RadioSettingsTile<String>(
      title: title,
      subtitle: subtitle,
      settingKey: settingKey,
      selected: selected,
      enabled: enabled,
      onChange: onChange,
      values: getValues(values),
      confirmChangeCallback: confirmChangeCallback,
    );
  }

  Map<String, String> getValues(List<String> values) {
    Map<String, String> valueMap = Map<String, String>();
    values.forEach((String value) {
      valueMap[value] = value;
    });
    return valueMap;
  }
}

/// [SimpleDropDownSettingsTile] is a simpler version of
/// the [DropDownSettingsTile].
///
/// Instead of a Value-String map, this widget just takes a list
/// of String values.
///
/// Example:
/// ```dart
/// SimpleDropDownSettingsTile(
///   title: 'Beauty Filter',
///   settingKey: 'key-dropdown-beauty-filter',
///   values: <String>[
///     'Simple',
///     'Normal',
///     'Little Special',
///     'Special',
///     'Extra Special',
///     'Bizzar',
///     'Horrific',
///   ],
///   selected: 'Special',
///   onChange: (value) {
///     debugPrint('key-dropdown-beauty-filter: $value');
///  },
/// );
/// ```
class SimpleDropDownSettingsTile extends StatelessWidget {
  final String settingKey;
  final String selected;
  final List<String> values;
  final String title;
  final String subtitle;
  final bool enabled;
  final OnChanged<String> onChange;


  /// This callback is used to allow custom interaction to confirm the changes
  /// made by the user, which by default is considered as an async operation
  /// so the return value must be a `Future<bool>`
  ///
  ///
  /// It can be used like this,
  /// ```dart
  /// confirmChangeCallback: () async {
  ///   var confirmChange = await showConfirmationDialog();
  ///   return confirmChange;
  /// },
  /// ```
  final OnConfirmCallback confirmChangeCallback;

  SimpleDropDownSettingsTile({
    @required this.title,
    @required this.settingKey,
    @required this.selected,
    @required this.values,
    this.enabled = true,
    this.onChange,
    this.subtitle = '',
    this.confirmChangeCallback,
  });

  @override
  Widget build(BuildContext context) {
    return DropDownSettingsTile<String>(
      title: title,
      subtitle: subtitle,
      settingKey: settingKey,
      selected: selected,
      enabled: enabled,
      onChange: onChange,
      values: getValues(values),
      confirmChangeCallback: confirmChangeCallback,
    );
  }

  Map<String, String> getValues(List<String> values) {
    Map<String, String> valueMap = Map<String, String>();
    values.forEach((String value) {
      valueMap[value] = value;
    });
    return valueMap;
  }
}

List<Widget> _getPaddedParentChildrenList(List<Widget> childrenIfEnabled) {
  List<Widget> children = <Widget>[];
  var _paddedChildren = _getPaddedChildren(childrenIfEnabled);
  children.addAll(_paddedChildren);
  return children;
}

List<Widget> _getPaddedChildren(List<Widget> childrenIfEnabled) {
  return childrenIfEnabled.map<Widget>((childWidget) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0),
      child: childWidget,
    );
  }).toList();
}

TextStyle headerTextStyle(BuildContext context) =>
    Theme
        .of(context)
        .textTheme
        .headline6
        .copyWith(fontSize: 16.0);

TextStyle subtitleTextStyle(BuildContext context) =>
    Theme
        .of(context)
        .textTheme
        .subtitle2
        .copyWith(fontSize: 13.0, fontWeight: FontWeight.normal);

Future<bool> _processConfirmation(
    OnConfirmCallback confirmChangeCallback,) async {
  var allowChange = true;
  if (confirmChangeCallback != null) {
    allowChange = await confirmChangeCallback?.call();
    allowChange ??= false; // in case use dismissed the pop up dialog
  }
  return allowChange;
}
