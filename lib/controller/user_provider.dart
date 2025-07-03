import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:e_commerce/model/user_model.dart';
import '../model/produkModel.dart';
import 'package:e_commerce/model/produkModel.dart';

class UserProvider with ChangeNotifier {
  User _user = User.empty();
  late Box<User> _userBox;
  late Box<List> _usersBox; // Changed to Box<List> since we store List<User>
  late Box<List> _wishlistBox;
  late Box<List> _transactionsBox;
  bool _isInitialized = false;
  bool _isLoading = false;
  String? _error;

  User get user => _user;
  bool get isInitialized => _isInitialized;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await init();
    }
  }

  Future<void> init() async {
    if (_isInitialized || _isLoading) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {

      await Hive.initFlutter();
      _userBox = await Hive.openBox<User>('currentUser');
      _usersBox = await Hive.openBox<List>('usersBox');
      _wishlistBox = await Hive.openBox<List>('wishlists');
      _transactionsBox = await Hive.openBox<List>('transactions');

      // Load users data
      final List<dynamic>? usersData = _usersBox.get('users');
      List<User> users = [];


      if (usersData != null) {
        users = usersData.cast<User>().toList();
      }

      if (users.isEmpty) {
        await _usersBox.put('users', <User>[]);
      }

      _user = _userBox.get('currentUser') ?? User.empty();
      _isInitialized = true;
    } catch (e) {
      _error = 'Initialization Error: ${e.toString()}';
      debugPrint('Error details: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Tambahkan di UserProvider
Future<void> recordTransaction(User user, Produk product) async {
  await _ensureInitialized();
  
  // Ambil data transaksi yang ada
  final transactionData = _transactionsBox.get('chart_${user.userId}') ?? [];
  final List<Map<String, dynamic>> transactions = transactionData.cast<Map<String, dynamic>>().toList();
  
  // Tambahkan transaksi baru
  transactions.add({
    'date': DateTime.now(),
    'amount': product.harga.toDouble(),
    'product': product,
  });
  
  // Simpan kembali
  await _transactionsBox.put('chart_${user.userId}', transactions);
  notifyListeners();
}

Future<List<Map<String, dynamic>>> getChartData(String userId) async {
  await _ensureInitialized();
  final data = _transactionsBox.get('chart_$userId') ?? [];
  return data.cast<Map<String, dynamic>>().toList();
}

  Future<void> addTransaction(User user, Produk product) async {
  await _ensureInitialized();
  
  final transaction = {
    'product': product,
    'date': DateTime.now().toString(),
    'status': 'Processing' // Status awal
  };

  List<dynamic>? userTransactions = _transactionsBox.get(user.userId);
  List<Map<String, dynamic>> transactions = userTransactions?.cast<Map<String, dynamic>>().toList() ?? [];
  
  // Cek duplikasi (opsional)
  if (transactions.any((t) => t['product'].id == product.id)) {
    throw Exception('Produk sudah ada di transaksi');
  }
  
  transactions.add(transaction);
  await _transactionsBox.put(user.userId, transactions);
  notifyListeners();
}

Future<List<Map<String, dynamic>>> getTransactions(String userId) async {
  await _ensureInitialized();
  
  try {
    if (!_transactionsBox.isOpen) {
      await init(); // Reinitialize if box is closed
    }
    
    final transactionsData = _transactionsBox.get(userId);
    if (transactionsData == null) return [];
    
    return transactionsData.cast<Map<String, dynamic>>().toList();
  } catch (e) {
    debugPrint('Error getting transactions: $e');
    return [];
  }
}


  Future<void> addToWishlist(Produk produk) async {
  await _ensureInitialized();
  if (_isLoading) return;

  _isLoading = true;
  notifyListeners();

  try {
    final userId = _user.userId;
    if (userId.isEmpty) throw Exception('User not logged in');

    List<dynamic>? wishlistData = _wishlistBox.get(userId);
    List<Produk> wishlist = wishlistData?.cast<Produk>().toList() ?? [];

    // Cek apakah produk sudah ada di wishlist
    if (wishlist.any((p) => p.id == produk.id)) {
      throw Exception('Produk sudah ada di wishlist');
    }

    wishlist.add(produk);
    await _wishlistBox.put(userId, wishlist);
  } catch (e) {
    _error = 'Failed to add to wishlist: ${e.toString()}';
    rethrow;
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

Future<List<Produk>> getWishlist(String userId) async {
  await _ensureInitialized();
  final wishlistData = _wishlistBox.get(userId);
  return wishlistData?.cast<Produk>().toList() ?? [];
}

Future<void> removeFromWishlist(String userId, Produk produk) async {
  await _ensureInitialized();
  if (_isLoading) return;

  _isLoading = true;
  notifyListeners();

  try {
    List<dynamic>? wishlistData = _wishlistBox.get(userId);
    List<Produk> wishlist = wishlistData?.cast<Produk>().toList() ?? [];
    
    wishlist.removeWhere((p) => p.id == produk.id);
    await _wishlistBox.put(userId, wishlist);
  } catch (e) {
    _error = 'Failed to remove from wishlist: ${e.toString()}';
    rethrow;
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}
  Future<void> registerUser(User newUser) async {
    await _ensureInitialized();
    if (_isLoading) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final List<dynamic>? usersData = _usersBox.get('users');
      List<User> users = usersData?.cast<User>().toList() ?? <User>[];

      if (users.any((u) => u.username == newUser.username)) {
        throw Exception('Username already exists');
      }
      if (users.any((u) => u.email == newUser.email)) {
        throw Exception('Email already registered');
      }

      users.add(newUser);
      await _usersBox.put('users', users);
      await _setCurrentUser(newUser);
    } catch (e) {
      _error = 'Registration Failed: ${e.toString()}';
      debugPrint('Registration error details: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loginUser(String usernameOrEmail, String password) async {
    await _ensureInitialized();
    if (_isLoading) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final List<dynamic>? usersData = _usersBox.get('users');
      List<User> users = usersData?.cast<User>().toList() ?? <User>[];

      User? matchedUser;
      for (final user in users) {
        if ((user.username == usernameOrEmail || user.email == usernameOrEmail) &&
            user.password == password) {
          matchedUser = user;
          break;
        }
      }

      if (matchedUser == null || matchedUser.userId.isEmpty) {
        throw Exception('Invalid username/email or password');
      }

      await _setCurrentUser(matchedUser);
    } catch (e) {
      _error = 'Login Failed: ${e.toString()}';
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _setCurrentUser(User user) async {
    _user = user;
    await _userBox.put('currentUser', user);
    notifyListeners();
  }

  Future<void> logout() async {
    await _ensureInitialized();
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      await _userBox.delete('currentUser');
      _user = User.empty();
    } catch (e) {
      _error = 'Logout Failed: ${e.toString()}';
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteUser(String userId) async {
    await _ensureInitialized();
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      final List<dynamic>? usersData = _usersBox.get('users');
      List<User> users = usersData?.cast<User>().toList() ?? <User>[];
          
      users.removeWhere((u) => u.userId == userId);
      await _usersBox.put('users', users);

      if (_user.userId == userId) {
        await _userBox.delete('currentUser');
        _user = User.empty();
      }
    } catch (e) {
      _error = 'Account Deletion Failed: ${e.toString()}';
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateUser(User updatedUser) async {
    await _ensureInitialized();
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      final List<dynamic>? usersData = _usersBox.get('users');
      List<User> users = usersData?.cast<User>().toList() ?? <User>[];
      
      final index = users.indexWhere((u) => u.userId == updatedUser.userId);
      
      if (index != -1) {
        users[index] = updatedUser;
        await _usersBox.put('users', users);
      }
      
      if (_user.userId == updatedUser.userId) {
        await _setCurrentUser(updatedUser);
      }
    } catch (e) {
      _error = 'Update Failed: ${e.toString()}';
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _userBox.close();
    _usersBox.close();
    super.dispose();
  }
}