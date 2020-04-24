//
//  KeyBoardAdaptive.swift
//  Honk-Frontend
//
//  Created by Nicholas O'Leary on 4/18/20.
//  Copyright © 2020 Grant Berman. All rights reserved.
//

import SwiftUI
import Combine

struct KeyBoardAdaptive: ViewModifier {
        @State private var keyBoardHeight: CGFloat = 0

    func body(content : Content) -> some View {
        content
            .padding(.bottom, keyBoardHeight)
            .onReceive(Publishers.keyboardHeight) {self.keyBoardHeight = $0}
            
    }
}

extension View{
    func keyBoardAdaptive() -> some View {
        ModifiedContent(content: self, modifier: KeyBoardAdaptive())
    }
}


