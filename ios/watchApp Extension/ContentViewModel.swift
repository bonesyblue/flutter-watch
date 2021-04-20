//
//  ContentViewModel.swift
//  watchApp Extension
//
//  Created by Jonathan Bones on 20.04.21.
//

import Foundation

class ContentViewModel: ObservableObject {
    @Published var value: String = "0"
    
    func updateValue(with text: String){
        DispatchQueue.main.async {
            self.value = text
        }
    }
}
