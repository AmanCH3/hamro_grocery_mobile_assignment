// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:hamro_grocery_mobile/feature/category/presentation/view/category_card.dart';
// import 'package:hamro_grocery_mobile/feature/category/presentation/view_model/category_event.dart';
// import 'package:hamro_grocery_mobile/feature/category/presentation/view_model/category_state.dart';
// import 'package:hamro_grocery_mobile/feature/category/presentation/view_model/category_view_model.dart';
// import 'package:hamro_grocery_mobile/feature/favorite/view/favorite_screen.dart';
// import 'package:hamro_grocery_mobile/feature/product/presentation/view/product_card.dart';
// import 'package:hamro_grocery_mobile/feature/product/presentation/view_model/product_event.dart';
// import 'package:hamro_grocery_mobile/feature/product/presentation/view_model/product_state.dart';
// import 'package:hamro_grocery_mobile/feature/product/presentation/view_model/product_view_model.dart';

// class ProductListScreen extends StatefulWidget {
//   const ProductListScreen({super.key});

//   @override
//   State<ProductListScreen> createState() => _ProductListScreenState();
// }

// class _ProductListScreenState extends State<ProductListScreen>
//     with TickerProviderStateMixin {
//   late AnimationController _animationController;
//   late AnimationController _headerAnimationController;
//   final ScrollController _scrollController = ScrollController();
//   bool _showScrollToTop = false;

//   @override
//   void initState() {
//     super.initState();
//     // Animation setup...
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );
//     _headerAnimationController = AnimationController(
//       duration: const Duration(milliseconds: 600),
//       vsync: this,
//     );

//     _scrollController.addListener(() {
//       if (_scrollController.offset > 300 && !_showScrollToTop) {
//         setState(() => _showScrollToTop = true);
//       } else if (_scrollController.offset <= 300 && _showScrollToTop) {
//         setState(() => _showScrollToTop = false);
//       }
//     });

//     _headerAnimationController.forward();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     _headerAnimationController.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8FFFE),
//       body: CustomScrollView(
//         controller: _scrollController,
//         slivers: [
//           _buildSliverAppBar(),
//           _buildCategorySelector(),
//           SliverToBoxAdapter(
//             child: BlocListener<ProductViewModel, ProductState>(
//               listener: (context, state) {
//                 if (!state.isLoading) {
//                   _animationController.forward(from: 0.0);
//                 }
//               },
//               child: BlocBuilder<ProductViewModel, ProductState>(
//                 builder: (context, state) {
//                   if (state.isLoading && state.products.isEmpty) {
//                     return _buildLoadingView();
//                   }
//                   if (state.errorMessage != null && state.products.isEmpty) {
//                     return _buildErrorView(state.errorMessage!);
//                   }
//                   if (state.products.isEmpty && !state.isLoading) {
//                     return _buildEmptyOrNoResultsView(context);
//                   }
//                   return _buildProductGrid(state);
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: _buildFloatingActionButton(),
//     );
//   }

//   Widget _buildCategorySelector() {
//     return SliverToBoxAdapter(
//       child: BlocBuilder<CategoryViewModel, CategoryState>(
//         builder: (context, categoryState) {
//           if (categoryState.isLoading) {
//             return const SizedBox(
//               height: 60,
//               child: Center(child: CircularProgressIndicator()),
//             );
//           }
//           if (categoryState.categories.isEmpty) return const SizedBox.shrink();

