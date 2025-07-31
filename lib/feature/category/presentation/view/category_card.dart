// // feature/category/presentation/widget/category_card.dart

// import 'package:flutter/material.dart';
// import 'package:hamro_grocery_mobile/feature/category/domain/entity/category_entity.dart'; // 2. Import the entity

// class CategoryCard extends StatelessWidget {
//   final CategoryEntity category;

//   const CategoryCard({super.key, required this.category});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 120,
//       margin: const EdgeInsets.symmetric(horizontal: 8.0),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 3,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const SizedBox(height: 8),
//           Text(
//             category.name, // 5. Use the name from the entity
//             textAlign: TextAlign.center,
//             maxLines: 2, // Allow for longer names
//             overflow: TextOverflow.ellipsis,
//             style: const TextStyle(
//               fontSize: 13,
//               fontWeight: FontWeight.w500,
//               color: Colors.black87,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String name;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.name,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey.shade300,
          ),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.2),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ]
                  : [],
        ),
        child: Center(
          child: Text(
            name,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
