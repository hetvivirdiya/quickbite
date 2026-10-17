
import 'package:flutter/material.dart';

class FoodItem {
  final String name;
  final double price;
  final bool isAvailable;

  const FoodItem({
    required this.name,
    required this.price,
    required this.isAvailable,
  });
}

const List<FoodItem> foodItems = [
  FoodItem(name: 'Pizza', price: 250, isAvailable: true),
  FoodItem(name: 'Burger', price: 120, isAvailable: true),
  FoodItem(name: 'Pasta', price: 180, isAvailable: true),
  FoodItem(name: 'Sandwich', price: 100, isAvailable: false),
];

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QuickBite',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/cart': (context) => const CartScreen(),
        '/summary': (context) {
          final total =
          ModalRoute.of(context)!.settings.arguments as double;
          return OrderSummaryScreen(total: total);
        },
      },
    );
  }
}

class FoodCard extends StatelessWidget {
  final FoodItem item;
  final VoidCallback onAdd;

  const FoodCard({
    super.key,
    required this.item,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      child: ListTile(
        leading: const Icon(
          Icons.fastfood,
          size: 36,
          color: Colors.deepOrange,
        ),
        title: Text(item.name),
        subtitle: Text(
          'Rs ${item.price.toStringAsFixed(2)}'
              '${item.isAvailable ? '' : ' • Unavailable'}',
        ),
        trailing: ElevatedButton(
          onPressed: item.isAvailable ? onAdd : null,
          child: const Text('Add'),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QuickBite'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Popular Food Items',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...foodItems.map(
                (item) => FoodCard(
              item: item,
              onAdd: () {
                CartScreenState.cart.add(item);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${item.name} added to cart')),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/cart');
              },
              child: const Text('View Cart'),
            ),
          ),
        ],
      ),
    );
  }
}

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => CartScreenState();
}

class CartScreenState extends State<CartScreen> {
  static final List<FoodItem> cart = [];

  double get total =>
      cart.fold(0.0, (sum, item) => sum + item.price);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Cart')),
      body: cart.isEmpty
          ? const Center(child: Text('Your cart is empty'))
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.length,
              itemBuilder: (context, index) {
                final item = cart[index];

                return ListTile(
                  title: Text(item.name),
                  subtitle: Text(
                    'Rs ${item.price.toStringAsFixed(2)}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        cart.removeAt(index);
                      });
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'Total: Rs ${total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: cart.isEmpty
                      ? null
                      : () {
                    final orderTotal = total;

                    Navigator.pushNamed(
                      context,
                      '/summary',
                      arguments: orderTotal,
                    );
                  },
                  child: const Text('Place Order'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OrderSummaryScreen extends StatelessWidget {
  final double total;

  const OrderSummaryScreen({
    super.key,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order Summary')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 70,
            ),
            const SizedBox(height: 16),
            const Text(
              'Order Placed ✓',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Total Amount: Rs ${total.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}