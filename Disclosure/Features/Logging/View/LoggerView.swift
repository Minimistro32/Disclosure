//
//  LoggerView.swift
//  Disclosure
//
//  Created by Tyson Freeze on 2/7/24.
//

import SwiftUI
import WidgetKit

struct LoggerView: View {
    @Environment(\.modelContext) var context
    @Binding var path: NavigationPath
    @Bindable var relapse: Relapse = Relapse()
    @FocusState private var isFocused: Bool
    @State var relapseReminderProxy: Bool = false
    //https://stackoverflow.com/questions/69397644/updating-tabview-badge-reloads-all-views-when-using-swiftui-3-badge-modifier
    //use value of `relapse.reminder` on init. This field circumvents a bug updating the badge on the tracker tab bar icon. If the analyze toggle is changed to update the badge the navigationStack path reloads.
    
    var isValidForm: Bool {
        relapse.intensity != 0 && relapse.compulsivity != 0
    }
#if os(macOS)
    var body: some View { //macOS
        HStack(alignment: .center) {
            Spacer()
            
            Form(content: {
                Section("Relapse") {
                    DatePicker("Date", selection: $relapse.date, in: ...Date())
                        .datePickerStyle(.compact)
                    
                    RelapseSlider(type: .intensity, value: .convert(from: $relapse.intensity))
                    RelapseSlider(type: .compulsivity, value: .convert(from: $relapse.compulsivity))
                }
                
                if !relapseReminderProxy {
                    Section("Analyze") {
                        Group {
                            Toggle("Bored", isOn: $relapse.triggers.bored)
                            Toggle("Loneliness", isOn: $relapse.triggers.loneliness)
                            Toggle("Anger", isOn: $relapse.triggers.anger)
                            Toggle("Hunger", isOn: $relapse.triggers.hunger)
                            Toggle("Stress", isOn: $relapse.triggers.stress)
                            Toggle("Tiredness", isOn: $relapse.triggers.tiredness)
                        }
                        .toggleStyle(.checkbox)
                        ZStack {
                            if relapse.notes.isEmpty {
                                Text("• Any other triggers?\n• Describe the situation. What was unmet or unmanaged?\n• If you could rewind time, what would you do differently?")
                                    .opacity(0.6)
                                    .offset(x: 25, y:-15)
                                    .padding(25)
                            }
                            TextField("Notes",
                                      text: $relapse.notes,
                                      axis: .vertical)
                            .lineLimit(6...)
                        }
                    }
                }
                
                
                //Submit Section
                Section {
                    Toggle("Finish analyzing later?", isOn: $relapseReminderProxy)
                    HStack(alignment: .center) {
                        Button {
                            relapse.reminder = relapseReminderProxy
                            context.insert(relapse)
                            path.removeLast()
                        } label: {
                            Text("Submit")
                                .frame(maxWidth: .infinity)
                        }
                        .disabled(!isValidForm)
                        Button {
                            path.removeLast()
                        } label: {
                            Text("Cancel")
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
            })
            .formStyle(.grouped)
            .navigationBarBackButtonHidden(true)
            .frame(width: 350)
            .padding()
            
            Spacer()
        }
    }
#else
    var body: some View { //iOS
        Form(content: {
            Section("Relapse") {
                DatePicker("Date", selection: $relapse.date, in: ...Date())
                    .datePickerStyle(.compact)
                    .bold()
                RelapseSlider(type: .intensity, value: .convert(from: $relapse.intensity))
                RelapseSlider(type: .compulsivity, value: .convert(from: $relapse.compulsivity))
            }
            
            if !relapseReminderProxy {
                Section("Analyze") {
                    BlahstSelector(selections: $relapse.triggers.array)
                        .tint(.white)
                    TextField("Notes",
                              text: $relapse.notes,
                              prompt: Text("Notes\n• Any other triggers?\n• Describe the situation. What was unmet or unmanaged?\n• If you could rewind time, what would you do differently?"), //
                              axis: .vertical)
                    .lineLimit(6...)
                    .focused($isFocused)
                }
                .transition(.opacity)
                
            }
            
            
            //Submit Section
            Section {
                Toggle("Finish analyzing later?", isOn: $relapseReminderProxy)
                Button {
                    relapse.reminder = relapseReminderProxy
                    context.insert(relapse)
                    
                    WidgetCenter.shared.reloadTimelines(ofKind: "DisclosureWidgets")
                    
                    if relapse.date.isSame(.day, as: Date.now) {
                        path.segue(to: .disclosureView, payload: relapse)
                    } else {
                        path.removeLast()
                    }
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
        .navigationTitle("Logger")
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                HStack{
                    Spacer()
                    Button("Dismiss") { isFocused = false }
                }
            }
        }
    }
#endif
}

//#Preview {
//    LoggerView()
//}


struct RelapseSlider: View {
    let type: SliderType
    @Binding var value: Double
    @State private var isEditing = false
    
    public enum SliderType: String {
        case intensity = "Intensity"
        case compulsivity = "Urge Strength"
    }
    
    private let range: ClosedRange<Double> = 1.0...10.0
    func slider1to10() -> some View {
        Slider(value: range.contains(value) || isEditing ? $value : .constant(5.5),
               in: range,
               step: 1.0,
               onEditingChanged: { editing in
            isEditing = editing
            value = range.contains(value) ? value : 5.5
        })
    }
    
    var body: some View {
        VStack {
            HStack{
                Text(type.rawValue)
#if !os(macOS)
                    .bold()
#endif
                Spacer()
                if range.contains(value) {
                    if type == .intensity {
                        Text("\(Int(value)) (\(Relapse.categoricalIntensity(for: value)))")
#if !os(macOS)
                            .bold()
                            .foregroundStyle(.intense)
#endif
                    } else {
                        Text("\(Int(value))")
#if !os(macOS)
                            .bold()
                            .foregroundStyle(.compulsion)
#endif
                    }
                }
            }
            
#if os(macOS)
            slider1to10()
#else
            ZStack {
                
                SliderTicks()
                slider1to10()
                    .tint(.clear)
                
                slider1to10()
                    .if(type == .intensity) {
                        $0.tint(.intense)
                    }
                    .if(type == .compulsivity) {
                        $0.tint(.compulsion)
                    }
                    .opacity((range.contains(value) ? value : 5.5) / 10)
            }
#endif
        }
    }
}

struct SliderTicks: View {
    //https://stackoverflow.com/questions/65779638/how-to-create-slider-with-tick-marks-using-swiftui
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
