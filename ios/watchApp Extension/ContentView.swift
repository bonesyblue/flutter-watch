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
        VStack(alignment: .center, spacing: 16) {
            Text(String(format: "Counter: %.0f", model.value.rounded()))
                .font(.title2)
            Slider(value: $model.value, in: 0...999)
            Button(action: model.postValue, label: {
                Text("Update")
                    .foregroundColor(.white)
                    .padding()
            })
            .background(Color.blue)
            .clipShape(Capsule())
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(model: ContentViewModel())
    }
}
