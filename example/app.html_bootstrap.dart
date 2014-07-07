library app_bootstrap;

import 'package:polymer/polymer.dart';

import 'package:core_elements/core_meta.dart' as i0;
import 'package:core_elements/core_iconset.dart' as i1;
import 'package:core_elements/core_icon.dart' as i2;
import 'package:core_elements/core_item.dart' as i3;
import 'package:core_elements/core_toolbar.dart' as i4;
import 'package:core_elements/core_header_panel.dart' as i5;
import 'package:core_elements/core_icons.dart' as i6;
import 'package:core_elements/core_selection.dart' as i7;
import 'package:core_elements/core_selector.dart' as i8;
import 'package:core_elements/core_menu.dart' as i9;
import 'package:core_elements/core_media_query.dart' as i10;
import 'package:core_elements/core_drawer_panel.dart' as i11;
import 'package:paper_elements/paper_focusable.dart' as i12;
import 'package:paper_elements/paper_ripple.dart' as i13;
import 'package:paper_elements/paper_shadow.dart' as i14;
import 'package:paper_elements/paper_button.dart' as i15;
import 'package:paper_elements/paper_icon_button.dart' as i16;
import 'package:core_elements/core_input.dart' as i17;
import 'package:paper_elements/paper_input.dart' as i18;
import 'package:core_elements/core_transition.dart' as i19;
import 'package:core_elements/core_key_helper.dart' as i20;
import 'package:core_elements/core_overlay_layer.dart' as i21;
import 'package:core_elements/core_overlay.dart' as i22;
import 'package:paper_elements/paper_dialog.dart' as i23;
import 'package:chessboard/chess_board.dart' as i24;
import 'chess_board_app.dart' as i25;
import 'app.html.0.dart' as i26;
import 'package:smoke/smoke.dart' show Declaration, PROPERTY, METHOD;
import 'package:smoke/static.dart' show useGeneratedCode, StaticConfiguration;
import 'package:chessboard/chess_board.dart' as smoke_0;
import 'package:polymer/polymer.dart' as smoke_1;
import 'package:observe/src/metadata.dart' as smoke_2;
import 'chess_board_app.dart' as smoke_3;
abstract class _M0 {} // PolymerElement & ChangeNotifier

