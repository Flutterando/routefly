# Routefly

Routefly is a folder-based route manager inspired by NextJS and created by the Flutterando community. It allows you to automatically create routes in your Flutter app by simply organizing your code files within specific directories. When a file is added to the "pages" directory, it's automatically available as a route. Just add the appropriate folder structure inside the "lib/app" folder.

**Example:**

- `/lib/app/dashboard/dashboard_page.dart` => `/dashboard`
- `/lib/app/users/users_page.dart` => `/users`
- `/lib/app/users/[id]/user_page.dart` => `/users/2`

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
      routerDelegate: Routefly.routerConfig(
        routes: routes,
      ),
    );
  }
}
```

3. Organize your code by creating folders that contain a *_page.dart file for each page. For example:

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

## Navigation

Routefly provides simple navigation methods:

`Routefly.navigate('path')`: Replaces the entire route stack with the requested path.<br>
`Routefly.push('path')`: Adds a route to the route stack. <br>
`Routefly.pop()`: Removes the top route from the route stack. <br>
`Routefly.replace('path')`: Replaces the last route in the stack with the requested path. <br>

## Dynamic Routes

Dynamic Routes allow you to create routes from dynamic data. You can use dynamic segments enclosed in brackets, such as `[id]` or `[slugs]`. For example:

Create a page using a dynamic segment: `lib/app/users/[id]/user_page.dart`. This generates the route path `/users/[id]`.

Use navigation commands to replace the dynamic segment, like `Routefly.push('/users/2')`.

Access the dynamic parameter (id) on the page using `Routefly.query['id']`.

You can also access segment parameters using Routefly.query.params, e.g., `Routefly.query.params['search']` for `/product?search=Text`.

## Dynamic Routes

When you don't know the exact segment names ahead of time and want to create routes from dynamic data, you can use Dynamic Segments that are filled in at request time, just put the dynamic segment in the folder name in brackets. Ex: `[id]`, `[slugs]`...

Imagine that you want to access a user for editing that needs an id.
Create the page using the dynamic segment: `lib/app/users/[id]/user_page.dart`. This will generate the route path `/users/[id]`.


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


## Layout (RouterOutlet)

Layout são páginas que aceitam navegação aninhada. Todas as rotas filhas ao layout será apontada como filha na navegação.

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

Para criar um layout crie a pasta a qual pertencerá e adicione um arquivo `*_layout.dart`. As pastas filhas devem ficar dentro da pasta parent do layout.

No Widget do layout adicione `RouterOutlet()` aonde preferir que as rotas aninhadas apareçam.
ex:

```dart
...
Expanded(
    flex: 3,
    child: RouterOutlet(),
),
...

```




If you have any questions or need assistance with the package, feel free to reach out to the `Flutterando` community.

**Happy routing with Routefly!**
