// screens/home/home_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../providers/cart_provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/product_card.dart';
import '../../utils/responsive_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final PageController _bannerController = PageController(
    viewportFraction: 0.9,
  );

  late AnimationController _marqueeController;
  late Animation<double> _marqueeAnimation;

  int _currentBanner = 0;
  Timer? _autoSlideTimer;
  int _selectedIndex = 0;

  final List<String> banners = [
    'assets/images/slider/slider1.jpg',
    'assets/images/slider/slider2.jpg',
    'assets/images/slider/slider3.jpg',
  ];

  final String marqueeText =
      '🔥 Free Shipping over \$100     ✨ New Arrivals Every Week     💎 Premium Quality Guaranteed     ⭐ Trusted Fashion Store     ';

  @override
  void initState() {
    super.initState();
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (_bannerController.hasClients) {
        _currentBanner = (_currentBanner + 1) % banners.length;
        _bannerController.animateToPage(
          _currentBanner,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });

    _marqueeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat();

    _marqueeAnimation = Tween<double>(
      begin: 1,
      end: -1,
    ).animate(_marqueeController);
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _bannerController.dispose();
    _marqueeController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0: // Home
        break;
      case 1: // Shop
        Navigator.pushReplacementNamed(context, '/main');
        break;
      case 2: // Cart
        Navigator.pushNamed(context, '/cart');
        break;
      case 3: // Profile
        Navigator.pushNamed(context, '/profile');
        break;
    }
  }

  void _navigateToSearch() {
    showSearch(context: context, delegate: ProductSearchDelegate());
  }

  // --- UPDATED: Show Profile Details (No Edit Button) ---
  void _showProfileDetails(BuildContext context, AuthProvider auth) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppTheme.kWhite,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag Handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),

            // Large Avatar
            CircleAvatar(
              radius: 40,
              backgroundColor: AppTheme.kGold,
              child: Text(
                auth.user?.initials ?? 'G',
                style: const TextStyle(
                  color: AppTheme.kDark,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // User Name
            Text(
              auth.user?.name ?? 'Guest User',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppTheme.kDark,
              ),
            ),
            const SizedBox(height: 8),

            // User Email
            Text(
              auth.user?.email ?? 'guest@example.com',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),

            // Close Button Only
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Close',
                style: TextStyle(color: AppTheme.kGray),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final cart = context.watch<CartProvider>();
    final productProvider = context.watch<ProductProvider>();
    final bool showingAll = productProvider.selectedCategory == 'All';
    final bool isDesktop = ResponsiveHelper.isDesktop(context);

    return Scaffold(
      backgroundColor: AppTheme.kBg,
      drawer: isDesktop ? _buildDrawer(auth) : null,
      bottomNavigationBar: isDesktop ? null : _buildCustomBottomBar(cart),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTopBar(auth, cart, isDesktop),
              _buildMarquee(),
              const SizedBox(height: 16),
              _buildBannerSlider(),
              const SizedBox(height: 12),
              _buildCategories(productProvider),
              const SizedBox(height: 24),
              if (showingAll) ...[
                _sectionTitle('Featured Products'),
                _buildProductGrid(productProvider.featuredProducts),
                const SizedBox(height: 24),
                _sectionTitle('New Arrivals'),
                _buildProductGrid(productProvider.newArrivals),
              ] else ...[
                _sectionTitle(productProvider.selectedCategory),
                _buildProductGrid(productProvider.filteredProducts),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomBottomBar(CartProvider cart) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, 'Home', 0),
          _buildNavItem(Icons.shopping_bag, 'Shop', 1),
          GestureDetector(
            onTap: () => _onItemTapped(2),
            child: SizedBox(
              width: 60,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Icon(
                        Icons.shopping_cart,
                        color: _selectedIndex == 2
                            ? AppTheme.kGold
                            : Colors.grey,
                      ),
                      if (cart.itemCount > 0)
                        Positioned(
                          right: 0,
                          top: -6,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: AppTheme.kRed,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 14,
                              minHeight: 14,
                            ),
                            child: Text(
                              cart.itemCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Cart',
                    style: TextStyle(
                      fontSize: 10,
                      color: _selectedIndex == 2 ? AppTheme.kGold : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildNavItem(Icons.person_outline, 'Profile', 3),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: _selectedIndex == index ? AppTheme.kGold : Colors.grey,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: _selectedIndex == index ? AppTheme.kGold : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(AuthProvider auth) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: AppTheme.kGold),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppTheme.kDark,
                  child: Text(
                    auth.user?.initials ?? '',
                    style: const TextStyle(
                      color: AppTheme.kGold,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  auth.user?.name ?? 'Guest',
                  style: const TextStyle(
                    color: AppTheme.kDark,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  auth.user?.email ?? '',
                  style: const TextStyle(color: AppTheme.kDark, fontSize: 14),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            selected: _selectedIndex == 0,
            onTap: () => _onItemTapped(0),
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: const Text('Shop'),
            selected: _selectedIndex == 1,
            onTap: () => _onItemTapped(1),
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('Cart'),
            selected: _selectedIndex == 2,
            onTap: () => _onItemTapped(2),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Profile'),
            selected: _selectedIndex == 3,
            onTap: () => _onItemTapped(3),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(AuthProvider auth, CartProvider cart, bool isDesktop) {
    return Padding(
      padding: ResponsiveHelper.getPadding(context),
      child: Row(
        children: [
          if (isDesktop)
            Row(
              children: [
                Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Style Hub',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: ResponsiveHelper.getFontSize(context, 18),
                    color: AppTheme.kDark,
                  ),
                ),
              ],
            )
          else
            GestureDetector(
              onTap: () => _showProfileDetails(context, auth),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: ResponsiveHelper.getValue(
                      context: context,
                      mobile: 16,
                      tablet: 18,
                      desktop: 20,
                    ),
                    backgroundColor: AppTheme.kGold,
                    child: Text(
                      auth.user?.initials ?? 'G',
                      style: TextStyle(
                        color: AppTheme.kDark,
                        fontWeight: FontWeight.bold,
                        fontSize: ResponsiveHelper.getFontSize(context, 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Style Hub',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: ResponsiveHelper.getFontSize(context, 16),
                      color: AppTheme.kDark,
                    ),
                  ),
                ],
              ),
            ),

          if (isDesktop) ...[
            const SizedBox(width: 40),
            Expanded(
              child: GestureDetector(
                onTap: _navigateToSearch,
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Colors.grey),
                      const SizedBox(width: 10),
                      Text(
                        'Search products...',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: ResponsiveHelper.getFontSize(context, 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20),
          ],

          const Spacer(),

          if (!isDesktop)
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: _navigateToSearch,
            ),

          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () => Navigator.pushNamed(context, '/cart'),
              ),
              if (cart.itemCount > 0)
                Positioned(
                  right: 4,
                  top: 2,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: AppTheme.kRed,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      cart.itemCount.toString(),
                      style: const TextStyle(
                        color: AppTheme.kWhite,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),

          if (isDesktop) ...[
            const SizedBox(width: 15),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/profile'),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: AppTheme.kGold,
                child: Text(
                  auth.user?.initials ?? 'G',
                  style: const TextStyle(
                    color: AppTheme.kDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMarquee() {
    return Container(
      height: 40,
      width: double.infinity,
      color: AppTheme.kGold,
      child: ClipRect(
        child: AnimatedBuilder(
          animation: _marqueeAnimation,
          builder: (context, child) {
            return FractionalTranslation(
              translation: Offset(_marqueeAnimation.value, 0),
              child: child,
            );
          },
          child: Row(
            children: [
              Text(
                marqueeText + marqueeText,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.kDark,
                  fontSize: ResponsiveHelper.getFontSize(context, 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBannerSlider() {
    return Column(
      children: [
        SizedBox(
          height: ResponsiveHelper.getValue(
            context: context,
            mobile: 190,
            tablet: 240,
            desktop: 300,
          ),
          child: PageView.builder(
            controller: _bannerController,
            itemCount: banners.length,
            onPageChanged: (i) => setState(() => _currentBanner = i),
            itemBuilder: (_, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.asset(
                    banners[index],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Center(child: Text('Image not found')),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        SmoothPageIndicator(
          controller: _bannerController,
          count: banners.length,
          effect: const ExpandingDotsEffect(
            activeDotColor: AppTheme.kGold,
            dotHeight: 8,
            dotWidth: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildCategories(ProductProvider provider) {
    return SizedBox(
      height: 42,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: provider.categories.map((cat) {
            final selected = provider.selectedCategory == cat;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: ChoiceChip(
                label: Text(cat),
                selected: selected,
                selectedColor: AppTheme.kGold,
                onSelected: (_) => provider.setCategory(cat),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: ResponsiveHelper.getPadding(context),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            fontSize: ResponsiveHelper.getFontSize(context, 20),
            fontWeight: FontWeight.bold,
            color: AppTheme.kDark,
          ),
        ),
      ),
    );
  }

  Widget _buildProductGrid(List products) {
    return Padding(
      padding: ResponsiveHelper.getPadding(context),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: ResponsiveHelper.getGridColumns(context),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: ResponsiveHelper.isMobile(context) ? 0.58 : 0.65,
        ),
        itemBuilder: (_, i) {
          final product = products[i];
          return ProductCard(
            product: product,
            isWishlisted: context.read<ProductProvider>().isWishlisted(
              product.id,
            ),
            onWishlist: context.read<ProductProvider>().toggleWishlist,
            onTap: () => Navigator.pushNamed(
              context,
              '/product-details',
              arguments: product,
            ),
            onAddToCart: (p, size) =>
                context.read<CartProvider>().addItem(p, size),
          );
        },
      ),
    );
  }
}

class ProductSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final productProvider = context.read<ProductProvider>();
    final results = productProvider.searchProducts(query);

    if (results.isEmpty) {
      return const Center(child: Text('No products found'));
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        itemCount: results.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: ResponsiveHelper.getGridColumns(context),
          childAspectRatio: 0.65,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          final product = results[index];
          return ProductCard(
            product: product,
            isWishlisted: productProvider.isWishlisted(product.id),
            onWishlist: productProvider.toggleWishlist,
            onTap: () {
              Navigator.pushNamed(
                context,
                '/product-details',
                arguments: product,
              );
            },
            onAddToCart: (p, size) =>
                context.read<CartProvider>().addItem(p, size),
          );
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final productProvider = context.read<ProductProvider>();
    final suggestions = query.isEmpty
        ? []
        : productProvider.searchProducts(query);

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final product = suggestions[index];
        return ListTile(
          leading: product.imageUrl.startsWith('http')
              ? Image.network(
                  product.imageUrl,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                )
              : Image.asset(
                  product.imageUrl,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
          title: Text(product.name),
          subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
          onTap: () {
            query = product.name;
            showResults(context);
          },
        );
      },
    );
  }
}
