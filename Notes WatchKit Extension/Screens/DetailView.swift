//
//  DetailView.swift
//  Notes WatchKit Extension
//
//  Created by Visarut Tippun on 3/4/22.
//

import SwiftUI

struct DetailView: View {
    
    let note: Note
    let count: Int
    let index: Int
    
    @State private var isCreditsPresented: Bool = false
    @State private var isSettingsPresented: Bool = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 3) {
            HeaderView()
            
            Spacer()
            
            ScrollView(.vertical, showsIndicators: true) {
                Text(note.text)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
            } //: ScrollView
            
            Spacer()
            
            HStack(alignment: .center) {
                Image(systemName: "gear")
                    .imageScale(.large)
                    .onTapGesture {
                        isSettingsPresented.toggle()
                    }
                    .sheet(isPresented: $isSettingsPresented) {
                        SettingsView()
                    }
                
                Spacer()
                
                Text("\(count) / \(index + 1)")
                
                Spacer()
                
                Image(systemName: "info.circle")
                    .imageScale(.large)
                    .onTapGesture {
                        isCreditsPresented.toggle()
                    }
                    .sheet(isPresented: $isCreditsPresented) {
                        CreditsView()
                    }
            } //: HStack
            .foregroundColor(.secondary)
        } //: VStack
        .padding(3)
    }
}

struct DetailView_Previews: PreviewProvider {
    static let sampleNote = Note(text: "Hello, World!")
    
    static var previews: some View {
        DetailView(note: sampleNote, count: 5, index: 1)
    }
}
