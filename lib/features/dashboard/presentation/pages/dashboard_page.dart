import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uts_apps_market_1123150112/core/constants/app_colors.dart';
import 'package:uts_apps_market_1123150112/core/router/app_router.dart';
import 'package:uts_apps_market_1123150112/features/auth/presentation/providers/auth_provider.dart';
import 'package:uts_apps_market_1123150112/features/product/data/models/product_model.dart';
import 'package:uts_apps_market_1123150112/features/product/presentation/providers/product_provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _searchCtrl      = TextEditingController();
  String _selectedCategory = 'All';
  int    _currentNavIndex  = 0;

  // Daftar kategori dari data produk + 'All'
  static const List<String> _categories = [
    'All', 'Shoes', 'Shirt', 'Pants', 'Bag', 'Accessories',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().fetchProducts();
    });
    _searchCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  // ─── Format Harga Rupiah ──────────────────────────────────
  String _formatPrice(double price) {
    final str    = price.toInt().toString();
    final buffer = StringBuffer();
    int count    = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) buffer.write('.');
      buffer.write(str[i]);
      count++;
    }
    return 'Rp. ${buffer.toString().split('').reversed.join()}';
  }

  // ─── Filter Kategori + Search ─────────────────────────────
  List<ProductModel> _filteredProducts(List<ProductModel> products) {
    final query = _searchCtrl.text.toLowerCase();
    return products.where((p) {
      // Filter 1: Kategori yang dipilih
      final matchCategory = _selectedCategory == 'All' ||
          p.category.toLowerCase() == _selectedCategory.toLowerCase();

      // Filter 2: Search keyword
      final matchSearch = query.isEmpty ||
          p.name.toLowerCase().contains(query) ||
          p.category.toLowerCase().contains(query);

      return matchCategory && matchSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final productProv = context.watch<ProductProvider>();
    final user        = context.read<AuthProvider>().firebaseUser;
    final filtered    = _filteredProducts(productProv.products);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── AppBar ────────────────────────────────────────
          SliverAppBar(
            floating: true,
            backgroundColor: AppColors.primary,
            title: Text(
              'Halo, ${user?.displayName?.split(' ').first ?? 'User'} 👋',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout, color: AppColors.textPrimary),
                onPressed: () async {
                  await context.read<AuthProvider>().logout();
                  if (!context.mounted) return;
                  Navigator.pushReplacementNamed(context, AppRouter.login);
                },
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                // ── SearchBar ──────────────────────────────
                _SearchBar(controller: _searchCtrl),
                const SizedBox(height: 16),

                // ── BannerCard ─────────────────────────────
                const _BannerCard(),
                const SizedBox(height: 20),

                // ── Categories Row ─────────────────────────
                SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _categories.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (_, i) => _CategoryChip(
                      label:    _categories[i],
                      selected: _selectedCategory == _categories[i],
                      onTap:    () => setState(
                        () => _selectedCategory = _categories[i],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // ── Section Label ──────────────────────────
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'For you',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),

          // ── SliverGrid Produk ──────────────────────────────
          switch (productProv.status) {
            ProductStatus.loading || ProductStatus.initial =>
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),

            ProductStatus.error => SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(productProv.error ?? 'Error'),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => productProv.fetchProducts(),
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            ),

            ProductStatus.loaded => SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (_, i) => _ProductCard(
                    product:     filtered[i],
                    formatPrice: _formatPrice,
                  ),
                  childCount: filtered.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:   2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing:  12,
                  childAspectRatio: 0.68,
                ),
              ),
            ),
          },
        ],
      ),

      // ── BottomNav ──────────────────────────────────────────
      bottomNavigationBar: _BottomNav(
        currentIndex: _currentNavIndex,
        onTap: (i) => setState(() => _currentNavIndex = i),
      ),
    );
  }
}


// ─── Widget: SearchBar ────────────────────────────────────────
class _SearchBar extends StatelessWidget {
  final TextEditingController controller;

  const _SearchBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText:    'Cari produk...',
          prefixIcon:  const Icon(Icons.search, color: AppColors.textHint),
          filled:      true,
          fillColor:   AppColors.surface,
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}


// ─── Widget: BannerCard ───────────────────────────────────────
class _BannerCard extends StatelessWidget {
  const _BannerCard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 130,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Flash Sale 50%',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Promo spesial hari ini saja!',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.85)),
                  ),
                ],
              ),
            ),
            const Icon(Icons.local_offer_rounded, size: 60, color: Colors.white24),
          ],
        ),
      ),
    );
  }
}


// ─── Widget: CategoryChip ─────────────────────────────────────
class _CategoryChip extends StatelessWidget {
  final String  label;
  final bool    selected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color:        selected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.primaryDark : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            color:      selected ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}


// ─── Widget: ProductCard ──────────────────────────────────────
class _ProductCard extends StatelessWidget {
  final ProductModel           product;
  final String Function(double) formatPrice;

  const _ProductCard({required this.product, required this.formatPrice});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      color: AppColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar produk
          Expanded(
            child: Image.network(
              product.imageUrl,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                color: AppColors.primaryLight,
                child: const Icon(Icons.image_not_supported,
                    size: 40, color: AppColors.textHint),
              ),
            ),
          ),

          // Info produk
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  formatPrice(product.price),
                  style: const TextStyle(
                    color: Color(0xFF1565C0),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  product.category,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


// ─── Widget: BottomNav ────────────────────────────────────────
class _BottomNav extends StatelessWidget {
  final int        currentIndex;
  final ValueChanged<int> onTap;

  const _BottomNav({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex:     currentIndex,
      onTap:            onTap,
      selectedItemColor:   AppColors.primaryDark,
      unselectedItemColor: AppColors.textHint,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined),     label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: 'Cart'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite_outline),  label: 'Favorite'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline),    label: 'Account'),
      ],
    );
  }
}
