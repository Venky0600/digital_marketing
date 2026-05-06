import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'gradient_button.dart';

// ──────────────────────────────────────────────────────────────────────────────
// CustomCard
// ──────────────────────────────────────────────────────────────────────────────
class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Color? color;
  final double radius;

  const CustomCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.color,
    this.radius = 16,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding ?? const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color ?? (isDark ? const Color(0xFF1E2746) : Colors.white),
          borderRadius: BorderRadius.circular(radius),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: child,
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// StatsCard
// ──────────────────────────────────────────────────────────────────────────────
class StatsCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final String? trend;
  final bool isDark;

  const StatsCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.trend,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2746) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, color: color, size: 18),
              ),
              if (trend != null)
                Text(trend!, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 10),
          Text(value, style: GoogleFonts.poppins(
            fontWeight: FontWeight.w800, fontSize: 20,
            color: isDark ? Colors.white : const Color(0xFF1A1A2E))),
          Text(label, style: TextStyle(fontSize: 12, color: isDark ? Colors.white54 : Colors.black45)),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// EmptyState
// ──────────────────────────────────────────────────────────────────────────────
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const EmptyState({super.key, required this.icon, required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 36, color: AppColors.primary.withOpacity(0.6)),
            ),
            const SizedBox(height: 20),
            Text(title, style: GoogleFonts.poppins(
              fontWeight: FontWeight.w700, fontSize: 18,
              color: isDark ? Colors.white : const Color(0xFF1A1A2E))),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: isDark ? Colors.white54 : Colors.black45, height: 1.5)),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// SearchFilterBar
// ──────────────────────────────────────────────────────────────────────────────
class SearchFilterBar extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final List<String> filterOptions;
  final String selectedFilter;
  final ValueChanged<String> onFilterChanged;
  final ValueChanged<String> onSearchChanged;

  const SearchFilterBar({
    super.key,
    required this.controller,
    required this.hintText,
    required this.filterOptions,
    required this.selectedFilter,
    required this.onFilterChanged,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        TextField(
          controller: controller,
          onChanged: onSearchChanged,
          style: TextStyle(color: isDark ? Colors.white : Colors.black87),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: isDark ? Colors.white38 : Colors.black38, fontSize: 14),
            prefixIcon: Icon(Icons.search, color: isDark ? Colors.white38 : Colors.black38),
            suffixIcon: controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: () {
                      controller.clear();
                      onSearchChanged('');
                    })
                : null,
            filled: true,
            fillColor: isDark ? const Color(0xFF1E2746) : Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 36,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: filterOptions.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) {
              final f = filterOptions[i];
              final isSelected = f == selectedFilter;
              return GestureDetector(
                onTap: () => onFilterChanged(f),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: isSelected ? AppColors.gradientPrimary : null,
                    color: isSelected ? null : (isDark ? const Color(0xFF1E2746) : Colors.white),
                    borderRadius: BorderRadius.circular(20),
                    border: isSelected ? null : Border.all(color: isDark ? Colors.white12 : Colors.black12),
                  ),
                  child: Text(f, style: TextStyle(
                    color: isSelected ? Colors.white : (isDark ? Colors.white60 : Colors.black54),
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
                  )),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
