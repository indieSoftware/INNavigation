
# INNavigation

Provides an easy accessor which builds on top of SwiftUI's new `NavigationStack` introduced with iOS 16.

In addition it supports a custom navigation bar which stays on screen even during view transitions.

## Overview

`INNavigation` uses SwiftUI's `NavigationStack` for navigation. However, this library provides a `Router` which provides a common interface for navigation and handles the navigation via routes. For that a hierarchy is build up for horizontal and vertical navigation.

With horizontal navigation a push/pop navigation is meant, originally provided by a `UINavigationController` and in SwiftUI' `NavigationStack`.

A vertical navigation is realized with present/dismiss actions to show or dismiss sheets. Each vertical navigation automatically introduces a new layer for a horizontal navigation.

In addition to the routing management the routing system also supports custom navigation bars which stay on screen simulating a static navigation bar which, however, can change for each screen.

## Further documentation

How to usa INNavigation: [Usage](https://github.com/indieSoftware/INNavigation/blob/master/docu/Usage.md)

