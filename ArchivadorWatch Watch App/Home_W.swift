//
//  Home_W.swift
//  ArchivadorWatch Watch App
//
//  Created by Yorjandis Garcia on 18/3/24.
//

import SwiftUI

struct Home_W: View {
    
    @State private var SelectedPage = 1
    
    var body: some View {
        ZStack {
            Color(.fondo)
                .ignoresSafeArea()
            
            TabView(selection: $SelectedPage, content: {
                
                NavigationStack{
                    home()
                }.tag(1)
                
                NavigationStack{
                    ListCatgoriasView_W()
                    //.ignoresSafeArea()
                }.tag(2)
                
                NavigationStack{
                    ListEntradasViews_W(categoria: nil)
                    //.ignoresSafeArea()
                }.tag(3)
                
                
            })
            .tabViewStyle(.page)
            
        }
    }
    
    @ViewBuilder
    func home()-> some View{
         VStack{
             VStack{
                 HStack{
                     Button("Categorías..."){
                         withAnimation {
                             self.SelectedPage = 2
                         }
                     }
                     NavigationLink{
                         AddCateg_W()
                     }label: {
                         Circle()
                             .foregroundColor(.orange)
                             .frame(width: 50, height: 50)
                             
                             .overlay {
                                 Image(systemName: "plus").foregroundColor(.black).bold()
                             }
                     }.buttonStyle(PlainButtonStyle())
                 }
                 HStack{
                     Button("Entradas..."){
                         withAnimation {
                             self.SelectedPage = 3
                         }
                     }
                     NavigationLink{
                         AddEntrada_W()
                     }label: {
                         Circle()
                             .foregroundColor(.orange)
                             .frame(width: 50, height: 50)
                             .overlay {
                                 Image(systemName: "plus").foregroundColor(.black).bold()
                             }
                     }.buttonStyle(PlainButtonStyle())
                 }
             }
        }
         .navigationTitle("Archivador")
    }
}

#Preview {
    Home_W()
}
