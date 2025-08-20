import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.onFavoriteToggle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
                 padding: EdgeInsets.all(16.w),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              width: 1,
              strokeAlign: BorderSide.strokeAlignOutside,
              color: Color(0xFF28A228),
            ),
                         borderRadius: BorderRadius.circular(15.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left side - Product image and details
            Row(
              children: [
                // Product Image - 54x64 as per Figma
                Container(
                  width: 54.w,
                  height: 64.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: AssetImage(product.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                
                                 SizedBox(width: 8.w),
                
                                 // Product Information - 115 width as per Figma
                                   SizedBox(
                    width: 115.w,
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       // Product Name
                       SizedBox(
                         width: 115.w,
                         child: Text(
                           product.name,
                           style: TextStyle(
                             color: const Color(0xFF1E1E1E),
                             fontSize: 16.sp,
                             fontFamily: 'Poppins',
                             fontWeight: FontWeight.w500,
                           ),
                           maxLines: 1,
                           overflow: TextOverflow.ellipsis,
                         ),
                       ),
                       
                        SizedBox(height: 8.h),
                       
                       // Price
                       SizedBox(
                         width: 115.w,
                         child: Text(
                           '\$${product.price.toStringAsFixed(2)}',
                           style: TextStyle(
                             color: Color(0xFF28A228),
                             fontSize: 16.sp,
                             fontFamily: 'Poppins',
                             fontWeight: FontWeight.w500,
                           ),
                         ),
                       ),
                     ],
                   ),
                 ),
              ],
            ),
            
            // Right side - Favorite icon
            GestureDetector(
              onTap: onFavoriteToggle,
              child: SizedBox(
                width: 24.w,
                height: 24.h,
                                         child: Icon(
                   product.isFavorite
                       ? Icons.favorite
                       : Icons.favorite_border,
                   color: product.isFavorite
                       ? const Color(0xFF28A228)
                       : const Color(0xFF1E1E1E),
                   size: 24.sp,
                 ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