//           return Container(
//             height: 60,
//             padding: const EdgeInsets.symmetric(vertical: 8),
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               itemCount: categoryState.categories.length + 1,
//               itemBuilder: (context, index) {
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 4.0),
//                   child: _buildCategoryItem(context, categoryState, index),
//                 );
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildCategoryItem(
//     BuildContext context,
//     CategoryState categoryState,
//     int index,
//   ) {
//     if (index == 0) {
//       return CategoryCard(
//         name: "All",
//         isSelected: categoryState.selectedCategoryId == null,
//         onTap: () {
//           context.read<CategoryViewModel>().add(
//             const SelectCategoryEvent(null),
//           );
//           context.read<ProductViewModel>().add(const LoadProductsEvent());
//         },
//       );
//     }
//     final category = categoryState.categories[index - 1];
//     return CategoryCard(
//       name: category.name,
//       isSelected: categoryState.selectedCategoryId == category.categoryId,
//       onTap: () {
//         context.read<CategoryViewModel>().add(
//           SelectCategoryEvent(category.categoryId),
//         );
//         context.read<ProductViewModel>().add(
//           LoadProductsEvent(categoryName: category.name),
//         );
//       },
//     );
//   }

//   Widget _buildProductGrid(ProductState state) {
//     return Column(
//       children: [
//         Container(
//           margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
//           padding: const EdgeInsets.all(20),
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Colors.white, Colors.green.shade50],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.green.withOpacity(0.1),
//                 blurRadius: 15,
//                 offset: const Offset(0, 5),
//               ),
//             ],
//           ),
//           child: Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: Colors.green,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: const Icon(
//                   Icons.inventory_2_outlined,
//                   color: Colors.white,
//                   size: 24,
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       '${state.products.length} Products Found',
//                       style: const TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black87,
//                       ),
//                     ),
//                     Text(
//                       'Available in this selection',
//                       style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//                     ),
//                   ],
//                 ),
//               ),
//               if (state.isLoading)
//                 const SizedBox(
//                   width: 24,
//                   height: 24,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2.5,
//                     valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(20),
//           child: AnimatedBuilder(
//             animation: _animationController,
//             builder: (context, child) {
//               final selectedCategoryId =
//                   context.read<CategoryViewModel>().state.selectedCategoryId;
//               return GridView.builder(
//                 key: ValueKey(selectedCategoryId),
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   crossAxisSpacing: 15,
//                   mainAxisSpacing: 15,
//                   childAspectRatio: 0.65,
//                 ),
//                 itemCount: state.products.length,
//                 itemBuilder: (context, index) {
//                   final product = state.products[index];
//                   final delay = (index * 0.05).clamp(0.0, 1.0);
//                   final animationValue = Curves.easeOut.transform(
//                     (_animationController.value - delay).clamp(0.0, 1.0),
//                   );
//                   return Transform.translate(
//                     offset: Offset(0, 50 * (1 - animationValue)),
//                     child: Opacity(
//                       opacity: animationValue,
//                       child: ProductCard(product: product),
//                     ),
//                   );
//                 },
//               );
//             },
//           ),
//         ),
//         const SizedBox(height: 100),
//       ],
//     );
//   }

//   Widget _buildEmptyOrNoResultsView(BuildContext context) {
//     final isFiltered =
//         context.read<CategoryViewModel>().state.selectedCategoryId != null;
//     final icon =
//         isFiltered ? Icons.search_off_rounded : Icons.shopping_basket_outlined;
//     final title = isFiltered ? 'No Products Found' : 'No Products Available';
//     final message =
//         isFiltered
//             ? 'There are no products available in this category.'
//             : 'We\'re currently updating our inventory.\nPlease check back soon!';

//     return Container(
//       height: MediaQuery.of(context).size.height * 0.5,
//       padding: const EdgeInsets.all(24),
//       alignment: Alignment.center,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(icon, size: 60, color: Colors.grey[400]),
//           const SizedBox(height: 24),
//           Text(
//             title,
//             style: const TextStyle(
//               fontSize: 22,
//               fontWeight: FontWeight.bold,
//               color: Colors.black87,
//             ),
//           ),
//           const SizedBox(height: 12),
//           Text(
//             message,
//             style: TextStyle(
//               fontSize: 14,
//               color: Colors.grey[600],
//               height: 1.5,
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }

