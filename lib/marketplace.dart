import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gaia/theme_provider.dart';

class MarketplaceItem {
  final String name;
  final String description;
  final int pointsCost;
  final String imageUrl;
  final String category;
  bool isInCart;

  MarketplaceItem({
    required this.name,
    required this.description,
    required this.pointsCost,
    required this.imageUrl,
    required this.category,
    this.isInCart = false,
  });
}

class Marketplace extends StatefulWidget {
  const Marketplace({Key? key}) : super(key: key);

  @override
  State<Marketplace> createState() => _MarketplaceState();
}

class _MarketplaceState extends State<Marketplace> {
  int _selectedCategoryIndex = 0;
  int _totalPoints = 119; // Your total available points
  bool _showCart = false;

  // Product categories
  final List<String> _categories = [
    'All',
    'Eco-Friendly',
    'Certificates',
    'Donations',
    'Gift Cards',
  ];

  // Sample marketplace items
  late List<MarketplaceItem> _items;

  @override
  void initState() {
    super.initState();
    _initializeItems();
  }

  void _initializeItems() {
    _items = [
      MarketplaceItem(
        name: 'Carbon Offset Certificate',
        description: 'Offset 1 ton of carbon emissions with this certificate',
        pointsCost: 50,
        imageUrl: 'assets/certificate.png',
        category: 'Certificates',
      ),
      MarketplaceItem(
        name: 'Plant 5 Trees',
        description: 'We will plant 5 trees in deforested areas',
        pointsCost: 30,
        imageUrl: 'assets/tree.png',
        category: 'Eco-Friendly',
      ),
      MarketplaceItem(
        name: 'Reusable Bamboo Utensils',
        description: 'Set of eco-friendly bamboo utensils for everyday use',
        pointsCost: 45,
        imageUrl: 'assets/bamboo.png',
        category: 'Eco-Friendly',
      ),
      MarketplaceItem(
        name: 'Donation to Education Fund',
        description: 'Support education for underprivileged children',
        pointsCost: 25,
        imageUrl: 'assets/education.png',
        category: 'Donations',
      ),
      MarketplaceItem(
        name: '₹500 Sustainable Store Voucher',
        description: 'Gift card for sustainable products store',
        pointsCost: 70,
        imageUrl: 'assets/gift_card.png',
        category: 'Gift Cards',
      ),
      MarketplaceItem(
        name: 'Clean Water Initiative',
        description: 'Provide clean water access to communities in need',
        pointsCost: 35,
        imageUrl: 'assets/water.png',
        category: 'Donations',
      ),
    ];
  }

  List<MarketplaceItem> get _filteredItems {
    if (_selectedCategoryIndex == 0) {
      return _items;
    } else {
      return _items
          .where((item) => item.category == _categories[_selectedCategoryIndex])
          .toList();
    }
  }

  List<MarketplaceItem> get _cartItems {
    return _items.where((item) => item.isInCart).toList();
  }

  int get _cartTotalPoints {
    return _cartItems.fold(0, (sum, item) => sum + item.pointsCost);
  }

  int get _remainingPoints {
    return _totalPoints - _cartTotalPoints;
  }

  void _toggleItemInCart(MarketplaceItem item) {
    setState(() {
      // Check if adding to cart would exceed available points
      if (!item.isInCart && _cartTotalPoints + item.pointsCost > _totalPoints) {
        _showInsufficientPointsDialog();
        return;
      }

      item.isInCart = !item.isInCart;
    });
  }

  void _showInsufficientPointsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Insufficient Points'),
        content: Text(
            'You don\'t have enough points to add this item to your cart.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _checkout() {
    if (_cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Your cart is empty'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Purchase'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('You are about to spend $_cartTotalPoints points on:'),
            SizedBox(height: 16),
            ..._cartItems.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 16),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item.name,
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      Text(
                        '${item.pointsCost} pts',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Remaining balance:'),
                Text(
                  '$_remainingPoints pts',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Process purchase
              setState(() {
                _totalPoints = _remainingPoints;
                for (var item in _items) {
                  item.isInCart = false;
                }
              });
              Navigator.pop(context);
              _showPurchaseSuccessDialog();
            },
            child: Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _showPurchaseSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final theme = Theme.of(context);
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Success animation/icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                    size: 60,
                  ),
                ),
                SizedBox(height: 20),

