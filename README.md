# Routefly

![Logo](https://github.com/Flutterando/routefly/blob/main/assets/images/logo_with_text.png?raw=true)

Routefly is a folder-based route manager inspired by NextJS and created by the Flutterando community. It allows you to automatically create routes in your Flutter app by simply organizing your code files within specific directories. When a file is added to the "pages" directory, it's automatically available as a route. Just add the appropriate folder structure inside the "lib/app" folder.

**Example:**


![Logo](https://github.com/Flutterando/routefly/blob/main/assets/images/routefly_scheme.png?raw=true)

## Installation and Initialization

To get started with Routefly, follow these steps:

1. Add the Routefly package to your Flutter project:

```bash
   flutter pub add routefly
```

2. Modify your MaterialApp or CupertinoApp by replacing it with MaterialApp.router or CupertinoApp.router. Configure the router using the Routefly.routerConfig method:

```dart
import 'package:routefly/routefly.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: Routefly.routerConfig(
        routes: routes, // GENERATED
      ),
    );
  }
}
```

3. Organize your code by creating folders that contain a *_page.dart file for each page. 
For example:

```
.
└── app/
    ├── product/
    │   └── product_page.dart
    └── user/
        └── user_page.dart
```

4. Generate routes using the following command:
```
dart run routefly
```

Run this command every time you create a new folder with a page to generate the routes again. You can also use the `--watch` flag to automatically generate routes when adding a new page to a folder.


## Route Groups

In the app directory, nested folders are normally mapped to URL paths. However, you can mark a folder as a Route Group to prevent the folder from being included in the route's URL path.

This allows you to organize your route segments and project files into logical groups without affecting the URL path structure.

A route group can be created by wrapping a folder's name in parenthesis: `(folderName)`

```
.
└── app/
    ├── (product)/
        └── home/
            └── home_page.dart
```
Generate => `/home`;

## Navigation

Routefly provides simple navigation methods:

`Routefly.navigate('path')`: Replaces the entire route stack with the requested path.<br>
`Routefly.pushNavigate('path')`: Adds a new route on top of the existing stack.<br>
`Routefly.push('path')`: Adds a route to the route stack. <br>
`Routefly.pop()`: Removes the top route from the route stack. <br>
`Routefly.replace('path')`: Replaces the last route in the stack with the requested path. <br>

**You can use `RELATIVE PATH` also**;


It is also possible to access routes using Record `routesPath` which replaces the strings
which represent the `path` by an object notation.

```dart
// String notation
Routefly.navigate('/dashboard/users');

// Object Notation
Routefly.navigate(routesPath.dashboard.users);
```

`Dynamic routes` are also represented by objects, but it is necessary to replace the dynamic parameters;<br>
Use the `changes()` method to do this;

```dart
// String notation => /product/[id]
Routefly.navigate('/product/1');

// Object Notation => /product/[id]
Routefly.navigate(routesPath.product.changes({'id': '1'}));
```


## Dynamic Routes

Dynamic Routes allow you to create routes from dynamic data. You can use dynamic segments enclosed in brackets, such as `[id]` or `[slugs]`. For example:

Create a page using a dynamic segment: `lib/app/users/[id]/user_page.dart`. This generates the route path `/users/[id]`.

Use navigation commands to replace the dynamic segment, like `Routefly.push('/users/2')`.

Access the dynamic parameter (id) on the page using `Routefly.query['id']`.

You can also access segment parameters using Routefly.query.params, e.g., `Routefly.query.params['search']` for `/product?search=Text`.


## Custom Transition

To create custom route transitions, define a routeBuilder function in your page file. This allows you to use custom transitions based on PageRouteBuilder. For example:


```dart
Route routeBuilder(BuildContext context, RouteSettings settings) {
  return PageRouteBuilder(
    settings: settings // <- !! DON'T FORGET THAT !!
    pageBuilder: (_, a1, a2) => const UserPage(),
    transitionsBuilder: (_, a1, a2, child) {
      return FadeTransition(opacity: a1, child: child);
    },
  );
}
```

It is also possible to change the global transition of the routes:

```dart
@override
  Widget build(BuildContext context) {
    return CupertinoApp.router(
      routerConfig: Routefly.routerConfig(
        routes: routes,
        routeBuilder: (context, settings, child) {
          return CupertinoPageRoute(
            settings: settings, // !! IMPORTANT !!
            builder: (context) => child,
          );
        },
      ),
    );
  }
```


## Layout (RouterOutlet)

Layout are pages that support nested navigation. All child routes to the layout will be pointed out as children in the navigation.

```
.
└── app/
    └── dashboard/
        ├── users/
        │   └── users_page.dart
        ├── products/
        │   └── products_page.dart
        └── dashboard_layout.dart
```

To create a layout, create the folder it will belong to and add a `*_layout.dart` file. The child folders must be inside the layout's parent folder.

In the Layout Widget, add `RouterOutlet()` wherever you prefer nested routes to appear.
ex:

```dart
RouterOutlet(),

```
![Logo](https://github.com/Flutterando/routefly/blob/main/assets/images/nested_navigation.gif?raw=true)

## Middleware

Middleware are functions that intercept the request and can change the route information and can cancel or redirect the route request.

```dart
FutureOr<RouteInformation> _guardRoute(RouteInformation routeInformation) {
  if (routeInformation.uri.path == '/guarded') {
    return routeInformation.redirect(Uri.parse('/'));
  }

  return routeInformation;
}
```

Now add it to the initial configuration.

```dart
return MaterialApp.router(
      routerConfig: Routefly.routerConfig(
        routes: routes,
        middlewares: [_guardRoute], // <<<<
      ),
    );
```

## Not found page (404)

When creating a route with name `404`, it will be triggered when a page is not found.
`Routefly` gives the possibility to modify the default route for unfound pages.

```dart
return MaterialApp.router(
      routerConfig: Routefly.routerConfig(
        routes: routes,
        notFoundPath: '/not-found',
      ),
    );
```
![Logo](https://github.com/Flutterando/routefly/blob/main/assets/images/404.png?raw=true)


If you have any questions or need assistance with the package, feel free to reach out to the `Flutterando` community.

**Happy routing with Routefly!**
