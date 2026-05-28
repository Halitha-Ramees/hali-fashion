# kalifashion

A new Flutter project.

## Firestore products

The app reads product listings from the Firestore `products` collection. Each
product document should use the app product id as the Firestore document id
(`products/p001`, `products/p002`, and so on), and the document also stores the
same id in `productId` so cart/order snapshots stay linked to the catalog.

Registered users are saved in the `users` collection with the Firebase Auth uid
as the document id. Checkout orders are saved in the `orders` collection with
the logged-in user's `userId`, customer delivery details, product snapshots, and
order totals.

Seed the current app product list with:

```powershell
$env:GOOGLE_APPLICATION_CREDENTIALS="C:\path\to\service-account.json"
node .\tools\seed_products_firestore.mjs
```

The service account needs permission to write Firestore documents in the
`hali-fashion` project, such as the Cloud Datastore User role. The app keeps
client-side product writes blocked in `firestore.rules`.

To preview the exact product ids before writing:

```powershell
node .\tools\seed_products_firestore.mjs --dry-run
```

Deploy Firestore rules after changing the rules file:

```powershell
$env:GOOGLE_APPLICATION_CREDENTIALS="C:\path\to\service-account.json"
node .\tools\deploy_firestore_rules.mjs
```

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
