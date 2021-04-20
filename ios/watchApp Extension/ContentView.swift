//
//  ContentView.swift
//  watchApp Extension
//
//  Created by Jonathan Bones on 19.04.21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var model: ContentViewModel
    
    var body: some View {
        Text(model.value)
            .padding()
            .foregroundColor(.blue)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(model: ContentViewModel())
    }
}
