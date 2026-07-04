import 'dart:convert';
import 'package:flutter/material.dart';

void main() {
  runApp(const ShirtStoreApp());
}

class ShirtStoreApp extends StatelessWidget {
  const ShirtStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shirt Store Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
          primary: const Color(0xFF2563EB),
          surface: const Color(0xFFF8FAFC),
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      ),
      home: const SplashScreen(),
    );
  }
}

// ================= RESPONS DATA DARI API SERVER =================
const String mockProductJsonResponse = '''
[
  {"id": "1", "name": "Oversize Black Tee", "price": 149000, "category": "Oversize", "rating": 4.8, "img": "https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=500&q=80", "desc": "Kaos oversize hitam premium dengan bahan katun combed 24s tebal dan adem."},
  {"id": "2", "name": "Oversize White Tee", "price": 149000, "category": "Oversize", "rating": 4.7, "img": "https://images.unsplash.com/photo-1583743814966-8936f5b7be1a?w=500&q=80", "desc": "Kaos oversize putih bersih, potongan trendi dan sangat minimalis."},
  {"id": "3", "name": "Basic White Classic", "price": 89000, "category": "Basic", "rating": 4.6, "img": "https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=500&q=80", "desc": "Kaos polos basic putih dengan potongan regular fit esensial."},
  {"id": "4", "name": "Basic Black Onyx", "price": 89000, "category": "Basic", "rating": 4.9, "img": "https://images.unsplash.com/photo-1618354691373-d851c5c3a990?w=500&q=80", "desc": "Kaos hitam polos esensial dengan warna pekat anti-luntur."},
  {"id": "5", "name": "Polo Navy Blue Elite", "price": 179000, "category": "Polo", "rating": 4.5, "img": "https://images.unsplash.com/photo-1581655353564-df123a1eb820?w=500&q=80", "desc": "Kaos kerah polo rajut premium untuk gaya semi-formal elegan."}
]
''';

List<Map<String, dynamic>> globalProductsFromApi = [];
List<String> favoriteIds = ["1", "3"]; 
List<Map<String, dynamic>> cartItems = []; 

