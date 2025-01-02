//
//  SegmentPicker.swift
//  GymP
//
//  Created by Elias Osarumwense on 21.08.24.
//

import SwiftUI

struct SegmentPicker: View {
    let titles: [String]
    @State var selectedIndex: Int = 0

    var body: some View {
        SegmentedPicker(
            titles,
            selectedIndex: Binding(
                get: { selectedIndex },
                set: { selectedIndex = $0 ?? 0 }),
            content: { item, isSelected in
                Text(item)
                    .foregroundColor(isSelected ? Color.black : Color.gray)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
            },
            selection: {
                VStack(spacing: 0) {
                    Spacer()
                    Rectangle()
                        .fill(Color.black)
                        .frame(height: 1)
                }
            })
            .animation(.easeInOut(duration: 0.3), value: selectedIndex)
    }
}

struct SegmentPicker_Previews: PreviewProvider {
    static var previews: some View {
        SegmentPicker(titles: ["Option 1", "Option 2", "Option 3"])
    }
}

public struct SegmentedPicker<Element, Content, Selection>: View where Content: View, Selection: View {
    
    public typealias Data = [Element]
    
    @State private var segmentSizes: [Data.Index: CGSize] = [:]
    @Binding private var selectedIndex: Data.Index?
    
    private let data: Data
    private let selection: () -> Selection
    private let content: (Data.Element, Bool) -> Content
    private let selectionAlignment: VerticalAlignment
    
    public init(_ data: Data,
                selectedIndex: Binding<Data.Index?>,
                selectionAlignment: VerticalAlignment = .center,
                @ViewBuilder content: @escaping (Data.Element, Bool) -> Content,
                @ViewBuilder selection: @escaping () -> Selection) {
        
        self.data = data
        self.content = content
        self.selection = selection
        self._selectedIndex = selectedIndex
        self.selectionAlignment = selectionAlignment
    }
    
    public var body: some View {
        ZStack(alignment: Alignment(horizontal: .horizontalCenterAlignment, vertical: selectionAlignment)) {
            selectionView
            segmentsView
        }
    }
    
    // Break the selection view into a separate subview
    private var selectionView: some View {
        if let index = selectedIndex {
            return AnyView(selection()
                .frame(width: selectionSize(at: index).width, height: selectionSize(at: index).height)
                .alignmentGuide(.horizontalCenterAlignment) { dimensions in
                    dimensions[HorizontalAlignment.center]
                }
            )
        } else {
            return AnyView(EmptyView())
        }
    }
    
    // Break the segments view into a separate subview
    private var segmentsView: some View {
        HStack(spacing: 0) {
            ForEach(data.indices, id: \.self) { index in
                segmentButton(for: index)
            }
        }
    }

    // Extract the segment button to simplify the ForEach block
    private func segmentButton(for index: Int) -> some View {
        Button(action: { selectedIndex = index }) {
            content(data[index], selectedIndex == index)
        }
        .buttonStyle(PlainButtonStyle())
        .background(segmentBackground(for: index))  // Use a helper for background
        .alignmentGuide(.horizontalCenterAlignment) { _ in
            selectedIndex == index ? 0 : CGFloat.infinity
        }
    }

    // Extract the background with GeometryReader and Preference handling
    private func segmentBackground(for index: Int) -> some View {
        GeometryReader { proxy in
            Color.clear
                .preference(key: SegmentSizePreferenceKey.self, value: SegmentSize(index: index, size: proxy.size))
        }
        .onPreferenceChange(SegmentSizePreferenceKey.self) { segment in
            segmentSizes[segment.index] = segment.size
        }
    }
    private func selectionSize(at index: Data.Index) -> CGSize {
        segmentSizes[index] ?? .zero
    }
}

private extension SegmentedPicker {
    struct SegmentSize: Equatable {
        let index: Int
        let size: CGSize
    }
    
    struct SegmentSizePreferenceKey: PreferenceKey {
        static var defaultValue: SegmentSize { SegmentSize(index: .zero, size: .zero) }
        
        static func reduce(value: inout SegmentSize, nextValue: () -> SegmentSize) {
            value = nextValue()
        }
    }
}

private extension HorizontalAlignment {
    private enum CenterAlignment: AlignmentID {
        static func defaultValue(in d: ViewDimensions) -> CGFloat {
            d[HorizontalAlignment.center]
        }
    }

    static let horizontalCenterAlignment = HorizontalAlignment(CenterAlignment.self)
}
