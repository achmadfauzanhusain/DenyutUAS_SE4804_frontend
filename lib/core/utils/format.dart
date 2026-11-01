const _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
  'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
];

String _two(int n) => n.toString().padLeft(2, '0');

String formatDate(DateTime d) => '${d.day} ${_months[d.month - 1]} ${d.year}';

String formatDateTime(DateTime d) =>
    '${formatDate(d)}, ${_two(d.hour)}.${_two(d.minute)}';

String formatRemaining(DateTime deadline) {
  final diff = deadline.difference(DateTime.now());
  if (diff.isNegative) return 'Lewat batas waktu';
  if (diff.inHours >= 24) return '${diff.inDays} hari lagi';
  if (diff.inHours >= 1) return '${diff.inHours} jam lagi';
  return '${diff.inMinutes} menit lagi';
}

String formatAgo(DateTime t) {
  final d = DateTime.now().difference(t);
  if (d.inHours >= 24) return '${d.inDays} hari lalu';
  if (d.inHours >= 1) return '${d.inHours} jam lalu';
  return '${d.inMinutes} menit lalu';
}