// ================= 1. SPLASH SCREEN =================
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFF2563EB).withAlpha(25), shape: BoxShape.circle),
              child: const Icon(Icons.checkroom, size: 80, color: Color(0xFF2563EB)),
            ),
            const SizedBox(height: 24),
            const Text('Shirt Store', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            const Text('Premium E-Commerce App', style: TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 48),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

// ================= 2. LOGIN SCREEN (PREMIUM DESIGN) =================
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;
  bool _rememberMe = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 240,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [BoxShadow(color: Colors.black.withAlpha(20), blurRadius: 20, offset: const Offset(0, 8))],
                      ),
                      child: const Icon(Icons.checkroom, size: 64, color: Color(0xFF2563EB)),
                    ),
                    const SizedBox(height: 28),
                    const Text('Welcome Back', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white)),
                    const Text('Silakan login untuk melanjutkan belanja', style: TextStyle(color: Colors.white70)),
                    const SizedBox(height: 40),
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Email Address', style: TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  hintText: 'contoh@email.com',
                                  prefixIcon: const Icon(Icons.email_outlined),
                                  filled: true,
                                  fillColor: const Color(0xFFF8FAFC),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                                ),
                                validator: (v) => v!.isEmpty ? 'Email tidak boleh kosong' : null,
                              ),
                              const SizedBox(height: 20),
                              const Text('Password', style: TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: _obscure,
                                decoration: InputDecoration(
                                  hintText: 'Masukkan password',
                                  prefixIcon: const Icon(Icons.lock_outlined),
                                  suffixIcon: IconButton(icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility), onPressed: () => setState(() => _obscure = !_obscure)),
                                  filled: true,
                                  fillColor: const Color(0xFFF8FAFC),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                                ),
                                validator: (v) => v!.isEmpty ? 'Password tidak boleh kosong' : null,
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: Checkbox(
                                          value: _rememberMe,
                                          onChanged: (v) => setState(() => _rememberMe = v!),
                                          activeColor: const Color(0xFF2563EB),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Text('Remember Me', style: TextStyle(fontSize: 13)),
                                    ],
                                  ),
                                  TextButton(onPressed: () {}, child: const Text('Forgot Password?', style: TextStyle(fontSize: 13, color: Color(0xFF2563EB))))
                                ],
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                height: 52,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF2563EB), 
                                    foregroundColor: Colors.white, 
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                    elevation: 0,
                                  ),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainNavigation()));
                                    }
                                  },
                                  child: const Text('LOGIN', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text('Belum punya akun? ', style: TextStyle(fontSize: 13, color: Colors.grey)),
                                    InkWell(
                                      onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Fitur Registrasi Belum Tersedia'), backgroundColor: Colors.orange)),
                                      child: const Text('Daftar', style: TextStyle(fontSize: 13, color: Color(0xFF2563EB), fontWeight: FontWeight.bold)),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ================= NAVIGASI UTAMA =================
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});
  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _index = 0;

  @override
  void initState() {
    super.initState();
    if (cartItems.isEmpty) {
      cartItems.add({
        'id': '2',
        'name': 'Oversize White Tee',
        'price': 149000,
        'img': 'https://images.unsplash.com/photo-1583743814966-8936f5b7be1a?w=500&q=80',
        'qty': 1,
        'size': 'L'
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(onGoToCart: () => setState(() => _index = 1)),
      const CartScreen(),
      const FavoriteScreen(),
      const ProfileScreen(),
    ];
    return Scaffold(
      body: IndexedStack(index: _index, children: screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF2563EB),
        unselectedItemColor: Colors.grey.shade400,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), activeIcon: Icon(Icons.shopping_bag), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), activeIcon: Icon(Icons.favorite), label: 'Favorite'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

// ================= 3. HOME SCREEN =================
class HomeScreen extends StatefulWidget {
  final VoidCallback onGoToCart;
  const HomeScreen({super.key, required this.onGoToCart});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCat = 'All';
  String _searchQuery = '';
  bool _loading = false;
  final List<String> _cats = ['All', 'Oversize', 'Basic', 'Polo', 'Hoodie', 'Jersey'];

  @override
  void initState() {
    super.initState();
    if (globalProductsFromApi.isEmpty) _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 1000));
    final List<dynamic> decoded = json.decode(mockProductJsonResponse);
    setState(() {
      globalProductsFromApi = decoded.map((e) => Map<String, dynamic>.from(e)).toList();
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filtered = globalProductsFromApi.where((p) {
      final matchCat = _selectedCat == 'All' || p['category'] == _selectedCat;
      final matchSearch = p['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
      return matchCat && matchSearch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        scrolledUnderElevation: 0,
        title: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Halo, Guest User', style: TextStyle(fontSize: 14, color: Colors.grey)), Text('Shirt Store', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))]),
        actions: [
          Stack(children: [
            IconButton(icon: const Icon(Icons.shopping_bag_outlined), onPressed: widget.onGoToCart),
            if (cartItems.isNotEmpty) Positioned(right: 4, top: 4, child: CircleAvatar(radius: 8, backgroundColor: Colors.red, child: Text('${cartItems.length}', style: const TextStyle(fontSize: 10, color: Colors.white), textAlign: TextAlign.center)))
          ]),
          const SizedBox(width: 12)
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  TextField(
                    onChanged: (v) => setState(() => _searchQuery = v),
                    decoration: InputDecoration(hintText: 'Cari kaos favoritmu...', prefixIcon: const Icon(Icons.search), filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none)),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)]), borderRadius: BorderRadius.circular(20)),
                    child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('🔥 Diskon Hingga 50%', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)), Text('Untuk Semua Kaos Premium', style: TextStyle(color: Colors.white60, fontSize: 14))]),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 38,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _cats.length,
                      itemBuilder: (context, i) {
                        final active = _selectedCat == _cats[i];
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(label: Text(_cats[i]), selected: active, onSelected: (s) => setState(() => _selectedCat = _cats[i]), selectedColor: const Color(0xFF2563EB), labelStyle: TextStyle(color: active ? Colors.white : Colors.black)),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.7, crossAxisSpacing: 14, mainAxisSpacing: 14),
                    itemCount: filtered.length,
                    itemBuilder: (context, i) {
                      final p = filtered[i];
                      final isFav = favoriteIds.contains(p['id']);
                      
                      // Menambahkan InkWell agar jika area kartu produk dipencet, langsung pindah ke Detail Screen
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => DetailScreen(product: p))).then((_) => setState(() {}));
                        },
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Expanded(
                              child: Stack(children: [
                                Hero(tag: 'img_${p['id']}', child: Image.network(p['img'], width: double.infinity, height: double.infinity, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.image)))),
                                Positioned(right: 6, top: 6, child: CircleAvatar(radius: 16, backgroundColor: Colors.white.withAlpha(200), child: IconButton(padding: EdgeInsets.zero, icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, size: 16, color: isFav ? Colors.red : Colors.grey), onPressed: () => setState(() => isFav ? favoriteIds.remove(p['id']) : favoriteIds.add(p['id'])))))
                              ]),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(p['name'], style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                                Row(children: [const Icon(Icons.star, color: Colors.amber, size: 14), Text(' ${p['rating']}', style: const TextStyle(fontSize: 12))]),
                                const SizedBox(height: 6),
                                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                  Text('Rp ${p['price'] ~/ 1000}k', style: const TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.bold)),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), 
                                    decoration: BoxDecoration(color: const Color(0xFF2563EB), borderRadius: BorderRadius.circular(8)), 
                                    child: const Text('Detail', style: TextStyle(color: Colors.white, fontSize: 11))
                                  )
                                ])
                              ]),
                            )
                          ]),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24)
                ],
              ),
            ),
    );
  }
}

