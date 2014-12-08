// DO NOT EDIT: auto-generated with `pub run custom_element_apigen:update`

/// Dart API for the polymer element `core_dropdown_base`.
library core_elements.core_dropdown_base;

import 'dart:html';
import 'dart:js' show JsArray, JsObject;
import 'package:web_components/interop.dart' show registerDartType;
import 'package:polymer/polymer.dart' show initMethod;
import 'package:custom_element_apigen/src/common.dart' show DomProxyMixin;

/// `core-dropdown-base` is a base class for implementing controls that displays
/// an overlay when tapped on.
///
/// The child element with the class `dropdown` will be used as the drop-down. It
/// should be a `core-dropdown` or other overlay element.
class CoreDropdownBase extends HtmlElement with DomProxyMixin {
  CoreDropdownBase.created() : super.created();
  factory CoreDropdownBase() => new Element.tag('core-dropdown-base');

  get $ => jsElement[r'$'];

  /// True if the menu is open.
  bool get opened => jsElement[r'opened'];
  set opened(bool value) { jsElement[r'opened'] = value; }

  get dropdown => jsElement[r'dropdown'];
}
@initMethod
upgradeCoreDropdownBase() => registerDartType('core-dropdown-base', CoreDropdownBase);
