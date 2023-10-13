## Routefly

Gerenciador de rotas baseadas em pastas inspirado no NextJS

## Install

```
flutter pub add routefly
```

Modifique o `MaterialApp` ou `CupertinoApp` por `MaterialApp.router` ou `CupertinoApp.router`;

```dart

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: Routefly.routerConfig(
        initialPath: '/home',
        routes: routes,
      ),
    );
  }
}

```

Crie pastas contendo um arquivo `*_page.dart` que conterá a página.

```
.
└── app/
    ├── product/
    │   └── product_page.dart
    └── user/
        └── user_page.dart
```

Use o comando abaixo para gerar as rotas:

```
dart pub run routefly
```
Use esse comando toda vez que criar uma nova pasta com uma página para gerar a rota novamente.

