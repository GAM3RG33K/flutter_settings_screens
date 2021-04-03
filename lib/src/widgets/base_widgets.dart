part of 'settings_widgets.dart';

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
  /// title string for the tile
  final String title;

  /// subtitle string for the tile, default = ''
  final String subtitle;

  /// flag to represent if the tile is accessible or not, if false user input is ignored
  /// default = true
  final bool enabled;

  /// flag to represent the current state of the expansion tile, if true it means that
  /// the tile is in expanded mode
  /// default = false
  final bool expanded;

  /// The widget displayed when the tile is expanded
  final Widget child;

  /// The widget shown in front of the title
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
      leading: widget.leading,
      child: Text(''),
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
        initiallyExpanded: widget.expanded,
        childrenPadding: EdgeInsets.only(left: 8.0),
        children: <Widget>[widget.child],
      ),
    );
  }
}

///[_ModalSettingsTile] is a widget which shows the given child widget inside a
/// dialog view.
///
/// This widget can be used to show a settings UI which is too big for a single
///  tile in the SettingScreen UI or a Setting tile which needs to be shown separately.
class _ModalSettingsTile<T> extends StatefulWidget {
  /// title string for the tile
  final String title;

  /// subtitle string for the tile, default = ''
  final String subtitle;

  /// flag to represent if the tile is accessible or not, if false user input is ignored
  /// default = true
  final bool enabled;

  /// The widget shown in front of the title
  final Widget leading;

  /// The list widgets which will be displayed in a vertical list manner
  /// when the dialog is displayed
  final List<Widget> children;

  /// flag that determines if the dialog will be displayed with
  /// confirmation buttons or not .
  /// Buttons like, ok & cancel
  ///
  /// default = false
  final bool showConfirmation;

  /// Callback to execute when user taps cancel button,
  /// It is a simple void callback to execute when user wants to revert the changes
  /// back to previous
  ///
  /// **Note**: the action performed will not affect the settings that were updated
  /// automatically. However you can choose to modify them as per your need by referencing
  /// the values from the callback & updating
  final VoidCallback onCancel;

  /// Callback to execute when user taps ok button, while [onCancel] callback
  /// is a simple void callback, this one allows you to perform some task
  /// before closing the dialog.
  ///
  /// **Note**: the action performed will not affect the settings that were updated
  /// automatically. However you can choose to modify them as per your need by referencing
  /// the values from the callback & updating
  final OnConfirmedCallback onConfirm;

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
            contentPadding: EdgeInsets.zero,
            children: _finalWidgets(dialogContext, children),
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
        TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
          ),
          onPressed: () {
            widget.onCancel?.call();
            _disposeDialog(dialogContext);
          },
          child:
              Text(MaterialLocalizations.of(dialogContext).cancelButtonLabel),
        ),
        TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
          ),
          onPressed: () async {
            var closeDialog = true;
            if (widget.onConfirm != null) {
              closeDialog = widget.onConfirm();
            }

            if (closeDialog) {
              _disposeDialog(dialogContext);
            }
          },
          child: Text(MaterialLocalizations.of(dialogContext).okButtonLabel),
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
      activeColor: Theme.of(context).accentColor,
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
    return Switch.adaptive(
      value: value,
      onChanged: enabled ? onChanged : null,
      activeColor: Theme.of(context).accentColor,
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
          value: selected,
          onChanged: enabled ? onChanged : null,
          underline: Container(),
          items: values.map<DropdownMenuItem<T>>(
            (T val) {
              return DropdownMenuItem<T>(
                value: val,
                child: itemBuilder(val),
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

  /// flag which allows updating the value of setting immediately when the
  /// slider is moved, default = true
  ///
  /// If this flag is enabled then [onChangeStart] & [onChangeEnd] callbacks are
  /// ignored & will not be executed
  final bool eagerUpdate;

  _SettingsSlider({
    @required this.value,
    @required this.min,
    @required this.max,
    @required this.step,
    @required this.enabled,
    this.onChangeStart,
    this.onChanged,
    this.onChangeEnd,
    this.eagerUpdate = true,
  });

  @override
  Widget build(BuildContext context) {
    return Slider.adaptive(
      value: value,
      min: min,
      max: max,
      divisions: (max - min) ~/ (step),
      onChangeStart: enabled && !eagerUpdate
          ? (value) => onChangeStart(value.roundToDouble())
          : null,
      onChanged: enabled ? (value) => onChanged(value.roundToDouble()) : null,
      onChangeEnd: enabled && !eagerUpdate
          ? (value) => onChangeEnd(value.roundToDouble())
          : null,
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
      },
    );
  }
}
