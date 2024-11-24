//
//  CustomBottomBar.swift
//  brichios
//
//  Created by Mac Mini 2 on 24/11/2024.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case house          // "house" existe
    case wallet = "banknote" 
    case person
    case bank = "building.columns"
    case gearshape
}


struct CustomBottomBar: View {
    @Binding var selectedTab: Tab
    private var fillImage: String {
        selectedTab.rawValue + ".fill"
    }
    private var tabColor: Color {
        switch selectedTab {
        case .house:
            return .blue
        case .wallet:
            return .indigo
        case .person:
            return .purple
        case .bank:
            return .green
        case .gearshape:
            return .orange
        }
    }
    
    
    var body: some View {
        VStack {
            HStack {
                ForEach(Tab.allCases, id: \.rawValue) { tab in
                    Spacer()
                    Image(systemName: selectedTab == tab ? fillImage : tab.rawValue)
                        .scaleEffect(tab == selectedTab ? 1.25 : 1.0)
                        .foregroundColor(tab == selectedTab ? tabColor : .gray)
                        .font(.system(size: 20))
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.1)) {
                                selectedTab = tab
                            }
                        }
                    Spacer()
                }
            }
            .frame(width: nil, height: 60)
            .background(.ultraThinMaterial)
            .cornerRadius(20)
            .padding()
        }
        .background(Color.clear) // Ajoutez ceci
        .ignoresSafeArea(.all) // Et ceci si nécessaire
    }
}

struct CustomBottomBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomBottomBar(selectedTab: .constant(.house))
    }
}
