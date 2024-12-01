class HistoryRequest {
  final String fromCurrency;
  final String toCurrency;
  final String startDate;
  final String endDate;

  const HistoryRequest({
    required this.fromCurrency,
    required this.toCurrency,
    required this.startDate,
    required this.endDate,
  });
}
