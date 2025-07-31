import 'package:flutter/material.dart';

@immutable
sealed class CategoryEvent {}

final class LoadCategoriesEvent extends CategoryEvent {}
