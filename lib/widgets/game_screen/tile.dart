import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sudoku_game/styles/colors.dart';
import 'package:sudoku_game/styles/typography.dart';

class Tile extends StatefulWidget {
  final int number;
  final bool isInvalid;
  final Function(int) onSubmit;

  const Tile({
    this.number,
    this.isInvalid,
    this.onSubmit,
  });

  @override
  _TileState createState() => _TileState();
}

class _TileState extends State<Tile> {
  TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.text = (widget.number ?? '').toString();

    return Container(
      decoration: BoxDecoration(
        color: widget.number == null
            ? AppColors.emptyTile
            : widget.isInvalid
                ? AppColors.red.withOpacity(0.1)
                : null,
        border: Border.all(width: 0.5),
      ),
      child: _buildNumberTextField(),
    );
  }

  Widget _buildNumberTextField() {
    return TextField(
      controller: _controller,
      buildCounter: (BuildContext context, {int currentLength, int maxLength, bool isFocused}) => null,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
      keyboardType: TextInputType.number,
      maxLength: 1,
      maxLengthEnforced: false,
      showCursor: false,
      enableInteractiveSelection: false,
      textAlign: TextAlign.center,
      style: AppTypography.number,
      decoration: const InputDecoration(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.red, width: 3),
        ),
      ),
      onChanged: (String s) {
        widget.onSubmit(s.isEmpty ? null : int.parse(s[0]));
      },
    );
  }
}
