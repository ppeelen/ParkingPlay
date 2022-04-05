//
//  TabBar.swift
//  ParkingPlay
//
//  Created by Paul Peelen on 2022-04-05.
//

import SwiftUI

enum Tab {
    case map
    case list
}

struct TabItem: Identifiable {
    let id = UUID()
    let tab: Tab
    let title: String
    let icon: String
}

struct TabBar: View {
    @State private var selectedTab: Tab = .map

    private var tabItems: [TabItem] = [
        TabItem(tab: .map, title: "Map", icon: "map"),
        TabItem(tab: .list, title: "List", icon: "list.dash")
    ]

    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch selectedTab {
                case .map:
                    let places = [Place(lat: 59.34855106680632, long: 18.11139511272728)]
                    MapView(places: places)
                case .list:
                    ContentView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            HStack {
                ForEach(tabItems) { item in
                    Button {
                        selectedTab = item.tab
                    } label: {
                        VStack(spacing: 0) {
                            Image(systemName: item.icon)
                                .symbolVariant(.fill)
                                .font(.body.bold())
                                .frame(width: 44, height: 29)
                            Text(item.title)
                                .font(.caption2)
                                .lineLimit(1)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .foregroundStyle(selectedTab == item.tab ? .primary : .secondary)
                }
            }
            .padding(.horizontal, 8)
            .padding(.top, 6)
            .frame(height: 56, alignment: .top)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 30, style: .continuous))
            .frame(maxHeight: .infinity, alignment: .bottom)
            .ignoresSafeArea()
            .padding(.bottom, 20)
            .padding(.horizontal, 10)
        }
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TabBar()
                .previewDisplayName("Light")
                .preferredColorScheme(.light)
            TabBar()
                .previewDisplayName("Dark")
                .preferredColorScheme(.dark)
        }
    }
}
