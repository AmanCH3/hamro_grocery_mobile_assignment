// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// // Add these imports at the top
// import 'package:badges/badges.dart' as badges;
// import 'package:hamro_grocery_mobile/app/service_locator/service_locator.dart';
// import 'package:hamro_grocery_mobile/dashboard/category_card.dart';
// import 'package:hamro_grocery_mobile/feature/category/presentation/view_model/category_state.dart';
// import 'package:hamro_grocery_mobile/feature/category/presentation/view_model/category_view_model.dart';
// import 'package:hamro_grocery_mobile/feature/notification/presentation/view/notification_screen.dart';
// import 'package:hamro_grocery_mobile/feature/notification/presentation/view_model/notification_event.dart';
// import 'package:hamro_grocery_mobile/feature/notification/presentation/view_model/notification_state.dart';
// import 'package:hamro_grocery_mobile/feature/notification/presentation/view_model/notification_view_model.dart';
// import 'package:hamro_grocery_mobile/feature/product/presentation/view/product_list_detail.dart';
// import 'package:hamro_grocery_mobile/view/auth/dashboard/welcome_banner.dart';

// class HomeScreen extends StatelessWidget {
//   final VoidCallback openDrawer;
//   const HomeScreen({Key? key, required this.openDrawer}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create:
//           (context) =>
//               serviceLocator<NotificationViewModel>()
//                 ..add(GetNotificationsEvent()),
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           centerTitle: false,
//           automaticallyImplyLeading: false,
//           leading: IconButton(
//             onPressed: openDrawer,
//             icon: const Icon(Icons.menu, color: Colors.black),
//           ),
//           title: const Text(
//             "Hamro Grocery",
//             style: TextStyle(
//               color: Colors.black,
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           actions: [
//             BlocBuilder<NotificationViewModel, NotificationState>(
//               builder: (context, state) {
//                 return badges.Badge(
//                   position: badges.BadgePosition.topEnd(top: 0, end: 3),
//                   badgeContent: Text(
//                     state.unreadCount.toString(),
//                     style: const TextStyle(color: Colors.white, fontSize: 10),
//                   ),
//                   showBadge: state.unreadCount > 0,
//                   child: IconButton(
//                     icon: const Icon(
//                       Icons.notifications_outlined,
//                       color: Colors.black,
//                     ),
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => const NotificationScreen(),
//                         ),
//                       ).then((_) {
//                         // When we return from the notification screen, refetch the count.
//                         context.read<NotificationViewModel>().add(
//                           GetNotificationsEvent(),
//                         );
//                       });
//                     },
//                   ),
//                 );
//               },
//             ),
//             const SizedBox(width: 8),
//           ],
//         ),
//         body: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const WelcomeBanner(),
//                 const SizedBox(height: 20),
//                 const Text(
//                   'Categories',
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 10),
//                 BlocBuilder<CategoryViewModel, CategoryState>(
//                   builder: (context, state) {
//                     if (state.isLoading) {
//                       return const Center(child: CircularProgressIndicator());
//                     } else if (state.errorMessage != null) {
//                       // CORRECTED: Used state.errorMessage
//                       return Center(child: Text(state.errorMessage!));
//                     }
//                     return GridView.builder(
//                       shrinkWrap: true,
//                       physics: const NeverScrollableScrollPhysics(),
//                       gridDelegate:
//                           const SliverGridDelegateWithFixedCrossAxisCount(
//                             crossAxisCount: 2,
//                             crossAxisSpacing: 10,
//                             mainAxisSpacing: 10,
//                             childAspectRatio: 1.2,
//                           ),
//                       itemCount: state.categories.length,
//                       itemBuilder: (context, index) {
//                         return CategoryCard(
//                           categoryName: state.categories[index].categoryId,
//                           categoryImage: state.categories[index].categoryId,
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder:
//                                     (context) => ProductListScreen(
//                                       categoryName:
//                                           state.categories[index].categoryId,
//                                     ),
//                               ),
//                             );
//                           },
//                         );
//                       },
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:badges/badges.dart' as badges;

// ADDED: Imports for the Bot feature
import 'package:hamro_grocery_mobile/feature/bot/presentation/view/bot_view.dart';
import 'package:hamro_grocery_mobile/feature/bot/presentation/view_model/bot_view_model.dart';

// Your existing imports
import 'package:hamro_grocery_mobile/app/service_locator/service_locator.dart';
import 'package:hamro_grocery_mobile/dashboard/category_card.dart';
import 'package:hamro_grocery_mobile/feature/category/presentation/view_model/category_state.dart';
import 'package:hamro_grocery_mobile/feature/category/presentation/view_model/category_view_model.dart';
import 'package:hamro_grocery_mobile/feature/notification/presentation/view/notification_screen.dart';
import 'package:hamro_grocery_mobile/feature/notification/presentation/view_model/notification_event.dart';
import 'package:hamro_grocery_mobile/feature/notification/presentation/view_model/notification_state.dart';
import 'package:hamro_grocery_mobile/feature/notification/presentation/view_model/notification_view_model.dart';
import 'package:hamro_grocery_mobile/feature/product/presentation/view/product_list_detail.dart';
import 'package:hamro_grocery_mobile/view/auth/dashboard/welcome_banner.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback openDrawer;
  const HomeScreen({Key? key, required this.openDrawer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              serviceLocator<NotificationViewModel>()
                ..add(GetNotificationsEvent()),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: openDrawer,
            icon: const Icon(Icons.menu, color: Colors.black),
          ),
          title: const Text(
            "Hamro Grocery",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            // --- ADDED: IconButton for the Bot ---
            IconButton(
              tooltip: 'Ask TrailMate Bot',
              icon: const Icon(
                Icons.support_agent_outlined,
                color: Colors.black,
              ),
              onPressed: () {
                // Navigate to the BotView screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => BlocProvider(
                          // Provide the ChatBloc that BotView will need
                          create: (context) => serviceLocator<ChatBloc>(),
                          child: const BotView(),
                        ),
                  ),
                );
              },
            ),
            // --- End of Added Code ---

            // Existing notification icon
            BlocBuilder<NotificationViewModel, NotificationState>(
              builder: (context, state) {
                return badges.Badge(
                  position: badges.BadgePosition.topEnd(top: 0, end: 3),
                  badgeContent: Text(
                    state.unreadCount.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                  showBadge: state.unreadCount > 0,
                  child: IconButton(
                    icon: const Icon(
                      Icons.notifications_outlined,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NotificationScreen(),
                        ),
                      ).then((_) {
                        // When we return from the notification screen, refetch the count.
                        context.read<NotificationViewModel>().add(
                          GetNotificationsEvent(),
                        );
                      });
                    },
                  ),
                );
              },
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const WelcomeBanner(),
                const SizedBox(height: 20),
                const Text(
                  'Categories',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                BlocBuilder<CategoryViewModel, CategoryState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state.errorMessage != null) {
                      return Center(child: Text(state.errorMessage!));
                    }
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 1.2,
                          ),
                      itemCount: state.categories.length,
                      itemBuilder: (context, index) {
                        return CategoryCard(
                          categoryName: state.categories[index].categoryId,
                          categoryImage: state.categories[index].categoryId,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => ProductListScreen(
                                      categoryName:
                                          state.categories[index].categoryId,
                                    ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
