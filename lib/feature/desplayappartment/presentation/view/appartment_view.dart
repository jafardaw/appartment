import 'package:appartment/core/style/color.dart';
import 'package:appartment/core/widget/app_bar_widget.dart';
import 'package:appartment/core/widget/loading_view.dart';
import 'package:appartment/feature/desplayappartment/data/model/apartment_model.dart';
import 'package:appartment/feature/desplayappartment/presentation/manger/cubit/apartments_cubit.dart';
import 'package:appartment/feature/desplayappartment/presentation/manger/cubit/apartments_state.dart';
import 'package:appartment/feature/desplayappartment/presentation/manger/cubit/favorit_cubit.dart';
import 'package:appartment/feature/desplayappartment/presentation/view/apartment_details_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppartmentView extends StatefulWidget {
  const AppartmentView({super.key});

  @override
  State<AppartmentView> createState() => _AppartmentViewState();
}

class _AppartmentViewState extends State<AppartmentView> {
  // كونتورلرز للتحكم في حقول البحث
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  void initState() {
    // جلب البيانات عند تشغيل الصفحة لأول مرة
    context.read<ApartmentsCubit>().getApartments();
    super.initState();
  }

  // ميثود لتشغيل الفلترة عند أي تغيير في النصوص
  void _onFilterChanged() {
    context.read<ApartmentsCubit>().filterApartments(
      cityName: _cityController.text,
      maxPrice: double.tryParse(_priceController.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppareWidget(
        title: 'العقارات المتاحة',
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: [
          // قسم الفلاتر (مدينة وسعر)
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                // فلتر المدينة
                Expanded(
                  child: _buildFilterField(
                    controller: _cityController,
                    hint: 'ابحث بالمدينة...',
                    icon: Icons.location_city,
                    onChanged: (val) => _onFilterChanged(),
                  ),
                ),
                const SizedBox(width: 10),
                // فلتر السعر
                Expanded(
                  child: _buildFilterField(
                    controller: _priceController,
                    hint: 'أقصى سعر...',
                    icon: Icons.payments_outlined,
                    isNumber: true,
                    onChanged: (val) => _onFilterChanged(),
                  ),
                ),
              ],
            ),
          ),

          // عرض النتائج باستخدام BlocBuilder
          Expanded(
            child: BlocBuilder<ApartmentsCubit, ApartmentsState>(
              builder: (context, state) {
                if (state is ApartmentsLoading) {
                  return const LoadingViewWidget();
                }

                if (state is ApartmentsFailure) {
                  return Center(
                    child: Text(
                      state.error,
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        color: Colors.red,
                      ),
                    ),
                  );
                }

                if (state is ApartmentsSuccess) {
                  if (state.apartments.isEmpty) {
                    return _buildEmptyState();
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.apartments.length,
                    itemBuilder: (context, index) {
                      final apartment = state.apartments[index];
                      return _buildApartmentCard(apartment);
                    },
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  // ويدجت حقل الفلترة الموحد

  Widget _buildFilterField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required Function(String) onChanged,
    bool isNumber = false,
  }) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: const TextStyle(fontFamily: 'Cairo', fontSize: 13),
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, size: 20, color: Colors.blueAccent),
        filled: true,
        fillColor: Colors.grey[100],
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  /// *****  a4c95b42-ddbc-4fcd-8ae0-3391ad4c57df  ******
  // بطاقة عرض الشقة مع إضافة زر المفضلة
  Widget _buildApartmentCard(ApartmentModel apartment) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ApartmentDetailsView(apartment: apartment),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        elevation: 4,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // استخدام Stack لوضع زر المفضلة فوق الصورة
            Stack(
              children: [
                // الصورة (أو الأيقونة الافتراضية)
                Container(
                  height: 140,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[50],
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(15),
                    ),
                  ),
                  child: const Icon(
                    Icons.apartment_rounded,
                    size: 50,
                    color: Colors.blueGrey,
                  ),
                ),
                // زر المفضلة في الزاوية
                Positioned(
                  top: 10,
                  left: 10, // نضعه على اليسار لأن التطبيق باللغة العربية
                  child: BlocBuilder<FavoritesCubit, List<ApartmentModel>>(
                    builder: (context, favorites) {
                      // التحقق إذا كانت الشقة موجودة في قائمة المفضلة
                      final isFav = context.read<FavoritesCubit>().isFavorite(
                        apartment,
                      );
                      return GestureDetector(
                        onTap: () {
                          context.read<FavoritesCubit>().toggleFavorite(
                            apartment,
                          );
                        },
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.white.withOpacity(0.9),
                          child: Icon(
                            isFav ? Icons.home : Icons.home_outlined,
                            color: isFav
                                ? const Color.fromARGB(255, 76, 56, 49)
                                : Colors.grey,
                            size: 20,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        apartment.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      Text(
                        "${apartment.pricePerDay} ل.س",
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "${apartment.city.name} - ${apartment.address}",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _buildMiniInfo(
                        Icons.king_bed_outlined,
                        "${apartment.rooms} غرف",
                      ),
                      const SizedBox(width: 20),
                      _buildMiniInfo(
                        Icons.bathtub_outlined,
                        "${apartment.bathrooms} حمام",
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.blueAccent),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontFamily: 'Cairo', fontSize: 12)),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 60, color: Colors.grey[400]),
          const SizedBox(height: 10),
          const Text(
            "لا توجد نتائج تطابق معايير البحث",
            style: TextStyle(fontFamily: 'Cairo', color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
