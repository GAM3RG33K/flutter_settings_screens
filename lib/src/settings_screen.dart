import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:flutter_settings_screens/src/utils/utils.dart';

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

class _SettingsTile extends StatefulWidget {
  final String title;
  final Widget leading;
  final String subtitle;
  final bool enabled;
  final Widget child;
  final Function onTap;
  final bool childBelowTitle;

  _SettingsTile({
    @required this.title,
    @required this.child,
    this.subtitle = '',
    this.onTap,
    this.enabled = true,
    this.childBelowTitle = false,
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
            title: Text(widget.title),
            subtitle: widget.subtitle.isEmpty ? null : Text(widget.subtitle),
            enabled: widget.enabled,
            onTap: widget.enabled ? widget.onTap : null,
            trailing: Visibility(
              visible: !widget.childBelowTitle,
              child: widget.child,
            ),
            dense: true,
          ),
          Visibility(
            visible: widget.childBelowTitle,
            child: widget.child,
          ),
          _SettingsTileDivider(),
        ],
      ),
    );
  }
}

class _SimpleHeaderTile extends StatefulWidget {
  final String title;
  final String subtitle;
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
        title: Text(widget.title),
        subtitle: widget.subtitle.isNotEmpty ? Text(widget.subtitle) : null,
        leading: widget.leading,
      ),
    );
  }
}

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
        title: Text(widget.title),
        leading: widget.leading,
        subtitle: Text(widget.subtitle),
        children: <Widget>[widget.child],
        initiallyExpanded: widget.expanded,
      ),
    );
  }
}

class _ModalSettingsTile extends StatefulWidget {
  final String title;
  final String subtitle;
  final bool enabled;
  final Widget leading;
  final List<Widget> children;
  final bool showConfirmation;
  final GestureTapCallback onCancel;
  final GestureTapCallback onConfirm;

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
        title: Text(widget.title),
        subtitle: Text(widget.subtitle),
        enabled: widget.enabled,
        onTap:
        widget.enabled ? () => _showWidget(context, widget.children) : null,
        dense: true,
      ),
    );
  }

  void _showWidget(BuildContext context, List<Widget> children) {
    showDialog(
        context: context,
        builder: (dialogContext) {
          return SimpleDialog(
            title: Center(child: getTitle()),
            titlePadding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 2.0),
            elevation: 1.0,
            children: _finalWidgets(dialogContext, children),
            contentPadding: EdgeInsets.zero,
          );
        });
  }

  List<Widget> _finalWidgets(BuildContext dialogContext,
      List<Widget> children) {
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
        Text(widget.title),
      ],
    )
        : Text(widget.title);
  }

  List<Widget> _addActionWidgets(BuildContext dialogContext,
      List<Widget> children) {
    final finalList = List<Widget>.from(children);
    finalList.add(Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        FlatButton(
          padding: EdgeInsets.zero,
          child: Text('Cancel'),
          onPressed: () {
            if (widget.onCancel != null) {
              widget.onCancel();
            }
            _disposeDialog(dialogContext);
          },
        ),
        FlatButton(
          child: Text('OK'),
          padding: EdgeInsets.zero,
          onPressed: () {
            if (widget.onConfirm != null) {
              widget.onConfirm();
            }
            _disposeDialog(dialogContext);
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
  final Widget leading;

  SimpleSettingsTile({
    @required this.title,
    this.subtitle,
    this.screen,
    this.enabled = true,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return _SettingsTile(
      leading: leading,
      title: title,
      subtitle: subtitle,
      enabled: enabled,
      child: screen != null ? getIcon(context) : Text(''),
      onTap: enabled ? () => _handleTap(context) : null,
    );
  }

  Widget getIcon(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.navigate_next),
      onPressed: enabled ? () => _handleTap(context) : null,
    );
  }

  void _handleTap(BuildContext context) {
    if (screen == null) {
      return;
    }
    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => screen,
    ));
  }
}

class SimpleModalSettingsTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Widget> children;
  final bool enabled;
  final Widget leading;

  SimpleModalSettingsTile({
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

class SimpleExpandableSettingsTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Widget> children;
  final bool enabled;
  final bool expanded;
  final Widget leading;

  SimpleExpandableSettingsTile({
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
  final bool scrollable;

  SettingsContainer({
    this.children,
    this.scrollable = false,
  });

  @override
  Widget build(BuildContext context) {
    return _buildChild();
  }

  Widget _buildChild() {
    Widget child = scrollable ? getList(children) : getColumn(children);
    return Padding(
      padding: EdgeInsets.only(
        top: 16.0,
      ),
      child: Material(
        child: Container(
          padding: EdgeInsets.only(left: 4.0),
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
    return Wrap(
      children: <Widget>[
        Column(
          children: elements,
        )
      ],
    );
  }
}

class _SettingsCheckbox extends StatelessWidget {
  final bool value;
  final OnChanged<bool> onChanged;
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
  final OnChanged<bool> onChanged;
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

class _SettingsRadio<T> extends StatelessWidget {
  final T groupValue;
  final T value;
  final OnChanged<T> onChanged;
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

class _SettingsDropDown<T> extends StatelessWidget {
  final T selected;
  final List<T> values;
  final OnChanged<T> onChanged;
  final SimpleWidgetBuilder<T> child;
  final bool enabled;

  _SettingsDropDown({
    @required this.selected,
    @required this.values,
    @required this.onChanged,
    this.child,
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
          onChanged: onChanged,
          underline: Container(),
          items: values.map<DropdownMenuItem<T>>(
                (T val) {
              return DropdownMenuItem<T>(
                child: child(val),
                value: val,
              );
            },
          ).toList(),
        ),
      ],
    );
  }
}

class _SettingsSlider extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final double step;
  final OnChanged<double> onChanged;
  final bool enabled;

  _SettingsSlider({
    @required this.value,
    @required this.min,
    @required this.max,
    @required this.step,
    @required this.onChanged,
    @required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: value,
      min: min,
      max: max,
      divisions: (max - min) ~/ (step),
      onChanged: enabled ? onChanged : null,
    );
  }
}

class _SettingsColorPicker extends StatelessWidget {
  final String value;
  final OnChanged<String> onChanged;
  final bool enabled;
  final String title;

  _SettingsColorPicker({
    @required this.value,
    @required this.onChanged,
    @required this.enabled,
    @required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return _SettingsTile(
      title: title,
      subtitle: value,
      enabled: enabled,
      onTap: enabled ? () => _showColorPicker(context, value) : null,
      child: FloatingActionButton(
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

class TextInputSettingsTile extends StatefulWidget {
  final String settingKey;
  final String initialValue;
  final String title;
  final bool enabled;
  final OnChanged<String> onChange;
  final FormFieldValidator<String> validator;
  final bool obscureText;
  final Color borderColor;
  final Color errorColor;

  TextInputSettingsTile({
    @required this.title,
    @required this.settingKey,
    this.initialValue = '',
    this.enabled = true,
    this.onChange,
    this.validator,
    this.obscureText = false,
    this.borderColor,
    this.errorColor,
  });

  @override
  _TextInputSettingsTileState createState() => _TextInputSettingsTileState();
}

class _TextInputSettingsTileState extends State<TextInputSettingsTile> {
//  String currentValue;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return CacheChangeObserver<String>(
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
          onConfirm: () {
            _submitText(_controller.text);
          },
        );
      },
    );
  }

  Widget _buildTextField(BuildContext context, String value,
      OnChanged<String> onChanged) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          autovalidate: true,
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
                borderSide:
                BorderSide(color: widget.borderColor ?? Colors.blue),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
                borderSide:
                BorderSide(color: widget.borderColor ?? Colors.blue),
              )),
        ),
      ),
    );
  }

  void _submitText(String newValue) {
    bool isValid = true;
    final state = _formKey.currentState;
    if (state != null) {
      isValid = state.validate() ?? false;
    }

    if (isValid) {
      state.save();
    }
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
  final OnChanged<bool> onChange;
  final Widget leading;
  final String enabledLabel;
  final String disabledLabel;
  final List<Widget> childrenIfEnabled;

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
  });

  @override
  Widget build(BuildContext context) {
    return CacheChangeObserver<bool>(
      cacheKey: settingKey,
      defaultValue: defaultValue,
      builder: (BuildContext context, bool value, OnChanged<bool> onChanged) {
        Widget mainWidget = _SettingsTile(
          leading: leading,
          title: title,
          subtitle: getSubtitle(value),
          onTap: enabled ? () => onChanged(!value) : null,
          child: _SettingsSwitch(
            value: value,
            onChanged:
            enabled ? (value) => _onSwitchChange(value, onChanged) : null,
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

  void _onSwitchChange(bool value, OnChanged<bool> onChanged) {
    onChanged(value);
    if (onChange != null) {
      onChange(value);
    }
  }

  String getSubtitle(bool currentStatus) {
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
        children: <Widget>[
          mainWidget,
        ],
      );
    }
    List<Widget> children = <Widget>[mainWidget];
    children.addAll(childrenIfEnabled);
    return SettingsContainer(
      children: children,
    );
  }
}

class CheckboxSettingsTile extends StatelessWidget {
  final String settingKey;
  final bool defaultValue;
  final String title;
  final bool enabled;
  final OnChanged<bool> onChange;
  final Widget leading;
  final String enabledLabel;
  final String disabledLabel;
  final List<Widget> childrenIfEnabled;

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
  });

  @override
  Widget build(BuildContext context) {
    return CacheChangeObserver<bool>(
      cacheKey: settingKey,
      defaultValue: defaultValue,
      builder: (BuildContext context, bool value, OnChanged<bool> onChanged) {
        var mainWidget = _SettingsTile(
          leading: leading,
          title: title,
          subtitle: getSubtitle(value),
          onTap: enabled ? () => _onCheckboxChange(!value, onChanged) : null,
          child: _SettingsCheckbox(
            value: value,
            onChanged:
            enabled ? (value) => _onCheckboxChange(value, onChanged) : null,
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

  void _onCheckboxChange(bool value, OnChanged<bool> onChanged) {
    onChanged(value);
    if (onChange != null) {
      onChange(value);
    }
  }

  String getSubtitle(bool currentStatus) {
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
        children: <Widget>[mainWidget],
      );
    }
    List<Widget> children = <Widget>[mainWidget];
    children.addAll(childrenIfEnabled);
    return SettingsContainer(
      children: children,
    );
  }
}

class RadioSettingsTile<T> extends StatefulWidget {
  final String settingKey;
  final T selected;
  final Map<T, String> values;
  final String title;
  final bool enabled;
  final OnChanged<T> onChange;
  final Widget leading;

  RadioSettingsTile({
    @required this.title,
    @required this.settingKey,
    @required this.selected,
    @required this.values,
    this.enabled = true,
    this.onChange,
    this.leading,
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

  void _onRadioChange(T value, OnChanged<T> onChanged) {
    selectedValue = value;
    onChanged(value);
    if (widget.onChange != null) {
      widget.onChange(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CacheChangeObserver<T>(
      cacheKey: widget.settingKey,
      defaultValue: selectedValue,
      builder: (BuildContext context, T value, OnChanged<T> onChanged) {
        return SettingsContainer(
          children: <Widget>[
            _SimpleHeaderTile(
              title: widget.title,
              subtitle: widget.values[selectedValue],
              leading: widget.leading,
            ),
            _buildRadioTiles(context, value, onChanged)
          ],
        );
      },
    );
  }

  Widget _buildRadioTiles(BuildContext context, T groupValue,
      OnChanged<T> onChanged) {
    List<Widget> radioList =
    widget.values.entries.map<Widget>((MapEntry<T, String> entry) {
      return _SettingsTile(
        title: entry.value,
        onTap:
        widget.enabled ? () => _onRadioChange(entry.key, onChanged) : null,
        child: _SettingsRadio<T>(
          value: entry.key,
          onChanged: widget.enabled
              ? (T newValue) {
            _onRadioChange(newValue, onChanged);
          }
              : null,
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

class DropDownSettingsTile<T> extends StatefulWidget {
  final String settingKey;
  final T selected;
  final Map<T, String> values;
  final String title;
  final bool enabled;
  final OnChanged<T> onChange;

  DropDownSettingsTile({
    @required this.title,
    @required this.settingKey,
    @required this.selected,
    @required this.values,
    this.enabled = true,
    this.onChange,
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
    return CacheChangeObserver<T>(
      cacheKey: widget.settingKey,
      defaultValue: selectedValue,
      builder: (BuildContext context, T value, OnChanged<T> onChanged) {
        return SettingsContainer(
          children: <Widget>[
            _SettingsTile(
              title: widget.title,
              child: _SettingsDropDown<T>(
                selected: value,
                values: widget.values.keys.toList().cast<T>(),
                onChanged: widget.enabled
                    ? (T newValue) {
                  _handleDropDownChange(newValue, onChanged);
                }
                    : null,
                enabled: widget.enabled,
                child: (T value) {
                  return Text(widget.values[value]);
                },
              ),
            )
          ],
        );
      },
    );
  }

  void _handleDropDownChange(T value, OnChanged<T> onChanged) {
    selectedValue = value;
    onChanged(value);
    if (widget.onChange != null) {
      widget.onChange(value);
    }
  }
}

class SliderSettingsTile extends StatefulWidget {
  final String settingKey;
  final double defaultValue;
  final String title;
  final bool enabled;
  final double min;
  final double max;
  final double step;
  final OnChanged<double> onChange;
  final Widget leading;

  SliderSettingsTile({
    @required this.title,
    @required this.settingKey,
    this.defaultValue = 0.0,
    this.enabled = true,
    @required this.min,
    @required this.max,
    this.step = 1.0,
    this.onChange,
    this.leading,
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
    return CacheChangeObserver<double>(
      cacheKey: widget.settingKey,
      defaultValue: currentValue,
      builder:
          (BuildContext context, double value, OnChanged<double> onChanged) {
        debugPrint('creating settings Tile: ${widget.settingKey}');
        return SettingsContainer(
          children: <Widget>[
            _SimpleHeaderTile(
              title: widget.title,
              subtitle: value.toString(),
              leading: widget.leading,
            ),
            _SettingsSlider(
              onChanged: widget.enabled
                  ? (double newValue) =>
                  _handleSliderChanged(newValue, onChanged)
                  : null,
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

  void _handleSliderChanged(double newValue, OnChanged<double> onChanged) {
    currentValue = newValue;
    onChanged(newValue);
    if (widget.onChange != null) {
      widget.onChange(newValue);
    }
  }
}

class ColorPickerSettingsTile extends StatefulWidget {
  final String settingKey;
  final String defaultStringValue;
  final Color defaultValue;
  final String title;
  final bool enabled;
  final OnChanged<Color> onChange;

  ColorPickerSettingsTile({
    @required this.title,
    @required this.settingKey,
    this.defaultValue,
    this.enabled = true,
    this.onChange,
    this.defaultStringValue = '#ff000000',
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
    return CacheChangeObserver<String>(
      cacheKey: widget.settingKey,
      defaultValue: currentValue,
      builder:
          (BuildContext context, String value, OnChanged<String> onChanged) {
        debugPrint('creating settings Tile: ${widget.settingKey}');
        return _SettingsColorPicker(
          title: widget.title,
          value: value,
          enabled: widget.enabled,
          onChanged: widget.enabled
              ? (color) => _handleColorChanged(color, onChanged)
              : null,
        );
      },
    );
  }

  void _handleColorChanged(String color, OnChanged<String> onChanged) {
    currentValue = color;
    onChanged(color);
    if (widget.onChange != null) {
      var colorFromString = Utils.colorFromString(color);
      widget.onChange(colorFromString);
    }
  }
}

class RadioModalSettingsTile<T> extends StatefulWidget {
  final String settingKey;
  final T selected;
  final Map<T, String> values;
  final String title;
  final bool enabled;
  final OnChanged<T> onChange;

  RadioModalSettingsTile({
    @required this.title,
    @required this.settingKey,
    @required this.selected,
    @required this.values,
    this.enabled = true,
    this.onChange,
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

  void _onRadioChange(T value, OnChanged<T> onChanged) {
    selectedValue = value;
    onChanged(value);
    if (widget.onChange != null) {
      widget.onChange(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CacheChangeObserver<T>(
      cacheKey: widget.settingKey,
      defaultValue: selectedValue,
      builder: (BuildContext context, T value, OnChanged<T> onChanged) {
        return _ModalSettingsTile(
          children: <Widget>[_buildRadioTiles(context, value, onChanged)],
          title: widget.title,
          subtitle: widget.values[selectedValue],
        );
      },
    );
  }

  Widget _buildRadioTiles(BuildContext context, T groupValue,
      OnChanged<T> onChanged) {
    List<Widget> radioList =
    widget.values.entries.map<Widget>((MapEntry<T, String> entry) {
      return Padding(
        padding: const EdgeInsets.all(0.0),
        child: _SettingsTile(
          title: entry.value,
          onTap: widget.enabled
              ? () => _onRadioChange(entry.key, onChanged)
              : null,
          child: _SettingsRadio<T>(
            value: entry.key,
            onChanged: widget.enabled
                ? (T newValue) {
              _onRadioChange(newValue, onChanged);
            }
                : null,
            enabled: widget.enabled,
            groupValue: groupValue,
          ),
        ),
      );
    }).toList();
    return Column(
      children: radioList,
    );
  }
}

class SliderModalSettingsTile extends StatefulWidget {
  final String settingKey;
  final double defaultValue;
  final String title;
  final bool enabled;
  final double min;
  final double max;
  final double step;
  final OnChanged<double> onChange;

  SliderModalSettingsTile({
    @required this.title,
    @required this.settingKey,
    this.defaultValue = 0.0,
    this.enabled = true,
    @required this.min,
    @required this.max,
    this.step = 0.0,
    this.onChange,
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
    return CacheChangeObserver<double>(
      cacheKey: widget.settingKey,
      defaultValue: currentValue,
      builder:
          (BuildContext context, double value, OnChanged<double> onChanged) {
        debugPrint('creating settings Tile: ${widget.settingKey}');
        return SettingsContainer(
          children: <Widget>[
            _ModalSettingsTile(
              title: widget.title,
              subtitle: value.toString(),
              children: <Widget>[
                _SettingsSlider(
                  onChanged: widget.enabled
                      ? (double newValue) =>
                      _handleSliderChanged(newValue, onChanged)
                      : null,
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
    currentValue = newValue;
    onChanged(newValue);
    if (widget.onChange != null) {
      widget.onChange(newValue);
    }
  }
}

class SimpleRadioSettingsTile extends StatelessWidget {
  final String settingKey;
  final String selected;
  final List<String> values;
  final String title;
  final bool enabled;
  final OnChanged<String> onChange;

  SimpleRadioSettingsTile({@required this.title,
    @required this.settingKey,
    @required this.selected,
    @required this.values,
    this.enabled = true,
    this.onChange});

  @override
  Widget build(BuildContext context) {
    return RadioSettingsTile<String>(
      title: title,
      settingKey: settingKey,
      selected: selected,
      enabled: enabled,
      onChange: onChange,
      values: getValues(values),
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

class SimpleDropDownSettingsTile extends StatelessWidget {
  final String settingKey;
  final String selected;
  final List<String> values;
  final String title;
  final bool enabled;
  final OnChanged<String> onChange;

  SimpleDropDownSettingsTile({@required this.title,
    @required this.settingKey,
    @required this.selected,
    @required this.values,
    this.enabled = true,
    this.onChange});

  @override
  Widget build(BuildContext context) {
    return DropDownSettingsTile<String>(
      title: title,
      settingKey: settingKey,
      selected: selected,
      enabled: enabled,
      onChange: onChange,
      values: getValues(values),
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
// TODO(hjoshi): add TextField Settings
