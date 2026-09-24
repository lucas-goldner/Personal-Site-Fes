import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../components/animation_container.dart';
import '../components/baffle_text.dart';
import '../components/hover_button.dart';
import '../data/site_data.dart';
import '../interop/email.dart';
import '../layout/metrics.dart';

/// The contact form and the map.
class Contact extends StatefulComponent {
  const Contact({super.key});

  @override
  State<Contact> createState() => _ContactState();

  /// Lines up the message box with the single-line fields above it.
  ///
  /// The ported rule gives every field the same 50px height. An input centres
  /// its one line in that box, while a textarea starts at the top of it, which
  /// left the Message placeholder sitting higher than the other three. Letting
  /// the row count drive the height gives the box its three lines, and the top
  /// padding puts the first of them where the inputs put theirs.
  @css
  static List<StyleRule> get styles => [
    css('#contact .form-container textarea').styles(
      height: .auto,
      // Left and right stay at the browser's 2px so the placeholder starts on
      // the same column as the ones above.
      padding: .only(top: 14.px, right: 2.px, bottom: 10.px, left: 2.px),
      // Dragging the corner sideways pulled the field out of its column.
      raw: {'resize': 'vertical'},
    ),
  ];
}

class _ContactState extends State<Contact> {
  String _name = '';
  String _email = '';
  String _phone = '';
  String _message = '';

  /// The status line under the form.
  String _sent = '';

  /// True once a submit was rejected for missing required fields.
  bool _error = false;

  /// Set once the rotated "Contact" heading has finished resolving.
  bool _show = false;

  /// Required fields flag up only after a failed submit, as before.
  bool _isValid(String value) => !(_error && value.isEmpty);

  Future<void> _submit() async {
    if (_name.isEmpty || _email.isEmpty || _message.isEmpty) {
      setState(() => _error = true);
      return;
    }
    setState(() {
      _error = false;
      _sent = '';
    });

    var ok = false;
    try {
      ok = await sendContactMail(
        name: _name,
        email: _email,
        phone: _phone,
        message: _message,
      );
    } catch (_) {
      ok = false;
    }
    if (!mounted) return;
    setState(() {
      _sent = ok ? 'Email sent!' : 'Sending failed, please try again.';
    });
  }

  @override
  Component build(BuildContext context) {
    final metrics = MetricsProvider.of(context);

    return section(
      id: 'contact',
      classes: 'contact',
      styles: Styles(raw: {'height': metrics.cssHeight}),
      [
        div(classes: 'row', [
          div(classes: 'side col-md-2', [
            h2([
              BaffleText(
                text: 'Contact',
                revealDuration: 500,
                revealDelay: 500,
                revealCallbackDelay: 1100,
                onRevealed: () => setState(() => _show = true),
              ),
            ]),
          ]),
          div(classes: 'form col-md-5', [_form(metrics)]),
          div(classes: 'map col-md-5', [_map(metrics)]),
        ]),
      ],
    );
  }

  bool _visible(SiteMetrics metrics) => _show || metrics.isAuto;

  Component _form(SiteMetrics metrics) {
    if (!_visible(metrics)) return const Component.empty();

    return AnimationContainer(
      delay: 0,
      animation: 'fadeInUp fast',
      children: [
        div(classes: 'form-container', [
          div(classes: 'line-text', [
            h4([.text('Get In Touch')]),
            _field(
              delay: 50,
              child: input(
                type: InputType.text,
                classes: 'name${_isValid(_name) ? '' : ' error'}',
                attributes: const {'placeholder': 'Name'},
                onInput: (String value) => _name = value,
              ),
            ),
            _field(
              delay: 100,
              child: input(
                type: InputType.text,
                classes: 'email${_isValid(_email) ? '' : ' error'}',
                attributes: const {'placeholder': 'Email'},
                onInput: (String value) => _email = value,
              ),
            ),
            _field(
              delay: 150,
              child: input(
                type: InputType.text,
                classes: 'phone',
                attributes: const {'placeholder': 'Phone'},
                onInput: (String value) => _phone = value,
              ),
            ),
            _field(
              delay: 200,
              child: textarea(
                classes: 'message${_isValid(_message) ? '' : ' error'}',
                placeholder: 'Message',
                rows: 3,
                onInput: (String value) => _message = value,
                const [],
              ),
            ),
            p(classes: 'message whiteColor', [.text(' $_sent')]),
            AnimationContainer(
              delay: 250,
              animation: 'fadeInUp fast',
              children: [
                div(classes: 'submit', [
                  HoverButton(
                    label: 'Send Message',
                    hasError: _error,
                    onClick: _submit,
                  ),
                ]),
              ],
            ),
          ]),
        ]),
      ],
    );
  }

  Component _field({required int delay, required Component child}) {
    return AnimationContainer(
      delay: delay,
      animation: 'fadeInUp fast',
      children: [
        div(classes: 'form-group', [child]),
      ],
    );
  }

  Component _map(SiteMetrics metrics) {
    if (!_visible(metrics)) return const Component.empty();

    return AnimationContainer(
      delay: 1000,
      animation: 'fadeIn fast',
      height: metrics.cssHeight,
      children: [
        iframe(
          src: mapEmbedUrl,
          attributes: const {
            'title': 'map',
            'width': '100%',
            'height': '100%',
          },
          const [],
        ),
      ],
    );
  }
}