// ================= 4. DETAIL SCREEN =================
class DetailScreen extends StatefulWidget {
  final Map<String, dynamic> product;
  const DetailScreen({super.key, required this.product});
  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  String _size = 'M';
  int _qty = 1;

  @override
  Widget build(BuildContext context) {
    int total = widget.product['price'] * _qty;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white),
      body: Column(children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Hero(tag: 'img_${widget.product['id']}', child: ClipRRect(borderRadius: BorderRadius.circular(20), child: Image.network(widget.product['img'], width: double.infinity, height: 260, fit: BoxFit.cover))),
              const SizedBox(height: 20),
              Text(widget.product['name'], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Text('Rp ${widget.product['price']}', style: const TextStyle(fontSize: 18, color: Color(0xFF2563EB), fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              const Text('Deskripsi', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(widget.product['desc'], style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 20),
              const Text('Ukuran', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: ['S', 'M', 'L', 'XL'].map((s) {
                  final act = _size == s;
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: GestureDetector(
                      onTap: () => setState(() => _size = s),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: act ? const Color(0xFF2563EB) : Colors.white, 
                          borderRadius: BorderRadius.circular(10), 
                          border: act ? null : Border.all(color: Colors.grey.shade300)
                        ),
                        child: Center(child: Text(s, style: TextStyle(color: act ? Colors.white : Colors.black, fontWeight: FontWeight.bold)))
                      )
                    )
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('Jumlah', style: TextStyle(fontWeight: FontWeight.bold)),
                Row(children: [IconButton(icon: const Icon(Icons.remove), onPressed: () => setState(() { if (_qty > 1) _qty--; })), Text('$_qty', style: const TextStyle(fontWeight: FontWeight.bold)), IconButton(icon: const Icon(Icons.add), onPressed: () => setState(() => _qty++))])
              ])
            ]),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withAlpha(12), blurRadius: 10, offset: const Offset(0, -4))]),
          child: SafeArea(
            child: Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [const Text('Total Harga', style: TextStyle(fontSize: 12, color: Colors.grey)), Text('Rp $total', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2563EB)))])),
              Expanded(flex: 2, child: SizedBox(height: 48, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB), foregroundColor: Colors.white), onPressed: () { cartItems.add({'id': widget.product['id'], 'name': widget.product['name'], 'price': widget.product['price'], 'img': widget.product['img'], 'qty': _qty, 'size': _size}); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ditambahkan ke keranjang!'), backgroundColor: Colors.green)); Navigator.pop(context); }, child: const Text('Tambah ke Keranjang'))))
            ]),
          ),
        )
      ]),
    );
  }
}

