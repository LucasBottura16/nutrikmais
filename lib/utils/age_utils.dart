class AgeUtils {
  static int? calculateAgeFromBirthDate(String birthDateText) {
    final parts = birthDateText.trim().split('/');
    if (parts.length != 3) return null;

    final int? day = int.tryParse(parts[0]);
    final int? month = int.tryParse(parts[1]);
    final int? year = int.tryParse(parts[2]);
    if (day == null || month == null || year == null) return null;

    final now = DateTime.now();
    if (year < 1900 || year > now.year) return null;

    DateTime birthDate;
    try {
      birthDate = DateTime(year, month, day);
    } catch (_) {
      return null;
    }

    if (birthDate.year != year ||
        birthDate.month != month ||
        birthDate.day != day) {
      return null;
    }

    int age = now.year - birthDate.year;
    final hasHadBirthdayThisYear =
        (now.month > birthDate.month) ||
        (now.month == birthDate.month && now.day >= birthDate.day);
    if (!hasHadBirthdayThisYear) {
      age -= 1;
    }

    return age;
  }
}
