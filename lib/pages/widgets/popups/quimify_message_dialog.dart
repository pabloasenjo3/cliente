import 'package:quimify_client/pages/widgets/objects/quimify_icon_button.dart';
import 'package:quimify_client/pages/widgets/popups/quimify_dialog.dart';
import 'package:quimify_client/pages/widgets/popups/quimify_report_dialog.dart';
import 'package:quimify_client/pages/widgets/popups/widgets/quimify_dialog_button.dart';
import 'package:quimify_client/pages/widgets/popups/widgets/quimify_dialog_content_text.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class QuimifyMessageDialog extends StatelessWidget {
  const QuimifyMessageDialog({
    super.key,
    required this.title,
    this.details,
    this.closable = true,
  })  : linkName = null,
        link = null,
        reportLabel = null,
        _hasLink = false,
        _hasReportButton = false;

  const QuimifyMessageDialog.linked({
    super.key,
    required this.title,
    this.details,
    required this.linkName,
    required this.link,
    this.closable = true,
  })  : reportLabel = null,
        _hasLink = true,
        _hasReportButton = false;

  const QuimifyMessageDialog.reportable({
    super.key,
    required this.title,
    required this.details,
    required this.reportLabel,
  })  : linkName = null,
        link = null,
        closable = true,
        _hasLink = false,
        _hasReportButton = true;

  final String title;
  final String? details;
  final String? linkName, link, reportLabel;
  final bool closable;

  final bool _hasLink, _hasReportButton;

  Future<void> show(BuildContext context) async => await showQuimifyDialog(
      context: context, closable: closable, dialog: this);

  void _exit(BuildContext context) => Navigator.of(context).pop();

  void _openLink(BuildContext context) =>
      launchUrl(Uri.parse(link!), mode: LaunchMode.externalApplication);

  void _pressedButton(BuildContext context) {
    if (_hasLink) {
      _openLink(context);
    }

    if (closable) {
      _exit(context);
    }
  }

  void _pressedReportButton(BuildContext context) {
    _exit(context);

    QuimifyReportDialog(
      details: details,
      reportLabel: reportLabel!,
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(closable),
      child: QuimifyDialog(
        title: title,
        content: details != null && details!.isNotEmpty
            ? QuimifyDialogContentText(text: details!)
            : null,
        actions: [
          Row(
            children: [
              if (_hasReportButton)
                Row(
                  children: [
                    QuimifyIconButton.square(
                      height: 50,
                      backgroundColor: Theme.of(context).colorScheme.error,
                      onPressed: () => _pressedReportButton(context),
                      icon: Image.asset(
                        'assets/images/icons/report.png',
                        width: 20,
                        color: Theme.of(context).colorScheme.onError,
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              Expanded(
                child: QuimifyDialogButton(
                  onPressed: () => _pressedButton(context),
                  text: _hasLink ? linkName! : 'Entendido',
                ),
              ),
            ],
          ),
        ],
        closable: closable,
      ),
    );
  }
}
