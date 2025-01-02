//
//  CalculateWeightOnEachSideVIew.swift
//  GymP
//
//  Created by Elias Osarumwense on 11.08.24.
//

import SwiftUI
import SceneKit

struct CalculateWeightOnEachSideView: View {
    @EnvironmentObject var colorSettings: ColorSettings
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.colorScheme) var colorScheme
    
    @State private var baseBarbellWeight: Double = 20.0
    @State private var totalWeight: Double = 20.0
    @State private var isWeightSelectorPresented: Bool = false
    @State private var availablePlates: [Double: Bool] = [1.25: true, 2.5: true, 5: true, 10: true, 15: true, 20: true, 25: true, 30: true]
    @State private var isPlateSelectorPresented: Bool = false
    
    // State to control the bar type
    @State private var selectedBarType: BarType = .manbar
    
    var leftSidePlatesCount: [Double: Int] {
        let leftPlates = platesOnBar().filter { $0.isLeftSide }.map { $0.weight }
        return countPlates(leftPlates)
    }
    
    var rightSidePlatesCount: [Double: Int] {
        let rightPlates = platesOnBar().filter { !$0.isLeftSide }.map { $0.weight }
        return countPlates(rightPlates)
    }
    
    enum BarType: String, CaseIterable {
        case manbar = "Man's Bar"
        case womanbar = "Woman's Bar"
        case ezCurl = "EZ Curl Bar"
        case trapbar = "Trap Bar"
    }
    
    
    
    var body: some View {
        VStack(spacing: 20) {
            // Segmented Picker for Bar Selection
            Picker("Bar Type", selection: $selectedBarType) {
                ForEach(BarType.allCases, id: \.self) { type in
                    Text(type.rawValue)
                        .font(Font.custom("Lexend-Medium", size: 10))
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.leading)
            .padding(.trailing)
            .onChange(of: selectedBarType) { newBarType in
                if newBarType == .manbar {
                    baseBarbellWeight = 20.0
                } 
                else if newBarType == .womanbar {
                    baseBarbellWeight = 15
                }
                else if newBarType == .ezCurl {
                    baseBarbellWeight = 7.5
                }
                // Adjust the total weight accordingly to avoid invalid selections
                //totalWeight = max(baseBarbellWeight, totalWeight)
            }
            // SceneKit View to show the selected bar with weights
            Section {
                SceneKitView(availablePlates: $availablePlates, totalWeight: $totalWeight, baseBarbellWeight: $baseBarbellWeight, selectedBarType: $selectedBarType)
                    .frame(height: 300)
                    .background(Color.clear)
            }
            .cornerRadius(10)
            .padding(.horizontal)
            
            HStack {
                // Left Side Plates
                VStack(alignment: .leading) {
                    Text("Left Side Plates:")
                        .customFont(.medium, 10)
                        .foregroundStyle(.gray)
                    
                    ForEach(leftSidePlatesCount.sorted(by: >), id: \.key) { plate, count in
                        HStack (spacing: 0) {
                            Text("\(count)x ")
                                .customFont(.medium, 9)
                            Text("\(formattedWeight(plate)) kg")
                                .customFont(.medium, 15)
                        }
                    }
                    Spacer() // Spacer to push content upwards
                }
                .frame(height: 120)
                .padding(.leading)
                .padding(.trailing)
                
                Spacer() // Spacer between Left Side and Middle content
                
                // Middle Section
                VStack {
                    HStack (spacing: 0) {
                        Text("Barbellweight: ")
                            .customFont(.medium, 9)
                            .foregroundStyle(.gray)
                        Text("\(formattedWeight(baseBarbellWeight)) kg")
                            .customFont(.medium, 13)
                    }
                    
                    ZStack {
                        // Background rectangle behind the picker
                        RoundedRectangle(cornerRadius: 6)
                            .fill(colorSettings.selectedColor.opacity(0.3))
                            .frame(width: 144, height: 30)
                        
                        // Picker
                        Picker("Select Total Weight", selection: $totalWeight) {
                            ForEach(possibleWeights(), id: \.self) { weight in
                                Text("\(formattedWeight(weight)) kg")
                                    .customFont(.medium, 20)
                                    .tag(weight)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(height: 100) // Match height with the background rectangle
                    }
                }
                
                Spacer() // Spacer between Middle and Right Side content
                
                // Right Side Plates
                VStack(alignment: .leading) {
                    Text("Right Side Plates:")
                        .customFont(.medium, 10)
                        .foregroundStyle(.gray)
                    
                    ForEach(rightSidePlatesCount.sorted(by: >), id: \.key) { plate, count in
                        HStack (spacing: 0) {
                            Text("\(count)x ")
                                .customFont(.medium, 9)
                            Text("\(formattedWeight(plate)) kg")
                                .customFont(.medium, 15)
                        }
                    }
                    Spacer() // Spacer to push content upwards
                }
                .frame(height: 120)
                .padding(.leading)
                .padding(.trailing)
            }
            Text("Select available Plates:")
                .customFont(.medium, 10)
                .foregroundStyle(.gray)
            ZStack {
                Rectangle()
                    .fill(colorScheme == .dark ? Color.gray : Color.black) // Set the color to black
                    .frame(width: 381, height: 15) // Set the width and height
                    .cornerRadius(10) // Optionally, add rounded corners
                Rectangle()
                    .fill(colorScheme == .dark ? Color.gray : Color.black) // Set the color to black
                    .frame(width: 200, height: 12) // Set the width and height

                    .rotationEffect(.degrees(90))
                    .offset(x: -185, y: 100)
                Rectangle()
                    .fill(colorScheme == .dark ? Color.gray : Color.black) // Set the color to black
                    .frame(width: 200, height: 12) // Set the width and height

                    .rotationEffect(.degrees(90))
                    .offset(x: 185, y: 100)
                
                
                Rectangle()
                    .fill(colorScheme == .dark ? Color.gray : Color.black) // Set the color to black
                    .frame(width: 120, height: 12) // Set the width and height
                    .cornerRadius(10)
                    .rotationEffect(.degrees(90))
                    .offset(x: 50)
                Rectangle()
                    .fill(colorScheme == .dark ? Color.gray : Color.black) // Set the color to black
                    .frame(width: 120, height: 12) // Set the width and height
                    .cornerRadius(10)
                    .rotationEffect(.degrees(90))
                    .offset(x: -50)
                Rectangle()
                    .fill(colorScheme == .dark ? Color.gray : Color.black) // Set the color to black
                    .frame(width: 120, height: 12) // Set the width and height
                    .cornerRadius(10)
                    .rotationEffect(.degrees(90))
                    .offset(x: -148)
                Rectangle()
                    .fill(colorScheme == .dark ? Color.gray : Color.black) // Set the color to black
                    .frame(width: 120, height: 12) // Set the width and height
                    .cornerRadius(10)
                    .rotationEffect(.degrees(90))
                    .offset(x: 148)
                VStack {
                    let columns = [
                        GridItem(.flexible()), // Each column will be flexible and adjust according to the content
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ]
                    
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(Array(availablePlates.keys).sorted(), id: \.self) { plate in
                            Button(action: {
                                withAnimation(.easeOut) {
                                    triggerHapticFeedbackLight()
                                    availablePlates[plate]?.toggle()
                                }
                            }) {
                                ZStack {
                                    // Main Plate Circle with Clipping Effect
                                    Circle()
                                        .fill(availablePlates[plate] == true ? Color(.sRGB, red: 0.33, green: 0.33, blue: 0.33, opacity: 1.0) : Color(.sRGB, red: 0.33, green: 0.33, blue: 0.33, opacity: 0.3))
                                        .frame(width: circleSize(for: plate), height: circleSize(for: plate))
                                        .overlay(
                                            Circle()
                                                .stroke(availablePlates[plate] == true ? (colorScheme == .dark ? Color.gray : Color.black) : Color.black.opacity(0.3), lineWidth: 3) // Outer stroke
                                        )
                                        .mask(
                                            ZStack {
                                                Circle().frame(width: circleSize(for: plate), height: circleSize(for: plate)) // The outer circle mask
                                                Circle()
                                                    .frame(width: 10, height: 10) // Smaller inner circle that clips the outer circle
                                                    .blendMode(.destinationOut) // This makes the smaller circle behave like a "hole"
                                                Ellipse()
                                                    .frame(width: EllipseSizeWidth(for: plate), height: EllipseSizeHeight(for: plate))
                                                            .offset(x: offsetEllipseY(for: plate))
                                                            .blendMode(.destinationOut)
                                                Ellipse()
                                                            .frame(width: EllipseSizeWidth(for: plate), height: EllipseSizeHeight(for: plate))
                                                            .offset(x: -offsetEllipseY(for: plate))
                                                            .blendMode(.destinationOut)
                                                            
                                            }
                                        )
                                    
                                    // Weight Text Inside the Plate, Centered
                                    Text("\(formattedWeight(plate))")
                                        .customFont(.medium, plate == 1.25 || plate == 2.5 ? 7 : 10) // Adjust font size based on plate value
                                        .foregroundColor(availablePlates[plate] == true ? .white : .white.opacity(0.3))
                                        .offset(y: offsetY(for: plate)) // Dynamic offset for the weight text
                                    Text("\(formattedWeight(plate))")
                                        .customFont(.medium, plate == 1.25 || plate == 2.5 ? 7 : 10) // Adjust font size based on plate value
                                        .foregroundColor(availablePlates[plate] == true ? .white : .white.opacity(0.3))
                                        .offset(y: -offsetY(for: plate)) // Dynamic offset for the weight text
                                }
                            }
                            .padding(2) // Padding between plates
                        }
                    }
                    .padding(2)
                }
            }

            
            HStack {
                Button(action: {
                    isWeightSelectorPresented = true
                }) {
                    Text("Adjust Barbell Weight")
                        .customFont(.medium, 15)
                        .padding(8)
                        .background(colorSettings.selectedColor)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .sheet(isPresented: $isWeightSelectorPresented) {
                    WeightSelectorView(baseWeight: $baseBarbellWeight)
                        .presentationDetents([.height(250)])
                        .presentationDragIndicator(.hidden)
                }
            }
            .offset(y: -13)

        }
        .navigationBarBackButtonHidden(true)
                .navigationTitle("Calculate Weight")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "arrow.left")
                                .foregroundColor(colorSettings.selectedColor)
                        }
                    }
                }
                .onChange(of: totalWeight) { newValue in
                    totalWeight = max(baseBarbellWeight, newValue)
                }
                .padding(.top, 50)
    }
    
    func possibleWeights() -> [Double] {
        var possibleWeights: Set<Double> = [baseBarbellWeight]
        
        for (plate, isEnabled) in availablePlates where isEnabled {
            var newWeights: Set<Double> = []
            for weight in possibleWeights {
                var additionalWeight = 0.0
                while additionalWeight <= 1000 - baseBarbellWeight {
                    additionalWeight += plate * 2 // Since each plate is added to both sides
                    newWeights.insert(weight + additionalWeight)
                }
            }
            possibleWeights = possibleWeights.union(newWeights)
        }
        
        return possibleWeights.sorted()
    }

    // Calculate the plates added to the bar for both sides
    func platesOnBar() -> [(weight: Double, isLeftSide: Bool)] {
        let remainingWeight = (totalWeight - baseBarbellWeight) / 2 // Remaining weight per side
        var plates: [(Double, Bool)] = []

        // Collect available plates and sort them by weight (descending)
        let enabledPlates = availablePlates.filter { $0.value }.map { $0.key }.sorted(by: { $0 > $1 })

        // Safeguard: Guard against infinite recursion or unreachable configurations by limiting recursion depth
        let maxRecursionDepth = 1000
        var recursionDepth = 0

        // Helper function for backtracking to find the correct combination of plates
        func findPlates(_ remainingWeight: Double, currentPlates: [(Double, Bool)]) -> [(Double, Bool)]? {
            // Safeguard: Prevent infinite recursion by checking depth
            recursionDepth += 1
            if recursionDepth > maxRecursionDepth {
                return nil // Exceeded safe recursion depth, abort
            }

            // Base case: if remaining weight is zero, we found a valid combination
            if remainingWeight == 0 {
                return currentPlates
            }

            // If remaining weight is negative, this path is not valid
            if remainingWeight < 0 {
                return nil
            }

            // Try adding plates recursively
            for plate in enabledPlates {
                // Avoid infinite recursion when there's no smaller plate to adjust the weight
                if plate > remainingWeight {
                    continue
                }

                // Try to place a plate on both sides
                var newPlates = currentPlates
                newPlates.append((plate, true))  // Left side plate
                newPlates.append((plate, false)) // Right side plate

                // Recur with the updated remaining weight and plate set
                if let validCombination = findPlates(remainingWeight - plate, currentPlates: newPlates) {
                    return validCombination // Return the valid combination found
                }
            }

            // If no valid combination was found, return nil
            return nil
        }

        // Start the recursive search with the initial remaining weight
        if let validPlates = findPlates(remainingWeight, currentPlates: []) {
            return validPlates // Return the valid plates combination
        } else {
            // Handle case where no valid combination is found
            print("No valid plate combination found.")
            return [] // Return empty if no valid combination was found
        }
    }
    
    func countPlates(_ plates: [Double]) -> [Double: Int] {
            var countDict: [Double: Int] = [:]
            
            for plate in plates {
                countDict[plate, default: 0] += 1
            }
            
            return countDict
        }
    
    func circleSize(for plate: Double) -> CGFloat {
        switch plate {
        case 1.25:
            return 35
        case 2.5:
            return 40
        case 5:
            return 45
        case 10:
            return 50
        case 15:
            return 55
        case 20:
            return 60
        case 25:
            return 65
        case 30:
            return 70
        default:
            return 50 // Default size if plate weight doesn't match
        }
    }
    
    func EllipseSizeWidth(for plate: Double) -> CGFloat {
        switch plate {
        case 1.25:
            return 4
        case 2.5:
            return 5
        case 5:
            return 6
        case 10:
            return 7
        case 15:
            return 8
        case 20:
            return 8
        case 25:
            return 8
        case 30:
            return 8
        default:
            return 7 // Default size if plate weight doesn't match
        }
    }
    
    func EllipseSizeHeight(for plate: Double) -> CGFloat {
        switch plate {
        case 1.25:
            return 9
        case 2.5:
            return 10
        case 5:
            return 11
        case 10:
            return 12
        case 15:
            return 13
        case 20:
            return 16
        case 25:
            return 18
        case 30:
            return 20
        default:
            return 12 // Default size if plate weight doesn't match
        }
    }
    
    func offsetY(for plate: Double) -> CGFloat {
        switch plate {
        case 1.25:
            return -10
        case 2.5:
            return -11
        case 5:
            return -13
        case 10:
            return -15
        case 15:
            return -18
        case 20:
            return -20
        case 25:
            return -23
        case 30:
            return -25
        default:
            return 0 // Default offset if plate weight doesn't match
        }
    }
    
    func offsetEllipseY(for plate: Double) -> CGFloat {
        switch plate {
        case 1.25:
            return 12
        case 2.5:
            return 14
        case 5:
            return 16
        case 10:
            return 18
        case 15:
            return 20
        case 20:
            return 22
        case 25:
            return 24
        case 30:
            return 26
        default:
            return 0 // Default offset if plate weight doesn't match
        }
    }
    func formattedWeight(_ weight: Double) -> String {
        if weight.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "%.0f", weight)
        } else {
            return String(format: "%.2f", weight)
        }
    }
}

