import 'product.dart';

class ProductResponse {
  final List<Product> products;
  final PaginationInfo pagination;
  final int status;
  final String message;

  ProductResponse({
    required this.products,
    required this.pagination,
    required this.status,
    required this.message,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    final productsList = data['products'] as List<dynamic>;
    final paginationData = data['pagination'] as Map<String, dynamic>;

    return ProductResponse(
      products: productsList
          .map((productJson) => Product.fromJson(productJson as Map<String, dynamic>))
          .toList(),
      pagination: PaginationInfo.fromJson(paginationData),
      status: json['status'] as int,
      message: json['message'] as String,
    );
  }
}

class PaginationInfo {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
  final PaginationLinks links;

  PaginationInfo({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
    required this.links,
  });

  factory PaginationInfo.fromJson(Map<String, dynamic> json) {
    return PaginationInfo(
      currentPage: json['current_page'] as int,
      lastPage: json['last_page'] as int,
      perPage: json['per_page'] as int,
      total: json['total'] as int,
      links: PaginationLinks.fromJson(json['links'] as Map<String, dynamic>),
    );
  }
}

class PaginationLinks {
  final String? next;
  final String? prev;

  PaginationLinks({
    this.next,
    this.prev,
  });

  factory PaginationLinks.fromJson(Map<String, dynamic> json) {
    return PaginationLinks(
      next: json['next'] as String?,
      prev: json['prev'] as String?,
    );
  }
}
