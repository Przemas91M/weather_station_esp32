extension StringExtension on String {
  String capitalize() {
    return split(' ').map((word) {
      return '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
    }).join(' ');
  }
}
