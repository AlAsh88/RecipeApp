### Steps to Run the App
1. Clone the Repository:
    * Open your terminal and run the following command to clone the project repository:
        - https://github.com/AlAsh88/RecipeApp
2. Open the Project in Xcode:
    * Navigate to the project directory
        -  cd RecipeApp
    * Open the project file in Xcode:
        - open RecipeApp.xcodeproj
3. Select a Target and Simulator:
    - In Xcode, select your desired build target in RecipeApp from the Scheme Selector (top-left corner).
    - Choose a Simulator (e.g., iPhone 14) or a physical device.
4. Build and Run the App:
    - Press 'Cmd + R' or click the Run button in Xcode to build and launch the app.
    - The app will launch on the selected simulator or device.


### Focus Areas: What specific areas of the project did you prioritize? Why did you choose to focus on these areas?
1. Image Caching (Main focus area):
    - Implemented efficient memory and disk caching to improve performance, reduce network usage, and ensure faster image loading.
2. Pull-to-Refresh:
    - Added a UIRefreshControl for seamless data reloading, ensuring users always have up-to-date recipes.
3. Sorting Recipes:
    - Enabled sorting by Name and Cuisine using a simple action sheet triggered by a navigation bar button.
4. Clean Architecture:
    - Organized code following MVVM principles for better maintainability, with clear separation of UI, data handling, and caching logic.
5. Error Handling:
    - Provided meaningful feedback and fallbacks to handle network or image loading issues gracefully.


### Time Spent: Approximately how long did you spend working on this project? How did you allocate your time?
* I spent approximately 6-8 hours working on this project, with the time allocated as follows:

1. Project Setup & API Integration: (~20%)
     - Setting up the project structure, integrating the recipe API, and parsing JSON data.
2. Image Caching: (~25%)
    - Implementing memory and disk caching for efficient image loading and performance optimization.
3. Pull-to-Refresh: (~15%)
    - Adding and fine-tuning the UIRefreshControl to ensure seamless data reloading.
4. Sorting Functionality: (~15%)
    - Enabling sorting of recipes by Name and Cuisine using an action sheet for user interaction.
5. UI & Code Refinement: (~20%)
    - Designing clean and responsive table view cells, ensuring constraints, and maintaining a clean architecture.
6. Error Handling & Debugging: (~5%)
    - Implementing graceful error handling for network/image issues and fixing bugs.


### Trade-offs and Decisions: Did you make any significant trade-offs in your approach?
1. Custom Image Caching vs Third-Party Libraries
    - Decision: Implemented a custom image caching solution using memory and disk caching instead of third-party libraries like Kingfisher or SDWebImage.
    - Trade-off: While third-party libraries are quicker to integrate, a custom solution provided greater control, reduced dependencies, and deepened understanding of caching mechanisms.
2. Using UIKit over SwiftUI
    - Decision: Opted for UIKit to ensure flexibility and compatibility with a wider range of iOS versions.
    - Trade-off: SwiftUI offers a modern declarative approach, but UIKit allowed more precise layout control and alignment with project requirements.
3. Limited Sorting Options
    - Decision: Focused on sorting recipes by Name and Cuisine for simplicity and core functionality.
    - Trade-off: While additional sorting or filtering options would improve the app, they were deprioritized due to time constraints.
4. Error Handling vs Time Constraints
    - Decision: Added basic error handling (e.g., alerts for network or image loading failures) to ensure reliability.
    - Trade-off: Advanced error recovery features like retry mechanisms or offline support were not implemented to prioritize core functionality.


### Weakest Part of the Project: What do you think is the weakest part of your project?
* The weakest part of the project is the basic error handling and lack of advanced offline support:

1. Error Handling
    - While basic error handling (e.g., showing alerts for network failures) has been implemented, the app lacks advanced recovery mechanisms such as retries for failed requests or fallback data when offline.
2. Offline Functionality
    - The app currently requires an active internet connection to fetch recipes. Adding offline support with local persistence (e.g., Core Data or a local JSON cache) would enhance reliability and user experience.
* These areas were deprioritized due to time constraints, with a focus on delivering core functionality such as image caching, sorting, and refreshing the recipe list.


### Additional Information: Is there anything else we should know? Feel free to share any insights or constraints you encountered.
* Insights:
    - Implementing custom image caching provided a deeper understanding of memory management, disk persistence, and asynchronous programming in Swift. Balancing performance and simplicity was key when handling images and network requests.
* Constraints:
    - Due to time constraints:
    - Advanced offline support (e.g., saving recipe data locally) was not implemented.
    - Error handling is functional but could be enhanced with retries or fallback mechanisms for a more robust experience.
* Learning:
    - This project reinforced the importance of clean architecture, modular code, and adhering to user experience best practices, such as smooth table view updates, sorting options, and pull-to-refresh functionality.
