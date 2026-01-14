# Expenses Tracker

A Flutter application for tracking personal expenses and income. This app allows users to add, view, and delete transactions, as well as monitor their total balance.

## Features

- **Add Transactions**: Users can add transactions with details such as type (expense/income), amount, category, and date.
- **View Transactions**: Transactions are displayed in a list, sorted by date, with visual indicators for expenses (red) and income (green).
- **Delete Transactions**: Users can swipe to delete transactions, with confirmation feedback.
- **Balance Calculation**: The app calculates and displays the total balance based on all transactions.
- **Responsive UI**: The app is designed with a clean and intuitive interface, including animations and visual feedback.

## Project Structure

```
lib/
├── core/
│   ├── api/
│   │   └── api_service.dart          # Handles API calls for fetching, adding, and deleting transactions
│   └── models/
│       └── transaction_model.dart    # Defines the TransactionModel class and JSON serialization
├── features/
│   └── transaction/
│       ├── pages/
│       │   ├── add_transaction_page.dart  # UI for adding new transactions
│       │   └── home_page.dart              # Main page displaying transactions and balance
│       └── providers/
│           └── transaction_provider.dart  # Riverpod providers for state management
└── utils/
    └── widgets/
        ├── balance_container.dart       # Widget for displaying the total balance
        └── transaction_item.dart         # Widget for displaying individual transaction items
```

## Core Components

### 1. API Service (`lib/core/api/api_service.dart`)

The `ApiService` class handles all HTTP requests related to transactions:

- **`fetchTransactions()`**: Fetches a list of transactions from the API and sorts them by date.
- **`addTransaction(TransactionModel transaction)`**: Sends a POST request to add a new transaction.
- **`deleteTransaction(String id)`**: Sends a DELETE request to remove a transaction by its ID.

### 2. Transaction Model (`lib/core/models/transaction_model.dart`)

The `TransactionModel` class represents a transaction with the following properties:

- `id`: Unique identifier for the transaction.
- `type`: Type of transaction (expense/income).
- `amount`: Amount of money involved in the transaction.
- `category`: Category of the transaction (e.g., Food, Transportation).
- `date`: Date of the transaction.

The class includes methods for converting between JSON and Dart objects:

- **`fromJson(Map<String, dynamic> json)`**: Converts a JSON object to a `TransactionModel`.
- **`toJson()`**: Converts a `TransactionModel` to a JSON object for API requests.

### 3. Transaction Provider (`lib/features/transaction/providers/transaction_provider.dart`)

This file contains Riverpod providers for managing the state of transactions:

- **`apiServiceProvider`**: Provides an instance of `ApiService` for dependency injection.
- **`transactionListProvider`**: A `FutureProvider` that fetches and provides a list of transactions.
- **`TransactionNotifier`**: A `StateNotifier` for handling the addition and deletion of transactions, with loading and error states.

### 4. Home Page (`lib/features/transaction/pages/home_page.dart`)

The `HomePage` widget is the main screen of the app, displaying:

- **Balance Container**: Shows the total balance calculated from all transactions.
- **Transaction List**: Displays transactions in a scrollable list, sorted by date.
- **Floating Action Button**: Allows users to navigate to the "Add Transaction" page.

Key functions:

- **`formatCurrency(String amount)`**: Formats a numeric amount into a currency string (e.g., "Rp 1.000").
- **`calculateBalance(List<TransactionModel> transactions)`**: Calculates the total balance by summing all income and subtracting expenses.

### 5. Add Transaction Page (`lib/features/transaction/pages/add_transaction_page.dart`)

The `AddTransactionPage` widget provides a form for users to input transaction details:

- **Type**: Dropdown to select between "Expense" and "Income".
- **Amount**: Text field with real-time formatting for currency.
- **Category**: Text field for the transaction category.

The form includes validation and submits the transaction to the API via the `TransactionNotifier`.

### 6. Transaction Item (`lib/utils/widgets/transaction_item.dart`)

The `TransactionItem` widget displays individual transactions in the list:

- **Dismissible**: Allows users to swipe to delete a transaction.
- **Visual Indicators**: Expenses are shown in red, and income in green.
- **Details**: Displays the category, type, date, and formatted amount.

### 7. Balance Container (`lib/utils/widgets/balance_container.dart`)

The `BalanceContainer` widget displays the total balance in a styled container at the top of the home page.

## State Management

The app uses **Riverpod** for state management:

- **Providers**: Used for dependency injection and fetching data.
- **StateNotifier**: Manages the state for adding and deleting transactions, with support for loading and error states.

## Dependencies

- **http**: For making HTTP requests to the API.
- **flutter_dotenv**: For managing environment variables, such as the API base URL.
- **flutter_riverpod**: For state management.

## Getting Started

To run this project:

1. Ensure you have Flutter installed and set up on your machine.
2. Clone this repository.
3. Run `flutter pub get` to install dependencies.
4. Create a `.env` file in the root directory and add your API base URL:
   ```
   BASE_URL=https://6966720ff6de16bde44d7056.mockapi.io/transaction
   ```
5. Run the app using `flutter run`.


