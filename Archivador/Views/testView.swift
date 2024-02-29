//
//  testView.swift
//  Archivador
//
//  Created by Yorjandis Garcia on 28/2/24.
//

import SwiftUI
import WebKit

struct testView: View {
    
    @State var texto = ""
    
    var body: some View {
       
        VStack{
            TextField("Coloque el texto aqui", text: $texto, axis: .vertical)

           
        }
        .padding(.horizontal, 15)
        
        
    }
}



#Preview {
    testView()
}
