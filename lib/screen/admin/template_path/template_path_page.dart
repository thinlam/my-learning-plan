import 'package:flutter/material.dart';
import 'template_path_detail_page.dart';
import 'template_path_form_page.dart';

enum TemplateType { exam, daily, extra }

class TemplatePathPage extends StatefulWidget {
  const TemplatePathPage({super.key});

  @override
  State<TemplatePathPage> createState() => _TemplatePathPageState();
}

class _TemplatePathPageState extends State<TemplatePathPage> {
  TemplateType selected = TemplateType.exam;

  final List<Map<String, dynamic>> templates = [
    {
      "name": "Lộ trình Ôn thi THPTQG",
      "type": TemplateType.exam,
      "desc": "Tập trung Toán - Văn - Anh, chia theo tuần",
      "grade": "12",
      "duration": "8 tuần",
    },
    {
      "name": "Lộ trình Ôn thi Học kỳ",
      "type": TemplateType.exam,
      "desc": "Ôn tập theo chương + đề kiểm tra",
      "grade": "11",
      "duration": "4 tuần",
    },
    {
      "name": "Lộ trình Học hằng ngày (chuẩn)",
      "type": TemplateType.daily,
      "desc": "Mỗi ngày 2-3 môn, tối ưu thời gian",
      "grade": "10-12",
      "duration": "30 ngày",
    },
    {
      "name": "Lộ trình Học hằng ngày (nhẹ)",
      "type": TemplateType.daily,
      "desc": "Phù hợp học sinh trung bình - khá",
      "grade": "10-11",
      "duration": "21 ngày",
    },
    {
      "name": "Lộ trình Học thêm buổi tối",
      "type": TemplateType.extra,
      "desc": "Dành cho học thêm: Toán/Lý/Hóa",
      "grade": "11-12",
      "duration": "6 tuần",
    },
  ];

  void _go(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  void _add() {
    _go(const TemplatePathFormPage(title: "Thêm lộ trình mẫu"));
  }

  void _edit(Map<String, dynamic> item) {
    _go(
      TemplatePathFormPage(
        title: "Chỉnh sửa lộ trình mẫu",
        initName: item["name"],
        initGrade: item["grade"],
        initDuration: item["duration"],
        initDesc: item["desc"],
      ),
    );
  }

  void _delete(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Xóa lộ trình mẫu"),
        content: Text("Bạn có chắc muốn xóa \"${item["name"]}\" không?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Hủy"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() => templates.remove(item));
              Navigator.pop(context);
            },
            child: const Text("Xóa"),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> get filtered =>
      templates.where((e) => e["type"] == selected).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f6fb),
      appBar: AppBar(
        title: const Text("Bộ lộ trình mẫu"),
        backgroundColor: Colors.indigo,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        onPressed: _add,
        child: const Icon(Icons.add),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _FilterChips(
            selected: selected,
            onChanged: (v) => setState(() => selected = v),
          ),
          const SizedBox(height: 14),

          // ===== SUMMARY MINI =====
          _SummaryRow(
            left: "Tổng: ${filtered.length}",
            right: _label(selected),
          ),
          const SizedBox(height: 14),

          // ===== LIST =====
          ...filtered.map(
            (item) => _TemplateCard(
              name: item["name"],
              desc: item["desc"],
              grade: item["grade"],
              duration: item["duration"],
              tag: _label(item["type"]),
              onTap: () => _go(
                TemplatePathDetailPage(
                  name: item["name"],
                  grade: item["grade"],
                  duration: item["duration"],
                  desc: item["desc"],
                ),
              ),
              onEdit: () => _edit(item),
              onDelete: () => _delete(item),
            ),
          ),
        ],
      ),
    );
  }

  String _label(TemplateType t) {
    switch (t) {
      case TemplateType.exam:
        return "Ôn thi";
      case TemplateType.daily:
        return "Hằng ngày";
      case TemplateType.extra:
        return "Học thêm";
    }
  }
}

class _FilterChips extends StatelessWidget {
  final TemplateType selected;
  final ValueChanged<TemplateType> onChanged;

  const _FilterChips({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _chip(
          text: "Ôn thi",
          active: selected == TemplateType.exam,
          onTap: () => onChanged(TemplateType.exam),
        ),
        const SizedBox(width: 10),
        _chip(
          text: "Hằng ngày",
          active: selected == TemplateType.daily,
          onTap: () => onChanged(TemplateType.daily),
        ),
        const SizedBox(width: 10),
        _chip(
          text: "Học thêm",
          active: selected == TemplateType.extra,
          onTap: () => onChanged(TemplateType.extra),
        ),
      ],
    );
  }

  Widget _chip({
    required String text,
    required bool active,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active ? Colors.indigo : Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              if (active)
                BoxShadow(
                  color: Colors.indigo.withOpacity(0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 6),
                ),
            ],
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: active ? Colors.white : Colors.grey.shade800,
            ),
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String left;
  final String right;

  const _SummaryRow({required this.left, required this.right});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _miniCard(Icons.list_alt, left)),
        const SizedBox(width: 12),
        Expanded(child: _miniCard(Icons.category, right)),
      ],
    );
  }

  Widget _miniCard(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.indigo),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _TemplateCard extends StatelessWidget {
  final String name;
  final String desc;
  final String grade;
  final String duration;
  final String tag;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _TemplateCard({
    required this.name,
    required this.desc,
    required this.grade,
    required this.duration,
    required this.tag,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: Colors.indigo.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.layers, color: Colors.indigo),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    desc,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _pill("Khối $grade"),
                      _pill(duration),
                      _pill(tag),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.orange),
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _pill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xfff4f6fb),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }
}