// ================= 5. CART SCREEN =================
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    int sub = cartItems.fold(0, (sum, e) => sum + ((e['price'] as int) * (e['qty'] as int)));
    int tax = (sub * 0.11).toInt();
    int total = sub + tax;

    return Scaffold(
      appBar: AppBar(title: const Text('Keranjang Belanja', style: TextStyle(fontWeight: FontWeight.bold))),
      body: cartItems.isEmpty
          ? const Center(child: Text('Keranjang belanja kosong'))
          : Column(children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: cartItems.length,
                  itemBuilder: (context, idx) {
                    final item = cartItems[idx];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.network(item['img'], width: 70, height: 70, fit: BoxFit.cover)),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                  Text('Size: ${item['size']} | Rp ${item['price']}', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                                  const SizedBox(height: 8),
                                  Text('Subtotal: Rp ${item['price'] * item['qty']}', style: const TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.bold, fontSize: 14)),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red), onPressed: () => setState(() => cartItems.removeAt(idx))),
                                Row(
                                  children: [
                                    IconButton(padding: EdgeInsets.zero, constraints: const BoxConstraints(), icon: const Icon(Icons.remove_circle_outline, size: 20), onPressed: () => setState(() { if (item['qty'] > 1) item['qty']--; })),
                                    Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: Text('${item['qty']}', style: const TextStyle(fontWeight: FontWeight.bold))),
                                    IconButton(padding: EdgeInsets.zero, constraints: const BoxConstraints(), icon: const Icon(Icons.add_circle_outline, size: 20), onPressed: () => setState(() => item['qty']++)),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24))),
                child: Column(children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Subtotal Produk', style: TextStyle(color: Colors.grey)), Text('Rp $sub')]),
                  const SizedBox(height: 6),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('PPN Pajak (11%)', style: TextStyle(color: Colors.grey)), Text('Rp $tax')]),
                  const Divider(height: 24),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Total Pembayaran', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), Text('Rp $total', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2563EB)))]),
                  const SizedBox(height: 16),
                  SizedBox(width: double.infinity, height: 50, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))), onPressed: () => showDialog(context: context, builder: (_) => AlertDialog(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)), title: const Text('Sukses'), content: const Text('Pesanan berhasil dibuat.'), actions: [TextButton(onPressed: () { setState(() => cartItems.clear()); Navigator.pop(context); }, child: const Text('OK'))])), child: const Text('Checkout', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))))
                ]),
              )
            ]),
    );
  }
}

// ================= 6. FAVORITE SCREEN =================
class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});
  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    final list = globalProductsFromApi.isEmpty ? [] : globalProductsFromApi.where((p) => favoriteIds.contains(p['id'])).toList();
    
    return Scaffold(
      appBar: AppBar(title: const Text('Favorit Saya', style: TextStyle(fontWeight: FontWeight.bold))),
      body: list.isEmpty
          ? const Center(child: Text('Belum ada favorit.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16), 
              itemCount: list.length, 
              itemBuilder: (context, idx) {
                final item = list[idx];
                return Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.network(item['img'], width: 50, height: 50, fit: BoxFit.cover)), 
                    title: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold)), 
                    subtitle: Text('Category: ${item['category']}\nRp ${item['price']}', style: const TextStyle(fontSize: 13)),
                    isThreeLine: true,
                    trailing: IconButton(icon: const Icon(Icons.favorite, color: Colors.red), onPressed: () => setState(() => favoriteIds.remove(item['id']))),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailScreen(product: item))).then((_) => setState(() {})),
                  ),
                );
              }
            ),
    );
  }
}

// ================= 7. PROFILE SCREEN =================
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Widget _buildMenuTile(IconData icon, String title, String subText) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: BorderSide(color: Colors.grey.shade200)),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF2563EB)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subText, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil Saya', style: TextStyle(fontWeight: FontWeight.bold)), scrolledUnderElevation: 0,),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Center(
              child: Column(
                children: [
                  CircleAvatar(radius: 50, backgroundColor: const Color(0xFF2563EB).withAlpha(25), child: const Icon(Icons.person, size: 54, color: Color(0xFF2563EB))),
                  const SizedBox(height: 14),
                  const Text('Guest User Premium', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const Text('guest.premium@email.com', style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(color: Colors.amber.shade100, borderRadius: BorderRadius.circular(20)),
                    child: Text('VIP Member', style: TextStyle(fontSize: 12, color: Colors.amber.shade900, fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            ),
            const SizedBox(height: 32),
            _buildMenuTile(Icons.edit_outlined, 'Edit Akun Profil', 'Perbarui nama, alamat email, dan nomor HP Anda'),
            _buildMenuTile(Icons.history_toggle_off, 'Riwayat Pembelian', 'Lihat semua transaksi kaos premium yang sukses dibuat'),
            _buildMenuTile(Icons.settings_outlined, 'Pengaturan Aplikasi', 'Atur preferensi sistem, tema warna, dan notifikasi belanja'),
            _buildMenuTile(Icons.help_outline, 'Pusat Bantuan & CS', 'Ada kendala? Hubungi tim support teknis toko kami 24/7'),
            const Divider(height: 40),
            Card(
              margin: EdgeInsets.zero,
              color: Colors.red.shade50,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: ListTile(
                leading: Icon(Icons.logout, color: Colors.red.shade700),
                title: Text('Logout / Keluar Akun', style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.bold)),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      title: const Text('Konfirmasi Keluar'),
                      content: const Text('Apakah Anda yakin ingin logout dari sistem toko?'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tidak')),
                        TextButton(onPressed: () { Navigator.pop(context); Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (r) => false); }, child: const Text('Ya, Keluar', style: TextStyle(color: Colors.red))),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}