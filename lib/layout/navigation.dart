import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../components/icon.dart';
import '../data/site_data.dart';
import '../interop/browser.dart';

/// The off-canvas menu and the hamburger that opens it.
class Navigation extends StatefulComponent {
  const Navigation({required this.onSectionChanged, super.key});

  /// Reports the index of the section the menu scrolled to, so the layout's
  /// wheel handler continues from the right place.
  final void Function(int index) onSectionChanged;

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  bool _show = false;

  void _navigate(int index) {
    setState(() => _show = false);
    scrollToElement(
      sectionIds[index],
      onEnd: () => component.onSectionChanged(index),
    );
  }

  @override
  Component build(BuildContext context) {
    return div([
      div(classes: 'opener', [
        Icon(
          faBars,
          classes: 'closeNav',
          events: events(onClick: () => setState(() => _show = true)),
        ),
      ]),
      div(classes: 'navigation${_show ? ' active' : ''}', [
        Icon(
          faTimes,
          classes: 'closeNav',
          events: events(onClick: () => setState(() => _show = false)),
        ),
        div(classes: 'logo', [
          img(src: 'img/LucasLogo.png', alt: 'logo'),
        ]),
        div(classes: 'links', [
          ul([
            for (var i = 0; i < sectionLabels.length; i++)
              li([
                button(
                  onClick: () => _navigate(i),
                  [.text(sectionLabels[i])],
                ),
              ]),
          ]),
        ]),
      ]),
    ]);
  }
}