// SceneKit View for displaying the 3D barbell and plates
struct SceneKitView: UIViewRepresentable {
    @Binding var availablePlates: [Double: Bool]
    @Binding var totalWeight: Double
    @Binding var baseBarbellWeight: Double
    @Binding var selectedBarType: CalculateWeightOnEachSideView.BarType
    
    func makeUIView(context: Context) -> SCNView {
        let sceneView = SCNView()
        sceneView.allowsCameraControl = true
        sceneView.autoenablesDefaultLighting = true
        sceneView.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        
        let scene = SCNScene()
        sceneView.scene = scene
        
        // Restrict the rotation to only horizontal (around the Y-axis)
        sceneView.defaultCameraController.minimumVerticalAngle = 0
        sceneView.defaultCameraController.maximumVerticalAngle = 0
        
        // Add the correct bar type to the scene based on user selection
        addBar(to: scene.rootNode)
        
        return sceneView
    }
    
    func updateUIView(_ scnView: SCNView, context: Context) {
        guard let rootNode = scnView.scene?.rootNode else { return }
        
        // Remove the existing bar node (barbell or EZ curl bar)
        rootNode.childNodes.filter { $0.name == "manbar" || $0.name == "ezCurlBar" || $0.name == "womanbar" || $0.name == "trapBar"}.forEach { $0.removeFromParentNode() }
        
        // Add the new bar based on the selectedBarType
        addBar(to: rootNode)
    }
    
