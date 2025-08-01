// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:hamro_grocery_mobile/feature/category/presentation/view_model/category_state.dart';
// import 'package:hamro_grocery_mobile/feature/category/presentation/view_model/category_view_model.dart';
// import 'package:hamro_grocery_mobile/feature/product/presentation/view/product_card.dart';

// import 'package:hamro_grocery_mobile/feature/product/presentation/view_model/product_event.dart';
// import 'package:hamro_grocery_mobile/feature/product/presentation/view_model/product_state.dart';
// import 'package:hamro_grocery_mobile/feature/product/presentation/view_model/product_view_model.dart';
// import 'package:hamro_grocery_mobile/feature/category/presentation/view/category_card.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   @override
//   void initState() {
//     super.initState();
//     context.read<ProductViewModel>().add(LoadProductsEvent());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildSearchBar(),
//           _buildSectionHeader('Shop By Category', onTap: () {}),
//           BlocBuilder<CategoryViewModel, CategoryState>(
//             builder: (context, state) {
//               if (state.isLoading) {
//                 return const SizedBox(
//                   height: 130,
//                   child: Center(child: CircularProgressIndicator()),
//                 );
//               }
//               if (state.errorMessage != null) {
//                 return SizedBox(
//                   height: 130,
//                   child: Center(child: Text(state.errorMessage!)),
//                 );
//               }

//               return SizedBox(
//                 height: 130,
//                 // Use ListView.builder for a dynamic list
//                 child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: state.categories.length,
//                   itemBuilder: (context, index) {
//                     final category = state.categories[index];
//                     // Use our helper to get the correct image asset

//                     return CategoryCard(category: category);
//                   },
//                 ),
//               );
//             },
//           ),

//           const SizedBox(height: 24.0),

//           // Latest Added (This section is now DYNAMIC)
//           _buildSectionHeader('Latest added', onTap: () {}),

//           BlocBuilder<ProductViewModel, ProductState>(
//             builder: (context, state) {
//               if (state.isLoading && state.products.isEmpty) {
//                 return const SizedBox(
//                   height: 340,
//                   child: Center(child: CircularProgressIndicator()),
//                 );
//               }

//               if (state.errorMessage != null) {
//                 return SizedBox(
//                   height: 340,
//                   child: Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(state.errorMessage!),
//                         const SizedBox(height: 10),
//                         ElevatedButton(
//                           onPressed:
//                               () => context.read<ProductViewModel>().add(
//                                 LoadProductsEvent(),
//                               ),
//                           child: const Text('Retry'),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               }

//               if (state.products.isEmpty) {
//                 return const SizedBox(
//                   height: 340,
//                   child: Center(
//                     child: Text('No products available right now.'),
//                   ),
//                 );
//               }
//               return SizedBox(
//                 height: 340,
//                 child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: state.products.length,
//                   itemBuilder: (context, index) {
//                     final product = state.products[index];
//                     return ProductCard(product: product);
//                   },
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSearchBar() {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 24.0),
//       decoration: BoxDecoration(
//         color: Colors.grey[100],
//         borderRadius: BorderRadius.circular(30),
//         border: Border.all(color: Colors.grey[200]!),
//       ),
//       child: const TextField(
//         decoration: InputDecoration(
//           hintText: 'Search for groceries...',
//           hintStyle: TextStyle(color: Colors.grey),
//           prefixIcon: Icon(Icons.search, color: Colors.grey),
//           border: InputBorder.none,
//           contentPadding: EdgeInsets.symmetric(
//             vertical: 16.0,
//             horizontal: 10.0,
//           ),
//         ),
//         style: TextStyle(color: Colors.black87),
//       ),
//     );
//   }

