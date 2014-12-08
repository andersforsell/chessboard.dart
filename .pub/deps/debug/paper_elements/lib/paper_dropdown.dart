// DO NOT EDIT: auto-generated with `pub run custom_element_apigen:update`

/// Dart API for the polymer element `paper_dropdown`.
library paper_elements.paper_dropdown;

import 'dart:html';
import 'dart:js' show JsArray, JsObject;
import 'package:web_components/interop.dart' show registerDartType;
import 'package:polymer/polymer.dart' show initMethod;
import 'package:core_elements/core_dropdown.dart';

/// `paper-dropdown` is a `core-dropdown` with a `paper-shadow`. By default, it
/// is animated on open with `paper-dropdown-transition`. Use this element with
/// `paper-dropdown-menu` or `paper-menu-button` to implement UI controls that
/// open a drop-down.
///
/// Example:
///
///     <paper-dropdown>
///       Hi!
///     </paper-dropdown>
///
/// Theming
/// -------
///
/// Style the background color of the dropdown with these selectors:
///
///     paper-dropdown::shadow #ripple,
///     paper-dropdown::shadow #background {
///         background-color: green;
///     }
class PaperDropdown extends CoreDropdown {
  PaperDropdown.created() : super.created();
  factory PaperDropdown() => new Element.tag('paper-dropdown');

  get $ => jsElement[r'$'];
}
@initMethod
upgradePaperDropdown() => registerDartType('paper-dropdown', PaperDropdown);
