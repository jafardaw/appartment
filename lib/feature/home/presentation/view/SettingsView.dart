import 'package:appartment/core/theme/manger/theme_cubit.dart';
import 'package:appartment/core/utils/assetimage.dart';
import 'package:appartment/core/widget/background_viwe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'الإعدادات',
          style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: BackgroundWrapper(
        backgroundImagePath:
            Assets.assetsImagesPhoto20250924144805RemovebgPreview,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 600,
              ), // الحد الأقصى للعرض كما تفضل
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // قسم المظهر (الثيم)
                  _buildSettingsCard(
                    context,
                    title: 'المظهر',
                    subtitle: 'التبديل بين الوضع الليلي والنهاري',
                    icon: Icons.palette_outlined,
                    trailing: BlocBuilder<ThemeCubit, ThemeMode>(
                      builder: (context, state) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: IconButton(
                            icon: Icon(
                              state == ThemeMode.light
                                  ? Icons.dark_mode
                                  : Icons.light_mode,
                              color: Theme.of(context).primaryColor,
                            ),
                            onPressed: () {
                              context.read<ThemeCubit>().toggleTheme();
                            },
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  // قسم اللغة (بما أنك تستخدم Easy Localization)
                  _buildSettingsCard(
                    context,
                    title: 'لغة التطبيق',
                    subtitle: 'العربية (الإمارات)',
                    icon: Icons.language_outlined,
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // هنا يمكنك إضافة منطق تغيير اللغة
                    },
                  ),

                  const SizedBox(height: 16),

                  // قسم معلومات التطبيق
                  _buildSettingsCard(
                    context,
                    title: 'عن التطبيق',
                    subtitle: 'الإصدار 1.0.0',
                    icon: Icons.info_outline,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ميثود لبناء الكروت بشكل موحد وجميل
  Widget _buildSettingsCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // زوايا منحنية حسب طلبك
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
          child: Icon(icon, color: Theme.of(context).primaryColor),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        trailing: trailing,
      ),
    );
  }
}