                // Title
                Text(
                  'Thank You!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12),

                // Message
                Text(
                  'Your order has been successfully processed.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Your contribution is making a difference!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                SizedBox(height: 24),

                // Points remaining
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star_rounded,
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Balance: $_totalPoints points',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),

                // Close button
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      _showCart = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Continue Shopping',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Marketplace',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        actions: [
          // Points display
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.star_rounded,
                      color: theme.colorScheme.primary,
                      size: 16,
                    ),
                    SizedBox(width: 4),
                    Text(
                      "$_totalPoints pts",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Cart button
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  setState(() {
                    _showCart = !_showCart;
                  });
                },
              ),
              if (_cartItems.isNotEmpty)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${_cartItems.length}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Categories
          Container(
            height: 48,
            margin: EdgeInsets.only(top: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final isSelected = _selectedCategoryIndex == index;
                return Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: ChoiceChip(
                    label: Text(_categories[index]),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedCategoryIndex = index;
                        });
                      }
                    },
                    backgroundColor: theme.cardColor,
                    selectedColor: theme.colorScheme.primary.withOpacity(0.2),
                    labelStyle: TextStyle(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 12),
                  ),
                );
              },
            ),
          ),

          Expanded(
            child: _showCart ? _buildCartView(theme) : _buildProductGrid(theme),
          ),

          // Checkout button
          if (_showCart && _cartItems.isNotEmpty)
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Total',
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                      Text(
                        '$_cartTotalPoints points',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _checkout,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Checkout',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProductGrid(ThemeData theme) {
    return _filteredItems.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_bag,
                  size: 64,
                  color: theme.colorScheme.onSurface.withOpacity(0.2),
                ),
                SizedBox(height: 16),
                Text(
                  'No items in this category',
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          )
        : GridView.builder(
            padding: EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: _filteredItems.length,
            itemBuilder: (context, index) {
              final item = _filteredItems[index];
              return _buildProductCard(item, theme);
            },
          );
  }

  Widget _buildProductCard(MarketplaceItem item, ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image
          Expanded(
            child: Container(
              color: theme.colorScheme.primary.withOpacity(0.1),
              child: Center(
                child: Image.asset(
                  item.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.image,
                      size: 48,
                      color: theme.colorScheme.primary.withOpacity(0.5),
                    );
                  },
                ),
              ),
            ),
          ),

          // Product info
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  item.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8),
                // Fix for the overflow issue - use Row with Expanded
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            Icons.star_rounded,
                            size: 16,
                            color: theme.colorScheme.primary,
                          ),
                          SizedBox(width: 4),
                          Text(
                            '${item.pointsCost}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () => _toggleItemInCart(item),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: item.isInCart
                              ? Colors.red.withOpacity(0.1)
                              : theme.colorScheme.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          item.isInCart
                              ? Icons.remove_shopping_cart
                              : Icons.add_shopping_cart,
                          size: 16,
                          color: item.isInCart
                              ? Colors.red
                              : theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartView(ThemeData theme) {
    if (_cartItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart,
              size: 64,
              color: theme.colorScheme.onSurface.withOpacity(0.2),
            ),
            SizedBox(height: 16),
            Text(
              'Your cart is empty',
              style: TextStyle(
                fontSize: 18,
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _showCart = false;
                });
              },
              child: Text('Continue Shopping'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: _cartItems.length,
      itemBuilder: (context, index) {
        final item = _cartItems[index];
        return Card(
          margin: EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                // Product image
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Image.asset(
                      item.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.image,
                          size: 32,
                          color: theme.colorScheme.primary.withOpacity(0.5),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(width: 16),

                // Product info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        item.category,
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.star_rounded,
                            size: 16,
                            color: theme.colorScheme.primary,
                          ),
                          SizedBox(width: 4),
                          Text(
                            '${item.pointsCost} pts',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Remove button
                IconButton(
                  icon: Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => _toggleItemInCart(item),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
