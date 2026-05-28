# HALI FASHION MOBILE APPLICATION

## Technical Report

**Application Name:** HALI Fashion  
**Application Theme Colors:** Black, Gold, White  
**Technology:** Flutter and Firebase  
**Module:** Mobile Software Development  

---

## Abstract

HALI Fashion is a modern fashion store mobile application developed using Flutter and Firebase technologies. The application provides a premium mobile shopping experience with a luxury black, gold, and white visual theme. Users can register, log in, browse fashion products, view product details, add items to the cart, and place orders.

The system was designed with responsive mobile layouts, reusable Flutter widgets, and Firebase cloud services. Firebase Authentication is used for user login and registration, while Cloud Firestore stores products, user details, and order information. This report explains the application architecture, main modules, database design, security approach, implementation process, testing, APK build, limitations, and future enhancements.

---

## Table of Contents

1. Introduction  
2. Problem Statement  
3. Project Objectives  
4. Scope of the Application  
5. Technology Stack  
6. System Architecture  
7. Application Modules  
8. Database Design  
9. Security Design  
10. UI/UX Design  
11. Implementation Details  
12. Testing and Results  
13. APK Build and Deployment  
14. Limitations  
15. Future Enhancements  
16. Conclusion  
17. References  
18. Appendices  

---

## 1. Introduction

HALI Fashion is a mobile fashion shopping application created to provide customers with a smooth and modern online shopping experience. The application focuses on stylish product presentation, simple navigation, secure authentication, and cloud-based data management.

The project was developed using the Flutter framework and Dart programming language. Firebase services were integrated to support authentication and real-time cloud database features. The app includes user authentication, product listing, product details, cart management, checkout, order history, and profile management.

The application uses a premium black, gold, and white theme to match the identity of a luxury fashion brand. Its interface is designed to be responsive and suitable for Android mobile devices.

---

## 2. Problem Statement

Many small and medium fashion businesses do not have a modern mobile shopping system. Traditional selling methods limit customer reach and make it difficult to manage products, customer records, and orders digitally.

Some existing systems also lack responsive mobile layouts, secure authentication, cloud database support, and simple checkout features. HALI Fashion solves these problems by providing a Flutter-based mobile application connected with Firebase services.

---

## 3. Project Objectives

- Develop a responsive fashion mobile application using Flutter.
- Implement Firebase Authentication for secure user login and registration.
- Use Cloud Firestore to store products, users, and orders.
- Create a premium UI using black, gold, and white theme colors.
- Provide product browsing, product detail, cart, and checkout features.
- Generate a release APK for Android installation and testing.

---

## 4. Scope of the Application

### Included Features

- User registration and login
- Splash screen and authentication flow
- Home screen with featured products
- Product listing and product details
- Shopping cart management
- Checkout and order placement
- Order history screen
- User profile screen
- Firebase Authentication integration
- Cloud Firestore database integration
- Android APK deployment

### Excluded Features

- Online payment gateway
- Delivery tracking
- Admin dashboard
- Push notifications
- Product review and rating system

---

## 5. Technology Stack

Flutter was used as the main mobile application framework because it supports fast development and responsive cross-platform UI. Dart was used as the programming language for application logic.

Firebase Authentication handles secure user login and registration. Cloud Firestore is used as the cloud database for storing product records, user profiles, and order details. Provider state management is used to manage cart, product, order, and user data inside the application.

| Technology | Version | Purpose |
|---|---:|---|
| Flutter | 3.x | Mobile application framework |
| Dart | 3.x | Programming language |
| Firebase | Latest | Backend services |
| Firebase Authentication | Latest | User authentication |
| Cloud Firestore | Latest | Cloud database |
| Provider | Latest | State management |
| GoRouter | Latest | App navigation |

---

## 6. System Architecture

The HALI Fashion application follows a client-server architecture. The Flutter mobile application acts as the client, while Firebase works as the backend service provider.

The user interacts with the Flutter UI. The application sends authentication requests to Firebase Authentication and sends database requests to Cloud Firestore. Firestore stores product data, user profile information, and order records. Provider classes manage app state and update the UI when data changes.

### Architecture Flow

User Interface -> Flutter Screens -> Providers -> Firebase Services -> Cloud Firestore / Firebase Auth

This architecture improves maintainability because UI screens, business logic, and backend services are separated into different layers.

---

## 7. Application Modules

### Authentication Module

This module allows users to register, log in, and log out. Firebase Authentication is used to securely verify email and password credentials.

### Splash Module

The splash screen displays the brand identity when the application starts. It then redirects the user to the login screen.

### Home Module

The home screen shows featured products, new arrivals, category sections, and a premium fashion layout.

### Shop Module

The shop module allows users to browse available fashion products. Product details such as name, image, price, description, category, and sizes are displayed.

### Product Detail Module

This module displays detailed information about a selected product. Users can select a size and add the product to the cart.

### Cart Module

The cart module stores selected products, quantities, sizes, and total price. Users can increase, decrease, or remove cart items.

### Checkout Module

The checkout module collects customer delivery details and places the order in Firestore.

### Orders Module

