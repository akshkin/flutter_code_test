# flutter_code_test

## Stock Data Visualization and Notification Center
Flutter app  with 2 pages where a bottom bar is used to navigate between the two pages
- Stock Price Data Visualization: 
- Notification Center: 

### Page 1: Stock Price Data Visualization

- Fetches stock price data from the Polygon stock data API.
- Displays the data for the latest available day (found this to be 2024-10-04), in a line chart.
- Y-axis: Displays the price in the reported currency.
- X-axis: Displays the time in hh:mm format.
- Uses Apple’s stock price (ticker: AAPL) in the development environment and Nvidia’s stock price (ticker: NVDA) in the production environment.

### Page 2: Notification Center

- A notification center that pings the same endpoint every 1 minute.
- On a successful response, a simple green tick is displayed on the screen.
- In case of an error, an error report with a timestamp is displayed on the screen.

## Further improvements

- Persist Notification state

## Technologies Used

Flutter: Used for the entire frontend of the app.
fl_chart: For displaying the stock price data in a chart format.
intl: For date and time formatting.
API Integration: Fetches stock data from The Polygon stock data API.

## Testing the app
- `flutter run -t lib/main_prod.dart` for production environment
- `flutter run -t lib/main_dev.dart` for development environment



