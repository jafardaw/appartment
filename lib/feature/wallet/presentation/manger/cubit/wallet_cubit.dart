import 'package:appartment/feature/wallet/repo/wallet_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// wallet_state.dart
abstract class WalletState {}

class WalletInitial extends WalletState {}

class WalletLoading extends WalletState {}

class WalletLoaded extends WalletState {
  final String balance;
  WalletLoaded(this.balance);
}

class ChargeSuccess extends WalletState {
  final String message;
  ChargeSuccess(this.message);
}

class WalletFailure extends WalletState {
  final String error;
  WalletFailure(this.error);
}

class WalletCubit extends Cubit<WalletState> {
  final WalletRepo repo;
  WalletCubit(this.repo) : super(WalletInitial());

  Future<void> fetchBalance() async {
    emit(WalletLoading());
    try {
      final balance = await repo.getBalance();
      emit(WalletLoaded(balance));
    } catch (e) {
      emit(WalletFailure(e.toString()));
    }
  }

  Future<void> chargeWallet(double amount) async {
    emit(WalletLoading());
    try {
      await repo.requestCharge(amount);
      emit(ChargeSuccess("تم إرسال طلب الشحن بنجاح"));
    } catch (e) {
      emit(WalletFailure("فشل في طلب الشحن"));
    }
  }
}
