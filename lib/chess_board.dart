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

  @observable String turn = WHITE;

  @observable Map<String, String> header;

  @observable List<String> pgn;

  @observable int squareSize = 0;

  static final COLUMNS = 'abcdefgh'.split('');

  static final BLACK = 'Black';

  static final WHITE = 'White';

  Element _boardElement;

  Element _dragPiece;

  Element _dragSquare;

  // Pawn promotion moves
  List<Move> _promotionMoves;

  Chess _currentPosition;

  List<Move> _legalMoves;

  ChessBoard.created() : super.created();

  @override
  void attached() {
    super.attached();

    _boardElement = $['board'];

    positionChanged(position);

    // Set the size and draw the board
    resize();

    window.onResize.listen((e) {
      resize();
    });

    _addDragDropListeners();

    _setPromotionDialogAttributes();
  }

  void positionChanged(String oldValue) {
    Map validMap = Chess.validate_fen(position);
    if (validMap["valid"]) {
      _currentPosition = new Chess.fromFEN(position);
    } else {
      _currentPosition = new Chess();
      _currentPosition.load_pgn(position, {
        'newline_char': '\n'
      });
    }
    _updateGameState();
  }

  void _setPromotionDialogAttributes() {
    for (Element button in $['white_promo'].children) {
      button.setAttribute('src', _buildPieceImgSrc(button.id));
    }
    for (Element button in $['black_promo'].children) {
      button.setAttribute('src', _buildPieceImgSrc(button.id));
    }
  }

  void resize() {
    // Calculate the new square size
    squareSize = _calculateSquareSize(clientWidth);

    // Set board width
    _boardElement.style.width = '${squareSize * 8}px';

    refresh();
  }

  void refresh() {
    _drawChessPosition();
  }

  void undo() {
    _currentPosition.undo();
    _updateGameState();
  }

  void _addDragDropListeners() {
    for (Element square in _boardElement.querySelectorAll('.square')) {
      square
          ..onDragEnd.listen(_onDragEnd)
          ..onDragEnter.listen(_onDragEnter)
          ..onDragOver.listen(_onDragOver)
          ..onDragLeave.listen(_onDragLeave)
          ..onDrop.listen(_onDrop)
          ..on['tap'].listen(_onClick);
    }
  }

  void _drawChessPosition() {
    for (var row = 1; row <= 8; row++) {
      for (var col in COLUMNS) {
        var square = "$col$row";
        var piece = _currentPosition.get(square);
        var pieceStr =
            piece != null ? '${piece.color}${piece.type.toUpperCase()}' : null;
        var squareElement = _boardElement.querySelector('#$square');
        var pieceElement = squareElement.querySelector('.piece');
        if (pieceElement != null) {
          if (pieceElement.id == pieceStr) {
            continue;
          }
          pieceElement.remove();
        }
        if (pieceStr != null) {
          pieceElement = new ImageElement(src: _buildPieceImgSrc(pieceStr))
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

  void _onClick(Event event) {
    if (_dragPiece == null) {
      _onDragStart(event);
    } else {
      _onDrop(event);
      _onDragEnd(event);
    }
  }

  void _onDragStart(Event event) {
    _dragPiece = event.target;
    _dragPiece.classes.add('moving');
    _dragSquare = _dragPiece.parent;
    if (event is MouseEvent && event.dataTransfer != null) {
      event.dataTransfer.effectAllowed = 'move';
    }
  }

  void _onDragEnd(Event event) {
    _dragPiece.classes.remove('moving');
    var squares = _boardElement.querySelectorAll('.square');
    for (var square in squares) {
      square.classes.remove('over');
    }
    _dragPiece = null;
  }

  void _onDragEnter(Event event) {
    Element dropTarget = _getSquareElement(event);
    if (_getValidMoves(_dragSquare, dropTarget).isNotEmpty) {
      if (event is MouseEvent) {
        event.dataTransfer.effectAllowed = 'move';
      }
      dropTarget.classes.add('over');
    } else {
      if (event is MouseEvent) {
        event.dataTransfer.effectAllowed = 'none';
      }
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

  void _onDrop(Event event) {
    // Stop the browser from redirecting.
    event.stopPropagation();
    event.preventDefault();

    // Don't do anything if dropping onto the same column we're dragging.
    Element dropTarget = _getSquareElement(event);
    dropTarget.classes.remove('over');
    var moves = _getValidMoves(_dragSquare, dropTarget);
    if (moves.length > 1) {
      // Pawn promotion
      if (turn == WHITE)
        $['white_promo'].toggle();
      else
        $['black_promo'].toggle();
      _promotionMoves = moves;
    } else if (moves.length == 1) {
      _movePiece(moves[0]);
    }
  }

  Element _getSquareElement(Event event) {
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
          if (turn == BLACK)
            $['white_promo'].toggle();
          else
            $['black_promo'].toggle();
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

    header = _currentPosition.header;

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
