import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uts_apps_market_1123150112/core/router/app_router.dart';
import 'package:uts_apps_market_1123150112/core/theme/theme_provider.dart';
import 'package:uts_apps_market_1123150112/features/auth/presentation/providers/auth_provider.dart';
import 'package:uts_apps_market_1123150112/features/product/presentation/providers/product_provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth    = context.watch<AuthProvider>();
    final product = context.watch<ProductProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Dashboard', style: TextStyle(fontSize: 18)),
            Text(
              'Halo, ${auth.firebaseUser?.displayName ?? 'User'}!',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () => showDialog(
              context: context,
              builder: (_) => const _AccountDialog(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await auth.logout();
              if (!context.mounted) return;
              Navigator.pushReplacementNamed(context, AppRouter.login);
            },
          ),
        ],
      ),

      body: switch (product.status) {
        ProductStatus.loading || ProductStatus.initial => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Memuat produk...'),
            ],
          ),
        ),

        ProductStatus.error => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(product.error ?? 'Terjadi kesalahan'),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon:     const Icon(Icons.refresh),
                label:    const Text('Coba Lagi'),
                onPressed: () => product.fetchProducts(),
              ),
            ],
          ),
        ),

        ProductStatus.loaded => RefreshIndicator(

          onRefresh: () => product.fetchProducts(),
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:   2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 12,
              mainAxisSpacing:  12,
            ),
            itemCount: product.products.length,
            itemBuilder: (context, i) {
              final p            = product.products[i];
              final surface      = Theme.of(context).colorScheme.surface;
              final onSurface    = Theme.of(context).colorScheme.onSurface;
              final primary      = Theme.of(context).colorScheme.primary;
              final hintColor    = Theme.of(context).hintColor;

              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: Image.network(
                        p.imageUrl,
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          height: 120,
                          color: surface,
                          child: Icon(Icons.image_not_supported, size: 40, color: hintColor),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: onSurface,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Rp ${p.price.toStringAsFixed(0)}',
                            style: TextStyle(
                              color: primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: primary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              p.category,
                              style: TextStyle(
                                fontSize: 11,
                                color: primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      },
    );
  }
}

class _AccountDialog extends StatelessWidget {
  const _AccountDialog();

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDark;

    return AlertDialog(
      title: const Text('Akun'),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                isDark ? Icons.dark_mode : Icons.light_mode,
                size: 20,
                color: isDark ? Colors.amber : Colors.grey.shade600,
              ),
              const SizedBox(width: 10),
              Text(
                isDark ? 'Mode Gelap' : 'Mode Terang',
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
          Switch(
            value: isDark,
            onChanged: (_) => context.read<ThemeProvider>().toggle(),
          ),
        ],
      ),
    );
  }
}
