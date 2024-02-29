class Paying {
  int payingID;
  double payingAmount;
  int customerID;
  DateTime date;
  String? payingNotes;

  Paying({
    required this.payingID,
    required this.payingAmount,
    required this.customerID,
    required this.date,
    this.payingNotes,
  });
}
