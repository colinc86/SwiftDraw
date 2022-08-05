//
//  XML.FormatterTests.swift
//  SwiftDraw
//
//  Created by Simon Whitty on 27/02/22.
//  Copyright 2022 Simon Whitty
//
//  Distributed under the permissive zlib license
//  Get the latest version from here:
//
//  https://github.com/swhitty/SwiftDraw
//
//  This software is provided 'as-is', without any express or implied
//  warranty.  In no event will the authors be held liable for any damages
//  arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//  claim that you wrote the original software. If you use this software
//  in a product, an acknowledgment in the product documentation would be
//  appreciated but is not required.
//
//  2. Altered source versions must be plainly marked as such, and must not be
//  misrepresented as being the original software.
//
//  3. This notice may not be removed or altered from any source distribution.
//

@testable import SwiftDraw
import XCTest

final class XMLFormatterTests: XCTestCase {

    func testAA() {
        let formatter = XML.Formatter(spaces: 2)

        let element = XML.Element(
            name: "draw",
            attributes: ["zlevel": "2", "color": "Red&Back"]
        )

        element.children.append(.init(name: "circle"))

        XCTAssertEqual(
            formatter.encodeElement(element),
            """
            <draw color="Red&amp;Back" zlevel="2">
              <circle />
            </draw>
            """
        )
    }

    func testBB() throws {
        let url = try Bundle.test.url(forResource: "gradient-gratification.svg")
        let svg = try DOM.SVG.parse(fileURL: url)

        let element = XML.Formatter.SVG.makeElement(from: svg)
        let formatter = XML.Formatter(spaces: 2)

        XCTAssertEqual(
            formatter.encodeRootElement(element),
            """
            <?xml version="1.0" encoding="UTF-8"?>
            <svg height="352" width="480" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
              <defs>
                <linearGradient id="violet" x1="0.0" x2="1.0" y1="1.0" y2="1.0" />
                <linearGradient id="magenta" x1="0.0" x2="1.0" y1="1.0" y2="1.0" />
                <linearGradient id="spread" x1="0.0" x2="0.0" y1="0.0" y2="1.0" />
                <rect id="frame" height="256.0" width="256.0" x="112.0" y="48.0" />
              </defs>
              <rect fill="url(#checkerboard)" height="352.0" width="480.0" x="0.0" y="0.0" />
              <use fill="url(#magenta)" xlink:href="#frame" />
              <use fill="url(#violet)" mask="url(#fade)" xlink:href="#frame" />
            </svg>
            """
        )
    }

    func testSymbol() throws {
        let url = try Bundle.test.url(forResource: "symbol-test.svg")
        let svg = try DOM.SVG.parse(fileURL: url)

        let element = XML.Formatter.SVG.makeElement(from: svg)
        let formatter = XML.Formatter(spaces: 2)

        XCTAssertEqual(
            formatter.encodeRootElement(element),
            """
            <?xml version="1.0" encoding="UTF-8"?>
            <svg viewBox="0.0 0.0 550.0 550.0" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
              <defs>
                <path id="A" d="M0.0,69.755 L2.685,69.755 L28.369,3.287 L29.052,3.287 L29.052,0.0 L27.148,0.0 L0.0,69.755 Z M10.693,45.536 L45.996,45.536 L45.263,43.313 L11.474,43.313 L10.693,45.536 Z M54.15,69.755 L56.787,69.755 L29.638,0.0 L28.466,0.0 L28.466,3.287 L54.15,69.755 Z" fill="rgb(39, 170, 225)" />
              </defs>
              <g id="Notes" font-family="LucidaGrande, 'Lucida Grande', sans-serif" font-size="13.0">
                <text x="18.0" y="126.0">Small</text>
                <text x="18.0" y="320.0">Medium</text>
                <text x="18.0" y="517.0">Large</text>
              </g>
              <g id="Guides" stroke="rgb(39, 170, 225)" stroke-width="0.5">
                <path id="Capline-S" d="M18.0,26.0 l500.0,0.0" />
                <use x="95.0" xlink:href="#A" y="26.0" />
                <path id="Baseline-S" d="M18.0,96.0 l500.0,0.0" />
                <path id="Capline-M" d="M18.0,220.0 l500.0,0.0" />
                <use x="95.0" xlink:href="#A" y="220.0" />
                <path id="Baseline-M" d="M18.0,290.0 l500.0,0.0" />
                <path id="Capline-L" d="M18.0,417.0 l500.0,0.0" />
                <use x="95.0" xlink:href="#A" y="417.0" />
                <path id="Baseline-L" d="M18.0,487.0 l500.0,0.0" />
                <path id="left-margin-Regular-M" d="M256.0,195.0 l0.0,120.0" />
                <path id="right-margin-Regular-M" d="M373.0,195.0 l0.0,120.0" />
              </g>
              <g id="Regular-M">
                <path d="M285.854,236.968 L285.854,257.0591 C285.854,276.55 301.654,292.351 321.145,292.351 M301.019,252.0174 L285.894,236.892 L270.769,252.0174 M346.434,272.144 L346.434,252.0577 C346.434,232.567 330.634,216.766 311.143,216.766 M331.269,257.0591 L346.394,272.184 L361.519,257.0591" fill="none" stroke="rgb(33, 33, 33)" stroke-linecap="round" stroke-linejoin="round" stroke-width="10.0" />
              </g>
            </svg>
            """
        )
    }

