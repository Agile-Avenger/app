// report_data.dart

import 'package:flutter/foundation.dart';

class ReportData {
  static final ReportData _instance = ReportData._internal();

  factory ReportData() {
    return _instance;
  }

  ReportData._internal();

  String? imagePath;
  String? diseaseType;
  String? analysisResult;
  Map<String, dynamic>? rawReportData;
  DateTime? reportGenerationTime;
  String? scanType;

  // Additional metadata
  Map<String, dynamic>? patientInfo;
  Map<String, dynamic>? studyDetails;
  Map<String, dynamic>? analysisMetrics;

  void setReportData({
    required String imagePath,
    required String diseaseType,
    required String analysisResult,
    String? scanType,
    Map<String, dynamic>? rawData,
  }) {
    this.imagePath = imagePath;
    this.diseaseType = diseaseType;
    this.analysisResult = analysisResult;
    this.scanType = scanType;
    rawReportData = rawData;
    reportGenerationTime = DateTime.now();

    // Parse additional data if available
    if (rawData != null) {
      patientInfo = rawData['patient_info'] as Map<String, dynamic>?;
      studyDetails = rawData['study'] as Map<String, dynamic>?;
      analysisMetrics = rawData['analysis_metrics'] as Map<String, dynamic>?;
    }
  }

  void clearReportData() {
    imagePath = null;
    diseaseType = null;
    analysisResult = null;
    rawReportData = null;
    reportGenerationTime = null;
    scanType = null;
    patientInfo = null;
    studyDetails = null;
    analysisMetrics = null;
  }

  bool get hasReportData =>
      imagePath != null && diseaseType != null && analysisResult != null;
}
