library chessboard;

/* Copyright (c) 2014, Anders Forsell (aforsell1971@gmail.com)
 * Released under the MIT license
 * https://github.com/andersforsell/chessboard.dart/blob/master/LICENSE
 *
 * Based on chessboard.js
 * Copyright 2013 Chris Oakman
 * Released under the MIT license
 * https://github.com/oakmac/chessboardjs/blob/master/LICENSE
 */

import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:chess/chess.dart';
import 'package:paper_elements/paper_dialog.dart';
import 'package:analyzer/src/generated/java_core.dart';

/**
 * A Polymer chessboard element.
 */
@CustomTag('chess-board')
class ChessBoard extends PolymerElement {
  @published String position = Chess.DEFAULT_POSITION;

  @published bool reversed = false;

  @published bool showNotation = true;

  @published String pieceTheme = 'packages/chessboard/img/{piece}.png';

  @observable String gameStatus = '';

  @observable String turn;

  @observable List<String> pgn;

  @observable int squareSize = 0;

  static final COLUMNS = 'abcdefgh'.split('');

  Element _boardElement;

  Element _dragPiece;

  Element _dragSquare;

  // Pawn promotion moves
  List<Move> _promotionMoves;

  PaperDialog _promotionDlg;

  Chess _currentPosition;

  List<Move> _legalMoves;

  ChessBoard.created() : super.created();

  @override
  void domReady() {
    _boardElement = $['board'];

    _currentPosition = new Chess.fromFEN(position);

    _updateGameState();

    // Set the size and draw the board
    _resize();

    window.onResize.listen((e) {
      _resize();
    });

    _addDragDropListeners();

    _setPromotionDialogAttributes();
  }

  void positionChanged(String oldValue) {
    _currentPosition = new Chess.fromFEN(position);
    _updateGameState();
  }

  void _setPromotionDialogAttributes() {
    for (Element button in $['white_promo'].children) {
      button.setAttribute('iconSrc', _buildPieceImgSrc(button.id));
    }
    for (Element button in $['black_promo'].children) {
      button.setAttribute('iconSrc', _buildPieceImgSrc(button.id));
    }
  }

  void _resize() {
    // Calculate the new square size
    int size = Math.min(clientWidth, clientHeight);
    squareSize = _calculateSquareSize(clientWidth);

    // Set board width
    _boardElement.style.width = '${squareSize * 8}px';

    // Redraw the board
    _drawChessPosition(refresh: true);
  }

  void _addDragDropListeners() {
    for (var square in _boardElement.querySelectorAll('.square')) {
      square
          ..onDragEnd.listen(_onDragEnd)
          ..onDragEnter.listen(_onDragEnter)
          ..onDragOver.listen(_onDragOver)
          ..onDragLeave.listen(_onDragLeave)
          ..onDrop.listen(_onDrop)
          ..onClick.listen(_onClick);
    }
  }

  void _drawChessPosition({bool refresh: false}) {
    for (var row = 1; row <= 8; row++) {
      for (var col in COLUMNS) {
        var square = "$col$row";
        var piece = _currentPosition.get(square);
        var pieceStr = piece != null ?
            '${piece.color}${piece.type.toUpperCase()}' : null;
        var squareElement = _boardElement.querySelector('#$square');
        var pieceElement = squareElement.querySelector('.piece');
        if (pieceElement != null) {
          if (refresh) {
            pieceElement.style
                ..height = "${squareSize}px"
                ..width = "${squareSize}px";
          }
          if (pieceElement.id == pieceStr) {
            continue;
          }
          pieceElement.remove();
        }
        if (pieceStr != null) {
          pieceElement = new ImageElement(src: _buildPieceImgSrc(pieceStr),
              width: squareSize, height: squareSize)
              ..className = 'piece'
              ..id = pieceStr
              ..onDragStart.listen(_onDragStart);
          squareElement.children.add(pieceElement);
        }
      }
    }
  }

  String _buildPieceImgSrc(String piece) {
    return pieceTheme.replaceAll(new RegExp('{piece}'), piece);
  }

  /**
   * Calculates square size based on the width of the container
   * got a little CSS black magic here, so let me explain:
   * get the width of the container element (could be anything), reduce by 1 for
   * fudge factor, and then keep reducing until we find an exact mod 8 for
   * our square size.
   */
  int _calculateSquareSize(int containerWidth) {
    if (containerWidth <= 0) {
      return 0;
    }

    // pad one pixel
    var boardWidth = containerWidth - 1;

    while (boardWidth % 8 != 0 && boardWidth > 0) {
      boardWidth--;
    }

    return boardWidth ~/ 8;
  }

