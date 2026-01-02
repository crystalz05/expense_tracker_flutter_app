String formatDate(DateTime date) {
  final now = DateTime.now();
  final difference = now.difference(date);
  if (difference.inDays == 0) {
    return "Today";
  } else if (difference.inDays == 1) {
    return "Yesterday";
  } else if (difference.inDays < 7) {
    return "${difference.inDays}d ago";
  } else {
    return "${date.day}/${date.month}/${date.year}";
  }
}


DateTime month = DateTime.now();

DateTime firstDay = DateTime(month.year, month.month, 1);
DateTime lastDay = DateTime(month.year, month.month + 1, 0, 23, 59, 59);