//   // --- UNCHANGED WIDGETS BELOW (SliverAppBar, LoadingView, ErrorView, etc.) ---
//   Widget _buildSliverAppBar() {
//     /* ... No changes ... */
//     return SliverAppBar(
//       expandedHeight: 200,
//       floating: false,
//       pinned: true,
//       elevation: 0,
//       backgroundColor: Colors.transparent,
//       foregroundColor: Colors.white,
//       flexibleSpace: FlexibleSpaceBar(
//         background: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [
//                 Colors.green.shade400,
//                 Colors.green.shade600,
//                 Colors.green.shade800,
//               ],
//             ),
//           ),
//           child: Stack(
//             children: [
//               Positioned.fill(
//                 child: Opacity(
//                   opacity: 0.1,
//                   child: Container(
//                     decoration: const BoxDecoration(
//                       image: DecorationImage(
//                         image: NetworkImage(
//                           'https://www.transparenttextures.com/patterns/food.png',
//                         ),
//                         repeat: ImageRepeat.repeat,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               Positioned(
//                 bottom: 30,
//                 left: 20,
//                 right: 20,
//                 child: SlideTransition(
//                   position: Tween<Offset>(
//                     begin: const Offset(0, 1),
//                     end: Offset.zero,
//                   ).animate(
//                     CurvedAnimation(
//                       parent: _headerAnimationController,
//                       curve: Curves.easeOutBack,
//                     ),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Fresh Products',
//                         style: TextStyle(
//                           fontSize: 32,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                           shadows: [
//                             Shadow(
//                               offset: Offset(0, 2),
//                               blurRadius: 4,
//                               color: Colors.black26,
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         'Quality guaranteed • Best prices • Fresh daily',
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: Colors.white.withOpacity(0.9),
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       actions: [
//         Container(
//           margin: const EdgeInsets.only(right: 8),
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.2),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: IconButton(
//             icon: const Icon(
//               Icons.favorite_border_rounded,
//               color: Colors.white,
//             ),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => const FavoritesScreen()),
//               );
//             },
//           ),
//         ),
//         Container(
//           margin: const EdgeInsets.only(right: 8),
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.2),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: IconButton(
//             icon: const Icon(Icons.search_rounded, color: Colors.white),
//             onPressed: () => _showSearchDialog(),
//           ),
//         ),
//         Container(
//           margin: const EdgeInsets.only(right: 16),
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.2),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: IconButton(
//             icon: const Icon(Icons.tune_rounded, color: Colors.white),
//             onPressed: () => _showFilterDialog(),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildLoadingView() {
//     /* ... No changes ... */
//     return Container(
//       height: MediaQuery.of(context).size.height * 0.6,
//       padding: const EdgeInsets.all(40),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(30),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.green.withOpacity(0.1),
//                   blurRadius: 20,
//                   offset: const Offset(0, 10),
//                 ),
//               ],
//             ),
//             child: Column(
//               children: [
//                 Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     Container(
//                       width: 80,
//                       height: 80,
//                       decoration: BoxDecoration(
//                         color: Colors.green.withOpacity(0.1),
//                         shape: BoxShape.circle,
//                       ),
//                     ),
//                     const SizedBox(
//                       width: 50,
//                       height: 50,
//                       child: CircularProgressIndicator(
//                         valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
//                         strokeWidth: 4,
//                       ),
//                     ),
//                     const Icon(
//                       Icons.shopping_basket_outlined,
//                       color: Colors.green,
//                       size: 24,
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 24),
//                 const Text(
//                   'Loading Fresh Products',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   'Getting the best products for you...',
//                   style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildErrorView(String errorMessage) {
//     /* ... No changes ... */
//     return Container(
//       height: MediaQuery.of(context).size.height * 0.6,
//       padding: const EdgeInsets.all(24),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(30),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.red.withOpacity(0.1),
//                   blurRadius: 20,
//                   offset: const Offset(0, 10),
//                 ),
//               ],
//             ),
//             child: Column(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                     color: Colors.red.withOpacity(0.1),
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(
//                     Icons.wifi_off_rounded,
//                     size: 50,
//                     color: Colors.red[400],
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 const Text(
//                   'Connection Error',
//                   style: TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 Text(
//                   errorMessage,
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey[600],
//                     height: 1.5,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 32),
//                 ElevatedButton.icon(
//                   onPressed: () {
//                     context.read<ProductViewModel>().add(LoadProductsEvent());
//                   },
//                   icon: const Icon(Icons.refresh_rounded),
//                   label: const Text(
//                     'Try Again',
//                     style: TextStyle(fontWeight: FontWeight.w600),
//                   ),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green,
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 32,
//                       vertical: 16,
//                     ),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     elevation: 3,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildFloatingActionButton() {
//     /* ... No changes ... */
//     return AnimatedScale(
//       scale: _showScrollToTop ? 1.0 : 0.0,
//       duration: const Duration(milliseconds: 300),
//       child: FloatingActionButton(
//         onPressed: () {
//           _scrollController.animateTo(
//             0,
//             duration: const Duration(milliseconds: 800),
//             curve: Curves.easeInOut,
//           );
//         },
//         backgroundColor: Colors.green,
//         child: const Icon(
//           Icons.keyboard_arrow_up_rounded,
//           color: Colors.white,
//           size: 28,
//         ),
//       ),
//     );
//   }

//   void _showSearchDialog() {
//     /* ... No changes ... */
//     showDialog(
//       context: context,
//       builder:
//           (context) => AlertDialog(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20),
//             ),
//             title: const Text('Search Products'),
//             content: const TextField(
//               decoration: InputDecoration(
//                 hintText: 'Search for products...',
//                 prefixIcon: Icon(Icons.search),
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text('Cancel'),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text('Search functionality coming soon!'),
//                     ),
//                   );
//                 },
//                 child: const Text('Search'),
//               ),
//             ],
//           ),
//     );
//   }

//   void _showFilterDialog() {
//     /* ... No changes ... */
//     showDialog(
//       context: context,
//       builder:
//           (context) => AlertDialog(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20),
//             ),
//             title: const Text('Filter Products'),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 ListTile(
//                   leading: const Icon(Icons.sort),
//                   title: const Text('Sort by Price'),
//                   onTap: () {},
//                 ),
//                 ListTile(
//                   leading: const Icon(Icons.category),
//                   title: const Text('Category'),
//                   onTap: () {},
//                 ),
//                 ListTile(
//                   leading: const Icon(Icons.star),
//                   title: const Text('Rating'),
//                   onTap: () {},
//                 ),
//               ],
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text('Cancel'),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text('Filter functionality coming soon!'),
//                     ),
//                   );
//                 },
//                 child: const Text('Apply'),
//               ),
//             ],
//           ),
//     );
//   }
// }
