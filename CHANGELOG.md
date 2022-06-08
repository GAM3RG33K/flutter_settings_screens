## 0.3.3-null-safety+1
 - Fix issue where implementation for setObject in default cache provider always throws exception
 - Custom text style in all widgets
 - Clear the notifiers map when the widget is disposed

## 0.3.3-null-safety
 - Breaking Changes:
   - Cache Provider interface definition updated to allow asynchronous getter/setter
   - Optional Default values are moved to getters instead of setters
   - Flutter SDK version upgraded to 2.15.0 & upgraded the plugin dependencies
   - Changed all getters & setters definitions to support null values
   - Changed Settings implementation according to new changes
 - Example app moved Flutter SDK to 2.15.0
 - Updated example app implementation
 - Updated Code documentation in cache provider interface


## 0.3.2-null-safety
 - Provider version updated to 6.0.0, thanks to @Pawelek55
 - ExpandedSettingTile were not using the provided expanded status, fixed by @Colton127
 - Updated theme changes in the source code & in the example to resolve analyzer warnings

## 0.3.1-null-safety
 - added functionality to update the specific SettingsUI by updating it's value
   by calling setValue with `notify` as `true`.

   Example:
   ```dart
    await Settings.setValue<T>(cacheKey, newValue, notify: true);
   ```

 - Fix - Unresponsive tapping of the switch tile, fixed by @pascalwils
 - Updated ReadMe content to match new updates
 - Updated example app code to demo the UI update functionality
    - Checkout Auto adjusting Volume slider

## 0.3.0-null-safety
 - null-safety migration
 - bug-fix for slider not respecting step value in decimal points

## 0.2.2+1
 - complete dependency update to latest

## 0.2.2
 - remove autovalidate option to comply with new sdk changes
 - remove unnecessary use of Generic cache provider interface
    `Set<E> getKeys<E>()` -> `Set getKeys()`
	- reason for this is that generics may restrict some implementation in some way
	- to achieve the same effect as the generics implementation, one can just `cast` the set as they want
	- if the whole interface depends on generics only then the previous declaration makes sense.
 - update & fix example app code
 - plugin code organization & documentation updates

#### Developer Note:
  1. The sdk upgrade will be done in two stages
    - stage 1: only update the dependencies with code changes to comply with the updates
	- stage 2: update the flutter/dart sdk version along with the least version of supported dependencies
  2. Few of the next releases may contain some breaking changes in relation to cache provider implementation
  3. A few of the planned updates:
      - null safety support for library
      - cache provider structuring to support universal implementation, allows using any storage platform to be used
	    like, shared_preferences, hive, flutter_secure_storage, etc
	  - massive UI customization in terms of platforms & designs
	  - conditional changes or changes with confirmation
	  - settings value change observation

**If you have any suggestions and/or support to offer please file an issue in the repository & let me know, use `[Suggestion]` or `[FeatureRequest]` tags in issue titles**

## 0.2.1+1
* improved overall alignment of settings tiles
* update cache provide code to make asynchronous calls to setter methods
  - autoValidated parameter in text input settings is now deprecated and will be removed soon. User `autoValidateMode` parameter instead.
* removed native platform dependency code as this library does not depend on native features. At least not directly.

## 0.2.1
* `SimpleSettingsTile` will take any widget as `child` instead of only `SettingsScreen`
  - **Breaking**: parameter name changed from `screen` to `child` for consistency
* Added `subtitle` property for most settings tiles to allow a describing how this setting may introduce change in behaviour of the app
* Improved Settings title and subtitle text style for consistency in UI
* `SliderSettings` now have 2 additional callbacks:
  - onChangeStart - allows detecting drag start event
  - onChangeEnd - allows detecting drag end event
     - Using this allows changing the slider value only when user stops sliding
* Updated Example code to reflect latest features 

## 0.2.0+1
* improved plugin initialization, now supports async method call
* resolved a bug where Radio Settings was not reflecting changes

## 0.2.0
* complete re-do of the whole library
  * removed rx-dart dependency
  * improved the working of the many existing settings widgets
    * many of the choice based widgets now support any primitive value as input/output values instead of just strings
    * added more customization choices per setting widget
  * added a default cache provider which is based on `shared_preferences` library by flutter team
* updated code documentation

#### Breaking Change:
Your existing use of some settings widgets might show error or not work as due to them being re-designed, like change in name/type of the parameters or the widget itself is renamed.

This was a major re-design/refactor of the library, so please re-test part of your code which uses this library.

## 0.1.0+0.2
* update in license file

## 0.1.0+0.1
* 0.1.0 release + update in documentation and sdk version constraints

## 0.1.0
* first release

## 0.0.1
* initial code release