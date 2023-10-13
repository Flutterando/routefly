import 'package:routefly/routefly.dart';
import 'package:flutter/material.dart';

import 'app/home/config/config_page.dart';
import 'app/home/home_page.dart';
import 'app/product/product_page.dart';
import 'app/user/user_page.dart';


final routes = <RouteEntity>[
  RouteEntity(
  path: '/home/config',
  page: const MaterialPage(child: ConfigPage()),
),RouteEntity(
  path: '/home',
  page: HomePage(),
),RouteEntity(
  path: '/product',
  page: const MaterialPage(child: ProductPage()),
),RouteEntity(
  path: '/user',
  page: const MaterialPage(child: UserPage()),
),
];