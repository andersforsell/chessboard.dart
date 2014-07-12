/* Copyright (c) 2014, Anders Forsell (aforsell1971@gmail.com)
 * Released under the MIT license
 * https://github.com/andersforsell/chessboard.dart/blob/master/LICENSE
 */

import 'dart:html';
import 'dart:math';
import 'package:polymer/polymer.dart';
import 'package:paper_elements/paper_input.dart';
import 'package:chessboard/chess_board.dart';

/**
 * A Polymer chessboard app for testing.
 */
@CustomTag('chess-board-app')
class ChessBoardApp extends PolymerElement {

  ChessBoardApp.created() : super.created();

  @override
  void domReady() {
    var navicon = $['navicon'];
    var drawerPanel = $['drawerPanel'];

    _resize();

    window.onResize.listen((e) {
      _resize();
    });

    // TODO uncomment when https://github.com/dart-lang/core-elements/issues/39 is fixed
    // navicon.onClick.listen((e) => drawerPanel.togglePanel());
  }

  void _resize() {
    var mainHeaderPanel = $['main_header_panel'];
    var mainToolbar = $['main_toolbar'];
    var turn = $['turn'];
    var gameStatus = $['gameStatus'];

    ChessBoard chessBoard = $['chess_board'];
    var paddingX2 = 20 * 2;
    int height = mainHeaderPanel.clientHeight - mainToolbar.clientHeight -
        turn.clientHeight - gameStatus.clientHeight - paddingX2;
    int width = mainHeaderPanel.clientWidth - paddingX2;
    chessBoard.style
        ..width = '${min(height, width)}px'
        ..height = chessBoard.style.width;
    chessBoard.resize();
  }

  void onMove(CustomEvent event, detail, target) {
    ChessBoard chess = event.target;
    print('Move event, next turn is ${target.turn}');
  }

  void loadGameClicked(Event event, var detail, Node target) {
    $['loaddlg'].toggle();
  }

  void okClicked(Event event, var detail, Node target) {
    PaperInput posInput = $['pos_input'];
    ChessBoard chessBoard = $['chess_board']..position = posInput.value;
    async((num) => chessBoard.refresh());
  }
}
