# User Manager - iOS Application

## 📱 Introduction
User Manager is an iOS application developed as part of a technical test. It allows users to manage a list of users by performing CRUD operations (Create, Read, Update, Delete) with both local persistence and API integration. The app supports multiple languages (English and Spanish) and is compatible with iOS 15+.

## Video of app running


https://github.com/user-attachments/assets/2cec3b5f-567b-4031-a014-d6c3b5e32885


## 🛠️ Tech Stack
- **Language:** Swift
- **Architecture:** MVVM + Coordinator
- **UI:** SwiftUI
- **Persistence:** Realm
- **Networking:** Alamofire
- **Concurrency:** async-await
- **Location:** Core Location
- **Error Handling:** Custom error management
- **Supported Versions:** iOS 15 and above
- **Multi-language support:** English and Spanish
- **It uses Logs:** in order to show in console what is happening while running the app

## 🌐 API Integration
The app retrieves the user list from the following endpoint:
- URL: [JSONPlaceholder Users](https://jsonplaceholder.typicode.com/users)
- Data: username, full name, phone, email, and city

## 🚀 Features
### User List Screen
- Fetches user data from the API.
- Displays username, full name, phone number, email, and city.
- Tapping on a user navigates to the User Detail screen.

### User Detail Screen
- Displays detailed information about the user.
- Shows a placeholder profile image.
- Allows editing the user's name and email with validation.
- Saves changes locally using Realm.

### Add User Screen
- Form to create a new user with the following fields:
  - Name (required)
  - Email (valid email required)
  - Phone (required)
- Uses reusable validation functions.
- Saves the new user locally and updates the user list.
- Button to capture the current location (latitude and longitude) using Core Location.

### Delete User
- Allows deletion of users (logical deletion from the API list).
- Reflects changes both locally and in the API response.

### Localization
- Supports English and Spanish using `LocalizedStringKey`.
- Uses dynamic localization for variable-based strings.

## 🗺️ Location Handling
- Uses Core Location to get the current user's latitude and longitude.
- Requests permission to access location.
- Captures location even when the app is in the background.
- Button to obtain the current location while creating a new user.