    func addBar(to rootNode: SCNNode) {
        let barNode: SCNNode
        if selectedBarType == .manbar {
            barNode = createBarbell()
        } else if selectedBarType == .ezCurl {
            barNode = createEZCurlBar()
        } else if selectedBarType == .womanbar{
            barNode = createWomanBat()
        }
        else
        {
            barNode = createTrapBar()
        }
        
        rootNode.addChildNode(barNode)
        
        // Add collars to the bar
        addCollars(to: barNode)
        
        // Add plates to the bar if total weight exceeds base barbell weight
        if totalWeight > baseBarbellWeight {
            addPlates(to: barNode, availablePlates: availablePlates, totalWeight: totalWeight - baseBarbellWeight)
        }
    }

    func createEZCurlBar() -> SCNNode {
        let ezCurlBar = SCNNode()
        
        let barRadius: CGFloat = 0.02  // Same as your barbell radius
        let barTotalLength: CGFloat = 1.65  // Same as your barbell total length
        let handleLength: CGFloat = 0.4  // Length of the straight handles on both sides
        let curlLength: CGFloat = 0.25  // Length of each curved segment
        let curlAngle: Float = Float.pi / 6  // Curl angle for each bend
        
        // Create the first straight handle segment on the left side
        let leftHandleSegment = SCNNode(geometry: SCNCylinder(radius: barRadius, height: handleLength))
        leftHandleSegment.position = SCNVector3(0, -barTotalLength / 2 + handleLength / 2, 0)
        leftHandleSegment.geometry?.firstMaterial?.diffuse.contents = UIColor.gray
        leftHandleSegment.name = "leftHandleSegment"
        
        // Create the first curl segment (bent upwards)
        let firstCurlSegment = SCNNode(geometry: SCNCylinder(radius: barRadius, height: curlLength))
        firstCurlSegment.position = SCNVector3(-0.06, -barTotalLength / 2 + handleLength + curlLength / 2.58, 0)
        firstCurlSegment.eulerAngles = SCNVector3(0, 0, curlAngle)  // First bend upwards
        firstCurlSegment.geometry?.firstMaterial?.diffuse.contents = UIColor.gray
        firstCurlSegment.name = "firstCurlSegment"
        
        // Create the second curl segment (bent downwards)
        let secondCurlSegment = SCNNode(geometry: SCNCylinder(radius: barRadius, height: curlLength))
        secondCurlSegment.position = SCNVector3(-0.06, -barTotalLength / 2 + handleLength + curlLength * 1.2, 0)
        secondCurlSegment.eulerAngles = SCNVector3(0, 0, -curlAngle)  // Second bend downwards
        secondCurlSegment.geometry?.firstMaterial?.diffuse.contents = UIColor.gray
        secondCurlSegment.name = "secondCurlSegment"
        
        // Create the center straight segment
        let centerSegment = SCNNode(geometry: SCNCylinder(radius: barRadius, height: handleLength / 7.5))
        centerSegment.position = SCNVector3(0, 0, 0)
        centerSegment.geometry?.firstMaterial?.diffuse.contents = UIColor.gray
        centerSegment.name = "centerSegment"
        
        // Create the third curl segment (bent upwards)
        let thirdCurlSegment = SCNNode(geometry: SCNCylinder(radius: barRadius, height: curlLength))
        thirdCurlSegment.position = SCNVector3(-0.06, barTotalLength / 2 - handleLength - curlLength * 1.2, 0)
        thirdCurlSegment.eulerAngles = SCNVector3(0, 0, curlAngle)  // Third bend upwards
        thirdCurlSegment.geometry?.firstMaterial?.diffuse.contents = UIColor.gray
        thirdCurlSegment.name = "thirdCurlSegment"
        
        // Create the fourth curl segment (bent downwards)
        let fourthCurlSegment = SCNNode(geometry: SCNCylinder(radius: barRadius, height: curlLength))
        fourthCurlSegment.position = SCNVector3(-0.06, barTotalLength / 2 - handleLength - curlLength / 2.58, 0)
        fourthCurlSegment.eulerAngles = SCNVector3(0, 0, -curlAngle)  // Fourth bend downwards
        fourthCurlSegment.geometry?.firstMaterial?.diffuse.contents = UIColor.gray
        fourthCurlSegment.name = "fourthCurlSegment"
        
        // Create the right straight handle segment
        let rightHandleSegment = SCNNode(geometry: SCNCylinder(radius: barRadius, height: handleLength))
        rightHandleSegment.position = SCNVector3(0, barTotalLength / 2 - handleLength / 2, 0)
        rightHandleSegment.geometry?.firstMaterial?.diffuse.contents = UIColor.gray
        rightHandleSegment.name = "rightHandleSegment"
        
        // Add all segments to the main EZ curl bar node
        ezCurlBar.addChildNode(leftHandleSegment)
        ezCurlBar.addChildNode(firstCurlSegment)
        ezCurlBar.addChildNode(secondCurlSegment)
        ezCurlBar.addChildNode(centerSegment)
        ezCurlBar.addChildNode(thirdCurlSegment)
        ezCurlBar.addChildNode(fourthCurlSegment)
        ezCurlBar.addChildNode(rightHandleSegment)
        
        ezCurlBar.eulerAngles = SCNVector3(0, 0, Float.pi / 2)  // Rotate the whole bar to lay flat on X-axis
        ezCurlBar.name = "ezCurlBar"
        
        return ezCurlBar
    }
    
