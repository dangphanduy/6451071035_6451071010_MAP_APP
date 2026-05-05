import 'package:flutter/material.dart';
import 'package:map_app_6451071035_6451071010/common/widgets/profile_menu_item..dart';
import 'package:map_app_6451071035_6451071010/controllers/login_controller.dart';
import 'package:map_app_6451071035_6451071010/controllers/settings_controller.dart';
import 'package:map_app_6451071035_6451071010/screens/notifications/my_notifications.dart';
import 'package:map_app_6451071035_6451071010/screens/order/my_order_screen.dart';
import 'package:map_app_6451071035_6451071010/screens/shipping_address/my_shipping_address_screen.dart';
import '../../common/styles/app_colors.dart';
import '../../common/styles/app_text_styles.dart';
import '../../routes/app_routes.dart';
import '../bank_account/my_bank_account_screen.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (authController) {
        bool loggedIn = authController.currentUser != null;

        if (!loggedIn) {
          return _buildGuestProfile(context);
        }

        return _buildUserProfile(context, authController);
      },
    );
  }

  /// ===== Header =====
  Widget _buildHeader(BuildContext context, AuthController authController) {
    final user = authController.currentUser;

    String fullName = '';
    String email = '';

    if (user != null) {
      fullName = '${user.firstName} ${user.lastName}';
      email = user.email;
    }



    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
      color: AppColors.primaryBlue,
      child: Row(
        children: [
          const CircleAvatar(
            radius: 32,
            backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(fullName, style: AppTextStyle.whiteTitle),
                const SizedBox(height: 4),
                Text(email, style: AppTextStyle.whiteSubtitle),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.updateAccount);
            },
            icon: const Icon(Icons.edit, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildUserProfile(
      BuildContext context,
      AuthController authController,
      ) {
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          _buildHeader(context, authController),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAccountSetting(context),
                    const SizedBox(height: 24),

                    ///  APP SETTINGS HERE
                    _buildAppSettingLabel(),
                    const SizedBox(height: 16),
                    _buildAppSettings(),

                    const SizedBox(height: 24),
                    _buildLogoutButton(context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ===== Account Setting =====
  Widget _buildAccountSetting(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('profile.account_settings'.tr, style: AppTextStyle.title),
        const SizedBox(height: 16),

        ProfileMenuItem(
          icon: Icons.location_on,
          title: 'profile.my_address'.tr,
          subtitle: 'profile.manage_shipping'.tr,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => MyShippingAddressScreen()),
            );
          },
        ),

        ProfileMenuItem(
          icon: Icons.shopping_cart,
          title: 'profile.my_cart'.tr,
          subtitle: 'profile.view_cart'.tr,
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.cartOverview);
          },
        ),

        ProfileMenuItem(
          icon: Icons.receipt_long,
          title: 'profile.my_orders'.tr,
          subtitle: 'profile.track_orders'.tr,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MyOrderScreen()),
            );
          },
        ),

        ProfileMenuItem(
          icon: Icons.account_balance,
          title: 'profile.bank_account'.tr,
          subtitle: 'profile.manage_payment'.tr,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => MyBankAccountScreen()),
            );
          },
        ),

        ProfileMenuItem(
          icon: Icons.notifications,
          title: 'profile.notifications'.tr,
          subtitle: 'profile.notification_settings'.tr,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => MyNotificationScreen()),
            );
          },
        ),
      ],
    );
  }

  /// ===== LABEL =====
  Widget _buildAppSettingLabel() {
    return Text('profile.app_settings'.tr, style: AppTextStyle.title);
  }



  /// ===== SETTINGS =====
  Widget _buildAppSettings() {
    final controller = Get.find<SettingsController>();

    return Obx(
          () => Column(
        children: [
          ProfileMenuItem(
            icon: Icons.dark_mode,
            title: 'profile.theme'.tr,
            subtitle: controller.themeLabelKey.tr,
            onTap: () => _showThemeDialog(controller),
          ),
          ProfileMenuItem(
            icon: Icons.text_fields,
            title: 'profile.font_size'.tr,
            subtitle: controller.fontSizeLabelKey.tr,
            onTap: () => _showFontDialog(controller),
          ),
          ProfileMenuItem(
            icon: Icons.language,
            title: 'profile.language'.tr,
            subtitle: controller.languageLabelKey.tr,
            onTap: () => _showLanguageDialog(controller),
          ),
        ],
      ),
    );
  }

  /// ===== LOGOUT =====
  Widget _buildLogoutButton(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: GestureDetector(
        onTap: () async {
          bool? confirm = await showDialog<bool>(
            context: context,
            builder: (dialogContext) {
              return AlertDialog(
                title: Text('profile.logout'.tr),
                content: Text('profile.logout_confirm'.tr),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext, false),
                    child: Text('common.cancel'.tr),
                  ),


                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext, true),
                    child: Text(
                      'profile.logout'.tr,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              );
            },
          );

          if (confirm == true) {
            await authController.logout();

            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.home,
                  (route) => false,
            );
          }
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.red),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              'profile.logout'.tr,
              style: TextStyle(
                color: Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// ===== GUEST =====
Widget _buildGuestProfile(BuildContext context) {
  return Scaffold(
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    body: Column(


      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
          color: AppColors.primaryBlue,
          child: Column(
            children: [
              const CircleAvatar(
                radius: 40,
                child: Icon(Icons.person, size: 40),
              ),
              const SizedBox(height: 16),
              Text(
                'profile.guest'.tr,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.login);
                },
                child: Text('profile.login_now'.tr),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

/// ===== DIALOGS =====
void _showThemeDialog(SettingsController controller) {
  Get.defaultDialog(
    title: 'theme.title'.tr,
    content: Column(
      children: [
        ListTile(
          title: Text('theme.light'.tr),
          onTap: () {
            controller.changeTheme('light');
            Get.back();
          },
        ),
        ListTile(
          title: Text('theme.dark'.tr),


          onTap: () {
            controller.changeTheme('dark');
            Get.back();
          },
        ),
        ListTile(
          title: Text('theme.system'.tr),
          onTap: () {
            controller.changeTheme('system');
            Get.back();
          },
        ),
      ],
    ),
  );
}

void _showFontDialog(SettingsController controller) {
  Get.defaultDialog(
    title: 'font.title'.tr,
    content: Column(
      children: [
        ListTile(
          title: Text('font.small'.tr),
          onTap: () {
            controller.changeFontSize('small');
            Get.back();
          },
        ),
        ListTile(
          title: Text('font.medium'.tr),
          onTap: () {
            controller.changeFontSize('medium');
            Get.back();
          },
        ),
        ListTile(
          title: Text('font.large'.tr),
          onTap: () {
            controller.changeFontSize('large');
            Get.back();
          },
        ),
      ],
    ),
  );
}

void _showLanguageDialog(SettingsController controller) {
  Get.defaultDialog(


    title: 'language.title'.tr,
    content: Column(
      children: [
        ListTile(
          title: Text('language.vietnamese'.tr),
          onTap: () {
            controller.changeLanguage('vi');
            Get.back();
          },
        ),
        ListTile(
          title: Text('language.english'.tr),
          onTap: () {
            controller.changeLanguage('en');
            Get.back();
          },
        ),
      ],
    ),
  );
}