This module displays the user's order history and order status.

### Profile Module

The profile module displays user details and allows customer account-related actions.

---

## 8. Database Design

Cloud Firestore is used as the main database. The database is document-based and stores records inside collections.

### Main Collections

| Collection | Purpose |
|---|---|
| products | Stores fashion product details |
| users | Stores registered user profile details |
| orders | Stores customer order records |

### Products Collection Fields

- productId
- name
- category
- description
- imageUrl
- price
- sizes
- isFeatured
- isNew

### Users Collection Fields

- userId
- fullName
- email
- createdAt
- updatedAt

### Orders Collection Fields

- orderId
- userId
- customerName
- customerEmail
- phoneNumber
- shippingAddress
- city
- postalCode
- items
- total
- status
- createdAt

This database structure supports product browsing, customer profile storage, and order management.

---

## 9. Security Design

Firebase Authentication is used to protect user accounts. Only registered users can log in and place orders.

Firestore security rules are designed to protect private user data. Product data can be publicly readable so customers can browse the store. User profiles and order records should only be accessible by the authenticated owner. This helps protect customer information and improves application security.

---

## 10. UI/UX Design

The HALI Fashion app uses a premium black, gold, and white color theme. Black is used as the main background color, gold is used for highlights and brand elements, and white is used for readable text.

The user interface includes modern fashion-style layouts, product cards, image-based product presentation, bottom navigation, readable typography, and responsive screen design. The goal is to create a luxury shopping experience while keeping navigation simple.

Main UI screens include:

- Splash screen
- Login screen
- Register screen
- Home screen
- Product listing screen
- Product detail screen
- Cart screen
- Checkout screen
- Orders screen
- Profile screen

---

## 11. Implementation Details

The application was implemented using Flutter widgets and reusable components. The main application starts from `main.dart`, initializes Firebase, and loads the Flutter app.

GoRouter is used for navigation between screens. Provider is used for state management. Separate providers handle users, products, cart, and orders. This keeps the code organized and easier to maintain.

Firebase SDK packages were added to connect the application with Firebase Authentication and Firestore. Product and order models were created to convert Firestore data into Dart objects.

The Android launcher icon was updated using the HALI Fashion logo. A release APK was generated using Flutter build tools.

---

## 12. Testing and Results

Testing was performed to confirm that the application works correctly on Android.

### Functional Testing

| Test Case | Expected Result | Status |
|---|---|---|
| App launch | Splash screen should appear | Passed |
| User login | User should log in using valid credentials | Passed |
| Product browsing | Products should display correctly | Passed |
| Product details | Selected product details should open | Passed |
| Add to cart | Product should be added to cart | Passed |
| Checkout | Order should be placed successfully | Passed |
| Order history | User orders should be displayed | Passed |

### Build Testing

The Flutter analyzer completed without errors. Unit/widget tests passed successfully. The Android release APK was built successfully.

---

## 13. APK Build and Deployment

The Android APK was generated using the Flutter release build command:

```bash
flutter build apk --release
```

The generated APK file is located in:

```text
build/app/outputs/flutter-apk/app-release.apk
```

The HALI Fashion logo was set as the Android launcher icon before building the APK. The APK can be installed on Android devices for testing and demonstration.

---

## 14. Limitations

- No online payment gateway integration
- No delivery tracking system
- No admin dashboard for product management
- No push notification feature
- No product reviews and ratings
- Internet connection is required for Firebase features

---

## 15. Future Enhancements

- Add online payment gateway support
- Add admin dashboard for product and order management
- Add push notifications for offers and order updates
- Add delivery tracking
- Add product reviews and ratings
- Add wishlist feature
- Add AI-based fashion recommendations
- Publish the application to Google Play Store

---

## 16. Conclusion

The HALI Fashion mobile application successfully demonstrates a modern fashion shopping system using Flutter and Firebase. The application provides secure authentication, product browsing, cart management, checkout, order history, and profile management.

The project also demonstrates important mobile application development concepts such as responsive UI design, cloud database integration, state management, routing, testing, and APK deployment. Overall, HALI Fashion is a functional and professional mobile shopping application suitable for academic demonstration and future real-world enhancement.

---

## 17. References

- Flutter Official Documentation: https://flutter.dev
- Firebase Documentation: https://firebase.google.com
- Dart Programming Language: https://dart.dev
- Material Design Guidelines: https://material.io
- Android Developer Documentation: https://developer.android.com
- GitHub Repository: https://github.com/Hainiya16/hainiya_fashion_gallery/tree/main
- Figma Design Link: https://www.figma.com/design/4e7jlsXvhirXPY8LDphKFm/ShoeShop?node-id=0-1&t=YpYPtWyp9U59faJT-1

---

## 18. Appendices

### Appendix A - Firebase Configuration

Firebase was configured for Android and web platforms. Firebase services used in this project include Firebase Authentication and Cloud Firestore.

### Appendix B - APK Build Screenshot

The APK was built using Flutter release build command. The final APK file was generated in the Flutter build output folder.

### Appendix C - App Icon

The HALI Fashion logo was used as the Android launcher icon for the mobile application.

