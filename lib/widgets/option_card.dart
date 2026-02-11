import 'package:flutter/material.dart';
import 'package:my_health_core/styles/app_colors.dart';


class OptionCard extends StatelessWidget {
  const OptionCard({
    Key? key,
    required this.option,
    required this.color,
    this.optionLabel = '',
    this.isSelected = false,
  }) : super(key: key);
  
  final String option;
  final Color color;
  final String optionLabel;
  final bool isSelected;
  
  @override
  Widget build(BuildContext context) {
    // Use color for submitted state, isSelected for selection
    Color backgroundColor = color != AppColors.white ? color : (isSelected ? AppColors.selected : AppColors.white);
    bool isTextWhite = (color != AppColors.white) || isSelected;
    
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.getTextColor(context),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Text(
            '$optionLabel. ',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: isTextWhite ? AppColors.white : AppColors.getTextColor(context),
            ),
          ),
          Expanded(
            child: Text(
              option,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: isTextWhite ? AppColors.white : AppColors.getTextColor(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
