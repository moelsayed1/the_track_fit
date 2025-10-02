import 'package:the_track_fit/core/constants/app_constants.dart';

class Package {
  final int id;
  final String enName;
  final String arName;
  final String enDescription;
  final String arDescription;
  final String price;
  final int durationDays;
  final int isActive;
  final String image;
  final String createdAt;
  final String updatedAt;
  final int subscriptionsCount;
  final bool mostPopular;

  Package({
    required this.id,
    required this.enName,
    required this.arName,
    required this.enDescription,
    required this.arDescription,
    required this.price,
    required this.durationDays,
    required this.isActive,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
    required this.subscriptionsCount,
    required this.mostPopular,
  });

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      id: json['id'] ?? 0,
      enName: json['en_name'] ?? '',
      arName: json['ar_name'] ?? '',
      enDescription: json['en_description'] ?? '',
      arDescription: json['ar_description'] ?? '',
      price: json['price'] ?? '0.00',
      durationDays: json['duration_days'] ?? 0,
      isActive: json['is_active'] ?? 0,
      image: json['image'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      subscriptionsCount: json['subscriptions_count'] ?? 0,
      mostPopular: json['most_popular'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'en_name': enName,
      'ar_name': arName,
      'en_description': enDescription,
      'ar_description': arDescription,
      'price': price,
      'duration_days': durationDays,
      'is_active': isActive,
      'image': image,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'subscriptions_count': subscriptionsCount,
      'most_popular': mostPopular,
    };
  }

  String get fullImageUrl {
    return '${AppConstants.baseUrl}/storage/$image';
  }

  /// Parse HTML description to extract features list
  List<String> get features {
    List<String> processedFeatures = [];

    // Use regex to find all <li>...</li> patterns
    RegExp exp = RegExp(r'<li>(.*?)</li>');
    Iterable<RegExpMatch> matches = exp.allMatches(enDescription);

    for (final m in matches) {
      String featureText = m.group(1)?.trim() ?? '';
      if (featureText.isEmpty) continue;

      // Clean up HTML entities and tags
      featureText = featureText
          .replaceAll(
            RegExp(r'<[^>]*>'),
            '',
          ) // Remove all HTML tags including <strong>
          .replaceAll('&nbsp;', ' ')
          .replaceAll('&amp;', '&')
          .replaceAll('&lt;', '<')
          .replaceAll('&gt;', '>')
          .replaceAll('&quot;', '"')
          .replaceAll('&#39;', "'")
          .replaceAll(RegExp(r'\s+'), ' ')
          .trim();

      // Check for "every month" and split if found
      if (featureText.contains('every month')) {
        int index = featureText.indexOf('every month');
        String part1 = featureText
            .substring(0, index + 'every month'.length)
            .trim();
        String part2 = featureText
            .substring(index + 'every month'.length)
            .trim();

        if (part1.isNotEmpty) {
          processedFeatures.add(part1);
        }
        if (part2.isNotEmpty) {
          processedFeatures.add(part2);
        }
      } else {
        processedFeatures.add(featureText);
      }
    }

    return processedFeatures;
  }

  /// Parse Arabic HTML description to extract features list
  List<String> get arFeatures {
    List<String> processedFeatures = [];

    // Use regex to find all <li>...</li> patterns
    RegExp exp = RegExp(r'<li>(.*?)</li>');
    Iterable<RegExpMatch> matches = exp.allMatches(arDescription);

    for (final m in matches) {
      String featureText = m.group(1)?.trim() ?? '';
      if (featureText.isEmpty) continue;

      // Clean up HTML entities and tags
      featureText = featureText
          .replaceAll(
            RegExp(r'<[^>]*>'),
            '',
          ) // Remove all HTML tags including <strong>
          .replaceAll('&nbsp;', ' ')
          .replaceAll('&amp;', '&')
          .replaceAll('&lt;', '<')
          .replaceAll('&gt;', '>')
          .replaceAll('&quot;', '"')
          .replaceAll('&#39;', "'")
          .replaceAll(RegExp(r'\s+'), ' ')
          .trim();

      // Check for "كل شهر" and split if found
      if (featureText.contains('كل شهر')) {
        int index = featureText.indexOf('كل شهر');
        String part1 = featureText.substring(0, index + 'كل شهر'.length).trim();
        String part2 = featureText.substring(index + 'كل شهر'.length).trim();

        if (part1.isNotEmpty) {
          processedFeatures.add(part1);
        }
        if (part2.isNotEmpty) {
          processedFeatures.add(part2);
        }
      } else {
        processedFeatures.add(featureText);
      }
    }

    return processedFeatures;
  }

  /// Get formatted price with currency
  String get formattedPrice {
    final priceValue = double.tryParse(price) ?? 0.0;
    return '${priceValue.toStringAsFixed(0)} EGP';
  }

  /// Get duration in months
  String get durationInMonths {
    final months = (durationDays / 30).round();
    return months > 1 ? '$months months' : '$months month';
  }
}
