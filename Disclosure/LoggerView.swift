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
    
    @Bindable var relapse: Relapse = Relapse()
    @FocusState private var isNotesFocused: Bool
    
    var isValidForm: Bool {
        relapse.intensity != 0 && relapse.compulsivity != 0
    }
    
    
    var body: some View {
        VStack {
            
            //                        Label("Log a Relapse", systemImage: "arrow.counterclockwise")
            //                        Text("Log a Relapse")
            //                            .padding(.top)
            
            Form(content: {
                Section("Relapse") {
                    DatePicker("Date", selection: $relapse.date, in: ...Date())
                        .datePickerStyle(.compact)
                        .bold()
                    IntensitySlider(value: .convert(from: $relapse.intensity))
                    CompulsivitySlider(value: .convert(from: $relapse.compulsivity))
                }
                
                if !relapse.reminder {
                    Section("Analyze") {
                        BlahstSelectionList(selections: $relapse.triggers.array)
                        .tint(.white)
                        TextField("Notes",
                                  text: $relapse.notes,
                                  prompt: Text("Notes\n• Any other triggers?\n• Describe the situation. What was unmet or unmanaged?\n• If you could rewind time, what would you do differently?"), //
                                  axis: .vertical)
                            .lineLimit(6...)
                            .focused($isNotesFocused)
                    }
                    .transition(.opacity)

                }
                
                //Submit Section
                Section {
                    Toggle("Finish analyzing later?", isOn: $relapse.reminder)
                    Button {
                        context.insert(relapse)
                        dismiss()
                    } label: {
                        HStack {
                            Spacer()
                            Text("Submit")
                            Spacer()
                        }
                    }
                    .disabled(!isValidForm)
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
    @State private var isEditing: Bool = false
    let range: ClosedRange<Double> = 1.0...10.0
    
    private var descriptor: String {
        return describeIntensity(Int(value))
    }
    
    
    var body: some View {
        VStack {
            HStack{
                Text("Intensity")
                    .bold()
                Spacer()
                if range.contains(value) {
                    if isEditing {
                        Text(descriptor + " - \(Int(value))")
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
                Slider(value: range.contains(value) || isEditing ? $value : .constant(5.5),
                       in: range,
                       step: 1.0,
                       onEditingChanged: { editing in
                    isEditing = editing
                    value = range.contains(value) ? value : 5.5
                })
                .tint(.clear)
                
                Slider(value: range.contains(value) || isEditing ? $value : .constant(5.5),
                       in: range,
                       step: 1.0,
                       onEditingChanged: { editing in
                    isEditing = editing
                    value = range.contains(value) ? value : 5.5
                })
                .tint(.teal)
                .opacity((range.contains(value) ? value : 5.5) / 10)
                
            }
        }
    }
}

func describeIntensity(_ value: Int) -> String {
    if value > 8 {
        return "New Material"
    } else if value > 4 {
        return "Nudity"
    } else if value > 2 {
        return "Revealing Clothes"
    }
    return "Masturbation"
}

struct CompulsivitySlider: View {
    @Binding var value: Double
    @State private var isEditing = false
    let range: ClosedRange<Double> = 1.0...10.0
    
    var body: some View {
        VStack {
            HStack{
                Text("Compulsive Feeling")
                    .bold()
                Spacer()
                if range.contains(value) {
                    Text("\(Int(value))")
                }
            }
            ZStack {
                SliderTicks()
                Slider(value: range.contains(value) || isEditing ? $value : .constant(5.5),
                       in: range,
                       step: 1.0,
                       onEditingChanged: { editing in
                    isEditing = editing
                    value = range.contains(value) ? value : 5.5
                })
            }
        }
    }
}
