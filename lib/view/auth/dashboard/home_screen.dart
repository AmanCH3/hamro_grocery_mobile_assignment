import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:badges/badges.dart' as badges;
import 'package:hamro_grocery_mobile/app/service_locator/service_locator.dart';
import 'package:hamro_grocery_mobile/feature/bot/presentation/view/bot_view.dart';
import 'package:hamro_grocery_mobile/feature/bot/presentation/view_model/bot_view_model.dart';
import 'package:hamro_grocery_mobile/feature/category/presentation/view/category_card.dart';
import 'package:hamro_grocery_mobile/feature/category/presentation/view_model/category_event.dart';
import 'package:hamro_grocery_mobile/feature/category/presentation/view_model/category_state.dart';
import 'package:hamro_grocery_mobile/feature/category/presentation/view_model/category_view_model.dart';
import 'package:hamro_grocery_mobile/feature/notification/presentation/view/notification_screen.dart';
import 'package:hamro_grocery_mobile/feature/notification/presentation/view_model/notification_event.dart';
import 'package:hamro_grocery_mobile/feature/notification/presentation/view_model/notification_state.dart';
import 'package:hamro_grocery_mobile/feature/notification/presentation/view_model/notification_view_model.dart';
import 'package:hamro_grocery_mobile/feature/product/presentation/view/product_card.dart';
import 'package:hamro_grocery_mobile/feature/product/presentation/view_model/product_event.dart';
import 'package:hamro_grocery_mobile/feature/product/presentation/view_model/product_state.dart';
import 'package:hamro_grocery_mobile/feature/product/presentation/view_model/product_view_model.dart';
import 'package:hamro_grocery_mobile/view/auth/dashboard/welcome_banner.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback openDrawer;
  const HomeScreen({Key? key, required this.openDrawer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use MultiBlocProvider to provide all necessary Blocs for this screen.
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) =>
                  serviceLocator<NotificationViewModel>()
                    ..add(GetNotificationsEvent()),
        ),
        BlocProvider(
          create:
              (context) =>
                  serviceLocator<CategoryViewModel>()
                    ..add(LoadCategoriesEvent()),
        ),
        BlocProvider(
          create:
              (context) =>
                  serviceLocator<ProductViewModel>()
                    // Load all products initially when the screen loads.
                    ..add(const LoadProductsEvent()),
        ),
      ],
      child: Scaffold(
        appBar: _buildAppBar(context),
        // The body should be a single widget. The SingleChildScrollView contains all content.
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const WelcomeBanner(),
              _buildCategorySection(),
              _buildProductSection(),
            ],
          ),
        ),
      ),
    );
  }

  // Extracted AppBar to a separate method for cleanliness
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
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
        // IconButton for the Bot
        IconButton(
          tooltip: 'Ask GrocerBot',
          icon: const Icon(Icons.support_agent_outlined, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) => BlocProvider(
                      create: (context) => serviceLocator<ChatBloc>(),
                      child: const BotView(),
                    ),
              ),
            );
          },
        ),
        // Notification icon with badge
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
                    // When returning, refresh the notification count
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
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: CategoryCard(
                        name: 'All',
                        isSelected: state.selectedCategoryId == null,
                        onTap: () {
                          context.read<CategoryViewModel>().add(
                            const SelectCategoryEvent(null),
                          );
                          context.read<ProductViewModel>().add(
                            const LoadProductsEvent(),
                          );
                        },
                      ),
                    );
                  }

                  final category = state.categories[index - 1];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: CategoryCard(
                      name: category.name,
                      isSelected:
                          state.selectedCategoryId == category.categoryId,
                      onTap: () {
                        context.read<CategoryViewModel>().add(
                          SelectCategoryEvent(category.categoryId),
                        );
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
                child: Center(child: Text('No products found.')),
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
