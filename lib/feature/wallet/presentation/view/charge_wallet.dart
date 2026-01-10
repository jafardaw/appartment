import 'package:appartment/core/func/show_snak_bar.dart';
import 'package:appartment/core/style/color.dart';
import 'package:appartment/core/widget/background_viwe.dart'; // تأكد من استيراده
import 'package:appartment/core/widget/custom_button.dart';
import 'package:appartment/core/widget/custom_field.dart';
import 'package:appartment/core/utils/assetimage.dart';
import 'package:appartment/feature/wallet/presentation/manger/cubit/wallet_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChargeWalletView extends StatefulWidget {
  const ChargeWalletView({super.key, required this.amount});
  final String amount;

  @override
  State<ChargeWalletView> createState() => _ChargeWalletViewState();
}

class _ChargeWalletViewState extends State<ChargeWalletView> {
  final TextEditingController amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'محفظتي',
          style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: BackgroundWrapper(
        backgroundImagePath:
            Assets.assetsImagesPhoto20250924144805RemovebgPreview,
        child: BlocConsumer<WalletCubit, WalletState>(
          listener: (context, state) {
            if (state is ChargeSuccess) {
              showCustomSnackBar(
                context,
                state.message,
                color: Palette.success,
              );
              context.read<WalletCubit>().fetchBalance();
              Navigator.pop(context);
            }
            if (state is WalletFailure) {
              showCustomSnackBar(context, state.error);
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Column(
                    children: [
                      // --- بطاقة عرض الرصيد الجذابة ---
                      _buildBalanceCard(widget.amount),

                      const SizedBox(height: 30),

                      // --- نموذج الشحن ---
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "إيداع رصيد جديد",
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                CustomTextField(
                                  controller: amountController,
                                  hintText: 'أدخل المبلغ المراد شحنه',
                                  prefixIcon: Icon(Icons.add_card_rounded),
                                  keyboardType: TextInputType
                                      .number, // لتفعيل لوحة أرقام فقط
                                ),
                                const SizedBox(height: 30),
                                CustomButton(
                                  text: 'تأكيد طلب الشحن',
                                  onTap: () {
                                    if (_formKey.currentState!.validate()) {
                                      context.read<WalletCubit>().chargeWallet(
                                        double.parse(amountController.text),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ويدجت عرض الرصيد بتصميم عصري
  Widget _buildBalanceCard(String balance) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Palette.success, const Color.fromARGB(255, 163, 194, 164)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "الرصيد المتاح",
                style: TextStyle(
                  color: Colors.white70,
                  fontFamily: 'Cairo',
                  fontSize: 14,
                ),
              ),
              Icon(Icons.account_balance_wallet, color: Colors.white54),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            balance,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Cairo',
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
