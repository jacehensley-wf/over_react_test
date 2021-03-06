// Copyright 2017 Workiva Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:html';

import 'package:over_react/over_react.dart';
import 'package:test/test.dart';
import 'package:over_react_test/over_react_test.dart';

/// Main entry point for DomUtil testing
main() {
  group('mount: renders the given instance', () {
    group('attached to the document', () {
      group('and unmounts after the test is done', () {
        TestJacket jacket;

        setUp(() {
          expect(document.body.children, isEmpty);
        });

        tearDown(() {
          expect(document.body.children, isEmpty);
          expect(jacket.getInstance().isMounted(), isFalse);

          jacket = null;
        });

        test('with the given container', () {
          var mountNode = new DivElement();
          jacket = mount(Sample()(), attachedToDocument: true, mountNode: mountNode);

          expect(document.body.children[0], mountNode);
          expect(jacket.getInstance().isMounted(), isTrue);
          expect(mountNode.children[0], jacket.getNode());
        });

        test('without the given container', () {
          jacket = mount(Sample()(), attachedToDocument: true);

          expect(jacket.getInstance().isMounted(), isTrue);
          expect(document.body.children[0].children[0], jacket.getNode());
        });
      });

      group('and does not unmount after the test is done', () {
        TestJacket jacket;

        setUp(() {
          expect(document.body.children, isEmpty);
        });

        tearDown(() {
          expect(document.body.children, isNotEmpty);
          expect(jacket.getInstance().isMounted(), isTrue);

          jacket.unmount();

          expect(document.body.children, isEmpty);
          expect(jacket.getInstance().isMounted(), isFalse);

          jacket = null;
        });

        test('with the given container', () {
          var mountNode = new DivElement();
          jacket = mount(Sample()(), attachedToDocument: true, mountNode: mountNode, autoTearDown: false);

          expect(document.body.children[0], mountNode);
          expect(jacket.getInstance().isMounted(), isTrue);
          expect(mountNode.children[0], jacket.getNode());
        });

        test('without the given container', () {
          jacket = mount(Sample()(), attachedToDocument: true, autoTearDown: false);

          expect(jacket.getInstance().isMounted(), isTrue);
          expect(document.body.children[0].children[0], jacket.getNode());
        });
      });
    });

    group('not attached to the document', () {
      group('and unmounts after the test is done', () {
        TestJacket jacket;

        setUp(() {
          expect(document.body.children, isEmpty);
        });

        tearDown(() {
          expect(document.body.children, isEmpty);
          expect(jacket.getInstance().isMounted(), isFalse);

          jacket = null;
        });

        test('with the given container', () {
          var mountNode = new DivElement();
          jacket = mount(Sample()(), mountNode: mountNode);

          expect(document.body.children, isEmpty);
          expect(jacket.getInstance().isMounted(), isTrue);
          expect(mountNode.children[0], jacket.getNode());
        });

        test('without the given container', () {
          jacket = mount(Sample()());

          expect(jacket.getInstance().isMounted(), isTrue);
        });
      });

      group('and does not unmount after the test is done', () {
        TestJacket jacket;

        setUp(() {
          expect(document.body.children, isEmpty);
        });

        tearDown(() {
          expect(document.body.children, isEmpty);
          expect(jacket.getInstance().isMounted(), isTrue);

          jacket.unmount();

          expect(document.body.children, isEmpty);
          expect(jacket.getInstance().isMounted(), isFalse);

          jacket = null;
        });

        test('with the given container', () {
          var mountNode = new DivElement();
          jacket = mount(Sample()(), mountNode: mountNode, autoTearDown: false);

          expect(document.body.children.isEmpty, isTrue);
          expect(jacket.getInstance().isMounted(), isTrue);
          expect(mountNode.children[0], jacket.getNode());
        });

        test('without the given container', () {
          jacket = mount(Sample()(), autoTearDown: false);

          expect(document.body.children, isEmpty);
          expect(jacket.getInstance().isMounted(), isTrue);
        });
      });
    });
  });

  group('TestJacket:', () {
    TestJacket<SampleComponent> jacket;

    setUp(() {
      var mountNode = new DivElement();
      jacket = mount<SampleComponent>((Sample()..addTestId('sample'))(),
          mountNode: mountNode,
          attachedToDocument: true
      );

      expect(Sample(jacket.getProps()).foo, isFalse);
      expect(jacket.getDartInstance().state.bar, isFalse);
    });

    test('rerender', () {
      jacket.rerender((Sample()..foo = true)());

      expect(Sample(jacket.getProps()).foo, isTrue);
    });

    test('getProps', () {
      expect(jacket.getProps(), getProps(jacket.getInstance()));
    });

    test('getNode', () {
      expect(jacket.getNode(), findDomNode(jacket.getInstance()));
    });

    test('getDartInstance', () {
      expect(jacket.getDartInstance(), getDartComponent(jacket.getInstance()));
    });

    test('setState', () {
      jacket.setState(jacket.getDartInstance().newState()..bar = true);

      expect(jacket.getDartInstance().state.bar, isTrue);
    });

    test('unmount', () {
      expect(jacket.getInstance().isMounted(), isTrue);

      jacket.unmount();

      expect(jacket.getInstance().isMounted(), isFalse);
    });
  });
}

@Factory()
UiFactory<SampleProps> Sample;

@Props()
class SampleProps extends UiProps {
  bool foo;
}

@State()
class SampleState extends UiState {
  bool bar;
}

@Component()
class SampleComponent extends UiStatefulComponent<SampleProps, SampleState> {
  @override
  Map getDefaultProps() => (newProps()..foo = false);

  @override
  Map getInitialState() => (newState()..bar = false);

  @override
  render() {
    return Dom.div()();
  }
}
