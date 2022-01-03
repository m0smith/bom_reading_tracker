/// Gauge chart example, where the data does not cover a full revolution in the
/// chart.
///
import "dart:math" show pi;
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class PersonalProgressChart extends StatefulWidget {
  List<charts.Series<GaugeSegment, String>> seriesList;

  PersonalProgressChart(totalChapters, chaptersRead, {Key? key})
      : seriesList = [
          charts.Series<GaugeSegment, String>(
            id: 'Segments',
            domainFn: (GaugeSegment segment, _) => segment.segment,
            measureFn: (GaugeSegment segment, _) => segment.size,
            data: [
              GaugeSegment('Complete', chaptersRead),
              // GaugeSegment('Acceptable', 100),
              // GaugeSegment('High', 50),
              GaugeSegment('Remaining', totalChapters - chaptersRead),
            ],
          )
        ],
        super(key: key);

  /// Creates a [PieChart] with sample data and no transition.
  factory PersonalProgressChart.withSampleData() {
    return PersonalProgressChart(
      56,
      100,
    );
  }

  @override
  State<PersonalProgressChart> createState() => _PersonalProgressChartState();

  /// Create one series with sample hard coded data.
  static List<charts.Series<GaugeSegment, String>> _createSampleData() {
    final data = [
      GaugeSegment('Complete', 75),
      GaugeSegment('Remaining', 5),
    ];

    return [
      charts.Series<GaugeSegment, String>(
        id: 'Segments',
        domainFn: (GaugeSegment segment, _) => segment.segment,
        measureFn: (GaugeSegment segment, _) => segment.size,
        data: data,
      )
    ];
  }
}

class _PersonalProgressChartState extends State<PersonalProgressChart> {
  final bool? animate = true;

  @override
  Widget build(BuildContext context) {
    return charts.PieChart<Object>(widget.seriesList,
        animate: animate,
        // Configure the width of the pie slices to 30px. The remaining space in
        // the chart will be left as a hole in the center. Adjust the start
        // angle and the arc length of the pie so it resembles a gauge.
        defaultRenderer: charts.ArcRendererConfig(
            arcWidth: 30, startAngle: 4 / 5 * pi, arcLength: 7 / 5 * pi),
    );
  }
}

/// Sample data type.
class GaugeSegment {
  final String segment;
  final int size;

  GaugeSegment(this.segment, this.size);
}