//   Widget _buildSectionHeader(String title, {required VoidCallback onTap}) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             title,
//             style: const TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Colors.black87,
//             ),
//           ),
//           TextButton(
//             onPressed: onTap,
//             child: const Text(
//               'View all',
//               style: TextStyle(
//                 color: Colors.green,
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hamro_grocery_mobile/feature/auth/presentation/view_model/profile_view_model/profile_event.dart';
import 'package:hamro_grocery_mobile/feature/auth/presentation/view_model/profile_view_model/profile_view_model.dart';
import 'package:hamro_grocery_mobile/feature/category/presentation/view/category_card.dart';
import 'package:hamro_grocery_mobile/feature/category/presentation/view_model/category_event.dart';
import 'package:hamro_grocery_mobile/feature/category/presentation/view_model/category_state.dart';
import 'package:hamro_grocery_mobile/feature/category/presentation/view_model/category_view_model.dart';
import 'package:hamro_grocery_mobile/feature/product/presentation/view/product_card.dart';
import 'package:hamro_grocery_mobile/feature/product/presentation/view_model/product_event.dart';
import 'package:hamro_grocery_mobile/feature/product/presentation/view_model/product_state.dart';
import 'package:hamro_grocery_mobile/feature/product/presentation/view_model/product_view_model.dart';
import 'welcome_banner.dart'; // Import your welcome banner

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _navigateToSearch(BuildContext context) {}

  @override
  void initState() {
    super.initState();
    // Load user profile when home screen initializes
    // This ensures the welcome banner has user data
    context.read<ProfileViewModel>().add(LoadProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // --- NEW APP BAR ---
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: GestureDetector(
          onTap: () => _navigateToSearch(context),
          child: Container(
            height: 45,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: const AbsorbPointer(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search for products...',
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 12.0, // Adjust vertical padding
                    horizontal: 10.0,
                  ),
                ),
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_none_outlined,
              color: Colors.black54,
            ),
            onPressed: () {
              // TODO: Implement notifications
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Manually trigger a refresh for both categories and all products
          context.read<CategoryViewModel>().add(LoadCategoriesEvent());
          context.read<ProductViewModel>().add(const LoadProductsEvent());
          // Also refresh user profile data
          context.read<ProfileViewModel>().add(LoadProfileEvent());
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Banner - positioned right below the app bar
              const WelcomeBanner(),

              // Existing sections
              _buildCategorySection(),
              _buildProductSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Shop By Category'),
        BlocBuilder<CategoryViewModel, CategoryState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const SizedBox(
                height: 50,
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (state.errorMessage != null) {
              return SizedBox(
                height: 50,
                child: Center(child: Text(state.errorMessage!)),
              );
            }
            return SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: state.categories.length + 1, // +1 for "All"
                itemBuilder: (context, index) {
                  // --- "ALL" BUTTON LOGIC ---
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: CategoryCard(
                        name: 'All',
                        isSelected: state.selectedCategoryId == null,
                        onTap: () {
                          // Update category UI
                          context.read<CategoryViewModel>().add(
                            const SelectCategoryEvent(null),
                          );
                          // Fetch all products from server
                          context.read<ProductViewModel>().add(
                            const LoadProductsEvent(),
                          );
                        },
                      ),
                    );
                  }

                  // --- SPECIFIC CATEGORY BUTTON LOGIC ---
                  final category = state.categories[index - 1];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: CategoryCard(
                      name: category.name,
                      isSelected:
                          state.selectedCategoryId == category.categoryId,
                      onTap: () {
                        // Update category UI
                        context.read<CategoryViewModel>().add(
                          SelectCategoryEvent(category.categoryId),
                        );
                        // Fetch products for this category from server
                        context.read<ProductViewModel>().add(
                          LoadProductsEvent(categoryName: category.name),
                        );
                      },
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildProductSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Latest Products'),
        BlocBuilder<ProductViewModel, ProductState>(
          builder: (context, state) {
            if (state.isLoading && state.products.isEmpty) {
              return const SizedBox(
                height: 260,
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (state.errorMessage != null && state.products.isEmpty) {
              return SizedBox(
                height: 260,
                child: Center(child: Text(state.errorMessage!)),
              );
            }
            if (state.products.isEmpty && !state.isLoading) {
              return const SizedBox(
                height: 260,
                child: Center(
                  child: Text('No products found in this category.'),
                ),
              );
            }
            return SizedBox(
              height: 260,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: state.products.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ProductCard(product: state.products[index]),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}