    func createTrapBar() -> SCNNode {
        let trapBar = SCNNode()
        
        let barRadius: CGFloat = 0.02  // Same as your EZ curl bar radius
        let handleRadius: CGFloat = 0.02  // Radius of the handles
        let handleLength: CGFloat = 0.4  // Length of the handles
        let hexSideLength: CGFloat = 0.7  // Length of one side of the hexagon
        let sleeveLength: CGFloat = 0.25  // Length of the sleeves (for weight plates)
        
        // Hexagon sides (left half)
        let leftHexSide1 = SCNNode(geometry: SCNCylinder(radius: barRadius, height: hexSideLength))
        leftHexSide1.position = SCNVector3(-hexSideLength / 2, 0, 0)
        leftHexSide1.eulerAngles = SCNVector3(0, 0, Float.pi / 3)
        leftHexSide1.geometry?.firstMaterial?.diffuse.contents = UIColor.gray
        
        let leftHexSide2 = SCNNode(geometry: SCNCylinder(radius: barRadius, height: hexSideLength))
        leftHexSide2.position = SCNVector3(0, hexSideLength / 2, 0)
        leftHexSide2.eulerAngles = SCNVector3(0, 0, -Float.pi / 3)
        leftHexSide2.geometry?.firstMaterial?.diffuse.contents = UIColor.gray
        
        // Right half of the hexagon
        let rightHexSide1 = SCNNode(geometry: SCNCylinder(radius: barRadius, height: hexSideLength))
        rightHexSide1.position = SCNVector3(hexSideLength / 2, 0, 0)
        rightHexSide1.eulerAngles = SCNVector3(0, 0, -Float.pi / 3)
        rightHexSide1.geometry?.firstMaterial?.diffuse.contents = UIColor.gray
        
        let rightHexSide2 = SCNNode(geometry: SCNCylinder(radius: barRadius, height: hexSideLength))
        rightHexSide2.position = SCNVector3(0, -hexSideLength / 2, 0)
        rightHexSide2.eulerAngles = SCNVector3(0, 0, Float.pi / 3)
        rightHexSide2.geometry?.firstMaterial?.diffuse.contents = UIColor.gray
        
        // Handles (one on each side of the hexagon)
        let leftHandle = SCNNode(geometry: SCNCylinder(radius: handleRadius, height: handleLength))
        leftHandle.position = SCNVector3(0, -hexSideLength / 2 - handleLength / 2, 0)
        leftHandle.geometry?.firstMaterial?.diffuse.contents = UIColor.gray
        
        let rightHandle = SCNNode(geometry: SCNCylinder(radius: handleRadius, height: handleLength))
        rightHandle.position = SCNVector3(0, hexSideLength / 2 + handleLength / 2, 0)
        rightHandle.geometry?.firstMaterial?.diffuse.contents = UIColor.gray
        
        // Sleeves for the weight plates
        let leftSleeve = SCNNode(geometry: SCNCylinder(radius: barRadius, height: sleeveLength))
        leftSleeve.position = SCNVector3(0, -hexSideLength - handleLength - sleeveLength / 2, 0)
        leftSleeve.geometry?.firstMaterial?.diffuse.contents = UIColor.gray
        
        let rightSleeve = SCNNode(geometry: SCNCylinder(radius: barRadius, height: sleeveLength))
        rightSleeve.position = SCNVector3(0, hexSideLength + handleLength + sleeveLength / 2, 0)
        rightSleeve.geometry?.firstMaterial?.diffuse.contents = UIColor.gray
        
        // Add all parts to the main trap bar node
        trapBar.addChildNode(leftHexSide1)
        trapBar.addChildNode(leftHexSide2)
        trapBar.addChildNode(rightHexSide1)
        trapBar.addChildNode(rightHexSide2)
        trapBar.addChildNode(leftHandle)
        trapBar.addChildNode(rightHandle)
        trapBar.addChildNode(leftSleeve)
        trapBar.addChildNode(rightSleeve)
        
        trapBar.eulerAngles = SCNVector3(0, 0, Float.pi / 2)  // Rotate to lay flat on the X-axis
        trapBar.name = "trapBar"
        
        return trapBar
    }
    // Create a 3D barbell laying flat on the X-axis using a cylinder
    func createBarbell() -> SCNNode {
        let barbell = SCNNode(geometry: SCNCylinder(radius: 0.025, height: 2)) // Shorter, thinner barbell
        barbell.name = "manbar"
        barbell.geometry?.firstMaterial?.diffuse.contents = UIColor.gray
        barbell.position = SCNVector3(0, 0, 0)
        barbell.eulerAngles = SCNVector3(0, 0, Float.pi / 2) // Rotate barbell to lay flat on X-axis
        
        return barbell
    }
    func createWomanBat() -> SCNNode {
        let barbell = SCNNode(geometry: SCNCylinder(radius: 0.02, height: 1.9)) // Shorter, thinner barbell
        barbell.name = "womanbar"
        barbell.geometry?.firstMaterial?.diffuse.contents = UIColor.gray
        barbell.position = SCNVector3(0, 0, 0)
        barbell.eulerAngles = SCNVector3(0, 0, Float.pi / 2) // Rotate barbell to lay flat on X-axis
        
        return barbell
    }
    