    func testPairedSequence() {
        XCTAssertEqual(
            ["a", "b", "c", "d"].paired(with: .nextSkippingLast).map { "\($0)\($1)" },
            ["ab", "bc", "cd"]
        )

        XCTAssertEqual(
            ["a", "b", "c", "d"].paired(with: .nextWrappingToFirst).map { "\($0)\($1)" },
            ["ab", "bc", "cd", "da"]
        )

        XCTAssertEqual(
            ["a", "b"].paired(with: .nextSkippingLast).map { "\($0)\($1)" },
            ["ab"]
        )

        XCTAssertEqual(
            ["a", "b"].paired(with: .nextWrappingToFirst).map { "\($0)\($1)" },
            ["ab", "ba"]
        )

        XCTAssertEqual(
            ["a"].paired(with: .nextSkippingLast).map { "\($0)\($1)" },
            []
        )

        XCTAssertEqual(
            ["a"].paired(with: .nextWrappingToFirst).map { "\($0)\($1)" },
            []
        )

        XCTAssertEqual(
            [].paired(with: .nextSkippingLast).map { "\($0)\($1)" },
            []
        )

        XCTAssertEqual(
            [].paired(with: .nextWrappingToFirst).map { "\($0)\($1)" },
            []
        )
    }

    func testEvenOddPathDirection() throws {
        let pathData = """
        M12 22C6.47715 22 2 17.5228 2 12C2 6.47715 6.47715 2 12 2C17.5228 2 22 6.47715 22 12C22 17.5228 17.5228 22 12 22Z
        M12 13C11.4477 13 11 12.5523 11 12V8C11 7.44772 11.4477 7 12 7C12.5523 7 13 7.44772 13 8V12C13 12.5523 12.5523 13 12 13
        ZM13 17H11V15H13V17Z
        """
        let domPath = try XMLParser().parsePath(from: pathData)
        let layerPath = try LayerTree.Builder.createPath(from: domPath)

        XCTAssertEqual(
            layerPath.subPaths().map(\.direction),
            [.clockwise, .clockwise, .clockwise]
        )
    }

    func testNonZeroDirection() throws {
        let pathData = """
        M12,22C17.523,22 22,17.523 22,12C22,6.477 17.523,2 12,2C6.477,2 2,6.477 2,12C2,17.523 6.477,22 12,22ZM13,17L11,17L11,15L13,15L13,17ZM12,13C11.448,13 11,12.552 11,12L11,8C11,7.448 11.448,7 12,7C12.552,7 13,7.448 13,8L13,12C13,12.552 12.552,13 12,13Z
        """
        let domPath = try XMLParser().parsePath(from: pathData)
        let layerPath = try LayerTree.Builder.createPath(from: domPath)

        XCTAssertEqual(
            layerPath.subPaths().map(\.direction),
            [.anticlockwise, .clockwise, .clockwise]
        )
    }

