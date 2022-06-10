import 'dart:math';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SelectionCallbackExample extends StatefulWidget {
  final List<charts.Series<dynamic, DateTime>> seriesList;
  final bool animate;

  final Function(String value) notifyParent;

  SelectionCallbackExample(this.seriesList, {this.animate = false, required this.notifyParent});

  factory SelectionCallbackExample.withData(List<charts.Series<dynamic, DateTime>> seriesList, Function(String value) notifyParent){
    return SelectionCallbackExample(
      seriesList,
      // Disable animations for image tests.
      animate: true,
      notifyParent: notifyParent,
    );
  }

  // We need a Stateful widget to build the selection details with the current
  // selection as the state.
  @override
  State<StatefulWidget> createState() => _SelectionCallbackState();

}

class _SelectionCallbackState extends State<SelectionCallbackExample> {
  DateTime? _time;
  Map<String, num> _measures = {};

  // Listens to the underlying selection changes, and updates the information
  // relevant to building the primitive legend like information under the
  // chart.
  _onSelectionChanged(charts.SelectionModel model) {
    final selectedDatum = model.selectedDatum;

    DateTime? time;
    final measures = <String, num>{};

    // We get the model that updated with a list of [SeriesDatum] which is
    // simply a pair of series & datum.
    //
    // Walk the selection updating the measures map, storing off the sales and
    // series name for each selection point.
    if (selectedDatum.isNotEmpty) {
      time = selectedDatum.first.datum.time;
      selectedDatum.forEach((charts.SeriesDatum datumPair) {
        measures[datumPair.series.displayName!] = datumPair.datum.count;
      });
    }

    // Request a build.
    setState(() {
      _time = time;
      _measures = measures;
      if(time != null) {
        widget.notifyParent(DateFormat("yyyy-MM-dd").format(time));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // The children consist of a Chart and Text widgets below to hold the info.
    final children = <Widget>[
      SizedBox(
          height: 150.0,
          child: charts.TimeSeriesChart(
            widget.seriesList,
            animate: widget.animate,
            selectionModels: [
              charts.SelectionModelConfig(
                type: charts.SelectionModelType.info,
                changedListener: _onSelectionChanged,
              )
            ],
            defaultRenderer: charts.BarRendererConfig<DateTime>(),
            // It is recommended that default interactions be turned off if using bar
            // renderer, because the line point highlighter is the default for time
            // series chart.
            defaultInteractions: false,
            // If default interactions were removed, optionally add select nearest
            // and the domain highlighter that are typical for bar charts.
            behaviors: [charts.SelectNearest(), charts.DomainHighlighter()],
          )),
    ];

    // If there is a selection, then include the details.
    if (_time != null) {
      children.add(Padding(
          padding: EdgeInsets.only(top: 5.0),
          child: Text(_time.toString())));
    }
    _measures.forEach((String series, num value) {
      children.add(Text('${series}: ${value}'));
    });

    return Column(children: children);
  }
}

/// Sample time series data type.
class TimeSeriesCount {
  final DateTime time;
  final int count;

  TimeSeriesCount(this.time, this.count);
}