    // Add collars to the barbell just before the plates on both sides
        func addCollars(to barbell: SCNNode) {
            let collarThickness: Float = 0.05
            let collarRadius: CGFloat = 0.04 // Slightly bigger than the barbell

            // Create the right-side collar
            let rightCollarNode = SCNNode(geometry: SCNCylinder(radius: collarRadius, height: CGFloat(collarThickness)))
            rightCollarNode.position = SCNVector3(0, 0.65, 0) // Positioned before the first plate on the right
            rightCollarNode.geometry?.firstMaterial?.diffuse.contents = UIColor.darkGray
            rightCollarNode.name = "collar"
            barbell.addChildNode(rightCollarNode)
            
            // Create the left-side collar
            let leftCollarNode = SCNNode(geometry: SCNCylinder(radius: collarRadius, height: CGFloat(collarThickness)))
            leftCollarNode.position = SCNVector3(0, -0.65, 0) // Positioned before the first plate on the left
            leftCollarNode.geometry?.firstMaterial?.diffuse.contents = UIColor.darkGray
            leftCollarNode.name = "collar"
            barbell.addChildNode(leftCollarNode)
        }

    
    // Add plates to the barbell at the ends based on the weight difference
    func addPlates(to barbell: SCNNode, availablePlates: [Double: Bool], totalWeight: Double) {
        let fixedThickness: Float = 0.05 // Set a fixed thickness for all plates
        var remainingWeight = totalWeight / 2 // Weight per side of the barbell
        var rightEndPosition: Float = 0.7 // Start stacking plates near the end of the barbell on the right side
        var leftEndPosition: Float = -0.7 // Start stacking plates near the end of the barbell on the left side

        // Collect available plates and sort them by weight (descending)
        let enabledPlates = availablePlates.filter { $0.value }.map { $0.key }.sorted(by: { $0 > $1 })

        // Safeguard: Guard against infinite recursion or unreachable configurations by limiting recursion depth
        let maxRecursionDepth = 1000
        var recursionDepth = 0
        
        // Helper function for backtracking to find the correct combination of plates
        func findPlates(_ remainingWeight: Double, currentPlates: [(Double, Bool)]) -> [(Double, Bool)]? {
            // Safeguard: Prevent infinite recursion by checking depth
            recursionDepth += 1
            if recursionDepth > maxRecursionDepth {
                return nil // Exceeded safe recursion depth, abort
            }

            // Base case: if remaining weight is zero, we found a valid combination
            if remainingWeight == 0 {
                return currentPlates
            }

            // If remaining weight is negative, this path is not valid
            if remainingWeight < 0 {
                return nil
            }

            // Try adding plates recursively
            for plate in enabledPlates {
                // Avoid infinite recursion when there's no smaller plate to adjust the weight
                if plate > remainingWeight {
                    continue
                }

                // Try to place a plate on both sides
                var newPlates = currentPlates
                newPlates.append((plate, true))  // Left side plate
                newPlates.append((plate, false)) // Right side plate

                // Recur with the updated remaining weight and plate set
                if let validCombination = findPlates(remainingWeight - plate, currentPlates: newPlates) {
                    return validCombination // Return the valid combination found
                }
            }

            // If no valid combination was found, return nil
            return nil
        }

        // Try to find a valid combination of plates
        if let validPlates = findPlates(remainingWeight, currentPlates: []) {
            // Add plates to the barbell based on the validPlates array
            for (plateWeight, isLeftSide) in validPlates {
                // Create and position the plate on the correct side
                let plateNode = createPlateNode(weight: plateWeight, thickness: fixedThickness)
                if isLeftSide {
                    plateNode.position = SCNVector3(0, leftEndPosition, 0) // Position on the left side along the X-axis
                    leftEndPosition -= fixedThickness // Move by the fixed thickness, no gaps
                } else {
                    plateNode.position = SCNVector3(0, rightEndPosition, 0) // Position on the right side along the X-axis
                    rightEndPosition += fixedThickness // Move by the fixed thickness, no gaps
                }

                plateNode.name = "plate"
                barbell.addChildNode(plateNode)
            }
        } else {
            // Handle case where no valid combination is found (optional logging, etc.)
            print("No valid plate combination found.")
        }
    }
    