  void _onClick(MouseEvent event) {
    if (_dragPiece == null) {
      _onDragStart(event);
    } else {
      _onDrop(event);
      _onDragEnd(event);
    }
  }

  void _onDragStart(MouseEvent event) {
    _dragPiece = event.target;
    _dragPiece.classes.add('moving');
    _dragSquare = _dragPiece.parent;
    if (event.dataTransfer != null) {
      event.dataTransfer.effectAllowed = 'move';
    }
  }

  void _onDragEnd(MouseEvent event) {
    _dragPiece.classes.remove('moving');
    var squares = _boardElement.querySelectorAll('.square');
    for (var square in squares) {
      square.classes.remove('over');
    }
    _dragPiece = null;
  }

  void _onDragEnter(MouseEvent event) {
    Element dropTarget = _getSquareElement(event);
    if (_getValidMoves(_dragSquare, dropTarget).isNotEmpty) {
      event.dataTransfer.effectAllowed = 'move';
      dropTarget.classes.add('over');
    } else {
      event.dataTransfer.effectAllowed = 'none';
    }
  }

  void _onDragOver(MouseEvent event) {
    // This is necessary to allow us to drop.
    event.preventDefault();
    event.dataTransfer.dropEffect = 'move';
  }

  void _onDragLeave(MouseEvent event) {
    Element dropTarget = _getSquareElement(event);
    dropTarget.classes.remove('over');
  }

  void _onDrop(MouseEvent event) {
    // Stop the browser from redirecting.
    event.stopPropagation();

    // Don't do anything if dropping onto the same column we're dragging.
    Element dropTarget = _getSquareElement(event);
    dropTarget.classes.remove('over');
    var moves = _getValidMoves(_dragSquare, dropTarget);
    if (moves.length > 1) {
      // Pawn promotion
      _promotionDlg = _boardElement.querySelector('#white_promo');
      _promotionDlg.opened = true;
      _promotionMoves = moves;
    } else if (moves.length == 1) {
      _movePiece(moves[0]);
    }
  }

  Element _getSquareElement(MouseEvent event) {
    Element target = event.target;
    if (target.classes.contains('piece')) {
      return target.parent;
    }
    return target;
  }

  /**
   * Returns a list of valid moves between [fromSquare] and [toSquare].
   * More than one is returned for pawn promotion.
   */
  List<Move> _getValidMoves(Element fromSquare, Element toSquare) {
    var moves = [];
    var from = fromSquare.id;
    var to = toSquare.id;
    for (var move in _legalMoves) {
      if (move.fromAlgebraic == from && move.toAlgebraic == to) {
        moves.add(move);
      }
    }
    return moves;
  }

  void promotionClicked(Event event, var detail, Node target) {
    if (target != null) {
      String promotionPiece = (target as Element).id.substring(1).toLowerCase();
      for (var move in _promotionMoves) {
        if (move.promotion.name == promotionPiece) {
          _movePiece(move);
          _promotionMoves = null;
          _promotionDlg.opened = false;
          return;
        }
      }
    }
  }

  void _movePiece(Move move) {
    _currentPosition.move(move);

    _updateGameState();

    _drawChessPosition();

    dispatchEvent(new CustomEvent('move'));
  }

  void _updateGameState() {
    _legalMoves = _currentPosition.moves({
      'asObjects': true
    });

    turn = _currentPosition.turn.value == 0 ? 'White' : 'Black';

    var pgnStr = _currentPosition.pgn({
      'max_width': 2,
      'newline_char': '@@'
    });
    pgn = pgnStr.split('@@');

    if (_currentPosition.in_checkmate) {
      gameStatus = 'checkmate';
    } else if (_currentPosition.in_stalemate) {
      gameStatus = 'stalemate';
    } else if (_currentPosition.in_threefold_repetition) {
      gameStatus = 'threefoldrepetition';
    } else if (_currentPosition.insufficient_material) {
      gameStatus = 'insufficientmaterial';
    } else if (_currentPosition.in_draw) {
      gameStatus = 'draw';
    } else if (_currentPosition.in_check) {
      gameStatus = 'check';
    } else {
      gameStatus = '';
    }
  }
}
