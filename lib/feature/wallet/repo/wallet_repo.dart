// wallet_repo.dart
import 'package:appartment/core/utils/api_service.dart';

class WalletRepo {
  final ApiService apiService;
  WalletRepo(this.apiService);

  Future<String> getBalance() async {
    final response = await apiService.get("wallet_balance");
    return response.data['wallet_balance'].toString();
  }

  Future<void> requestCharge(double amount) async {
    await apiService.post("wallet/request", {"amount": amount});
  }
}
