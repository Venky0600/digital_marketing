import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/product_model.dart';
import '../widgets/gradient_button.dart';

class ProductMarketingScreen extends StatelessWidget {
  const ProductMarketingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final isDark = provider.isDark;
    final products = provider.products;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F1426) : const Color(0xFFF4F5FA),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E2746) : Colors.white,
        elevation: 0,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios_new, color: isDark ? Colors.white : Colors.black87), onPressed: () => Navigator.pop(context)),
        title: Text('Product Marketing', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: isDark ? Colors.white : const Color(0xFF1A1A2E))),
        actions: [
          IconButton(icon: const Icon(Icons.add_circle_outline, color: Color(0xFF5C6BC0)),
            onPressed: () => _showAddProduct(context, provider, isDark)),
        ],
      ),
      body: products.isEmpty
          ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Text('🛍️', style: TextStyle(fontSize: 64)),
              const SizedBox(height: 16),
              Text('No Products Yet', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 18, color: isDark ? Colors.white : const Color(0xFF1A1A2E))),
              const SizedBox(height: 8),
              Text('Add products to create marketing pages.', style: TextStyle(color: isDark ? Colors.white54 : Colors.black45)),
            ]))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: products.length,
              itemBuilder: (_, i) => _ProductCard(product: products[i], isDark: isDark,
                onDelete: () => provider.deleteProduct(products[i].id)),
            ),
    );
  }

  void _showAddProduct(BuildContext context, AppProvider provider, bool isDark) {
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    final discountCtrl = TextEditingController();

    showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E2746) : Colors.white,
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24))),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(width: 36, height: 4, decoration: BoxDecoration(color: Colors.grey.withOpacity(0.3), borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),
            Text('Add Product', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 18, color: isDark ? Colors.white : const Color(0xFF1A1A2E))),
            const SizedBox(height: 16),
            for (final item in [[nameCtrl, 'Product Name', Icons.inventory], [descCtrl, 'Description', Icons.description], [priceCtrl, 'Price (₹)', Icons.money], [discountCtrl, 'Discounted Price (₹)', Icons.local_offer]])
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: TextField(
                  controller: item[0] as TextEditingController,
                  style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                  decoration: InputDecoration(
                    labelText: item[1] as String,
                    labelStyle: TextStyle(color: isDark ? Colors.white54 : Colors.black45),
                    prefixIcon: Icon(item[2] as IconData, color: const Color(0xFF5C6BC0), size: 20),
                    filled: true,
                    fillColor: isDark ? const Color(0xFF0F1426) : const Color(0xFFF4F5FA),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
                ),
              ),
            GradientButton(
              label: 'Add Product', icon: Icons.add_shopping_cart,
              gradient: AppColors.gradientAccent,
              onPressed: () {
                if (nameCtrl.text.isEmpty) return;
                provider.addProduct(Product(
                  id: provider.generateId(),
                  name: nameCtrl.text.trim(),
                  imageUrl: 'https://picsum.photos/seed/${nameCtrl.text.trim().hashCode}/600/400',
                  description: descCtrl.text.trim(),
                  price: double.tryParse(priceCtrl.text.trim()) ?? 0,
                  discountedPrice: double.tryParse(discountCtrl.text.trim()),
                  benefits: ['High quality', 'Best in class', 'Customer approved'],
                  testimonials: [],
                  ctaLabel: 'Buy Now',
                  category: 'Product',
                  createdAt: DateTime.now(),
                ));
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Product added! 🛍️'), backgroundColor: Color(0xFF5C6BC0)));
              }),
          ])),
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  final bool isDark;
  final VoidCallback onDelete;

  const _ProductCard({required this.product, required this.isDark, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2746) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 12, offset: const Offset(0, 4))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Stack(children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            child: Image.network(product.imageUrl, height: 180, width: double.infinity, fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(height: 180, color: const Color(0xFF5C6BC0).withOpacity(0.2),
                child: const Center(child: Icon(Icons.inventory_2, size: 48, color: Color(0xFF5C6BC0)))))),
          if (product.offerBadge != null)
            Positioned(top: 12, left: 12, child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(gradient: AppColors.gradientAccent, borderRadius: BorderRadius.circular(10)),
              child: Text(product.offerBadge!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12)))),
        ]),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text(product.name, style: GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize: 17, color: isDark ? Colors.white : const Color(0xFF1A1A2E)))),
              IconButton(icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20), onPressed: onDelete),
            ]),
            Row(children: [
              if (product.discountedPrice != null) ...[
                Text(product.discountedPriceFormatted!, style: const TextStyle(color: Color(0xFF4CAF50), fontWeight: FontWeight.w800, fontSize: 18)),
                const SizedBox(width: 8),
                Text(product.priceFormatted, style: const TextStyle(color: Colors.grey, fontSize: 13, decoration: TextDecoration.lineThrough)),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: const Color(0xFF4CAF50).withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                  child: Text('${product.discountPercentage}% OFF', style: const TextStyle(color: Color(0xFF4CAF50), fontSize: 10, fontWeight: FontWeight.w700))),
              ] else
                Text(product.priceFormatted, style: const TextStyle(color: Color(0xFF5C6BC0), fontWeight: FontWeight.w800, fontSize: 18)),
            ]),
            const SizedBox(height: 8),
            Text(product.description, maxLines: 2, overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12, color: isDark ? Colors.white54 : Colors.black45, height: 1.5)),
            const SizedBox(height: 10),
            Wrap(spacing: 6, children: product.benefits.map((b) =>
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFF5C6BC0).withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: Text('✓ $b', style: const TextStyle(fontSize: 10, color: Color(0xFF5C6BC0), fontWeight: FontWeight.w600)),
              )).toList()),
            const SizedBox(height: 12),
            GradientButton(
              label: product.ctaLabel,
              icon: Icons.shopping_cart_rounded,
              gradient: AppColors.gradientAccent,
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('${product.name} added to cart! 🛒'),
                backgroundColor: const Color(0xFF4CAF50)))),
          ]),
        ),
      ]),
    );
  }
}