    // Create a 3D plate as a cylinder with fixed thickness
    func createPlateNode(weight: Double, thickness: Float) -> SCNNode {
        // Adjust base radius based on weight
        let baseRadius: CGFloat = 0.15 + CGFloat(weight / 200.0)
        
        // Create the main cylinder with reduced height
        let plateHeight = CGFloat(thickness) * 0.8
        let plateGeometry = SCNCylinder(radius: baseRadius, height: plateHeight)
        
        // Create the main plate node
        let plateNode = SCNNode(geometry: plateGeometry)
        
        // Set material properties for the plate
        plateNode.geometry?.firstMaterial?.diffuse.contents = UIColor(white: 0.25, alpha: 1.0) // Dark gray
        plateNode.geometry?.firstMaterial?.specular.contents = UIColor.darkGray // For some shine
        plateNode.name = "plate"
        
        // Create top and bottom slightly rounded edges
        let taperHeight = CGFloat(thickness) * 0.1 // Taper height for rounding effect
        let topTaper = SCNCylinder(radius: baseRadius * 0.98, height: taperHeight)
        let bottomTaper = SCNCylinder(radius: baseRadius * 0.98, height: taperHeight)
        
        // Position the top and bottom tapers above and below the main plate
        let topTaperNode = SCNNode(geometry: topTaper)
        topTaperNode.position = SCNVector3(0, plateHeight / 2 + taperHeight / 2, 0)
        
        let bottomTaperNode = SCNNode(geometry: bottomTaper)
        bottomTaperNode.position = SCNVector3(0, -plateHeight / 2 - taperHeight / 2, 0)
        
        // Set material properties for the tapers
        topTaperNode.geometry?.firstMaterial?.diffuse.contents = UIColor(white: 0.25, alpha: 1.0)
        topTaperNode.geometry?.firstMaterial?.specular.contents = UIColor.darkGray
        bottomTaperNode.geometry?.firstMaterial?.diffuse.contents = UIColor(white: 0.25, alpha: 1.0)
        bottomTaperNode.geometry?.firstMaterial?.specular.contents = UIColor.darkGray
        
        // Combine the plate and tapers into a single node
        let plateWithRoundedEdgesNode = SCNNode()
        plateWithRoundedEdgesNode.addChildNode(plateNode)
        plateWithRoundedEdgesNode.addChildNode(topTaperNode)
        plateWithRoundedEdgesNode.addChildNode(bottomTaperNode)
        
        return plateWithRoundedEdgesNode
    }
}

// Weight Selector View
struct WeightSelectorView: View {
    @EnvironmentObject var colorSettings: ColorSettings
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @Binding var baseWeight: Double
    let availablePlates: [Double] = Array(stride(from: 2.5, through: 30, by: 2.5))
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Save")
                        .customFont(.semiBold, 15)
                        .foregroundColor(colorSettings.selectedColor)
                        .background(Color.clear)
                        .cornerRadius(10)
                }
        }
        .padding(.leading, 10)
        .padding(.trailing, 10)
        .offset(y: 15)

            
            Text("Adjust Barbell Weight")
                .customFont(.semiBold, 15)
                .padding()
            
            Picker("Barbell Weight", selection: $baseWeight) {
                ForEach(availablePlates, id: \.self) { plate in
                    Text("\(formattedWeight(plate)) kg")
                        .customFont(.medium, 20)
                        .tag(plate)
                        
                }
            }
            .pickerStyle(WheelPickerStyle())
            .padding()
            
            Spacer()
        }

    }
    
    func formattedWeight(_ weight: Double) -> String {
        return weight.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", weight) : String(format: "%.2f", weight)
    }
}

