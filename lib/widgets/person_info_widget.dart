import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../models/person.dart';

class PersonInfoWidget extends StatelessWidget {
  final Person person;

  const PersonInfoWidget({super.key, required this.person});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Colors.black54,
      height: ResponsiveBreakpoints.of(context).isMobile ? 140 : 220,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AutoSizeText(
              minFontSize: ResponsiveBreakpoints.of(context).isMobile ? 24 : 32,
              person.theDanh,
              style: const TextStyle(fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (person.phapDanh != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AutoSizeText(
                    minFontSize: ResponsiveBreakpoints.of(context).isMobile
                        ? 16
                        : 24,
                    "Pháp danh: ${person.phapDanh}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            if (person.ngayMat != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AutoSizeText(
                    minFontSize: ResponsiveBreakpoints.of(context).isMobile
                        ? 16
                        : 24,
                    "Ngày mất: ${person.ngayMat}",
                  ),
                ],
              ),
            if (person.huongTho != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AutoSizeText(
                    minFontSize: ResponsiveBreakpoints.of(context).isMobile
                        ? 16
                        : 24,
                    "Hưởng thọ: ${person.huongTho} tuổi",
                  ),
                ],
              ),
            if (person.nguyenQuan != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AutoSizeText(
                    minFontSize: ResponsiveBreakpoints.of(context).isMobile
                        ? 16
                        : 24,
                    "Nguyên quán: ${person.nguyenQuan}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
