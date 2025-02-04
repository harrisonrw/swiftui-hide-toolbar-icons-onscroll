//
//  ItemView.swift
//  HideToolbarIconsOnScroll
//
//  Created by Robert Harrison on 1/31/25.
//

import SwiftUI

struct ItemView: View {
    var item: UUID
    
    var body: some View {
        Text(item.uuidString)
            .font(.system(size: 14))
            .frame(maxWidth: .infinity)
            .padding(14)
            .foregroundColor(.black)
            .background(Color.white)
            .clipShape(
                .rect(
                    topLeadingRadius: 8,
                    bottomLeadingRadius: 8,
                    bottomTrailingRadius: 8,
                    topTrailingRadius: 8
                )
            )
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 16)
            .padding(.vertical, 4)
    }
}

#Preview {
    ItemView(item: UUID())
}
