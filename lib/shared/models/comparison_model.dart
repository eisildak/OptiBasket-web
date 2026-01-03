import 'package:freezed_annotation/freezed_annotation.dart';

part 'comparison_model.freezed.dart';
part 'comparison_model.g.dart';

@freezed
class PriceComparison with _$PriceComparison {
  const factory PriceComparison({
    required String productId,
    required String productName,
    required int quantity,
    required double yourPrice,
    required double supplierPrice,
    required double savings,
    required double savingsPercentage,
  }) = _PriceComparison;

  factory PriceComparison.fromJson(Map<String, dynamic> json) =>
      _$PriceComparisonFromJson(json);
}

@freezed
class ComparisonReport with _$ComparisonReport {
  const factory ComparisonReport({
    required String id,
    required String userId,
    required DateTime comparisonDate,
    @Default([]) List<PriceComparison> items,
    required double totalYourPrice,
    required double totalSupplierPrice,
    required double totalSavings,
    required double savingsPercentage,
    DateTime? createdAt,
  }) = _ComparisonReport;

  factory ComparisonReport.fromJson(Map<String, dynamic> json) =>
      _$ComparisonReportFromJson(json);
}

@freezed
class HistoricalComparison with _$HistoricalComparison {
  const factory HistoricalComparison({
    required DateTime date,
    required double yourPrice,
    required double supplierPrice,
    required double savings,
    required double savingsPercentage,
  }) = _HistoricalComparison;

  factory HistoricalComparison.fromJson(Map<String, dynamic> json) =>
      _$HistoricalComparisonFromJson(json);
}

@freezed
class SavingsAnalytics with _$SavingsAnalytics {
  const factory SavingsAnalytics({
    required double totalSavings,
    required double averageSavingsPercentage,
    required int totalComparisons,
    @Default([]) List<HistoricalComparison> weeklyData,
  }) = _SavingsAnalytics;

  factory SavingsAnalytics.fromJson(Map<String, dynamic> json) =>
      _$SavingsAnalyticsFromJson(json);
}
