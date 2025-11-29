import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_themes.dart';

enum ButtonVariant { primary, secondary, outline, text }
enum ButtonSize { small, medium, large }

class ThemedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final bool fullWidth;
  final double? customWidth;
  final double? customHeight;
  final EdgeInsetsGeometry? customPadding;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double borderRadius;
  final double elevation;

  const ThemedButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.fullWidth = false,
    this.customWidth,
    this.customHeight,
    this.customPadding,
    this.fontSize,
    this.fontWeight,
    this.borderRadius = 12.0,
    this.elevation = 2.0,
  });

  // Get button dimensions based on size
  EdgeInsetsGeometry _getPadding() {
    if (customPadding != null) return customPadding!;
    
    switch (size) {
      case ButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
      case ButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 12);
      case ButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 32, vertical: 16);
    }
  }

  double _getFontSize() {
    if (fontSize != null) return fontSize!;
    
    switch (size) {
      case ButtonSize.small:
        return 14;
      case ButtonSize.medium:
        return 16;
      case ButtonSize.large:
        return 18;
    }
  }

  FontWeight _getFontWeight() {
    return fontWeight ?? FontWeight.w600;
  }

  // Get button colors based on variant
  ButtonStyle _getButtonStyle() {
    final padding = _getPadding();
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
    );

    switch (variant) {
      case ButtonVariant.primary:
        return ElevatedButton.styleFrom(
          backgroundColor: onPressed == null 
              ? AppThemes.mediumGrey 
              : AppThemes.primaryButtonColor,
          foregroundColor: AppThemes.primaryButtonTextColor,
          padding: padding,
          shape: shape,
          elevation: onPressed == null ? 0 : elevation,
          shadowColor: AppThemes.cardShadowColor,
        );

      case ButtonVariant.secondary:
        return ElevatedButton.styleFrom(
          backgroundColor: onPressed == null 
              ? AppThemes.lightGrey 
              : AppThemes.lightGrey,
          foregroundColor: onPressed == null 
              ? AppThemes.mediumGrey 
              : AppThemes.primaryTextColor,
          padding: padding,
          shape: shape,
          elevation: onPressed == null ? 0 : 1,
          shadowColor: AppThemes.cardShadowColor,
        );

      case ButtonVariant.outline:
        return OutlinedButton.styleFrom(
          foregroundColor: onPressed == null 
              ? AppThemes.mediumGrey 
              : AppThemes.darkMaroon,
          padding: padding,
          shape: shape,
          side: BorderSide(
            color: onPressed == null 
                ? AppThemes.mediumGrey 
                : AppThemes.darkMaroon,
            width: 1.5,
          ),
        );

      case ButtonVariant.text:
        return TextButton.styleFrom(
          foregroundColor: onPressed == null 
              ? AppThemes.mediumGrey 
              : AppThemes.darkMaroon,
          padding: padding,
          shape: shape,
        );
    }
  }

  Widget _buildButtonContent() {
    if (isLoading) {
      return SizedBox(
        width: _getFontSize(),
        height: _getFontSize(),
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            variant == ButtonVariant.primary 
                ? AppThemes.white 
                : AppThemes.darkMaroon,
          ),
        ),
      );
    }

    final textWidget = Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: _getFontSize(),
        fontWeight: _getFontWeight(),
        letterSpacing: 0.5,
      ),
    );

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: _getFontSize() + 2),
          const SizedBox(width: 8),
          textWidget,
        ],
      );
    }

    return textWidget;
  }

  @override
  Widget build(BuildContext context) {
    Widget button;

    switch (variant) {
      case ButtonVariant.primary:
      case ButtonVariant.secondary:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: _getButtonStyle(),
          child: _buildButtonContent(),
        );
        break;
      case ButtonVariant.outline:
        button = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: _getButtonStyle(),
          child: _buildButtonContent(),
        );
        break;
      case ButtonVariant.text:
        button = TextButton(
          onPressed: isLoading ? null : onPressed,
          style: _getButtonStyle(),
          child: _buildButtonContent(),
        );
        break;
    }

    // Apply width constraints
    if (fullWidth) {
      return SizedBox(
        width: double.infinity,
        height: customHeight,
        child: button,
      );
    } else if (customWidth != null) {
      return SizedBox(
        width: customWidth,
        height: customHeight,
        child: button,
      );
    } else {
      return button;
    }
  }
}

// Additional helper widgets for common button patterns
class ThemedButtonGroup extends StatelessWidget {
  final List<ThemedButton> buttons;
  final MainAxisAlignment alignment;
  final double spacing;

  const ThemedButtonGroup({
    super.key,
    required this.buttons,
    this.alignment = MainAxisAlignment.spaceEvenly,
    this.spacing = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: alignment,
      children: buttons
          .asMap()
          .entries
          .map((entry) {
            final isLast = entry.key == buttons.length - 1;
            return Row(
              children: [
                entry.value,
                if (!isLast) SizedBox(width: spacing),
              ],
            );
          })
          .toList(),
    );
  }
}

// Floating Action Button variant using theme colors
class ThemedFloatingActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String? tooltip;
  final bool mini;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const ThemedFloatingActionButton({
    super.key,
    this.onPressed,
    required this.icon,
    this.tooltip,
    this.mini = false,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: tooltip,
      mini: mini,
      backgroundColor: backgroundColor ?? AppThemes.darkMaroon,
      foregroundColor: foregroundColor ?? AppThemes.white,
      elevation: 4,
      child: Icon(icon),
    );
  }
}
