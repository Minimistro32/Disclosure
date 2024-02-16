//
//  LoggerView.swift
//  Disclosure
//
//  Created by Tyson Freeze on 2/7/24.
//

import SwiftUI

struct LoggerView: View {
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var formDate = Date()
    @State private var formIntensity = 5.5
    @State private var formCompulsivity = 5.5
    @State private var formNotes = ""
    @State private var formTriggers: [String] = []
    @FocusState private var isNotesFocused: Bool
    @State private var formReminder = false
    
    var disableForm: Bool {
        formIntensity == 5.5 || formCompulsivity == 5.5
    }
    
    
    var body: some View {
        VStack {
            
            //                        Label("Log a Relapse", systemImage: "arrow.counterclockwise")
            //                        Text("Log a Relapse")
            //                            .padding(.top)
            
            Form(content: {
                Section("Relapse") {
                    DatePicker("Date", selection: $formDate, in: ...Date())
                        .datePickerStyle(.compact)
                        .bold()
                    IntensitySlider(value: $formIntensity)
                    CompulsivitySlider(value: $formCompulsivity)
                }
                
                if !formReminder {
                    Section("Analyze") {
                        MultipleSelectionList(
                            items: Blahst.list,
                            selections: $formTriggers)
                        .tint(.white)
                        TextField("Notes",
                                  text: $formNotes,
                                  prompt: Text("Notes\n• Any other triggers?\n• Describe the situation. What was unmet or unmanaged?\n• If you could rewind time, what would you do differently?"), //
                                  axis: .vertical)
                            .lineLimit(6...)
                            .focused($isNotesFocused)
                    }
                    .transition(.opacity)

                }
                
                //Submit Section
                Section {
                    Toggle("Finish analyzing later?", isOn: $formReminder)
                    Button {
                        let relapse = Relapse(
                            date: formDate,
                            reminder: formReminder,
                            intensity: Int(formIntensity),
                            compulsivity: Int(formCompulsivity),
                            notes: formNotes,
                            triggers: formTriggers
                        )
                        context.insert(relapse)
                        dismiss()
                    } label: {
                        HStack {
                            Spacer()
                            Text("Submit")
                            Spacer()
                        }
                    }
                    .disabled(disableForm)
                }
            })
            
            //Keyboard Dismiss Button
            if isNotesFocused {
                HStack {
                    Spacer()
                    Button("Dismiss") {
                        isNotesFocused = false
                    }
                    .padding(.trailing, 10)
                }
                .padding(.bottom, 10)
            }
            
        }
    }
}

#Preview {
    LoggerView()
}



struct SliderTicks: View {
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<10) { index in
                VStack {
                    Text("|")
                        .bold()
                        .opacity(0.2)
                    
                }
                if index != 9 {
                    Spacer()
                }
            }
        }
        .padding(.horizontal, 12)
    }
}

struct IntensitySlider: View {
    @Binding var value: Double
    @State private var isEditing = false
    
    private var descriptor: String {
        if value > 8 {
            return "New Material"
        } else if value > 4 {
            return "Nudity"
        } else if value > 2 {
            return "Revealing Clothes"
        }
        return "Masturbation"
    }
    
    
    var body: some View {
        VStack {
            HStack{
                Text("Intensity")
                    .bold()
                Spacer()
                if value.truncatingRemainder(dividingBy: 1) == 0 {
                    if isEditing {
                        Text("\(Int(value)) - " + descriptor)
                            .bold()
                            .foregroundStyle(.teal)
                    }   else {
                        Text("\(Int(value))")
                    }
                }
            }
            ZStack {
                //https://stackoverflow.com/questions/65779638/how-to-create-slider-with-tick-marks-using-swiftui
                SliderTicks()
                Slider(value: $value,
                       in: 1.0...10.0,
                       step: 1.0)
                .tint(.clear)
                
                Slider(value: $value,
                       in: 1.0...10.0,
                       step: 1.0,
                       onEditingChanged: { editing in
                    isEditing = editing
                })
                .tint(.teal)
                .opacity(value / 10)
                
            }
        }
    }
}

struct CompulsivitySlider: View {
    @Binding var value: Double
    
    var body: some View {
        VStack {
            HStack{
                Text("Compulsive Feeling")
                    .bold()
                Spacer()
                if value.truncatingRemainder(dividingBy: 1) == 0 {
                    Text("\(Int(value))")
                }
            }
            ZStack {
                SliderTicks()
                Slider(value: $value,
                       in: 1.0...10.0,
                       step: 1.0)
            }
        }
    }
}


