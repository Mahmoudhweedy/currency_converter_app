# Currency Converter Flutter App

## Project Overview
A Flutter-based currency converter application with real-time exchange rates, historical data, and local caching.

## Building the Project

### Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio / VS Code with Flutter extensions

### Setup Steps
1. Clone the repository
2. Run `flutter pub get`
3. Run `flutter pub run build_runner build`
4. Connect a device or start an emulator
5. Run `flutter run`

## Architecture: Clean Architecture

### Justification
- **Separation of Concerns**: Divides the project into layers (presentation, domain, data)
- **Testability**: Easy to write unit tests for each layer
- **Scalability**: Modular design allows easy feature additions
- **Dependency Rule**: Inner layers are independent of outer layers

## State Management: BLoC Pattern

### Justification
- Reactive programming paradigm
- Clear separation between business logic and UI
- Easy to manage complex state transformations
- Built-in error handling and loading states

## Image Loading: CachedNetworkImage

### Justification
- Efficient image caching
- Supports placeholders and error handling
- Reduces network requests
- Smooth image loading experience

## Local Database: Hive

### Justification
- Lightweight and Fast
- Ease of Use
- Strong Flutter Support
- Efficient Storage
- Customizable & Scalable
- Encryption Support

## Dependency Injection: get_it

### Justification
- Lightweight DI solution
- Reduces boilerplate code
- Easy service locator pattern implementation
- Supports lazy loading of dependencies

## Unit Testing
- Comprehensive test coverage for:
  - API integration
  - Business logic
  - Repository implementations
  - Bloc state management

## API & Flags
- Currency Conversion API: https://free.currencyconverterapi.com/
- Country Flags: https://flagcdn.com/

