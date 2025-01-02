//
//  ConfigureExerciseForTrainingView.swift
//  GymP
//
//  Created by Elias Osarumwense on 24.06.24.
//
/*
import SwiftUI

struct ConfigureExerciseForTrainingView: View {
    @Binding var isExerciseForTrainingSelected: Bool
    var training: Training?
    var exercise: Exercise
    
    var weightAfterComma: [Int] = [0, 25, 50, 75]
    @StateObject private var viewModel = TrainingViewModel()
    @Environment(\.managedObjectContext) var viewContext
    
    @State var isPickerPresent = false
    
    var body: some View {
        NavigationView {
            VStack {
                List(viewModel.trainingTemplate) { item in
                    HStack {
                        Button(action: {
                            isPickerPresent = true
                            print("Button pressed")
                        }, label: {
                            /*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/
                        })
                        
                        HStack(spacing: 0) {
                            Picker(selection: $viewModel.trainingTemplate[item.index].reps, label: Text("Reps")) {
                                // Your options for reps picker
                                ForEach(1..<100) { reps in
                                    Text("\(reps)")
                                }
                            }
                            .pickerStyle(.wheel)
                            .clipShape(Rectangle().offset(x: -16))
                            .clipShape(Rectangle().offset(y: -30))
                            .padding(.trailing, -16)
                            Text("x")
                                .clipShape(Rectangle())
                            Picker(selection: $viewModel.trainingTemplate[item.index].weightBeforeComma, label: Text("Weight")) {
                                // Your options for weight picker
                                ForEach(1..<1000) { weight in
                                    Text("\(weight)")
                                }
                            }
                            .pickerStyle(.wheel)
                            .clipShape(Rectangle().offset(x: 16))
                            .clipShape(Rectangle().offset(x: -16))
                            .padding(.leading, -16)
                            Text(",")
                                .clipShape(Rectangle())
                            Picker(selection: $viewModel.trainingTemplate[item.index].weightAfterComma, label: Text("Weight")) {
                                // Your options for weight picker
                                ForEach(weightAfterComma, id: \.self) { weight in
                                    Text("\(weight)")
                                }
                            }
                            .pickerStyle(.wheel)
                            .clipShape(Rectangle().offset(x: 16))
                            .padding(.leading, -16)
                         
                        }
                        .frame(height: 100)
                        .clipped(antialiased: true)
                        .padding()
                        
                    }
                }
                
                Button(action: {
                    viewModel.addTemplate(reps: 10, weightBeforeComma: 50, weightAfterComma: 0, index: 1, warmup: true)
                }) {
                    VStack {
                        Text("Add Set")
                    }
                }
            }
            .sheet(isPresented: $isPickerPresent) {
                //Test2()
                
            }
            .onAppear {
                // Add initial data when the view appears
                viewModel.addTemplate(reps: 10, weightBeforeComma: 50, weightAfterComma: 0, index: 0, warmup: true)
            }
            .navigationTitle("Edit Exercise")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        isExerciseForTrainingSelected = false
                    }) {
                        Image(systemName: "arrow.down")
                            .foregroundColor(.orange)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        //saveExerciseToTraining()
                    }) {
                        HStack {
                            Text("Sav")
                                .font(.body)
                                .foregroundColor(.orange)
                        }
                    }
                }
            }
        }
    }
    

}

class TrainingExerciseTemplateDummy: Identifiable, ObservableObject {
    var id: UUID
    @Published var reps: Int
    @Published var weightBeforeComma: Int
    @Published var weightAfterComma: Int
    var index: Int
    var warmup: Bool
    
    init(id: UUID = UUID(), reps: Int, weightBeforeComma: Int, weightAfterComma: Int, index: Int, warmup: Bool) {
        self.id = id
        self.reps = reps
        self.weightBeforeComma = weightBeforeComma
        self.weightAfterComma = weightAfterComma
        self.index = index
        self.warmup = warmup
    }
}

class TrainingViewModel: ObservableObject {
    @Published var trainingTemplate: [TrainingExerciseTemplateDummy] = []
    
    func addTemplate(reps: Int, weightBeforeComma: Int, weightAfterComma: Int, index: Int, warmup: Bool) {
        let newTemplate = TrainingExerciseTemplateDummy(reps: reps, weightBeforeComma: weightBeforeComma, weightAfterComma: weightAfterComma, index: index, warmup: warmup)
        trainingTemplate.append(newTemplate)
    }
}
*/

