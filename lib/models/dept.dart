class Dept {
  int deptID;
  double deptAmount;
  int customerID;
  DateTime date;
  String? deptNotes;

  Dept({
    required this.deptID,
    required this.deptAmount,
    required this.customerID,
    required this.date,
    this.deptNotes,
  });
}
