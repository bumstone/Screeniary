//
//  SortOptionMenu.swift
//  Screeniary
//
//  Created by 고범석 on 6/20/25.
//
import SwiftUI

struct SortOptionMenu: View {
    @Binding var sortOption: SortOption
    
    var body: some View {
        Menu {
            ForEach(SortOption.allCases, id: \.self) { option in
                Button(action: { sortOption = option }) {
                    Label(option.rawValue, systemImage: option.systemImage)
                    if sortOption == option {
                        Image(systemName: "checkmark")
                    }
                }
            }
        } label: {
            HStack(spacing: 4) {
                Image(systemName: sortOption.systemImage)
                Text(sortOption.rawValue)
                Image(systemName: "chevron.down")
            }
            .foregroundColor(.blue)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.blue.opacity(0.1))
            .cornerRadius(8)
        }
    }
}
