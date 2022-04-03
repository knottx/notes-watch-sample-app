//
//  ContentView.swift
//  Notes WatchKit Extension
//
//  Created by Visarut Tippun on 3/4/22.
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage("lineCount") var lineCount: Int = 1
    
    @State private var notes: [Note] = []
    @State private var text: String = ""
    
    func getDocumentDirectory() -> URL? {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return path.first
    }
    
    func save() {
        guard let url = getDocumentDirectory()?.appendingPathComponent("notes") else { return }
        do {
            let data = try JSONEncoder().encode(notes)
            try data.write(to: url)
        } catch {
            print("Failed to save data.")
        }
    }
    
    func load() {
        DispatchQueue.main.async {
            guard let url = getDocumentDirectory()?.appendingPathComponent("notes") else { return }
            do {
                let data = try Data(contentsOf: url)
                notes = try JSONDecoder().decode([Note].self, from: data)
            } catch {
                // Do nothing
            }
        }
    }
    
    func delete(offset: IndexSet) {
        withAnimation {
            notes.remove(atOffsets: offset)
            save()
        }
    }
    
    var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 6) {
                TextField("Add New Note", text: $text)
                
                Button {
                    guard !text.isEmpty else { return }
                    let new = Note(text: text)
                    notes.append(new)
                    text = ""
                    save()
                } label: {
                    Image(systemName: "plus.circle")
                        .font(.system(size: 42, weight: .semibold))
                }
                .fixedSize()
                .buttonStyle(.plain)
                .foregroundColor(.accentColor)
            } //: HStack
            Spacer()
            
            if notes.isEmpty {
                Spacer()
                Image(systemName: "note.text")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.gray)
                    .opacity(0.25)
                    .padding(25)
                Spacer()
            } else {
                List {
                    ForEach(0..<notes.count, id: \.self) { index in
                        NavigationLink {
                            DetailView(note: notes[index], count: notes.count, index: index)
                        } label: {
                            HStack {
                                Capsule()
                                    .frame(width: 4)
                                    .foregroundColor(.accentColor)
                                Text(notes[index].text)
                                    .lineLimit(lineCount)
                                    .padding(.leading, 5)
                            } //: HStack
                        }
                    } //: ForEach
                    .onDelete(perform: delete)
                } //: List
            }
            
        } //: VStack
        .navigationTitle("Notes")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            load()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
