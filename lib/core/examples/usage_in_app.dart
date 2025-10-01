import 'dart:developer';

import 'package:flutter/material.dart';

import '../helpers/api_response_helper.dart';
import '../services/language_service.dart';

/// مثال لكيفية استخدام الترجمة في التطبيق الحقيقي
class UsageInApp {
  
  /// مثال لاستخدام البيانات في شاشة التمارين
  static Future<List<Map<String, dynamic>>> getExercisesForWorkoutScreen() async {
    try {
      // استدعاء API الحقيقي
      // final response = await ApiService().get('/api/get-all-exercises');
      
      // محاكاة البيانات الحقيقية من API
      final apiResponse = {
        'status': 'success',
        'data': [
          {
            'id': 1,
            'ar_name': '1 تمرين',
            'ar_description': null,
            'en_name': 'Exercise 1',
            'en_description': null,
            'gif': 'exercises/gifs/01K1QR7EHW7CNB6KG3PVPEEGV9.gif',
            'gender': 'male',
            'goal': 'General Fitness'
          },
          {
            'id': 3,
            'ar_name': '3 تمرين',
            'ar_description': null,
            'en_name': 'Exercise 3',
            'en_description': null,
            'gif': 'exercises/gifs/01K1QR8WMRXHF0386JWAZKZX6T.gif',
            'gender': 'both',
            'goal': 'Weight Loss'
          }
        ]
      };

      // معالجة البيانات مع الترجمة التلقائية
      final processedResponse = await ApiResponseHelper.processApiResponse(
        apiResponse,
        specificFields: ['name', 'description', 'goal'],
      );

      return processedResponse['data'] ?? [];
    } catch (e) {
      log('خطأ في جلب التمارين: $e');
      return [];
    }
  }

  /// مثال لاستخدام البيانات في شاشة المنتجات
  static Future<List<Map<String, dynamic>>> getProductsForHomeScreen() async {
    try {
      // محاكاة بيانات المنتجات
      final apiResponse = {
        'status': 'success',
        'data': [
          {
            'id': 1,
            'ar_name': 'منتج 1',
            'ar_description': null,
            'en_name': 'Product 1',
            'en_description': null,
            'price': 700.00,
            'image_url': 'product1.jpg'
          },
          {
            'id': 2,
            'ar_name': 'منتج 2',
            'ar_description': null,
            'en_name': 'Product 2',
            'en_description': null,
            'price': 1200.00,
            'image_url': 'product2.jpg'
          }
        ]
      };

      // معالجة البيانات مع الترجمة التلقائية
      final processedResponse = await ApiResponseHelper.processApiResponse(
        apiResponse,
        specificFields: ['name', 'description'],
      );

      return processedResponse['data'] ?? [];
    } catch (e) {
      log('خطأ في جلب المنتجات: $e');
      return [];
    }
  }

  /// مثال لاستخدام البيانات في شاشة الأهداف
  static Future<List<Map<String, dynamic>>> getGoalsForProfileScreen() async {
    try {
      // محاكاة بيانات الأهداف
      final apiResponse = {
        'status': 'success',
        'data': [
          {
            'id': 1,
            'ar_name': 'اللياقة العامة',
            'ar_description': null,
            'en_name': 'General Fitness',
            'en_description': null,
          },
          {
            'id': 2,
            'ar_name': 'فقدان الوزن',
            'ar_description': null,
            'en_name': 'Weight Loss',
            'en_description': null,
          }
        ]
      };

      // معالجة البيانات مع الترجمة التلقائية
      final processedResponse = await ApiResponseHelper.processApiResponse(
        apiResponse,
        specificFields: ['name', 'description'],
      );

      return processedResponse['data'] ?? [];
    } catch (e) {
      log('خطأ في جلب الأهداف: $e');
      return [];
    }
  }
}

/// مثال لكيفية استخدام البيانات في واجهة المستخدم
class UIUsageExample {
  
  /// مثال لاستخدام البيانات في قائمة التمارين
  static Widget buildExerciseList() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: UsageInApp.getExercisesForWorkoutScreen(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        
        if (snapshot.hasError) {
          return Text('خطأ في تحميل البيانات');
        }
        
        final exercises = snapshot.data ?? [];
        
        return ListView.builder(
          itemCount: exercises.length,
          itemBuilder: (context, index) {
            final exercise = exercises[index];
            return ListTile(
              title: Text(exercise['name']), // سيكون مترجم تلقائياً
              subtitle: Text(exercise['goal'] ?? ''), // سيكون مترجم تلقائياً
              leading: Image.network(exercise['gif']),
            );
          },
        );
      },
    );
  }

  /// مثال لاستخدام البيانات في قائمة المنتجات
  static Widget buildProductList() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: UsageInApp.getProductsForHomeScreen(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        
        if (snapshot.hasError) {
          return Text('خطأ في تحميل البيانات');
        }
        
        final products = snapshot.data ?? [];
        
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.8,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return Card(
              child: Column(
                children: [
                  Image.network(product['image_url']),
                  Text(product['name']), // سيكون مترجم تلقائياً
                  Text('\$${product['price']}'),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
