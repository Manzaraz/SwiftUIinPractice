//
//  SpotifyRecentsCell.swift
//  SwiftUIinPractice
//
//  Created by Christian Manzaraz on 03/04/2025.
//

import SwiftUI

struct SpotifyRecentsCell: View {
    
    var imageName: String = Constants.randomImage
    var title: String = "Some radom title"
    
    var body: some View {
        HStack(spacing: 16) {
            ImageLoaderView(urlString: imageName)
                .frame(width: 55, height: 55)
            Text(title)
                .font(.callout)
                .fontWeight(.semibold)
                .lineLimit(2)
        }
            .padding(.trailing, )
            .frame(maxWidth: .infinity, alignment: .leading)
            .themeColors(isSelected: false)
            .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}

#Preview {
    
    ZStack {
        Color.black.ignoresSafeArea()
        VStack {
            HStack {
                SpotifyRecentsCell()
                SpotifyRecentsCell()
            }
            HStack {
                SpotifyRecentsCell()
                SpotifyRecentsCell()
            }
        }
    }
}
