# Simple News Client

A simple, user friendly news app that consumes the API from newsapi.org

Prerequisites

Before running the project, ensure you have the following installed:

- Flutter SDK: Install Flutter
- Dart SDK: Included with Flutter
- Xcode (for iOS development): Install Xcode
- Android Studio (for Android development): Install Android Studio
- Command line tools (optional):
    - Git: Install Git
    - Make sure you have the flutter and dart commands added to your PATH.

Getting Started

Follow these steps to set up and run the project on your local machine:

1. Clone the repository:
   git clone https://github.com/TiroLiroLD/TurnKey_Headspace_SimpleNewsClient.git
   cd simple_news_client

2. Install dependencies:
   flutter pub get

3. Load environment variables:
    - Create a .env file in the assets directory with the following content:
      API_KEY=your_news_api_key_here
    - Replace your_news_api_key_here with your actual News API key. A test API key is already provided in the .env file. It would not be shared like this in a real development scenario as it is on .gitignore, but for the purpose of this test and knowing the API key is a test key, it has been shared in a easy manner, as if the tester is running an app downloaded from the stores.

4. Generate necessary files:
   dart run build_runner build --delete-conflicting-outputs

5. Run the application:
    - To run on an Android device/emulator:
      flutter run
    - To run on an iOS device/simulator:
      flutter run

Features

- News Sources: View news from different sources.
- News Search: Search for news articles using various filters.
- Saved Articles: Save and manage your bookmarked articles.
- Background Sync: Get latest articles in the background. Note: Due to quota limits and lack of a user settings to what to sync (topic, sources, top headlines...), the first 5 sources in the list were chosen to showcase this feature. It is set to sync every minute on both iOS and Android, so the tester does not have to wait long to see the feature in action. To confirm it is working, there is a time at the top of the articles list with the latest sync time. When choosing a source, if it is not set to sync in background and therefore empty, it will fetch from API. To load more sources, pull to refresh the sources list. 

Troubleshooting

- If you encounter any issues with plugins or dependencies, try running:
  flutter clean
  flutter pub get

- Ensure your development environment is set up correctly and all required SDKs are installed.