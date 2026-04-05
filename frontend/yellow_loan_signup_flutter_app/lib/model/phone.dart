import 'package:yellow_loan_signup_flutter_app/util/to_rands_string.dart';

class Phone {
  Phone({
    required this.id,
    required this.image,
    required this.title,
    required this.cashPrice,
    required this.depositPercent,
    required this.interestRate,
  });

  factory Phone.fromJson(Map<String, dynamic> json) {
    return Phone(
      id: json['id'] as String,
      image:
          'https://fhkrgvwsnxzqsbwrjqef.supabase.co/storage/v1/object/public/phone-images/${json['image'] as String}',
      title: json['title'] as String,
      cashPrice: json['cash_price'] as int,
      depositPercent: (json['deposit_percent'] as num).toDouble(),
      interestRate: (json['interest_rate'] as num).toDouble(),
    );
  }
  final String id;
  final String image;
  final String title;
  final int cashPrice; // in cents
  final double depositPercent;
  final double interestRate;

  /// Deposit amount (downpayment) in cents
  double get deposit => cashPrice * depositPercent;

  /// Daily payment amount in cents for the 360-day loan period
  double get dailyPayment {
    final loanPrincipal = cashPrice * (1 - depositPercent);
    final loanAmount = loanPrincipal * (1 + interestRate);
    return loanAmount / 360;
  }

  String get dailyPaymentInRands {
    return (dailyPayment / 100).toRandsStringWithDecimals();
  }

  String get cashPriceInRands {
    return (cashPrice / 100).toRandsStringWithDecimals();
  }

  String get depositInRands {
    return (deposit / 100).toRandsStringWithDecimals();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'title': title,
      'cashPrice': cashPrice,
      'depositPercent': depositPercent,
      'interestRate': interestRate,
    };
  }
}
