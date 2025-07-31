import 'package:flutter/material.dart';

@immutable
sealed class ProductEvent {}

final class LoadProductsEvent extends ProductEvent {}
