import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallet_unsaac/core/theme/app_theme.dart';
import 'package:wallet_unsaac/core/theme/theme_cubit.dart';
import 'package:wallet_unsaac/core/theme/theme_state.dart';

class ColorSeedOption {
  const ColorSeedOption({required this.name, required this.color});
  final String name;
  final Color color;
}

const List<ColorSeedOption> seedColorPalette = [
  ColorSeedOption(name: 'Granate UNSAAC', color: AppTheme.seed),
  ColorSeedOption(name: 'Azul Andino', color: Color(0xFF1565C0)),
  ColorSeedOption(name: 'Verde Esmeralda', color: Color(0xFF2E7D32)),
  ColorSeedOption(name: 'Ámbar Imperial', color: Color(0xFFE65100)),
  ColorSeedOption(name: 'Morado Cusco', color: Color(0xFF6A1B9A)),
];

class ColorSeedCircleButton extends StatelessWidget {
  const ColorSeedCircleButton({super.key, required this.option, required this.onTap});
  final ColorSeedOption option;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ThemeCubit, ThemeState, bool>(
      // ignore: deprecated_member_use
      selector: (state) => state.seedColor.value == option.color.value,
      builder: (context, selected) {
        final onSurface = Theme.of(context).colorScheme.onSurface;
        return Tooltip(
          message: option.name,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(24),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 44, height: 44,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: option.color, shape: BoxShape.circle,
                border: Border.all(color: selected ? onSurface : Colors.transparent, width: 3.5),
                boxShadow: selected ? [BoxShadow(color: option.color.withValues(alpha: 0.4), blurRadius: 8, offset: const Offset(0, 3))] : null,
              ),
              child: selected ? const Icon(Icons.check_rounded, color: Colors.white, size: 22) : null,
            ),
          ),
        );
      },
    );
  }
}

class ColorSeedSelectorSheet extends StatelessWidget {
  const ColorSeedSelectorSheet({super.key});

  static Future<void> show(BuildContext context) {
    final themeCubit = context.read<ThemeCubit>();
    return showModalBottomSheet<void>(
      context: context, showDragHandle: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => BlocProvider.value(value: themeCubit, child: const ColorSeedSelectorSheet()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Color de énfasis', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text('Personaliza la paleta Material 3 a partir de un color semilla.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
          const SizedBox(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: seedColorPalette.map((o) => ColorSeedCircleButton(option: o,
                  onTap: () => context.read<ThemeCubit>().setSeedColor(o.color))).toList()),
          const SizedBox(height: 12),
        ]),
      ),
    );
  }
}
