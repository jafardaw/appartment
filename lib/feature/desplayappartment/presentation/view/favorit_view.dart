import 'package:appartment/core/widget/app_bar_widget.dart';
import 'package:appartment/feature/desplayappartment/data/model/apartment_model.dart';
import 'package:appartment/feature/desplayappartment/presentation/manger/cubit/favorit_cubit.dart';
import 'package:appartment/feature/desplayappartment/presentation/view/apartment_details_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppareWidget(title: 'المفضلة', automaticallyImplyLeading: true),
      body: BlocBuilder<FavoritesCubit, List<ApartmentModel>>(
        builder: (context, favorites) {
          if (favorites.isEmpty) {
            return _buildEmptyFavorites();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final apartment = favorites[index];
              // نستخدم نفس ميثود بناء الكرت لضمان تناسق التصميم
              return _buildApartmentCard(context, apartment);
            },
          );
        },
      ),
    );
  }

  // بطاقة عرض الشقة
  Widget _buildApartmentCard(BuildContext context, ApartmentModel apartment) {
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
            // صورة افتراضية
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

  Widget _buildEmptyFavorites() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 80, color: Colors.grey[300]),
          const Text(
            'قائمة المفضلة فارغة',
            style: TextStyle(fontFamily: 'Cairo'),
          ),
        ],
      ),
    );
  }

  // ملاحظة: انقل ميثود _buildApartmentCard لمكان عام (Common Widget)
  // ليسهل استخدامه في الصفحتين بنفس منطق الـ Navigator.push
}
