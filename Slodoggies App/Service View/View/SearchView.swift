//
//  SearchView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 24/07/25.
//

import SwiftUI

struct SearchBarView: View {

    @Binding var searchText: String

    var body: some View {
        HStack {
            Image("Search")
            TextField("Search", text: $searchText)
                .font(.custom("Outfit-Regular", size: 14))
        }
        .padding(8)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
        .padding(.horizontal)
    }
}
