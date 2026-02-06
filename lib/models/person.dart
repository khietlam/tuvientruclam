class Person {
  final int id;
  final String theDanh;
  final String? phapDanh;
  final String? ngayMat;
  final int? huongTho;
  final String? nguyenQuan;

  Person({
    required this.id,
    required this.theDanh,
    this.phapDanh,
    this.ngayMat,
    this.huongTho,
    this.nguyenQuan,
  });

  Person.fromJson(Map<String, dynamic> j)
    : id = j['id'],
      theDanh = j['theDanh'],
      phapDanh = j['phapDanh'],
      ngayMat = j['ngayMat'],
      huongTho = j['huongTho'],
      nguyenQuan = j['nguyenQuan'];
}
