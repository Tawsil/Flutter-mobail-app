import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import 'login_screen.dart';
import 'admin_martyrs_management_screen.dart';
import 'admin_injured_management_screen.dart';
import 'admin_prisoners_management_screen.dart';
import 'admin_users_management_screen.dart';
import 'admin_settings_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();
  
  String? _adminName;
  Map<String, int> _statistics = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    try {
      final adminName = await _authService.getCurrentUserName();
      final stats = await _firestoreService.getStatistics();
      
      if (mounted) {
        setState(() {
          _adminName = adminName;
          _statistics = stats;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _logout() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تسجيل الخروج'),
        content: const Text(AppConstants.confirmLogout),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.primaryWhite,
            ),
            child: const Text('تسجيل الخروج'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _authService.logout();
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    }
  }

  void _navigateToManagement(String section) {
    Widget? targetScreen;
    
    switch (section) {
      case 'الشهداء':
        targetScreen = const AdminMartyrsManagementScreen();
        break;
      case 'الجرحى':
        targetScreen = const AdminInjuredManagementScreen();
        break;
      case 'الأسرى':
        targetScreen = const AdminPrisonersManagementScreen();
        break;
      case 'المستخدمين':
        targetScreen = const AdminUsersManagementScreen();
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('سيتم إضافة شاشة إدارة $section قريباً'),
            backgroundColor: AppColors.info,
          ),
        );
        return;
    }
    
    if (targetScreen != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => targetScreen!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // ضمان اتجاه RTL للعربية
      child: Scaffold(
      appBar: AppBar(
        title: const Text(
          'لوحة التحكم الإدارية',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryWhite,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryGreen,
        elevation: 4,
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () => Scaffold.of(context).openEndDrawer(),
            icon: const Icon(
              Icons.menu,
              color: AppColors.primaryWhite,
            ),
            tooltip: 'القائمة الجانبية',
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminSettingsScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.settings,
              color: AppColors.primaryWhite,
            ),
            tooltip: 'الإعدادات',
          ),
          IconButton(
            onPressed: _logout,
            icon: const Icon(
              Icons.logout,
              color: AppColors.primaryWhite,
            ),
            tooltip: 'تسجيل الخروج',
          ),
        ],
      ),
      endDrawer: _buildDrawer(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryGreen,
              ),
            )
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primaryGreen.withOpacity(0.1),
                    AppColors.primaryWhite,
                  ],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                      // ترحيب بالمسؤول
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryGreen.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.admin_panel_settings,
                              size: 48,
                              color: AppColors.primaryWhite,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'مرحباً ${_adminName ?? "المسؤول"}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryWhite,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'لوحة التحكم الإدارية - إدارة ومراجعة البيانات',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.primaryWhite,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // بطاقات الإحصائيات
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              title: 'الشهداء',
                              count: _statistics['martyrs'] ?? 0,
                              icon: Icons.person_off_outlined,
                              color: AppColors.primaryRed,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              title: 'الجرحى',
                              count: _statistics['injured'] ?? 0,
                              icon: Icons.healing_outlined,
                              color: AppColors.warning,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              title: 'الأسرى',
                              count: _statistics['prisoners'] ?? 0,
                              icon: Icons.lock_person_outlined,
                              color: AppColors.earthBrown,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              title: 'قيد المراجعة',
                              count: _statistics['pending'] ?? 0,
                              icon: Icons.pending_outlined,
                              color: AppColors.info,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // زر فتح القائمة الجانبية
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.info.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.menu,
                              size: 48,
                              color: AppColors.primaryWhite,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'اضغط على القائمة الجانبية لإدارة البيانات',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryWhite,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'إدارة الشهداء والجرحى والأسرى والمستخدمين والإعدادات',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.primaryWhite,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                Scaffold.of(context).openEndDrawer();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryWhite,
                                foregroundColor: AppColors.primaryGreen,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                'فتح القائمة الجانبية',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // ملاحظة
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.success.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.security,
                              color: AppColors.success,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'أنت مسجل دخول كمسؤول. يمكنك مراجعة وإدارة جميع البيانات المرسلة.',
                                style: TextStyle(
                                  color: AppColors.success,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      width: 320,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryGreen.withOpacity(0.9),
              AppColors.primaryWhite,
            ],
          ),
        ),
        child: Column(
          children: [
            // رأس القائمة
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 50, 16, 20),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.primaryWhite,
                    child: Icon(
                      Icons.admin_panel_settings,
                      size: 40,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _adminName ?? 'المسؤول',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryWhite,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Administrator',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.primaryWhite,
                    ),
                  ),
                ],
              ),
            ),

            // قائمة الإدارة
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  const SizedBox(height: 20),

                  _buildDrawerItem(
                    title: 'إدارة الشهداء',
                    subtitle: 'مراجعة وتوثيق بيانات الشهداء',
                    icon: Icons.person_off_outlined,
                    color: AppColors.primaryRed,
                    onTap: () {
                      Navigator.pop(context);
                      _navigateToManagement('الشهداء');
                    },
                  ),
                  const SizedBox(height: 12),

                  _buildDrawerItem(
                    title: 'إدارة الجرحى',
                    subtitle: 'مراجعة وتوثيق بيانات الجرحى',
                    icon: Icons.healing_outlined,
                    color: AppColors.warning,
                    onTap: () {
                      Navigator.pop(context);
                      _navigateToManagement('الجرحى');
                    },
                  ),
                  const SizedBox(height: 12),

                  _buildDrawerItem(
                    title: 'إدارة الأسرى',
                    subtitle: 'مراجعة وتوثيق بيانات الأسرى',
                    icon: Icons.lock_person_outlined,
                    color: AppColors.earthBrown,
                    onTap: () {
                      Navigator.pop(context);
                      _navigateToManagement('الأسرى');
                    },
                  ),
                  const SizedBox(height: 12),

                  _buildDrawerItem(
                    title: 'إدارة المستخدمين',
                    subtitle: 'إدارة حسابات المستخدمين',
                    icon: Icons.people_outlined,
                    color: AppColors.primaryGreen,
                    onTap: () {
                      Navigator.pop(context);
                      _navigateToManagement('المستخدمين');
                    },
                  ),
                  const SizedBox(height: 12),

                  _buildDrawerItem(
                    title: 'الإعدادات',
                    subtitle: 'إعدادات التطبيق والحساب',
                    icon: Icons.settings,
                    color: AppColors.info,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AdminSettingsScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // زر تسجيل الخروج
            Container(
              margin: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _logout();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  foregroundColor: AppColors.primaryWhite,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 8),
                    Text(
                      'تسجيل الخروج',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.1),
                color.withOpacity(0.05),
              ],
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 24,
                  color: AppColors.primaryWhite,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_back_ios,
                color: color,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required int count,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 32,
            color: color,
          ),
          const SizedBox(height: 8),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildManagementCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 6,
      shadowColor: color.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.1),
                color.withOpacity(0.05),
              ],
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 30,
                  color: AppColors.primaryWhite,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: color,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}