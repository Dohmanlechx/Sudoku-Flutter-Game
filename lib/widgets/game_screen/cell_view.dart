import 'package:flutter/material.dart';
import 'package:sudoku_game/styles/colors.dart';
import 'package:sudoku_game/styles/typography.dart';

class CellView extends StatefulWidget {
  final int number;
  final bool isInvalid;
  final List<int> coordinates;
  final bool isSelected;
  final Function onSubmit;

  const CellView({
    this.number,
    this.isInvalid,
    this.coordinates,
    this.isSelected,
    this.onSubmit,
  });

  @override
  _CellViewState createState() => _CellViewState();
}

class _CellViewState extends State<CellView> {
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

    return GestureDetector(
      onTap: () {
        widget.onSubmit();
      },
      child: Container(
        decoration: BoxDecoration(
          color: widget.number == null
              ? AppColors.white
              : widget.isInvalid
                  ? AppColors.red.withOpacity(0.1)
                  : null,
          border: Border.all(width: 0.5),
        ),
        child: _buildNumber(),
      ),
    );
  }

  Widget _buildNumber() {
    return Container(
      decoration: widget.isSelected
          ? BoxDecoration(
              border: Border.all(color: AppColors.red, width: 3),
              borderRadius: const BorderRadius.all(Radius.circular(50)),
            )
          : null,
      child: Center(
        child: Text(
          (widget.number ?? '').toString(),
          style: AppTypography.number,
        ),
      ),
    );
  }
}
