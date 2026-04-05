class ApplicationRequest {
  ApplicationRequest({
    required this.fullName,
    required this.monthlyIncome,
    required this.proofDocument,
    required this.phoneId,
  });

  factory ApplicationRequest.fromJson(Map<String, dynamic> json) {
    return ApplicationRequest(
      fullName: json['fullName'] as String,
      monthlyIncome: json['monthlyIncome'] as int,
      proofDocument: json['proofDocument'] as String,
      phoneId: json['phoneId'] as String,
    );
  }

  final String fullName;
  final int monthlyIncome; // in cents
  final String proofDocument;
  final String phoneId;

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'monthlyIncome': monthlyIncome,
      'proofDocument': proofDocument,
      'phoneId': phoneId,
    };
  }
}
