import 'dart:math';
import 'dart:ui';

import 'package:bastionweb/widgets/fields/titledcard.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateIntervalWidget extends StatefulWidget {
  const DateIntervalWidget(
      {super.key,
      required this.selectDateRange,
      this.title = 'Период:',
      this.dateFormat = 'dd/MM/yyyy'});

  final void Function(DateTimeRange dateTime) selectDateRange;
  final String title;
  final String dateFormat;

  @override
  State<StatefulWidget> createState() => _DateIntervalWidgetState();
}

class _DateIntervalWidgetState extends State<DateIntervalWidget> {
  DateTimeRange currentDateRange =
      DateTimeRange(start: DateTime.now(), end: DateTime.now());

  @override
  Widget build(BuildContext context) {
    //print(Theme.of(context).primaryColor);
    return Container(
        padding: const EdgeInsets.all(8),
        constraints: BoxConstraints(
            maxWidth: contentLength().toDouble(), maxHeight: 100),
        child: MediaQuery.of(context).size.width < contentLength()
            ? TitledCard(
                color: Theme.of(context).primaryColorDark,
                title: "Период действия пропуска",
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                          style: ButtonStyle(
                              side: MaterialStatePropertyAll<BorderSide>(
                                  BorderSide(
                                      width: 2,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary))),
                          onPressed: () => dateTimeRangePicker(context),
                          child: Text(
                            "${DateFormat(widget.dateFormat, "ru").format(currentDateRange.start)}"
                            "  -  "
                            "${DateFormat(widget.dateFormat, "ru").format(currentDateRange.end)}",
                            style: Theme.of(context).textTheme.headlineSmall,
                          ))
                    ]))
            : TitledCard(
                color: Theme.of(context).primaryColorDark,
                title: "Период действия пропуска",
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(flex: 5,
                          child: SelectableText(
                              "${DateFormat(widget.dateFormat, "ru").format(currentDateRange.start)}"
                              "  -  "
                              "${DateFormat(widget.dateFormat, "ru").format(currentDateRange.end)}",
                              style:
                                  Theme.of(context).textTheme.headlineSmall)),
                      Flexible(flex: 1,
                          child: IconButton(
                              color: Theme.of(context).primaryColorDark,
                              hoverColor: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.5),
                              splashRadius: 20,
                              onPressed: () => dateTimeRangePicker(context),
                              icon: const Icon(Icons.edit))),
                      /*
                TextButton(
                    style: ButtonStyle(
                        side: MaterialStatePropertyAll<BorderSide>(BorderSide(
                            width: 2,
                            color: Theme.of(context).colorScheme.primary))),
                    onPressed: () => dateTimeRangePicker(context),
                    child: Text(
                      "${DateFormat(widget.dateFormat, "ru").format(currentDateRange.start)}"
                      "  -  "
                      "${DateFormat(widget.dateFormat, "ru").format(currentDateRange.end)}",
                      style: Theme.of(context).textTheme.headlineSmall,
                    )) */
                    ])));
  }

  void updateRange(DateTimeRange dateTimeRange) {
    setState(() {
      widget.selectDateRange(dateTimeRange);
      currentDateRange = dateTimeRange;
    });
  }

  dateTimeRangePicker(BuildContext context) async {
    DateTimeRange? picked = await showDateRangePicker(
        initialEntryMode: DatePickerEntryMode.input,
        context: context,
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 30),
        initialDateRange: DateTimeRange(
          end: DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day + 13),
          start: DateTime.now(),
        ),
        builder: (context, child) {
          return Column(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: 500.0,
                    maxHeight: MediaQuery.of(context).size.height - 20),
                child: child,
              )
            ],
          );
        });
    picked != null ? {updateRange(picked)} : {};
  }

  int contentLength() =>
      (widget.title +
              DateFormat(widget.dateFormat, "ru")
                  .format(currentDateRange.start) +
              DateFormat(widget.dateFormat, "ru")
                  .format(currentDateRange.start))
          .length *
      15;
}

class BorderWithLabel extends CustomPainter {
  BorderWithLabel({required this.color, required this.title, this.width = 8.0});

  final Color color;
  final String title;
  final double width;

  @override
  void paint(Canvas canvas, Size size) {
    TextStyle textStyle = TextStyle(
        fontSize: width * 4, color: color, fontWeight: FontWeight.bold);
    final textSpan = TextSpan(
      text: title,
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    final paint = Paint()
      ..color = color
      ..strokeWidth = width
      ..style = PaintingStyle.stroke;
    final xCenter = (size.width - textPainter.width) / 6;
    final yCenter = (-width / 2);
    final offset = Offset(xCenter, yCenter);
    textPainter.paint(canvas, offset);
    Path path = Path()
      ..moveTo(width, width / 2)
      ..lineTo((size.width - textPainter.width) / 6, width / 2)
      ..moveTo(
          ((size.width - textPainter.width) / 6) + textPainter.width, width / 2)
      ..lineTo(size.width - width, width / 2)
      ..arcTo(
          Rect.fromPoints(Offset(size.width - width * 2, width / 2),
              Offset(size.width - width / 2, width)),
          1.5 * pi,
          0.5 * pi,
          true)
      ..lineTo(size.width - width / 2, size.height - width)
      ..arcTo(
          Rect.fromPoints(
              Offset(size.width - width / 2, size.height - width * 2),
              Offset(size.width - width * 2, size.height - width / 2)),
          0.0 * pi,
          0.5 * pi,
          true)
      ..lineTo(width / 2, size.height - width / 2)
      ..arcTo(
          Rect.fromPoints(Offset(width * 2, size.height - width / 2),
              Offset(width / 2, size.height - width * 2)),
          0.5 * pi,
          0.5 * pi,
          true)
      ..lineTo(width / 2, width / 2)
      ..arcTo(
          Rect.fromPoints(Offset(width / 2, width), Offset(width, width / 2)),
          1.0 * pi,
          0.5 * pi,
          true)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(BorderWithLabel oldDelegate) => true;
}