    func testEvenOdd() throws {
        let pathData = """
        M 75 100
        l 50 -50 l 50 50 l -50 50 Z
        m 25 0
        l 25 -25 l 25 25 l -25 25 Z
        m 10 0
        l 15 -15 l 15 15 l -15 15 Z
        m 10 0
        l 5 -5 l 5 5 l -5 5 Z
        M 225 100
        l 50 -50 l 50 50 l -50 50 Z
        m 25 0
        l 25 -25 l 25 25 l -25 25 Z
        m 10 0
        l 15 -15 l 15 15 l -15 15 Z
        m 10 0
        l 5 -5 l 5 5 l -5 5 Z
        """
        let domPath = try XMLParser().parsePath(from: pathData)
        let layerPath = try LayerTree.Builder.createPath(from: domPath)

        let paths = MyPath.make(from: layerPath)
        print(paths.count)
        print(paths[0].inside.count)
        print(paths[1].inside.count)
    }

    func testNonZero() throws {
        let pathData = """
        M 75 100
        l 50 -50 l 50 50 l -50 50 Z
        m 25 0
        l 25 25 l 25 -25 l -25 -25 Z
        m 10 0
        l 15 15 l 15 -15 l -15 -15 Z
        m 10 0
        l 5 -5 l 5 5 l -5 5 Z
        M 225 100
        l 50 -50 l 50 50 l -50 50 Z
        m 25 0
        l 25 25 l 25 -25 l -25 -25 Z
        m 10 0
        l 15 15 l 15 -15 l -15 -15 Z
        m 10 0
        l 5 -5 l 5 5 l -5 5 Z
        """
        let domPath = try XMLParser().parsePath(from: pathData)
        let layerPath = try LayerTree.Builder.createPath(from: domPath)

        let paths = MyPath.make(from: layerPath)
        print(paths.count)
        print(paths[0].inside.count)
        print(paths[1].inside.count)

        print(paths[0].inside[0].inside.count)
        print(paths[0].inside[0].inside[0].inside.count)
    }
}

extension LayerTree.Path {

    func subPaths() -> [ArraySlice<Segment>] {
        segments.split(separator: .close)
    }
}

extension Array where Element == LayerTree.Point {
    func isPointInside(_ test: LayerTree.Point) -> Bool {
        var j: Int = count - 1
        var contains = false

        for i in indices {
            if (((self[i].y < test.y && self[j].y >= test.y) || (self[j].y < test.y && self[i].y >= test.y))
                && (self[i].x <= test.x || self[j].x <= test.x)) {
                contains = contains != (self[i].x + (test.y - self[i].y) / (self[j].y - self[i].y) * (self[j].x - self[i].x) < test.x)
            }

            j = i
        }

        if !contains {
            print("****")
            print("polygon", self.map { $0.stringValue })
            print("point", test.stringValue, contains)
            print("****")
        }

        return contains
    }
}

struct MyPath {
    var segments: ArraySlice<LayerTree.Path.Segment>
    var inside: [MyPath] = []

    func bounds(segments: ArraySlice<LayerTree.Path.Segment>) -> Bool {
        let outer = self.segments.compactMap(\.location)
        let inner = segments.compactMap(\.location)
        guard !inner.isEmpty else { return false }

        for p in inner {
            if !outer.isPointInside(p) {
                return false
            }
        }

        return true
    }

    mutating func appendPath(_ p: MyPath) {
        for (idx, path) in inside.enumerated() {
            if path.bounds(segments: p.segments) {
                inside[idx].appendPath(p)
                return
            }
        }
        inside.append(p)
    }

    static func make(from path: LayerTree.Path) -> [MyPath] {
        var paths = [MyPath]()
        for segments in path.segments.split(separator: .close) {
            paths.append(segments: segments)
        }
        return paths
    }
}

private extension Array where Element == MyPath {

    mutating func append(segments: ArraySlice<LayerTree.Path.Segment>) {
        for (idx, path) in enumerated() {
            if path.bounds(segments: segments) {
                self[idx].appendPath(MyPath(segments: segments))
                return
            }
        }

        append(MyPath(segments: segments))
    }

}

private extension LayerTree.Path.Segment {

  var isMove: Bool {
    switch self {
    case .move: return true
    default: return false
    }
  }

  var location: LayerTree.Point? {
    switch self {
    case .move(to: let p): return p
    case .line(let p): return p
    case .cubic(let p, _, _): return p
    case .close: return nil
    }
  }
}

extension LayerTree.Point {
    var stringValue: String {
        "\(x), \(y)"
    }
}
