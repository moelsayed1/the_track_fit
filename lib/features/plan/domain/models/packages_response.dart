import 'package.dart';

class PackagesResponse {
  final PackagesData data;
  final int status;
  final String message;

  PackagesResponse({
    required this.data,
    required this.status,
    required this.message,
  });

  factory PackagesResponse.fromJson(Map<String, dynamic> json) {
    return PackagesResponse(
      data: PackagesData.fromJson(json['data'] ?? {}),
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.toJson(),
      'status': status,
      'message': message,
    };
  }
}

class PackagesData {
  final int currentPage;
  final List<Package> packages;
  final String firstPageUrl;
  final int from;
  final int lastPage;
  final String lastPageUrl;
  final List<PageLink> links;
  final String? nextPageUrl;
  final String path;
  final int perPage;
  final String? prevPageUrl;
  final int to;
  final int total;

  PackagesData({
    required this.currentPage,
    required this.packages,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    this.nextPageUrl,
    required this.path,
    required this.perPage,
    this.prevPageUrl,
    required this.to,
    required this.total,
  });

  factory PackagesData.fromJson(Map<String, dynamic> json) {
    return PackagesData(
      currentPage: json['current_page'] ?? 1,
      packages: (json['data'] as List<dynamic>?)
          ?.map((package) => Package.fromJson(package))
          .toList() ?? [],
      firstPageUrl: json['first_page_url'] ?? '',
      from: json['from'] ?? 0,
      lastPage: json['last_page'] ?? 1,
      lastPageUrl: json['last_page_url'] ?? '',
      links: (json['links'] as List<dynamic>?)
          ?.map((link) => PageLink.fromJson(link))
          .toList() ?? [],
      nextPageUrl: json['next_page_url'],
      path: json['path'] ?? '',
      perPage: json['per_page'] ?? 10,
      prevPageUrl: json['prev_page_url'],
      to: json['to'] ?? 0,
      total: json['total'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'data': packages.map((package) => package.toJson()).toList(),
      'first_page_url': firstPageUrl,
      'from': from,
      'last_page': lastPage,
      'last_page_url': lastPageUrl,
      'links': links.map((link) => link.toJson()).toList(),
      'next_page_url': nextPageUrl,
      'path': path,
      'per_page': perPage,
      'prev_page_url': prevPageUrl,
      'to': to,
      'total': total,
    };
  }
}

class PageLink {
  final String? url;
  final String label;
  final bool active;

  PageLink({
    this.url,
    required this.label,
    required this.active,
  });

  factory PageLink.fromJson(Map<String, dynamic> json) {
    return PageLink(
      url: json['url'],
      label: json['label'] ?? '',
      active: json['active'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'label': label,
      'active': active,
    };
  }
}