void main() {
  useGeneratedCode(new StaticConfiguration(
      checkedMode: false,
      getters: {
        #$: (o) => o.$,
        #blurAction: (o) => o.blurAction,
        #col: (o) => o.col,
        #container: (o) => o.container,
        #contextMenuAction: (o) => o.contextMenuAction,
        #disabled: (o) => o.disabled,
        #downAction: (o) => o.downAction,
        #enumerate: (o) => o.enumerate,
        #error: (o) => o.error,
        #focusAction: (o) => o.focusAction,
        #gameStatus: (o) => o.gameStatus,
        #heading: (o) => o.heading,
        #icon: (o) => o.icon,
        #iconSrc: (o) => o.iconSrc,
        #index: (o) => o.index,
        #inputChangeAction: (o) => o.inputChangeAction,
        #inputValue: (o) => o.inputValue,
        #invalid: (o) => o.invalid,
        #label: (o) => o.label,
        #loadGameClicked: (o) => o.loadGameClicked,
        #mode: (o) => o.mode,
        #multi: (o) => o.multi,
        #multiline: (o) => o.multiline,
        #okClicked: (o) => o.okClicked,
        #onMove: (o) => o.onMove,
        #opened: (o) => o.opened,
        #pgn: (o) => o.pgn,
        #pgnMove: (o) => o.pgnMove,
        #pieceTheme: (o) => o.pieceTheme,
        #placeholder: (o) => o.placeholder,
        #position: (o) => o.position,
        #positionChanged: (o) => o.positionChanged,
        #promotionClicked: (o) => o.promotionClicked,
        #queryMatches: (o) => o.queryMatches,
        #raisedButton: (o) => o.raisedButton,
        #responsiveWidth: (o) => o.responsiveWidth,
        #reversed: (o) => o.reversed,
        #row: (o) => o.row,
        #rows: (o) => o.rows,
        #scroll: (o) => o.scroll,
        #selected: (o) => o.selected,
        #selectionSelect: (o) => o.selectionSelect,
        #showNotation: (o) => o.showNotation,
        #squareSize: (o) => o.squareSize,
        #src: (o) => o.src,
        #togglePanel: (o) => o.togglePanel,
        #tokenList: (o) => o.tokenList,
        #transition: (o) => o.transition,
        #transitionEndAction: (o) => o.transitionEndAction,
        #turn: (o) => o.turn,
        #upAction: (o) => o.upAction,
        #value: (o) => o.value,
        #z: (o) => o.z,
      },
      setters: {
        #container: (o, v) { o.container = v; },
        #gameStatus: (o, v) { o.gameStatus = v; },
        #icon: (o, v) { o.icon = v; },
        #iconSrc: (o, v) { o.iconSrc = v; },
        #inputValue: (o, v) { o.inputValue = v; },
        #multi: (o, v) { o.multi = v; },
        #opened: (o, v) { o.opened = v; },
        #pgn: (o, v) { o.pgn = v; },
        #pieceTheme: (o, v) { o.pieceTheme = v; },
        #position: (o, v) { o.position = v; },
        #queryMatches: (o, v) { o.queryMatches = v; },
        #reversed: (o, v) { o.reversed = v; },
        #selected: (o, v) { o.selected = v; },
        #showNotation: (o, v) { o.showNotation = v; },
        #squareSize: (o, v) { o.squareSize = v; },
        #src: (o, v) { o.src = v; },
        #transition: (o, v) { o.transition = v; },
        #turn: (o, v) { o.turn = v; },
        #z: (o, v) { o.z = v; },
      },
      parents: {
        smoke_3.ChessBoardApp: smoke_1.PolymerElement,
        smoke_0.ChessBoard: _M0,
        _M0: smoke_1.PolymerElement,
      },
      declarations: {
        smoke_3.ChessBoardApp: const {},
        smoke_0.ChessBoard: {
          #gameStatus: const Declaration(#gameStatus, String, kind: PROPERTY, annotations: const [smoke_2.reflectable, smoke_2.observable]),
          #pgn: const Declaration(#pgn, List, kind: PROPERTY, annotations: const [smoke_2.reflectable, smoke_2.observable]),
          #pieceTheme: const Declaration(#pieceTheme, String, kind: PROPERTY, annotations: const [smoke_2.reflectable, smoke_1.published]),
          #position: const Declaration(#position, String, kind: PROPERTY, annotations: const [smoke_2.reflectable, smoke_1.published]),
          #positionChanged: const Declaration(#positionChanged, Function, kind: METHOD),
          #reversed: const Declaration(#reversed, bool, kind: PROPERTY, annotations: const [smoke_2.reflectable, smoke_1.published]),
          #showNotation: const Declaration(#showNotation, bool, kind: PROPERTY, annotations: const [smoke_2.reflectable, smoke_1.published]),
          #squareSize: const Declaration(#squareSize, int, kind: PROPERTY, annotations: const [smoke_2.reflectable, smoke_2.observable]),
          #turn: const Declaration(#turn, String, kind: PROPERTY, annotations: const [smoke_2.reflectable, smoke_2.observable]),
        },
      },
      names: {
        #$: r'$',
        #blurAction: r'blurAction',
        #col: r'col',
        #container: r'container',
        #contextMenuAction: r'contextMenuAction',
        #disabled: r'disabled',
        #downAction: r'downAction',
        #enumerate: r'enumerate',
        #error: r'error',
        #focusAction: r'focusAction',
        #gameStatus: r'gameStatus',
        #heading: r'heading',
        #icon: r'icon',
        #iconSrc: r'iconSrc',
        #index: r'index',
        #inputChangeAction: r'inputChangeAction',
        #inputValue: r'inputValue',
        #invalid: r'invalid',
        #label: r'label',
        #loadGameClicked: r'loadGameClicked',
        #mode: r'mode',
        #multi: r'multi',
        #multiline: r'multiline',
        #okClicked: r'okClicked',
        #onMove: r'onMove',
        #opened: r'opened',
        #pgn: r'pgn',
        #pgnMove: r'pgnMove',
        #pieceTheme: r'pieceTheme',
        #placeholder: r'placeholder',
        #position: r'position',
        #positionChanged: r'positionChanged',
        #promotionClicked: r'promotionClicked',
        #queryMatches: r'queryMatches',
        #raisedButton: r'raisedButton',
        #responsiveWidth: r'responsiveWidth',
        #reversed: r'reversed',
        #row: r'row',
        #rows: r'rows',
        #scroll: r'scroll',
        #selected: r'selected',
        #selectionSelect: r'selectionSelect',
        #showNotation: r'showNotation',
        #squareSize: r'squareSize',
        #src: r'src',
        #togglePanel: r'togglePanel',
        #tokenList: r'tokenList',
        #transition: r'transition',
        #transitionEndAction: r'transitionEndAction',
        #turn: r'turn',
        #upAction: r'upAction',
        #value: r'value',
        #z: r'z',
      }));
  configureForDeployment([
      i0.upgradeCoreMeta,
      i1.upgradeCoreIconset,
      i2.upgradeCoreIcon,
      i3.upgradeCoreItem,
      i4.upgradeCoreToolbar,
      i5.upgradeCoreHeaderPanel,
      i7.upgradeCoreSelection,
      i8.upgradeCoreSelector,
      i9.upgradeCoreMenu,
      i10.upgradeCoreMediaQuery,
      i11.upgradeCoreDrawerPanel,
      i12.upgradePaperFocusable,
      i13.upgradePaperRipple,
      i14.upgradePaperShadow,
      i15.upgradePaperButton,
      i16.upgradePaperIconButton,
      i17.upgradeCoreInput,
      i18.upgradePaperInput,
      i19.upgradeCoreTransition,
      i20.upgradeCoreKeyHelper,
      i21.upgradeCoreOverlayLayer,
      i22.upgradeCoreOverlay,
      i23.upgradePaperDialog,
      () => Polymer.register('chess-board', i24.ChessBoard),
      () => Polymer.register('chess-board-app', i25.ChessBoardApp),
    ]);
  i26.main();
}
