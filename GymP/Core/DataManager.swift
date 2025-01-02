//
//  DataManager.swift
//  GymP
//
//  Created by Elias Osarumwense on 15.06.24.
//

import CoreData
import Foundation

// Main data manager to handle the todo items
class DataManager: NSObject, ObservableObject {
    
    static let preview: DataManager = {
        let result = DataManager(inMemory: true)
        let viewContext = result.container.viewContext
        
        for i in 0..<3 {
            let newItem = TrainingExerciseTemplate(context: viewContext)
            newItem.id = UUID()
            newItem.reps = 10
            newItem.weight = 10.0
            newItem.index = Int16(i)
            newItem.isWarmup = false
            newItem.exercise = nil // Set this to an actual Exercise entity if needed
        }
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
        return result
    }()
    
    @Published var exercises: [Exercise] = []
    @Published var exercisetemplate: [TrainingExerciseTemplate] = []
    //@Published var training: [Training] = []

    static let shared = DataManager()
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Exercises")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        super.init()
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unresolved error \(error.localizedDescription)")
            }
        }
    }
    
    func resetPersistentStore() {
            guard let storeURL = container.persistentStoreCoordinator.persistentStores.first?.url else {
                return
            }

            do {
                try container.persistentStoreCoordinator.destroyPersistentStore(at: storeURL, ofType: NSSQLiteStoreType, options: nil)
                try container.persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
                print("Resetted COre Data")
            } catch {
                print("Failed to reset Core Data stack: \(error)")
            }
        }
    func saveContext () {
            let context = container.viewContext
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
    
    func deleteAll() {
        let context = container.viewContext
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Exercise")

        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(batchDeleteRequest)
            try context.save()
            print("All entries deleted successfully.")
        } catch {
            // Handle the Core Data error
            print("Error deleting all entries: \(error.localizedDescription)")
        }
    }
    
    func preloadExercises() {
        let context = container.viewContext

        preloadChestExercises(context: context)
        preloadBackExercises(context: context)
        
        // Save the context
        saveContext()
    }

    func preloadChestExercises(context: NSManagedObjectContext) {
        preloadExercise(
            context: context,
            exerciseName: "Benchpress with Barbell",
            setup: setupBenchpressBarbell
        )
        preloadExercise(
            context: context,
            exerciseName: "Incline Benchpress with Barbell",
            setup: setupInclineBenchpressBarbell
        )
        preloadExercise(
            context: context,
            exerciseName: "Decline Benchpress with Barbell",
            setup: setupDeclineBenchpressBarbell
        )
        preloadExercise(
            context: context,
            exerciseName: "Machine Chest Press",
            setup: setupMachineChestPress
        )
        preloadExercise(
            context: context,
            exerciseName: "Smith Machine Bench Press",
            setup: setupSmithMachineBenchPress
        )
        preloadExercise(
            context: context,
            exerciseName: "Landmine Press",
            setup: setupLandminePress
        )
        preloadExercise(
            context: context,
            exerciseName: "Chest Fly with Dumbbells",
            setup: setupChestFlyDumbbells
        )
        preloadExercise(
            context: context,
            exerciseName: "Incline Dumbbell Fly",
            setup: setupInclineDumbbellFly
        )
        preloadExercise(
            context: context,
            exerciseName: "Decline Dumbbell Fly",
            setup: setupDeclineDumbbellFly
        )
        preloadExercise(
            context: context,
            exerciseName: "Push-up",
            setup: setupPushUp
        )
        preloadExercise(
            context: context,
            exerciseName: "Incline Push-up",
            setup: setupInclinePushUp
        )
        preloadExercise(
            context: context,
            exerciseName: "Svend Press",
            setup: setupSvendPress
        )
        preloadExercise(
            context: context,
            exerciseName: "Dips",
            setup: setupDips
        )
        preloadExercise(
            context: context,
            exerciseName: "Chest Press with Dumbbells",
            setup: setupChestPressDumbbells
        )
        preloadExercise(
            context: context,
            exerciseName: "Cable Crossover",
            setup: setupCableCrossover
        )
        preloadExercise(
            context: context,
            exerciseName: "Pec Deck Machine",
            setup: setupPecDeck
        )
        preloadExercise(
            context: context,
            exerciseName: "Dumbbell Pullover",
            setup: setupDumbbellPullover
        )
    }

    func preloadBackExercises(context: NSManagedObjectContext) {
        preloadExercise(
            context: context,
            exerciseName: "Dumbbell Pullover",
            setup: setupBackDumbbellPullover
        )
        preloadExercise(
            context: context,
            exerciseName: "Pull-Up",
            setup: setupPullUp
        )
        preloadExercise(
            context: context,
            exerciseName: "Bent-Over Barbell Row",
            setup: setupBentOverRow
        )
        preloadExercise(
            context: context,
            exerciseName: "T-Bar Row",
            setup: setupTBarRow
        )
        preloadExercise(
            context: context,
            exerciseName: "Seated Cable Row",
            setup: setupSeatedCableRow
        )
        preloadExercise(
            context: context,
            exerciseName: "Deadlift",
            setup: setupDeadlift
        )
        preloadExercise(
            context: context,
            exerciseName: "Dumbbell Row",
            setup: setupDumbbellRow
        )
        preloadExercise(
            context: context,
            exerciseName: "Lat Pulldown",
            setup: setupLatPulldown
        )
        preloadExercise(
            context: context,
            exerciseName: "Face Pull",
            setup: setupFacePull
        )
        preloadExercise(
            context: context,
            exerciseName: "Single-Arm Dumbbell Pullover",
            setup: setupSingleArmDumbbellPullover
        )
        preloadExercise(
            context: context,
            exerciseName: "Inverted Row",
            setup: setupInvertedRow
        )
        preloadExercise(
            context: context,
            exerciseName: "Hyperextension",
            setup: setupHyperextension
        )
        preloadExercise(
            context: context,
            exerciseName: "Hyperextension Flat",
            setup: setupHyperextensionFlat
        )
        preloadExercise(
            context: context,
            exerciseName: "Good Morning",
            setup: setupGoodMorning
        )
        preloadExercise(
            context: context,
            exerciseName: "Renegade Row",
            setup: setupRenegadeRow
        )
        preloadExercise(
            context: context,
            exerciseName: "Chest-Supported T-Bar Row",
            setup: setupChestSupportedTBarRow
        )
        preloadExercise(
            context: context,
            exerciseName: "Romanian Deadlift",
            setup: setupRomanianDeadlift
        )
        preloadExercise(
            context: context,
            exerciseName: "Pull-Up (Wide Grip)",
            setup: setupPullUpWideGrip
        )
        preloadExercise(
            context: context,
            exerciseName: "Barbell Bent-Over Row",
            setup: setupBarbellBentOverRow
        )
        preloadExercise(
            context: context,
            exerciseName: "Pull-Up (Close Grip)",
            setup: setupPullUpCloseGrip
        )
        preloadExercise(
            context: context,
            exerciseName: "Dumbbell Shrugs",
            setup: setupDumbbellShrugs
        )
        preloadExercise(
            context: context,
            exerciseName: "Dumbbell Bent-Over Reverse Fly",
            setup: setupReverseFly
        )
    }

    func preloadExercise(context: NSManagedObjectContext, exerciseName: String, setup: (NSManagedObjectContext) -> Void) {
        let request: NSFetchRequest<Exercise> = Exercise.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", exerciseName)
        
        do {
            let count = try context.count(for: request)
            if count == 0 {
                setup(context)
            }
        } catch {
            print("Failed to check existence of \(exerciseName): \(error)")
        }
    }
    
    func setupBenchpressBarbell(context: NSManagedObjectContext) {
        let benchpressBarbell = Exercise(context: context)
        benchpressBarbell.id = UUID()
        benchpressBarbell.name = "Benchpress with Barbell"
        benchpressBarbell.descrip = """
    Lie on your back on a flat bench. Grip a barbell with hands slightly wider than shoulder width. The bar should be directly over the shoulders.

    1. Press your feet firmly into the ground and keep your hips on the bench throughout the entire movement.

    2. Keep your core engaged and maintain a neutral spine position throughout the movement. Avoid arching your back.

    3. Slowly lift the bar or dumbbells off the rack, if using. Lower the bar to the chest, about nipple level, allowing elbows to bend out to the side, about 45 degrees away from the body.

    4. Stop lowering when your elbows are just below the bench. Press feet into the floor as you push the bar back up to return to starting position.

    5. Perform 5 to 10 reps, depending on weight used. Perform up to 3 sets.
    """
        let muscle1 = Muscle(context: context)
        muscle1.id = UUID()
        muscle1.name = "Chest"
        let muscle2 = Muscle(context: context)
        muscle2.id = UUID()
        muscle2.name = "Triceps"
        let muscle3 = Muscle(context: context)
        muscle3.id = UUID()
        muscle3.name = "Anterior Deltoid"
        benchpressBarbell.addToMuscle(muscle1)
        benchpressBarbell.addToMuscle(muscle2)
        benchpressBarbell.addToMuscle(muscle3)
        let equipment1 = Equipment(context: context)
        equipment1.id = UUID()
        equipment1.name = "Flat bench"
        let equipment2 = Equipment(context: context)
        equipment2.id = UUID()
        equipment2.name = "Barbell"
        benchpressBarbell.addToEquipment(equipment1)
        benchpressBarbell.addToEquipment(equipment2)
        benchpressBarbell.image = "bench-press"
    }

    func setupInclineBenchpressBarbell(context: NSManagedObjectContext) {
        let inclineBenchpressBarbell = Exercise(context: context)
        inclineBenchpressBarbell.id = UUID()
        inclineBenchpressBarbell.name = "Incline Benchpress with Barbell"
        inclineBenchpressBarbell.descrip = """
    Lie on your back on an incline bench. Grip a barbell with hands slightly wider than shoulder width. The bar should be directly over the shoulders.

    1. Press your feet firmly into the ground and keep your hips on the bench throughout the entire movement.

    2. Keep your core engaged and maintain a neutral spine position throughout the movement. Avoid arching your back.

    3. Slowly lift the bar off the rack. Lower the bar to the upper chest, allowing elbows to bend out to the side, about 45 degrees away from the body.

    4. Stop lowering when your elbows are just below the bench. Press feet into the floor as you push the bar back up to return to starting position.

    5. Perform 5 to 10 reps, depending on weight used. Perform up to 3 sets.
    """
        let muscle1 = Muscle(context: context)
        muscle1.id = UUID()
        muscle1.name = "Upper Chest"
        let muscle2 = Muscle(context: context)
        muscle2.id = UUID()
        muscle2.name = "Triceps"
        let muscle3 = Muscle(context: context)
        muscle3.id = UUID()
        muscle3.name = "Anterior Deltoid"
        inclineBenchpressBarbell.addToMuscle(muscle1)
        inclineBenchpressBarbell.addToMuscle(muscle2)
        inclineBenchpressBarbell.addToMuscle(muscle3)
        let equipment1 = Equipment(context: context)
        equipment1.id = UUID()
        equipment1.name = "Incline bench"
        let equipment2 = Equipment(context: context)
        equipment2.id = UUID()
        equipment2.name = "Barbell"
        inclineBenchpressBarbell.addToEquipment(equipment1)
        inclineBenchpressBarbell.addToEquipment(equipment2)
        inclineBenchpressBarbell.image = "incline-bench-press"
    }

    func setupDeclineBenchpressBarbell(context: NSManagedObjectContext) {
        let declineBenchpressBarbell = Exercise(context: context)
        declineBenchpressBarbell.id = UUID()
        declineBenchpressBarbell.name = "Decline Benchpress with Barbell"
        declineBenchpressBarbell.descrip = """
    Lie on your back on a decline bench. Grip a barbell with hands slightly wider than shoulder width. The bar should be directly over the shoulders.

    1. Press your feet firmly into the ground and keep your hips on the bench throughout the entire movement.

    2. Keep your core engaged and maintain a neutral spine position throughout the movement. Avoid arching your back.

    3. Slowly lift the bar off the rack. Lower the bar to the lower chest, allowing elbows to bend out to the side, about 45 degrees away from the body.

    4. Stop lowering when your elbows are just below the bench. Press feet into the floor as you push the bar back up to return to starting position.

    5. Perform 5 to 10 reps, depending on weight used. Perform up to 3 sets.
    """
        let muscle1 = Muscle(context: context)
        muscle1.id = UUID()
        muscle1.name = "Lower Chest"
        let muscle2 = Muscle(context: context)
        muscle2.id = UUID()
        muscle2.name = "Triceps"
        let muscle3 = Muscle(context: context)
        muscle3.id = UUID()
        muscle3.name = "Anterior Deltoid"
        declineBenchpressBarbell.addToMuscle(muscle1)
        declineBenchpressBarbell.addToMuscle(muscle2)
        declineBenchpressBarbell.addToMuscle(muscle3)
        let equipment1 = Equipment(context: context)
        equipment1.id = UUID()
        equipment1.name = "Decline bench"
        let equipment2 = Equipment(context: context)
        equipment2.id = UUID()
        equipment2.name = "Barbell"
        declineBenchpressBarbell.addToEquipment(equipment1)
        declineBenchpressBarbell.addToEquipment(equipment2)
        declineBenchpressBarbell.image = "decline-bench-press"
    }

    func setupMachineChestPress(context: NSManagedObjectContext) {
        let machineChestPress = Exercise(context: context)
        machineChestPress.id = UUID()
        machineChestPress.name = "Machine Chest Press"
        machineChestPress.descrip = """
    Sit on the chest press machine with your back against the pad.

    1. Grip the handles and extend your arms fully to start.

    2. Slowly bring the handles towards your chest, keeping your elbows at a 90-degree angle.

    3. Push the handles back to the starting position, extending your arms fully.

    4. Perform 8 to 12 reps. Perform up to 3 sets.
    """
        let muscle1 = Muscle(context: context)
        muscle1.id = UUID()
        muscle1.name = "Chest"
        let muscle2 = Muscle(context: context)
        muscle2.id = UUID()
        muscle2.name = "Triceps"
        let muscle3 = Muscle(context: context)
        muscle3.id = UUID()
        muscle3.name = "Anterior Deltoid"
        machineChestPress.addToMuscle(muscle1)
        machineChestPress.addToMuscle(muscle2)
        machineChestPress.addToMuscle(muscle3)
        let equipment1 = Equipment(context: context)
        equipment1.id = UUID()
        equipment1.name = "Chest press machine"
        machineChestPress.addToEquipment(equipment1)
        machineChestPress.image = "machine-chest-press"
    }

    func setupSmithMachineBenchPress(context: NSManagedObjectContext) {
        let smithMachineBenchPress = Exercise(context: context)
        smithMachineBenchPress.id = UUID()
        smithMachineBenchPress.name = "Smith Machine Bench Press"
        smithMachineBenchPress.descrip = """
    Lie on your back on a flat bench positioned under a Smith machine.

    1. Grip the bar with hands slightly wider than shoulder width.

    2. Unhook the bar and lower it to your chest.

    3. Press the bar back up to the starting position.

    4. Perform 5 to 10 reps, depending on weight used. Perform up to 3 sets.
    """
        let muscle1 = Muscle(context: context)
        muscle1.id = UUID()
        muscle1.name = "Chest"
        let muscle2 = Muscle(context: context)
        muscle2.id = UUID()
        muscle2.name = "Triceps"
        let muscle3 = Muscle(context: context)
        muscle3.id = UUID()
        muscle3.name = "Anterior Deltoid"
        smithMachineBenchPress.addToMuscle(muscle1)
        smithMachineBenchPress.addToMuscle(muscle2)
        smithMachineBenchPress.addToMuscle(muscle3)
        let equipment1 = Equipment(context: context)
        equipment1.id = UUID()
        equipment1.name = "Smith machine"
        smithMachineBenchPress.addToEquipment(equipment1)
        smithMachineBenchPress.image = "smith-machine-bench-press"
    }

    func setupLandminePress(context: NSManagedObjectContext) {
        let landminePress = Exercise(context: context)
        landminePress.id = UUID()
        landminePress.name = "Landmine Press"
        landminePress.descrip = """
    Stand with your feet shoulder-width apart, holding the end of a barbell that is anchored on the floor.

    1. Hold the barbell at chest height with both hands.

    2. Press the barbell up and slightly forward until your arms are fully extended.

    3. Slowly lower the barbell back to the starting position.

    4. Perform 8 to 12 reps. Perform up to 3 sets.
    """
        let muscle1 = Muscle(context: context)
        muscle1.id = UUID()
        muscle1.name = "Chest"
        let muscle2 = Muscle(context: context)
        muscle2.id = UUID()
        muscle2.name = "Anterior Deltoid"
        landminePress.addToMuscle(muscle1)
        landminePress.addToMuscle(muscle2)
        let equipment1 = Equipment(context: context)
        equipment1.id = UUID()
        equipment1.name = "Landmine attachment"
        landminePress.addToEquipment(equipment1)
        landminePress.image = "landmine-press"
    }

    func setupChestFlyDumbbells(context: NSManagedObjectContext) {
        let chestFlyDumbbells = Exercise(context: context)
        chestFlyDumbbells.id = UUID()
        chestFlyDumbbells.name = "Chest Fly with Dumbbells"
        chestFlyDumbbells.descrip = """
    Lie on your back on a flat bench with a dumbbell in each hand. Extend your arms above you, palms facing each other.

    1. Press your feet firmly into the ground and keep your hips on the bench throughout the entire movement.

    2. Keep a slight bend in your elbows and lower the weights in an arc motion until they are level with your chest.

    3. Squeeze your chest muscles and bring the dumbbells back to the starting position, maintaining the same arc motion.

    4. Perform 8 to 12 reps. Perform up to 3 sets.
    """
        let muscle1 = Muscle(context: context)
        muscle1.id = UUID()
        muscle1.name = "Chest"
        let muscle2 = Muscle(context: context)
        muscle2.id = UUID()
        muscle2.name = "Anterior Deltoid"
        chestFlyDumbbells.addToMuscle(muscle1)
        chestFlyDumbbells.addToMuscle(muscle2)
        let equipment1 = Equipment(context: context)
        equipment1.id = UUID()
        equipment1.name = "Flat bench"
        let equipment2 = Equipment(context: context)
        equipment2.id = UUID()
        equipment2.name = "Dumbbells"
        chestFlyDumbbells.addToEquipment(equipment1)
        chestFlyDumbbells.addToEquipment(equipment2)
        chestFlyDumbbells.image = "chest-fly-dumbbells"
    }

    func setupInclineDumbbellFly(context: NSManagedObjectContext) {
        let inclineDumbbellFly = Exercise(context: context)
        inclineDumbbellFly.id = UUID()
        inclineDumbbellFly.name = "Incline Dumbbell Fly"
        inclineDumbbellFly.descrip = """
    Lie on your back on an incline bench with a dumbbell in each hand. Extend your arms above you, palms facing each other.

    1. Keep a slight bend in your elbows and lower the weights in an arc motion until they are level with your chest.

    2. Squeeze your chest muscles and bring the dumbbells back to the starting position, maintaining the same arc motion.

    3. Perform 8 to 12 reps. Perform up to 3 sets.
    """
        let muscle1 = Muscle(context: context)
        muscle1.id = UUID()
        muscle1.name = "Upper Chest"
        let muscle2 = Muscle(context: context)
        muscle2.id = UUID()
        muscle2.name = "Anterior Deltoid"
        inclineDumbbellFly.addToMuscle(muscle1)
        inclineDumbbellFly.addToMuscle(muscle2)
        let equipment1 = Equipment(context: context)
        equipment1.id = UUID()
        equipment1.name = "Incline bench"
        let equipment2 = Equipment(context: context)
        equipment2.id = UUID()
        equipment2.name = "Dumbbells"
        inclineDumbbellFly.addToEquipment(equipment1)
        inclineDumbbellFly.addToEquipment(equipment2)
        inclineDumbbellFly.image = "incline-dumbbell-fly"
    }

    func setupDeclineDumbbellFly(context: NSManagedObjectContext) {
        let declineDumbbellFly = Exercise(context: context)
        declineDumbbellFly.id = UUID()
        declineDumbbellFly.name = "Decline Dumbbell Fly"
        declineDumbbellFly.descrip = """
    Lie on a decline bench with a dumbbell in each hand. Extend your arms above you, palms facing each other.

    1. Keep a slight bend in your elbows and lower the weights in an arc motion until they are level with your chest.

    2. Squeeze your chest muscles and bring the dumbbells back to the starting position, maintaining the same arc motion.

    3. Perform 8 to 12 reps. Perform up to 3 sets.
    """
        let muscle1 = Muscle(context: context)
        muscle1.id = UUID()
        muscle1.name = "Lower Chest"
        let muscle2 = Muscle(context: context)
        muscle2.id = UUID()
        muscle2.name = "Anterior Deltoid"
        declineDumbbellFly.addToMuscle(muscle1)
        declineDumbbellFly.addToMuscle(muscle2)
        let equipment1 = Equipment(context: context)
        equipment1.id = UUID()
        equipment1.name = "Decline bench"
        let equipment2 = Equipment(context: context)
        equipment2.id = UUID()
        equipment2.name = "Dumbbells"
        declineDumbbellFly.addToEquipment(equipment1)
        declineDumbbellFly.addToEquipment(equipment2)
        declineDumbbellFly.image = "decline-dumbbell-fly"
    }

    func setupPushUp(context: NSManagedObjectContext) {
        let pushUp = Exercise(context: context)
        pushUp.id = UUID()
        pushUp.name = "Push-up"
        pushUp.descrip = """
    Start in a plank position with your hands slightly wider than shoulder-width apart.

    1. Keep your body in a straight line from head to toe without sagging in the middle or arching your back.

    2. Lower your body until your chest nearly touches the floor. Keep your elbows at a 45-degree angle from your body.

    3. Push yourself back up to the starting position.

    4. Perform 10 to 20 reps. Perform up to 3 sets.
    """
        let muscle1 = Muscle(context: context)
        muscle1.id = UUID()
        muscle1.name = "Chest"
        let muscle2 = Muscle(context: context)
        muscle2.id = UUID()
        muscle2.name = "Triceps"
        let muscle3 = Muscle(context: context)
        muscle3.id = UUID()
        muscle3.name = "Anterior Deltoid"
        pushUp.addToMuscle(muscle1)
        pushUp.addToMuscle(muscle2)
        pushUp.addToMuscle(muscle3)
        pushUp.image = "push-up"
    }

    func setupInclinePushUp(context: NSManagedObjectContext) {
        let inclinePushUp = Exercise(context: context)
        inclinePushUp.id = UUID()
        inclinePushUp.name = "Incline Push-up"
        inclinePushUp.descrip = """
    Place your hands on a bench or elevated surface, slightly wider than shoulder-width apart.

    1. Keep your body in a straight line from head to toe without sagging in the middle or arching your back.

    2. Lower your body until your chest nearly touches the bench.

    3. Push yourself back up to the starting position.

    4. Perform 10 to 20 reps. Perform up to 3 sets.
    """
        let muscle1 = Muscle(context: context)
        muscle1.id = UUID()
        muscle1.name = "Upper Chest"
        let muscle2 = Muscle(context: context)
        muscle2.id = UUID()
        muscle2.name = "Triceps"
        let muscle3 = Muscle(context: context)
        muscle3.id = UUID()
        muscle3.name = "Anterior Deltoid"
        inclinePushUp.addToMuscle(muscle1)
        inclinePushUp.addToMuscle(muscle2)
        inclinePushUp.addToMuscle(muscle3)
        let equipment1 = Equipment(context: context)
        equipment1.id = UUID()
        equipment1.name = "Bench"
        inclinePushUp.addToEquipment(equipment1)
        inclinePushUp.image = "incline-push-up"
    }

    func setupSvendPress(context: NSManagedObjectContext) {
        let svendPress = Exercise(context: context)
        svendPress.id = UUID()
        svendPress.name = "Svend Press"
        svendPress.descrip = """
    Stand with feet shoulder-width apart, holding a weight plate with both hands in front of your chest.

    1. Press the plate out in front of you by extending your arms.

    2. Bring the plate back to your chest.

    3. Keep constant tension on your chest throughout the movement.

    4. Perform 10 to 15 reps. Perform up to 3 sets.
    """
        let muscle1 = Muscle(context: context)
        muscle1.id = UUID()
        muscle1.name = "Chest"
        let muscle2 = Muscle(context: context)
        muscle2.id = UUID()
        muscle2.name = "Anterior Deltoid"
        svendPress.addToMuscle(muscle1)
        svendPress.addToMuscle(muscle2)
        let equipment1 = Equipment(context: context)
        equipment1.id = UUID()
        equipment1.name = "Weight plate"
        svendPress.addToEquipment(equipment1)
        svendPress.image = "svend-press"
    }

    func setupDips(context: NSManagedObjectContext) {
        let dips = Exercise(context: context)
        dips.id = UUID()
        dips.name = "Dips"
        dips.descrip = """
    Use parallel bars to support your body with your arms straight down by your sides.

    1. Keep your core engaged and legs straight or slightly bent.

    2. Lower your body by bending your elbows until your shoulders are below your elbows.

    3. Push yourself back up to the starting position.

    4. Perform 8 to 15 reps. Perform up to 3 sets.
    """
        let muscle1 = Muscle(context: context)
        muscle1.id = UUID()
        muscle1.name = "Chest"
        let muscle2 = Muscle(context: context)
        muscle2.id = UUID()
        muscle2.name = "Triceps"
        let muscle3 = Muscle(context: context)
        muscle3.id = UUID()
        muscle3.name = "Anterior Deltoid"
        dips.addToMuscle(muscle1)
        dips.addToMuscle(muscle2)
        dips.addToMuscle(muscle3)
        let equipment1 = Equipment(context: context)
        equipment1.id = UUID()
        equipment1.name = "Parallel bars"
        dips.addToEquipment(equipment1)
        dips.image = "dips"
    }

    func setupChestPressDumbbells(context: NSManagedObjectContext) {
        let chestPressDumbbells = Exercise(context: context)
        chestPressDumbbells.id = UUID()
        chestPressDumbbells.name = "Chest Press with Dumbbells"
        chestPressDumbbells.descrip = """
    Lie on your back on a flat bench with a dumbbell in each hand. Extend your arms above you, palms facing forward.

    1. Press your feet firmly into the ground and keep your hips on the bench throughout the entire movement.

    2. Lower the dumbbells to the sides of your chest, keeping your elbows at a 90-degree angle.

    3. Push the dumbbells back up to the starting position, extending your arms fully.

    4. Perform 8 to 12 reps. Perform up to 3 sets.
    """
        let muscle1 = Muscle(context: context)
        muscle1.id = UUID()
        muscle1.name = "Chest"
        let muscle2 = Muscle(context: context)
        muscle2.id = UUID()
        muscle2.name = "Triceps"
        let muscle3 = Muscle(context: context)
        muscle3.id = UUID()
        muscle3.name = "Anterior Deltoid"
        chestPressDumbbells.addToMuscle(muscle1)
        chestPressDumbbells.addToMuscle(muscle2)
        chestPressDumbbells.addToMuscle(muscle3)
        let equipment1 = Equipment(context: context)
        equipment1.id = UUID()
        equipment1.name = "Flat bench"
        let equipment2 = Equipment(context: context)
        equipment2.id = UUID()
        equipment2.name = "Dumbbells"
        chestPressDumbbells.addToEquipment(equipment1)
        chestPressDumbbells.addToEquipment(equipment2)
        chestPressDumbbells.image = "chest-press-dumbbells"
    }

    func setupCableCrossover(context: NSManagedObjectContext) {
        let cableCrossover = Exercise(context: context)
        cableCrossover.id = UUID()
        cableCrossover.name = "Cable Crossover"
        cableCrossover.descrip = """
    Stand between two cable machines with a handle attached to the high pulley on each side.

    1. Grab the handles and step forward to put tension on the cables.

    2. Keep your elbows slightly bent and bring your hands together in front of you, squeezing your chest muscles.

    3. Slowly return to the starting position, allowing your chest to stretch.

    4. Perform 10 to 15 reps. Perform up to 3 sets.
    """
        let muscle1 = Muscle(context: context)
        muscle1.id = UUID()
        muscle1.name = "Chest"
        let muscle2 = Muscle(context: context)
        muscle2.id = UUID()
        muscle2.name = "Anterior Deltoid"
        cableCrossover.addToMuscle(muscle1)
        cableCrossover.addToMuscle(muscle2)
        let equipment1 = Equipment(context: context)
        equipment1.id = UUID()
        equipment1.name = "Cable machine"
        cableCrossover.addToEquipment(equipment1)
        cableCrossover.image = "cable-crossover"
    }

    func setupPecDeck(context: NSManagedObjectContext) {
        let pecDeck = Exercise(context: context)
        pecDeck.id = UUID()
        pecDeck.name = "Pec Deck Machine"
        pecDeck.descrip = """
    Sit on the pec deck machine with your back against the pad.

    1. Place your forearms on the padded lever and grasp the handles.

    2. Bring your elbows together in front of your chest, squeezing your chest muscles.

    3. Slowly return to the starting position, keeping tension on your chest.

    4. Perform 10 to 15 reps. Perform up to 3 sets.
    """
        let muscle1 = Muscle(context: context)
        muscle1.id = UUID()
        muscle1.name = "Chest"
        let muscle2 = Muscle(context: context)
        muscle2.id = UUID()
        muscle2.name = "Anterior Deltoid"
        pecDeck.addToMuscle(muscle1)
        pecDeck.addToMuscle(muscle2)
        let equipment1 = Equipment(context: context)
        equipment1.id = UUID()
        equipment1.name = "Pec deck machine"
        pecDeck.addToEquipment(equipment1)
        pecDeck.image = "pec-deck"
    }

    func setupDumbbellPullover(context: NSManagedObjectContext) {
        let dumbbellPullover = Exercise(context: context)
        dumbbellPullover.id = UUID()
        dumbbellPullover.name = "Dumbbell Pullover"
        dumbbellPullover.descrip = """
    Lie on your back on a flat bench with a dumbbell held with both hands above your chest.

    1. Keeping your arms slightly bent, lower the dumbbell in an arc behind your head.

    2. Squeeze your chest and lats to bring the dumbbell back to the starting position.

    3. Perform 8 to 12 reps. Perform up to 3 sets.
    """
        let muscle1 = Muscle(context: context)
        muscle1.id = UUID()
        muscle1.name = "Chest"
        muscle1.intensity = "main"
        let muscle2 = Muscle(context: context)
        muscle2.id = UUID()
        muscle2.name = "Lat"
        muscle2.intensity = "main"
        let muscle3 = Muscle(context: context)
        muscle3.id = UUID()
        muscle3.name = "Triceps"
        muscle3.intensity = "second"
        dumbbellPullover.addToMuscle(muscle1)
        dumbbellPullover.addToMuscle(muscle2)
        dumbbellPullover.addToMuscle(muscle3)
        let equipment1 = Equipment(context: context)
        equipment1.id = UUID()
        equipment1.name = "Flat bench"
        let equipment2 = Equipment(context: context)
        equipment2.id = UUID()
        equipment2.name = "Dumbbell"
        dumbbellPullover.addToEquipment(equipment1)
        dumbbellPullover.addToEquipment(equipment2)
        dumbbellPullover.image = "dumbbell-pullover"
    }

    func setupBackDumbbellPullover(context: NSManagedObjectContext) {
        let dumbbellPullover = Exercise(context: context)
        dumbbellPullover.id = UUID()
        dumbbellPullover.name = "Dumbbell Pullover"
        dumbbellPullover.descrip = """
    Lie on your back on a flat bench with a dumbbell held with both hands above your chest.

    1. Keeping your arms slightly bent, lower the dumbbell in an arc behind your head.

    2. Squeeze your chest and lats to bring the dumbbell back to the starting position.

    3. Perform 8 to 12 reps. Perform up to 3 sets.
    """
        let muscle1 = Muscle(context: context)
        muscle1.id = UUID()
        muscle1.name = "Chest"
        muscle1.intensity = "main"
        let muscle2 = Muscle(context: context)
        muscle2.id = UUID()
        muscle2.name = "Lat"
        muscle2.intensity = "main"
        let muscle3 = Muscle(context: context)
        muscle3.id = UUID()
        muscle3.name = "Triceps"
        muscle3.intensity = "second"
        dumbbellPullover.addToMuscle(muscle1)
        dumbbellPullover.addToMuscle(muscle2)
        dumbbellPullover.addToMuscle(muscle3)
        let equipment1 = Equipment(context: context)
        equipment1.id = UUID()
        equipment1.name = "Flat bench"
        let equipment2 = Equipment(context: context)
        equipment2.id = UUID()
        equipment2.name = "Dumbbell"
        dumbbellPullover.addToEquipment(equipment1)
        dumbbellPullover.addToEquipment(equipment2)
        dumbbellPullover.image = "dumbbell-pullover"
    }

    func setupPullUp(context: NSManagedObjectContext) {
        let pullUp = Exercise(context: context)
        pullUp.id = UUID()
        pullUp.name = "Pull-Up"
        pullUp.descrip = """
    Grab a pull-up bar with your palms facing forward and your hands shoulder-width apart.

    1. Pull yourself up until your chin is above the bar.

    2. Lower yourself back to the starting position.

    3. Perform 8 to 12 reps. Perform up to 3 sets.
    """
        let muscle1 = Muscle(context: context)
        muscle1.id = UUID()
        muscle1.name = "Lat"
        muscle1.intensity = "main"
        let muscle2 = Muscle(context: context)
        muscle2.id = UUID()
        muscle2.name = "Upper Back"
        muscle2.intensity = "main"
        let muscle3 = Muscle(context: context)
        muscle3.id = UUID()
        muscle3.name = "Biceps"
        muscle3.intensity = "second"
        pullUp.addToMuscle(muscle1)
        pullUp.addToMuscle(muscle2)
        pullUp.addToMuscle(muscle3)
        let equipment = Equipment(context: context)
        equipment.id = UUID()
        equipment.name = "Pull-up bar"
        pullUp.addToEquipment(equipment)
        pullUp.image = "pull-up"
    }

    func setupBentOverRow(context: NSManagedObjectContext) {
        let bentOverRow = Exercise(context: context)
        bentOverRow.id = UUID()
        bentOverRow.name = "Bent-Over Barbell Row"
        bentOverRow.descrip = """
    Stand with your feet shoulder-width apart, knees slightly bent, and bend at your hips to grab the barbell with an overhand grip.

    1. Pull the barbell towards your lower chest, keeping your elbows close to your body.

    2. Lower the barbell back to the starting position.

    3. Perform 8 to 12 reps. Perform up to 3 sets.
    """
        let muscle1 = Muscle(context: context)
        muscle1.id = UUID()
        muscle1.name = "Lat"
        muscle1.intensity = "main"
        let muscle2 = Muscle(context: context)
        muscle2.id = UUID()
        muscle2.name = "Middle Back"
        muscle2.intensity = "main"
        let muscle3 = Muscle(context: context)
        muscle3.id = UUID()
        muscle3.name = "Biceps"
        muscle3.intensity = "second"
        bentOverRow.addToMuscle(muscle1)
        bentOverRow.addToMuscle(muscle2)
        bentOverRow.addToMuscle(muscle3)
        let equipment = Equipment(context: context)
        equipment.id = UUID()
        equipment.name = "Barbell"
        bentOverRow.addToEquipment(equipment)
        bentOverRow.image = "bent-over-barbell-row"
    }

    func setupTBarRow(context: NSManagedObjectContext) {
        let tBarRow = Exercise(context: context)
        tBarRow.id = UUID()
        tBarRow.name = "T-Bar Row"
        tBarRow.descrip = """
    Stand with your feet on the foot rests of the T-bar machine, bend over, and grasp the handles with an overhand grip.

    1. Pull the handles towards your lower chest, keeping your elbows close to your body.

    2. Lower the handles back to the starting position.

    3. Perform 8 to 12 reps. Perform up to 3 sets.
    """
        let muscle1 = Muscle(context: context)
        muscle1.id = UUID()
        muscle1.name = "Lat"
        muscle1.intensity = "main"
        let muscle2 = Muscle(context: context)
        muscle2.id = UUID()
        muscle2.name = "Middle Back"
        muscle2.intensity = "main"
        let muscle3 = Muscle(context: context)
        muscle3.id = UUID()
        muscle3.name = "Biceps"
        muscle3.intensity = "second"
        tBarRow.addToMuscle(muscle1)
        tBarRow.addToMuscle(muscle2)
        tBarRow.addToMuscle(muscle3)
        let equipment = Equipment(context: context)
        equipment.id = UUID()
        equipment.name = "T-Bar machine"
        tBarRow.addToEquipment(equipment)
        tBarRow.image = "t-bar-row"
    }

    func setupSeatedCableRow(context: NSManagedObjectContext) {
        let seatedRow = Exercise(context: context)
        seatedRow.id = UUID()
        seatedRow.name = "Seated Cable Row"
        seatedRow.descrip = """
    Sit on the seat and place your feet on the footrests. Grab the cable attachment with an overhand grip.

    1. Pull the handle towards your lower chest, squeezing your shoulder blades together.

    2. Extend your arms back to the starting position.

    3. Perform 8 to 12 reps. Perform up to 3 sets.
    """
        let muscle1 = Muscle(context: context)
        muscle1.id = UUID()
        muscle1.name = "Lat"
        muscle1.intensity = "main"
        let muscle2 = Muscle(context: context)
        muscle2.id = UUID()
        muscle2.name = "Middle Back"
        muscle2.intensity = "main"
        let muscle3 = Muscle(context: context)
        muscle3.id = UUID()
        muscle3.name = "Biceps"
        muscle3.intensity = "second"
        seatedRow.addToMuscle(muscle1)
        seatedRow.addToMuscle(muscle2)
        seatedRow.addToMuscle(muscle3)
        let equipment = Equipment(context: context)
        equipment.id = UUID()
        equipment.name = "Cable machine"
        seatedRow.addToEquipment(equipment)
        seatedRow.image = "seated-cable-row"
    }

    func setupDeadlift(context: NSManagedObjectContext) {
        let deadlift = Exercise(context: context)
        deadlift.id = UUID()
        deadlift.name = "Deadlift"
        deadlift.descrip = """
    Stand with your feet hip-width apart, toes under the bar. Bend at your hips and knees, grip the bar just outside your legs with an overhand or mixed grip.

    1. Lift the bar by extending your hips and knees to full extension, keeping your back straight.

    2. Lower the bar back to the floor by bending your hips and knees.

    3. Perform 5 to 8 reps. Perform up to 5 sets.
    """
        let muscle1 = Muscle(context: context)
        muscle1.id = UUID()
        muscle1.name = "Lower Back"
        muscle1.intensity = "main"
        let muscle2 = Muscle(context: context)
        muscle2.id = UUID()
        muscle2.name = "Lat"
        muscle2.intensity = "main"
        let muscle3 = Muscle(context: context)
        muscle3.id = UUID()
        muscle3.name = "Hamstrings"
        muscle3.intensity = "main"
        deadlift.addToMuscle(muscle1)
        deadlift.addToMuscle(muscle2)
        deadlift.addToMuscle(muscle3)
        let equipment1 = Equipment(context: context)
        equipment1.id = UUID()
        equipment1.name = "Barbell"
        deadlift.addToEquipment(equipment1)
        deadlift.image = "deadlift"
    }

    func setupDumbbellRow(context: NSManagedObjectContext) {
        let dumbbellRow = Exercise(context: context)
        dumbbellRow.id = UUID()
        dumbbellRow.name = "Dumbbell Row"
        dumbbellRow.descrip = """
    Place one knee and hand on a flat bench, with your other foot on the ground for support. Hold a dumbbell with your arm extended.

    1. Pull the dumbbell towards your hip, squeezing your shoulder blade.

    2. Lower the dumbbell back to the starting position.

    3. Perform 8 to 12 reps per side. Perform up to 3 sets.
    """
        let muscle1 = Muscle(context: context)
        muscle1.id = UUID()
        muscle1.name = "Lat"
        muscle1.intensity = "main"
        let muscle2 = Muscle(context: context)
        muscle2.id = UUID()
        muscle2.name = "Middle Back"
        muscle2.intensity = "main"
        let muscle3 = Muscle(context: context)
        muscle3.id = UUID()
        muscle3.name = "Biceps"
        muscle3.intensity = "second"
        dumbbellRow.addToMuscle(muscle1)
        dumbbellRow.addToMuscle(muscle2)
        dumbbellRow.addToMuscle(muscle3)
        let equipment = Equipment(context: context)
        equipment.id = UUID()
        equipment.name = "Dumbbell"
        dumbbellRow.addToEquipment(equipment)
        dumbbellRow.image = "dumbbell-row"
    }

    func setupLatPulldown(context: NSManagedObjectContext) {
        let latPulldown = Exercise(context: context)
        latPulldown.id = UUID()
        latPulldown.name = "Lat Pulldown"
        latPulldown.descrip = """
    Sit at a lat pulldown machine with your knees braced under the pads. Grasp the bar with a wide overhand grip.

    1. Pull the bar down towards your upper chest, keeping your torso upright.

    2. Slowly release the bar back to the starting position.

    3. Perform 8 to 12 reps. Perform up to 3 sets.
    """
        let muscle1 = Muscle(context: context)
        muscle1.id = UUID()
        muscle1.name = "Lat"
        muscle1.intensity = "main"
        let muscle2 = Muscle(context: context)
        muscle2.id = UUID()
        muscle2.name = "Middle Back"
        muscle2.intensity = "main"
        let muscle3 = Muscle(context: context)
        muscle3.id = UUID()
        muscle3.name = "Biceps"
        muscle3.intensity = "second"
        latPulldown.addToMuscle(muscle1)
        latPulldown.addToMuscle(muscle2)
        latPulldown.addToMuscle(muscle3)
        let equipment = Equipment(context: context)
        equipment.id = UUID()
        equipment.name = "Lat pulldown machine"
        latPulldown.addToEquipment(equipment)
        latPulldown.image = "lat-pulldown"
    }

    func setupFacePull(context: NSManagedObjectContext) {
        let facePull = Exercise(context: context)
        facePull.id = UUID()
        facePull.name = "Face Pull"
        facePull.descrip = """
    Attach a rope to a cable machine at shoulder height. Stand with feet shoulder-width apart and grab the ends of the rope with an overhand grip.

    1. Pull the rope towards your face, keeping your elbows high and out.

    2. Slowly release the rope back to the starting position.

    3. Perform 10 to 15 reps. Perform up to 3 sets.
    """
        let muscle1 = Muscle(context: context)
        muscle1.id = UUID()
        muscle1.name = "Rear Delts"
        muscle1.intensity = "main"
        let muscle2 = Muscle(context: context)
        muscle2.id = UUID()
        muscle2.name = "Lat"
        muscle2.intensity = "second"
        let muscle3 = Muscle(context: context)
        muscle3.id = UUID()
        muscle3.name = "Upper Back"
        muscle3.intensity = "second"
        facePull.addToMuscle(muscle1)
        facePull.addToMuscle(muscle2)
        facePull.addToMuscle(muscle3)
        let equipment = Equipment(context: context)
        equipment.id = UUID()
        equipment.name = "Cable machine"
        facePull.addToEquipment(equipment)
        facePull.image = "face-pull"
    }

    func setupSingleArmDumbbellPullover(context: NSManagedObjectContext) {
        let singleArmPullover = Exercise(context: context)
        singleArmPullover.id = UUID()
        singleArmPullover.name = "Single-Arm Dumbbell Pullover"
        singleArmPullover.descrip = """
    Lie on your back on a flat bench with a dumbbell held with one hand above your chest.

    1. Keeping your arm slightly bent, lower the dumbbell in an arc behind your head.

    2. Squeeze your chest and lat to bring the dumbbell back to the starting position.

    3. Perform 8 to 12 reps per arm. Perform up to 3 sets.
    """
        let muscle1 = Muscle(context: context)
        muscle1.id = UUID()
        muscle1.name = "Chest"
        muscle1.intensity = "main"
        let muscle2 = Muscle(context: context)
        muscle2.id = UUID()
        muscle2.name = "Lat"
        muscle2.intensity = "main"
        let muscle3 = Muscle(context: context)
        muscle3.id = UUID()
        muscle3.name = "Triceps"
        muscle3.intensity = "second"
        singleArmPullover.addToMuscle(muscle1)
        singleArmPullover.addToMuscle(muscle2)
        singleArmPullover.addToMuscle(muscle3)
        let equipment1 = Equipment(context: context)
        equipment1.id = UUID()
        equipment1.name = "Flat bench"
        let equipment2 = Equipment(context: context)
        equipment2.id = UUID()
        equipment2.name = "Dumbbell"
        singleArmPullover.addToEquipment(equipment1)
        singleArmPullover.addToEquipment(equipment2)
        singleArmPullover.image = "single-arm-dumbbell-pullover"
    }

    func setupInvertedRow(context: NSManagedObjectContext) {
        let invertedRow = Exercise(context: context)
        invertedRow.id = UUID()
        invertedRow.name = "Inverted Row"
        invertedRow.descrip = """
    Set up a barbell in a squat rack or use a suspension trainer. Hang underneath with your body straight and arms fully extended.

    1. Pull your chest towards the bar/trainer, squeezing your shoulder blades together.

    2. Lower your body back to the starting position.

    3. Perform 8 to 12 reps. Perform up to 3 sets.
    """
        let muscle1 = Muscle(context: context)
        muscle1.id = UUID()
        muscle1.name = "Lat"
        muscle1.intensity = "main"
        let muscle2 = Muscle(context: context)
        muscle2.id = UUID()
        muscle2.name = "Middle Back"
        muscle2.intensity = "main"
        let muscle3 = Muscle(context: context)
        muscle3.id = UUID()
        muscle3.name = "Biceps"
        muscle3.intensity = "second"
        invertedRow.addToMuscle(muscle1)
        invertedRow.addToMuscle(muscle2)
        invertedRow.addToMuscle(muscle3)
        let equipment = Equipment(context: context)
        equipment.id = UUID()
        equipment.name = "Barbell or Suspension Trainer"
        invertedRow.addToEquipment(equipment)
        invertedRow.image = "inverted-row"
    }

    func setupHyperextension(context: NSManagedObjectContext) {
        let hyperextension = Exercise(context: context)
        hyperextension.id = UUID()
        hyperextension.name = "Hyperextension"
        hyperextension.descrip = """
    Lie face down on a hyperextension bench with your hips supported. Cross your arms over your chest.

    1. Lift your torso until it is in line with your legs, squeezing your lower back.

    2. Lower your torso back to the starting position.

    3. Perform 12 to 15 reps. Perform up to 3 sets.
    """
        let muscle1 = Muscle(context: context)
        muscle1.id = UUID()
        muscle1.name = "Lower Back"
        muscle1.intensity = "main"
        let muscle2 = Muscle(context: context)
        muscle2.id = UUID()
        muscle2.name = "Glutes"
        muscle2.intensity = "second"
        hyperextension.addToMuscle(muscle1)
        hyperextension.addToMuscle(muscle2)
        let equipment = Equipment(context: context)
        equipment.id = UUID()
        equipment.name = "Hyperextension bench"
        hyperextension.addToEquipment(equipment)
        hyperextension.image = "hyperextension"
    }
    
    func setupHyperextensionFlat(context: NSManagedObjectContext) {
        let hyperextension = Exercise(context: context)
        hyperextension.id = UUID()
        hyperextension.name = "Hyperextension Flat"
        hyperextension.descrip = """
    Lie face down on a hyperextension bench with your hips supported. Cross your arms over your chest.

    1. Lift your torso until it is in line with your legs, squeezing your lower back.

    2. Lower your torso back to the starting position.

    3. Perform 12 to 15 reps. Perform up to 3 sets.
    """
        let muscle1 = Muscle(context: context)
        muscle1.id = UUID()
        muscle1.name = "Lower Back"
        muscle1.intensity = "main"
        let muscle2 = Muscle(context: context)
        muscle2.id = UUID()
        muscle2.name = "Glutes"
        muscle2.intensity = "second"
        hyperextension.addToMuscle(muscle1)
        hyperextension.addToMuscle(muscle2)
        let equipment = Equipment(context: context)
        equipment.id = UUID()
        equipment.name = "Hyperextension flat bench"
        hyperextension.addToEquipment(equipment)
        hyperextension.image = "Hyperextension-Flat-video-white"
    }

    func setupGoodMorning(context: NSManagedObjectContext) {
        let goodMorning = Exercise(context: context)
        goodMorning.id = UUID()
        goodMorning.name = "Good Morning"
        goodMorning.descrip = """
    Stand with your feet shoulder-width apart, holding a barbell across your upper back.

    1. Hinge at your hips, lowering your torso until it is parallel to the floor.

    2. Return to the starting position by extending your hips.

    3. Perform 8 to 12 reps. Perform up to 3 sets.
    """
        let muscle1 = Muscle(context: context)
        muscle1.id = UUID()
        muscle1.name = "Lower Back"
        muscle1.intensity = "main"
        let muscle2 = Muscle(context: context)
        muscle2.id = UUID()
        muscle2.name = "Hamstrings"
        muscle2.intensity = "main"
        let muscle3 = Muscle(context: context)
        muscle3.id = UUID()
        muscle3.name = "Glutes"
        muscle3.intensity = "second"
        goodMorning.addToMuscle(muscle1)
        goodMorning.addToMuscle(muscle2)
        goodMorning.addToMuscle(muscle3)
        let equipment = Equipment(context: context)
        equipment.id = UUID()
        equipment.name = "Barbell"
        goodMorning.addToEquipment(equipment)
        goodMorning.image = "good-morning"
    }

    func setupRenegadeRow(context: NSManagedObjectContext) {
        let renegadeRow = Exercise(context: context)
        renegadeRow.id = UUID()
        renegadeRow.name = "Renegade Row"
        renegadeRow.descrip = """
    Start in a plank position with a dumbbell in each hand, wrists aligned under shoulders.

    1. Row one dumbbell up towards your hip, keeping your body stable and core engaged.

    2. Lower the dumbbell back to the floor and repeat on the other side.

    3. Perform 8 to 12 reps per side. Perform up to 3 sets.
    """
        let muscle1 = Muscle(context: context)
        muscle1.id = UUID()
        muscle1.name = "Lat"
        muscle1.intensity = "main"
        let muscle2 = Muscle(context: context)
        muscle2.id = UUID()
        muscle2.name = "Core"
        muscle2.intensity = "second"
        let muscle3 = Muscle(context: context)
        muscle3.id = UUID()
        muscle3.name = "Shoulders"
        muscle3.intensity = "second"
        renegadeRow.addToMuscle(muscle1)
        renegadeRow.addToMuscle(muscle2)
        renegadeRow.addToMuscle(muscle3)
        let equipment = Equipment(context: context)
        equipment.id = UUID()
        equipment.name = "Dumbbells"
        renegadeRow.addToEquipment(equipment)
        renegadeRow.image = "renegade-row"
    }

    func setupChestSupportedTBarRow(context: NSManagedObjectContext) {
        let chestSupportedRow = Exercise(context: context)
        chestSupportedRow.id = UUID()
        chestSupportedRow.name = "Chest-Supported T-Bar Row"
        chestSupportedRow.descrip = """
    Lie face down on an incline bench with your chest supported and grab the handles of a T-bar machine.

    1. Pull the handles towards your lower chest, squeezing your shoulder blades together.

    2. Lower the handles back to the starting position.

    3. Perform 8 to 12 reps. Perform up to 3 sets.
    """
        let muscle1 = Muscle(context: context)
        muscle1.id = UUID()
        muscle1.name = "Lat"
        muscle1.intensity = "main"
        let muscle2 = Muscle(context: context)
        muscle2.id = UUID()
        muscle2.name = "Middle Back"
        muscle2.intensity = "main"
        let muscle3 = Muscle(context: context)
        muscle3.id = UUID()
        muscle3.name = "Biceps"
        muscle3.intensity = "second"
        chestSupportedRow.addToMuscle(muscle1)
        chestSupportedRow.addToMuscle(muscle2)
        chestSupportedRow.addToMuscle(muscle3)
        let equipment = Equipment(context: context)
        equipment.id = UUID()
        equipment.name = "T-Bar machine"
        chestSupportedRow.addToEquipment(equipment)
        chestSupportedRow.image = "chest-supported-t-bar-row"
    }

    func setupRomanianDeadlift(context: NSManagedObjectContext) {
        let romanianDeadlift = Exercise(context: context)
        romanianDeadlift.id = UUID()
        romanianDeadlift.name = "Romanian Deadlift"
        romanianDeadlift.descrip = """
    Stand with your feet hip-width apart, holding a barbell in front of your thighs.

    1. Hinge at your hips, lowering the barbell along your legs until you feel a stretch in your hamstrings.

    2. Keep your back straight and return to the starting position by extending your hips.

    3. Perform 8 to 12 reps. Perform up to 3 sets.
    """
        let muscle1 = Muscle(context: context)
        muscle1.id = UUID()
        muscle1.name = "Hamstrings"
        muscle1.intensity = "main"
        let muscle2 = Muscle(context: context)
        muscle2.id = UUID()
        muscle2.name = "Lower Back"
        muscle2.intensity = "main"
        let muscle3 = Muscle(context: context)
        muscle3.id = UUID()
        muscle3.name = "Glutes"
        muscle3.intensity = "second"
        romanianDeadlift.addToMuscle(muscle1)
        romanianDeadlift.addToMuscle(muscle2)
        romanianDeadlift.addToMuscle(muscle3)
        let equipment = Equipment(context: context)
        equipment.id = UUID()
        equipment.name = "Barbell"
        romanianDeadlift.addToEquipment(equipment)
        romanianDeadlift.image = "romanian-deadlift"
    }

    func setupPullUpWideGrip(context: NSManagedObjectContext) {
        let pullUpWideGrip = Exercise(context: context)
        pullUpWideGrip.id = UUID()
        pullUpWideGrip.name = "Pull-Up (Wide Grip)"
        pullUpWideGrip.descrip = """
    Grab a pull-up bar with your palms facing forward and your hands wider than shoulder-width apart.

    1. Pull yourself up until your chin is above the bar.

    2. Lower yourself back to the starting position.

    3. Perform 8 to 12 reps. Perform up to 3 sets.
    """
        let muscle1 = Muscle(context: context)
        muscle1.id = UUID()
        muscle1.name = "Lat"
        muscle1.intensity = "main"
        let muscle2 = Muscle(context: context)
        muscle2.id = UUID()
        muscle2.name = "Upper Back"
        muscle2.intensity = "main"
        let muscle3 = Muscle(context: context)
        muscle3.id = UUID()
        muscle3.name = "Biceps"
        muscle3.intensity = "second"
        pullUpWideGrip.addToMuscle(muscle1)
        pullUpWideGrip.addToMuscle(muscle2)
        pullUpWideGrip.addToMuscle(muscle3)
        let equipment = Equipment(context: context)
        equipment.id = UUID()
        equipment.name = "Pull-up bar"
        pullUpWideGrip.addToEquipment(equipment)
        pullUpWideGrip.image = "pull-up-wide-grip"
    }

    func setupBarbellBentOverRow(context: NSManagedObjectContext) {
        let barbellRow = Exercise(context: context)
        barbellRow.id = UUID()
        barbellRow.name = "Barbell Bent-Over Row"
        barbellRow.descrip = """
    Stand with feet shoulder-width apart, knees slightly bent, and bend at your hips to lower your torso until it's almost parallel to the floor. Hold a barbell with an overhand grip, hands shoulder-width apart.

    1. Pull the barbell towards your lower chest, squeezing your shoulder blades together.

    2. Lower the barbell back to the starting position, maintaining control.

    3. Perform 8 to 12 reps. Perform up to 4 sets.
    """
        let muscle1 = Muscle(context: context)
        muscle1.id = UUID()
        muscle1.name = "Lat"
        muscle1.intensity = "main"
        let muscle2 = Muscle(context: context)
        muscle2.id = UUID()
        muscle2.name = "Middle Back"
        muscle2.intensity = "main"
        let muscle3 = Muscle(context: context)
        muscle3.id = UUID()
        muscle3.name = "Biceps"
        muscle3.intensity = "second"
        barbellRow.addToMuscle(muscle1)
        barbellRow.addToMuscle(muscle2)
        barbellRow.addToMuscle(muscle3)
        let equipment = Equipment(context: context)
        equipment.id = UUID()
        equipment.name = "Barbell"
        barbellRow.addToEquipment(equipment)
        barbellRow.image = "barbell-bent-over-row"
    }

    func setupPullUpCloseGrip(context: NSManagedObjectContext) {
        let pullUpCloseGrip = Exercise(context: context)
        pullUpCloseGrip.id = UUID()
        pullUpCloseGrip.name = "Pull-Up (Close Grip)"
        pullUpCloseGrip.descrip = """
    Grab a pull-up bar with your palms facing towards you and your hands shoulder-width apart.

    1. Pull yourself up until your chin clears the bar.

    2. Lower yourself back to the starting position with control.

    3. Perform 8 to 12 reps. Perform up to 3 sets.
    """
        let muscle1 = Muscle(context: context)
        muscle1.id = UUID()
        muscle1.name = "Lat"
        muscle1.intensity = "main"
        let muscle2 = Muscle(context: context)
        muscle2.id = UUID()
        muscle2.name = "Upper Back"
        muscle2.intensity = "main"
        let muscle3 = Muscle(context: context)
        muscle3.id = UUID()
        muscle3.name = "Biceps"
        muscle3.intensity = "second"
        pullUpCloseGrip.addToMuscle(muscle1)
        pullUpCloseGrip.addToMuscle(muscle2)
        pullUpCloseGrip.addToMuscle(muscle3)
        let equipment = Equipment(context: context)
        equipment.id = UUID()
        equipment.name = "Pull-up bar"
        pullUpCloseGrip.addToEquipment(equipment)
        pullUpCloseGrip.image = "pull-up-close-grip"
    }

    func setupDumbbellShrugs(context: NSManagedObjectContext) {
        let dumbbellShrugs = Exercise(context: context)
        dumbbellShrugs.id = UUID()
        dumbbellShrugs.name = "Dumbbell Shrugs"
        dumbbellShrugs.descrip = """
    Stand with feet shoulder-width apart, holding dumbbells at your sides with palms facing your body.

    1. Shrug your shoulders up towards your ears, squeezing your traps.

    2. Lower your shoulders back down with control.

    3. Perform 12 to 15 reps. Perform up to 3 sets.
    """
        let muscle1 = Muscle(context: context)
        muscle1.id = UUID()
        muscle1.name = "Trapezius"
        muscle1.intensity = "main"
        let muscle2 = Muscle(context: context)
        muscle2.id = UUID()
        muscle2.name = "Upper Back"
        muscle2.intensity = "second"
        dumbbellShrugs.addToMuscle(muscle1)
        dumbbellShrugs.addToMuscle(muscle2)
        let equipment = Equipment(context: context)
        equipment.id = UUID()
        equipment.name = "Dumbbells"
        dumbbellShrugs.addToEquipment(equipment)
        dumbbellShrugs.image = "dumbbell-shrugs"
    }

    func setupReverseFly(context: NSManagedObjectContext) {
        let reverseFly = Exercise(context: context)
        reverseFly.id = UUID()
        reverseFly.name = "Dumbbell Bent-Over Reverse Fly"
        reverseFly.descrip = """
    Stand with feet hip-width apart, holding dumbbells in front of thighs with palms facing each other. Hinge at your hips and bend your knees slightly.

    1. Raise the dumbbells to the sides until your arms are parallel to the floor, squeezing your shoulder blades together.

    2. Lower the dumbbells back to the starting position with control.

    3. Perform 12 to 15 reps. Perform up to 3 sets.
    """
        let muscle1 = Muscle(context: context)
        muscle1.id = UUID()
        muscle1.name = "Rear Delts"
        muscle1.intensity = "main"
        let muscle2 = Muscle(context: context)
        muscle2.id = UUID()
        muscle2.name = "Upper Back"
        muscle2.intensity = "main"
        reverseFly.addToMuscle(muscle1)
        reverseFly.addToMuscle(muscle2)
        let equipment = Equipment(context: context)
        equipment.id = UUID()
        equipment.name = "Dumbbells"
        reverseFly.addToEquipment(equipment)
        reverseFly.image = "dumbbell-bent-over-reverse-fly"
    }
    
    
    func ChestExercises() {
        let context = container.viewContext
        
        // Benchpress with Barbell
        let benchpressBarbell = Exercise(context: context)
        benchpressBarbell.id = UUID()
        benchpressBarbell.name = "Benchpress with Barbell"
        benchpressBarbell.descrip = """
Lie on your back on a flat bench. Grip a barbell with hands slightly wider than shoulder width. The bar should be directly over the shoulders.

1. Press your feet firmly into the ground and keep your hips on the bench throughout the entire movement.

2. Keep your core engaged and maintain a neutral spine position throughout the movement. Avoid arching your back.

3. Slowly lift the bar or dumbbells off the rack, if using. Lower the bar to the chest, about nipple level, allowing elbows to bend out to the side, about 45 degrees away from the body.

4. Stop lowering when your elbows are just below the bench. Press feet into the floor as you push the bar back up to return to starting position.

5. Perform 5 to 10 reps, depending on weight used. Perform up to 3 sets.
"""
        
        let benchpressBarbellMuscle1 = Muscle(context: context)
        let benchpressBarbellMuscle2 = Muscle(context: context)
        let benchpressBarbellMuscle3 = Muscle(context: context)
        benchpressBarbellMuscle1.id = UUID()
        benchpressBarbellMuscle1.name = "Chest"
        benchpressBarbellMuscle2.id = UUID()
        benchpressBarbellMuscle2.name = "Triceps"
        benchpressBarbellMuscle3.id = UUID()
        benchpressBarbellMuscle3.name = "Anterior Deltoid"
        benchpressBarbell.addToMuscle(benchpressBarbellMuscle1)
        benchpressBarbell.addToMuscle(benchpressBarbellMuscle2)
        benchpressBarbell.addToMuscle(benchpressBarbellMuscle3)
        let BenchpressBarbellEquipment1 = Equipment(context: context)
        let benchpressBarbellEquipment2 = Equipment(context: context)
        BenchpressBarbellEquipment1.id = UUID()
        BenchpressBarbellEquipment1.name = "Flat bench"
        benchpressBarbellEquipment2.id = UUID()
        benchpressBarbellEquipment2.name = "Barbell"
        benchpressBarbell.addToEquipment(BenchpressBarbellEquipment1)
        benchpressBarbell.addToEquipment(benchpressBarbellEquipment2)
        benchpressBarbell.image = "bench-press"
        
        // Incline Benchpress with Barbell
        let inclineBenchpressBarbell = Exercise(context: context)
        inclineBenchpressBarbell.id = UUID()
        inclineBenchpressBarbell.name = "Incline Benchpress with Barbell"
        inclineBenchpressBarbell.descrip = """
        Lie on your back on an incline bench. Grip a barbell with hands slightly wider than shoulder width. The bar should be directly over the shoulders.

        1. Press your feet firmly into the ground and keep your hips on the bench throughout the entire movement.

        2. Keep your core engaged and maintain a neutral spine position throughout the movement. Avoid arching your back.

        3. Slowly lift the bar off the rack. Lower the bar to the upper chest, allowing elbows to bend out to the side, about 45 degrees away from the body.

        4. Stop lowering when your elbows are just below the bench. Press feet into the floor as you push the bar back up to return to starting position.

        5. Perform 5 to 10 reps, depending on weight used. Perform up to 3 sets.
        """
        let inclineBenchpressBarbellMuscle1 = Muscle(context: context)
        let inclineBenchpressBarbellMuscle2 = Muscle(context: context)
        let inclineBenchpressBarbellMuscle3 = Muscle(context: context)
        inclineBenchpressBarbellMuscle1.id = UUID()
        inclineBenchpressBarbellMuscle1.name = "Upper Chest"
        inclineBenchpressBarbellMuscle2.id = UUID()
        inclineBenchpressBarbellMuscle2.name = "Triceps"
        inclineBenchpressBarbellMuscle3.id = UUID()
        inclineBenchpressBarbellMuscle3.name = "Anterior Deltoid"
        inclineBenchpressBarbell.addToMuscle(inclineBenchpressBarbellMuscle1)
        inclineBenchpressBarbell.addToMuscle(inclineBenchpressBarbellMuscle2)
        inclineBenchpressBarbell.addToMuscle(inclineBenchpressBarbellMuscle3)
        let inclineBenchpressBarbellEquipment1 = Equipment(context: context)
        let inclineBenchpressBarbellEquipment2 = Equipment(context: context)
        inclineBenchpressBarbellEquipment1.id = UUID()
        inclineBenchpressBarbellEquipment1.name = "Incline bench"
        inclineBenchpressBarbellEquipment2.id = UUID()
        inclineBenchpressBarbellEquipment2.name = "Barbell"
        inclineBenchpressBarbell.addToEquipment(inclineBenchpressBarbellEquipment1)
        inclineBenchpressBarbell.addToEquipment(inclineBenchpressBarbellEquipment2)
        inclineBenchpressBarbell.image = "incline-bench-press"

        // Decline Benchpress with Barbell
        let declineBenchpressBarbell = Exercise(context: context)
        declineBenchpressBarbell.id = UUID()
        declineBenchpressBarbell.name = "Decline Benchpress with Barbell"
        declineBenchpressBarbell.descrip = """
        Lie on your back on a decline bench. Grip a barbell with hands slightly wider than shoulder width. The bar should be directly over the shoulders.

        1. Press your feet firmly into the ground and keep your hips on the bench throughout the entire movement.

        2. Keep your core engaged and maintain a neutral spine position throughout the movement. Avoid arching your back.

        3. Slowly lift the bar off the rack. Lower the bar to the lower chest, allowing elbows to bend out to the side, about 45 degrees away from the body.

        4. Stop lowering when your elbows are just below the bench. Press feet into the floor as you push the bar back up to return to starting position.

        5. Perform 5 to 10 reps, depending on weight used. Perform up to 3 sets.
        """
        let declineBenchpressBarbellMuscle1 = Muscle(context: context)
        let declineBenchpressBarbellMuscle2 = Muscle(context: context)
        let declineBenchpressBarbellMuscle3 = Muscle(context: context)
        declineBenchpressBarbellMuscle1.id = UUID()
        declineBenchpressBarbellMuscle1.name = "Lower Chest"
        declineBenchpressBarbellMuscle2.id = UUID()
        declineBenchpressBarbellMuscle2.name = "Triceps"
        declineBenchpressBarbellMuscle3.id = UUID()
        declineBenchpressBarbellMuscle3.name = "Anterior Deltoid"
        declineBenchpressBarbell.addToMuscle(declineBenchpressBarbellMuscle1)
        declineBenchpressBarbell.addToMuscle(declineBenchpressBarbellMuscle2)
        declineBenchpressBarbell.addToMuscle(declineBenchpressBarbellMuscle3)
        let declineBenchpressBarbellEquipment1 = Equipment(context: context)
        let declineBenchpressBarbellEquipment2 = Equipment(context: context)
        declineBenchpressBarbellEquipment1.id = UUID()
        declineBenchpressBarbellEquipment1.name = "Decline bench"
        declineBenchpressBarbellEquipment2.id = UUID()
        declineBenchpressBarbellEquipment2.name = "Barbell"
        declineBenchpressBarbell.addToEquipment(declineBenchpressBarbellEquipment1)
        declineBenchpressBarbell.addToEquipment(declineBenchpressBarbellEquipment2)
        declineBenchpressBarbell.image = "decline-bench-press"

        // Machine Chest Press
        let machineChestPress = Exercise(context: context)
        machineChestPress.id = UUID()
        machineChestPress.name = "Machine Chest Press"
        machineChestPress.descrip = """
        Sit on the chest press machine with your back against the pad.

        1. Grip the handles and extend your arms fully to start.

        2. Slowly bring the handles towards your chest, keeping your elbows at a 90-degree angle.

        3. Push the handles back to the starting position, extending your arms fully.

        4. Perform 8 to 12 reps. Perform up to 3 sets.
        """
        let machineChestPressMuscle1 = Muscle(context: context)
        let machineChestPressMuscle2 = Muscle(context: context)
        let machineChestPressMuscle3 = Muscle(context: context)
        machineChestPressMuscle1.id = UUID()
        machineChestPressMuscle1.name = "Chest"
        machineChestPressMuscle2.id = UUID()
        machineChestPressMuscle2.name = "Triceps"
        machineChestPressMuscle3.id = UUID()
        machineChestPressMuscle3.name = "Anterior Deltoid"
        machineChestPress.addToMuscle(machineChestPressMuscle1)
        machineChestPress.addToMuscle(machineChestPressMuscle2)
        machineChestPress.addToMuscle(machineChestPressMuscle3)
        let machineChestPressEquipment1 = Equipment(context: context)
        machineChestPressEquipment1.id = UUID()
        machineChestPressEquipment1.name = "Chest press machine"
        machineChestPress.addToEquipment(machineChestPressEquipment1)
        machineChestPress.image = "machine-chest-press"
        
        // Smith Machine Bench Press
        let smithMachineBenchPress = Exercise(context: context)
        smithMachineBenchPress.id = UUID()
        smithMachineBenchPress.name = "Smith Machine Bench Press"
        smithMachineBenchPress.descrip = """
        Lie on your back on a flat bench positioned under a Smith machine.

        1. Grip the bar with hands slightly wider than shoulder width.

        2. Unhook the bar and lower it to your chest.

        3. Press the bar back up to the starting position.

        4. Perform 5 to 10 reps, depending on weight used. Perform up to 3 sets.
        """
        let smithMachineBenchPressMuscle1 = Muscle(context: context)
        let smithMachineBenchPressMuscle2 = Muscle(context: context)
        let smithMachineBenchPressMuscle3 = Muscle(context: context)
        smithMachineBenchPressMuscle1.id = UUID()
        smithMachineBenchPressMuscle1.name = "Chest"
        smithMachineBenchPressMuscle2.id = UUID()
        smithMachineBenchPressMuscle2.name = "Triceps"
        smithMachineBenchPressMuscle3.id = UUID()
        smithMachineBenchPressMuscle3.name = "Anterior Deltoid"
        smithMachineBenchPress.addToMuscle(smithMachineBenchPressMuscle1)
        smithMachineBenchPress.addToMuscle(smithMachineBenchPressMuscle2)
        smithMachineBenchPress.addToMuscle(smithMachineBenchPressMuscle3)
        let smithMachineBenchPressEquipment1 = Equipment(context: context)
        smithMachineBenchPressEquipment1.id = UUID()
        smithMachineBenchPressEquipment1.name = "Smith machine"
        smithMachineBenchPress.addToEquipment(smithMachineBenchPressEquipment1)
        smithMachineBenchPress.image = "smith-machine-bench-press"
        
        // Landmine Press
        let landminePress = Exercise(context: context)
        landminePress.id = UUID()
        landminePress.name = "Landmine Press"
        landminePress.descrip = """
        Stand with your feet shoulder-width apart, holding the end of a barbell that is anchored on the floor.

        1. Hold the barbell at chest height with both hands.

        2. Press the barbell up and slightly forward until your arms are fully extended.

        3. Slowly lower the barbell back to the starting position.

        4. Perform 8 to 12 reps. Perform up to 3 sets.
        """
        let landminePressMuscle1 = Muscle(context: context)
        let landminePressMuscle2 = Muscle(context: context)
        landminePressMuscle1.id = UUID()
        landminePressMuscle1.name = "Chest"
        landminePressMuscle2.id = UUID()
        landminePressMuscle2.name = "Anterior Deltoid"
        landminePress.addToMuscle(landminePressMuscle1)
        landminePress.addToMuscle(landminePressMuscle2)
        let landminePressEquipment1 = Equipment(context: context)
        landminePressEquipment1.id = UUID()
        landminePressEquipment1.name = "Landmine attachment"
        landminePress.addToEquipment(landminePressEquipment1)
        landminePress.image = "landmine-press"
        
        // Chest Fly with Dumbbells
        let chestFlyDumbbells = Exercise(context: context)
        chestFlyDumbbells.id = UUID()
        chestFlyDumbbells.name = "Chest Fly with Dumbbells"
        chestFlyDumbbells.descrip = """
        Lie on your back on a flat bench with a dumbbell in each hand. Extend your arms above you, palms facing each other.

        1. Press your feet firmly into the ground and keep your hips on the bench throughout the entire movement.

        2. Keep a slight bend in your elbows and lower the weights in an arc motion until they are level with your chest.

        3. Squeeze your chest muscles and bring the dumbbells back to the starting position, maintaining the same arc motion.

        4. Perform 8 to 12 reps. Perform up to 3 sets.
        """
        let chestFlyDumbbellsMuscle1 = Muscle(context: context)
        let chestFlyDumbbellsMuscle2 = Muscle(context: context)
        chestFlyDumbbellsMuscle1.id = UUID()
        chestFlyDumbbellsMuscle1.name = "Chest"
        chestFlyDumbbellsMuscle2.id = UUID()
        chestFlyDumbbellsMuscle2.name = "Anterior Deltoid"
        chestFlyDumbbells.addToMuscle(chestFlyDumbbellsMuscle1)
        chestFlyDumbbells.addToMuscle(chestFlyDumbbellsMuscle2)
        let chestFlyDumbbellsEquipment1 = Equipment(context: context)
        let chestFlyDumbbellsEquipment2 = Equipment(context: context)
        chestFlyDumbbellsEquipment1.id = UUID()
        chestFlyDumbbellsEquipment1.name = "Flat bench"
        chestFlyDumbbellsEquipment2.id = UUID()
        chestFlyDumbbellsEquipment2.name = "Dumbbells"
        chestFlyDumbbells.addToEquipment(chestFlyDumbbellsEquipment1)
        chestFlyDumbbells.addToEquipment(chestFlyDumbbellsEquipment2)
        chestFlyDumbbells.image = "chest-fly-dumbbells"

        // Incline Dumbbell Fly
        let inclineDumbbellFly = Exercise(context: context)
        inclineDumbbellFly.id = UUID()
        inclineDumbbellFly.name = "Incline Dumbbell Fly"
        inclineDumbbellFly.descrip = """
        Lie on your back on an incline bench with a dumbbell in each hand. Extend your arms above you, palms facing each other.

        1. Keep a slight bend in your elbows and lower the weights in an arc motion until they are level with your chest.

        2. Squeeze your chest muscles and bring the dumbbells back to the starting position, maintaining the same arc motion.

        3. Perform 8 to 12 reps. Perform up to 3 sets.
        """
        let inclineDumbbellFlyMuscle1 = Muscle(context: context)
        let inclineDumbbellFlyMuscle2 = Muscle(context: context)
        inclineDumbbellFlyMuscle1.id = UUID()
        inclineDumbbellFlyMuscle1.name = "Upper Chest"
        inclineDumbbellFlyMuscle2.id = UUID()
        inclineDumbbellFlyMuscle2.name = "Anterior Deltoid"
        inclineDumbbellFly.addToMuscle(inclineDumbbellFlyMuscle1)
        inclineDumbbellFly.addToMuscle(inclineDumbbellFlyMuscle2)
        let inclineDumbbellFlyEquipment1 = Equipment(context: context)
        let inclineDumbbellFlyEquipment2 = Equipment(context: context)
        inclineDumbbellFlyEquipment1.id = UUID()
        inclineDumbbellFlyEquipment1.name = "Incline bench"
        inclineDumbbellFlyEquipment2.id = UUID()
        inclineDumbbellFlyEquipment2.name = "Dumbbells"
        inclineDumbbellFly.addToEquipment(inclineDumbbellFlyEquipment1)
        inclineDumbbellFly.addToEquipment(inclineDumbbellFlyEquipment2)
        inclineDumbbellFly.image = "incline-dumbbell-fly"
        
        // Decline Dumbbell Fly
        let declineDumbbellFly = Exercise(context: context)
        declineDumbbellFly.id = UUID()
        declineDumbbellFly.name = "Decline Dumbbell Fly"
        declineDumbbellFly.descrip = """
        Lie on a decline bench with a dumbbell in each hand. Extend your arms above you, palms facing each other.

        1. Keep a slight bend in your elbows and lower the weights in an arc motion until they are level with your chest.

        2. Squeeze your chest muscles and bring the dumbbells back to the starting position, maintaining the same arc motion.

        3. Perform 8 to 12 reps. Perform up to 3 sets.
        """
        let declineDumbbellFlyMuscle1 = Muscle(context: context)
        let declineDumbbellFlyMuscle2 = Muscle(context: context)
        declineDumbbellFlyMuscle1.id = UUID()
        declineDumbbellFlyMuscle1.name = "Lower Chest"
        declineDumbbellFlyMuscle2.id = UUID()
        declineDumbbellFlyMuscle2.name = "Anterior Deltoid"
        declineDumbbellFly.addToMuscle(declineDumbbellFlyMuscle1)
        declineDumbbellFly.addToMuscle(declineDumbbellFlyMuscle2)
        let declineDumbbellFlyEquipment1 = Equipment(context: context)
        let declineDumbbellFlyEquipment2 = Equipment(context: context)
        declineDumbbellFlyEquipment1.id = UUID()
        declineDumbbellFlyEquipment1.name = "Decline bench"
        declineDumbbellFlyEquipment2.id = UUID()
        declineDumbbellFlyEquipment2.name = "Dumbbells"
        declineDumbbellFly.addToEquipment(declineDumbbellFlyEquipment1)
        declineDumbbellFly.addToEquipment(declineDumbbellFlyEquipment2)
        declineDumbbellFly.image = "decline-dumbbell-fly"

        
        // Push-up
        let pushUp = Exercise(context: context)
        pushUp.id = UUID()
        pushUp.name = "Push-up"
        pushUp.descrip = """
        Start in a plank position with your hands slightly wider than shoulder-width apart.

        1. Keep your body in a straight line from head to toe without sagging in the middle or arching your back.

        2. Lower your body until your chest nearly touches the floor. Keep your elbows at a 45-degree angle from your body.

        3. Push yourself back up to the starting position.

        4. Perform 10 to 20 reps. Perform up to 3 sets.
        """
        let pushUpMuscle1 = Muscle(context: context)
        let pushUpMuscle2 = Muscle(context: context)
        let pushUpMuscle3 = Muscle(context: context)
        pushUpMuscle1.id = UUID()
        pushUpMuscle1.name = "Chest"
        pushUpMuscle2.id = UUID()
        pushUpMuscle2.name = "Triceps"
        pushUpMuscle3.id = UUID()
        pushUpMuscle3.name = "Anterior Deltoid"
        pushUp.addToMuscle(pushUpMuscle1)
        pushUp.addToMuscle(pushUpMuscle2)
        pushUp.addToMuscle(pushUpMuscle3)
        pushUp.image = "push-up"

        // Incline Push-up
        let inclinePushUp = Exercise(context: context)
        inclinePushUp.id = UUID()
        inclinePushUp.name = "Incline Push-up"
        inclinePushUp.descrip = """
        Place your hands on a bench or elevated surface, slightly wider than shoulder-width apart.

        1. Keep your body in a straight line from head to toe without sagging in the middle or arching your back.

        2. Lower your body until your chest nearly touches the bench.

        3. Push yourself back up to the starting position.

        4. Perform 10 to 20 reps. Perform up to 3 sets.
        """
        let inclinePushUpMuscle1 = Muscle(context: context)
        let inclinePushUpMuscle2 = Muscle(context: context)
        let inclinePushUpMuscle3 = Muscle(context: context)
        inclinePushUpMuscle1.id = UUID()
        inclinePushUpMuscle1.name = "Upper Chest"
        inclinePushUpMuscle2.id = UUID()
        inclinePushUpMuscle2.name = "Triceps"
        inclinePushUpMuscle3.id = UUID()
        inclinePushUpMuscle3.name = "Anterior Deltoid"
        inclinePushUp.addToMuscle(inclinePushUpMuscle1)
        inclinePushUp.addToMuscle(inclinePushUpMuscle2)
        inclinePushUp.addToMuscle(inclinePushUpMuscle3)
        let inclinePushUpEquipment1 = Equipment(context: context)
        inclinePushUpEquipment1.id = UUID()
        inclinePushUpEquipment1.name = "Bench"
        inclinePushUp.addToEquipment(inclinePushUpEquipment1)
        inclinePushUp.image = "incline-push-up"
        
        // Svend Press
        let svendPress = Exercise(context: context)
        svendPress.id = UUID()
        svendPress.name = "Svend Press"
        svendPress.descrip = """
        Stand with feet shoulder-width apart, holding a weight plate with both hands in front of your chest.

        1. Press the plate out in front of you by extending your arms.

        2. Bring the plate back to your chest.

        3. Keep constant tension on your chest throughout the movement.

        4. Perform 10 to 15 reps. Perform up to 3 sets.
        """
        let svendPressMuscle1 = Muscle(context: context)
        let svendPressMuscle2 = Muscle(context: context)
        svendPressMuscle1.id = UUID()
        svendPressMuscle1.name = "Chest"
        svendPressMuscle2.id = UUID()
        svendPressMuscle2.name = "Anterior Deltoid"
        svendPress.addToMuscle(svendPressMuscle1)
        svendPress.addToMuscle(svendPressMuscle2)
        let svendPressEquipment1 = Equipment(context: context)
        svendPressEquipment1.id = UUID()
        svendPressEquipment1.name = "Weight plate"
        svendPress.addToEquipment(svendPressEquipment1)
        svendPress.image = "svend-press"
        
        // Dips
        let dips = Exercise(context: context)
        dips.id = UUID()
        dips.name = "Dips"
        dips.descrip = """
        Use parallel bars to support your body with your arms straight down by your sides.

        1. Keep your core engaged and legs straight or slightly bent.

        2. Lower your body by bending your elbows until your shoulders are below your elbows.

        3. Push yourself back up to the starting position.

        4. Perform 8 to 15 reps. Perform up to 3 sets.
        """
        let dipsMuscle1 = Muscle(context: context)
        let dipsMuscle2 = Muscle(context: context)
        let dipsMuscle3 = Muscle(context: context)
        dipsMuscle1.id = UUID()
        dipsMuscle1.name = "Chest"
        dipsMuscle2.id = UUID()
        dipsMuscle2.name = "Triceps"
        dipsMuscle3.id = UUID()
        dipsMuscle3.name = "Anterior Deltoid"
        dips.addToMuscle(dipsMuscle1)
        dips.addToMuscle(dipsMuscle2)
        dips.addToMuscle(dipsMuscle3)
        let dipsEquipment1 = Equipment(context: context)
        dipsEquipment1.id = UUID()
        dipsEquipment1.name = "Parallel bars"
        dips.addToEquipment(dipsEquipment1)
        dips.image = "dips"
        
        // Chest Press with Dumbbells
        let chestPressDumbbells = Exercise(context: context)
        chestPressDumbbells.id = UUID()
        chestPressDumbbells.name = "Chest Press with Dumbbells"
        chestPressDumbbells.descrip = """
        Lie on your back on a flat bench with a dumbbell in each hand. Extend your arms above you, palms facing forward.

        1. Press your feet firmly into the ground and keep your hips on the bench throughout the entire movement.

        2. Lower the dumbbells to the sides of your chest, keeping your elbows at a 90-degree angle.

        3. Push the dumbbells back up to the starting position, extending your arms fully.

        4. Perform 8 to 12 reps. Perform up to 3 sets.
        """
        let chestPressDumbbellsMuscle1 = Muscle(context: context)
        let chestPressDumbbellsMuscle2 = Muscle(context: context)
        let chestPressDumbbellsMuscle3 = Muscle(context: context)
        chestPressDumbbellsMuscle1.id = UUID()
        chestPressDumbbellsMuscle1.name = "Chest"
        chestPressDumbbellsMuscle2.id = UUID()
        chestPressDumbbellsMuscle2.name = "Triceps"
        chestPressDumbbellsMuscle3.id = UUID()
        chestPressDumbbellsMuscle3.name = "Anterior Deltoid"
        chestPressDumbbells.addToMuscle(chestPressDumbbellsMuscle1)
        chestPressDumbbells.addToMuscle(chestPressDumbbellsMuscle2)
        chestPressDumbbells.addToMuscle(chestPressDumbbellsMuscle3)
        let chestPressDumbbellsEquipment1 = Equipment(context: context)
        let chestPressDumbbellsEquipment2 = Equipment(context: context)
        chestPressDumbbellsEquipment1.id = UUID()
        chestPressDumbbellsEquipment1.name = "Flat bench"
        chestPressDumbbellsEquipment2.id = UUID()
        chestPressDumbbellsEquipment2.name = "Dumbbells"
        chestPressDumbbells.addToEquipment(chestPressDumbbellsEquipment1)
        chestPressDumbbells.addToEquipment(chestPressDumbbellsEquipment2)
        chestPressDumbbells.image = "chest-press-dumbbells"
        
        // Decline Bench Press with Barbell
        let declineBenchPressBarbell = Exercise(context: context)
        declineBenchPressBarbell.id = UUID()
        declineBenchPressBarbell.name = "Decline Bench Press with Barbell"
        declineBenchPressBarbell.descrip = """
        Lie on a decline bench with your feet secured at the top.

        1. Grip a barbell with hands slightly wider than shoulder width. The bar should be directly over the shoulders.

        2. Press your feet firmly into the ground and keep your hips on the bench throughout the entire movement.

        3. Lower the bar to the lower part of your chest, allowing elbows to bend out to the side.

        4. Stop lowering when your elbows are just below the bench. Press feet into the floor as you push the bar back up to return to starting position.

        5. Perform 5 to 10 reps, depending on weight used. Perform up to 3 sets.
        """
        let declineBenchPressBarbellMuscle1 = Muscle(context: context)
        let declineBenchPressBarbellMuscle2 = Muscle(context: context)
        let declineBenchPressBarbellMuscle3 = Muscle(context: context)
        declineBenchPressBarbellMuscle1.id = UUID()
        declineBenchPressBarbellMuscle1.name = "Lower Chest"
        declineBenchPressBarbellMuscle2.id = UUID()
        declineBenchPressBarbellMuscle2.name = "Triceps"
        declineBenchPressBarbellMuscle3.id = UUID()
        declineBenchPressBarbellMuscle3.name = "Anterior Deltoid"
        declineBenchPressBarbell.addToMuscle(declineBenchPressBarbellMuscle1)
        declineBenchPressBarbell.addToMuscle(declineBenchPressBarbellMuscle2)
        declineBenchPressBarbell.addToMuscle(declineBenchPressBarbellMuscle3)
        let declineBenchPressBarbellEquipment1 = Equipment(context: context)
        let declineBenchPressBarbellEquipment2 = Equipment(context: context)
        declineBenchPressBarbellEquipment1.id = UUID()
        declineBenchPressBarbellEquipment1.name = "Decline bench"
        declineBenchPressBarbellEquipment2.id = UUID()
        declineBenchPressBarbellEquipment2.name = "Barbell"
        declineBenchPressBarbell.addToEquipment(declineBenchPressBarbellEquipment1)
        declineBenchPressBarbell.addToEquipment(declineBenchPressBarbellEquipment2)
        declineBenchPressBarbell.image = "decline-bench-press-barbell"
        
        // Cable Crossover
        let cableCrossover = Exercise(context: context)
        cableCrossover.id = UUID()
        cableCrossover.name = "Cable Crossover"
        cableCrossover.descrip = """
        Stand between two cable machines with a handle attached to the high pulley on each side.

        1. Grab the handles and step forward to put tension on the cables.

        2. Keep your elbows slightly bent and bring your hands together in front of you, squeezing your chest muscles.

        3. Slowly return to the starting position, allowing your chest to stretch.

        4. Perform 10 to 15 reps. Perform up to 3 sets.
        """
        let cableCrossoverMuscle1 = Muscle(context: context)
        let cableCrossoverMuscle2 = Muscle(context: context)
        cableCrossoverMuscle1.id = UUID()
        cableCrossoverMuscle1.name = "Chest"
        cableCrossoverMuscle2.id = UUID()
        cableCrossoverMuscle2.name = "Anterior Deltoid"
        cableCrossover.addToMuscle(cableCrossoverMuscle1)
        cableCrossover.addToMuscle(cableCrossoverMuscle2)
        let cableCrossoverEquipment1 = Equipment(context: context)
        cableCrossoverEquipment1.id = UUID()
        cableCrossoverEquipment1.name = "Cable machine"
        cableCrossover.addToEquipment(cableCrossoverEquipment1)
        cableCrossover.image = "cable-crossover"

        // Pec Deck Machine
        let pecDeck = Exercise(context: context)
        pecDeck.id = UUID()
        pecDeck.name = "Pec Deck Machine"
        pecDeck.descrip = """
        Sit on the pec deck machine with your back against the pad.

        1. Place your forearms on the padded lever and grasp the handles.

        2. Bring your elbows together in front of your chest, squeezing your chest muscles.

        3. Slowly return to the starting position, keeping tension on your chest.

        4. Perform 10 to 15 reps. Perform up to 3 sets.
        """
        let pecDeckMuscle1 = Muscle(context: context)
        let pecDeckMuscle2 = Muscle(context: context)
        pecDeckMuscle1.id = UUID()
        pecDeckMuscle1.name = "Chest"
        pecDeckMuscle2.id = UUID()
        pecDeckMuscle2.name = "Anterior Deltoid"
        pecDeck.addToMuscle(pecDeckMuscle1)
        pecDeck.addToMuscle(pecDeckMuscle2)
        let pecDeckEquipment1 = Equipment(context: context)
        pecDeckEquipment1.id = UUID()
        pecDeckEquipment1.name = "Pec deck machine"
        pecDeck.addToEquipment(pecDeckEquipment1)
        pecDeck.image = "pec-deck"
        
        // Dumbbell Pullover
        let dumbbellPullover = Exercise(context: context)
        dumbbellPullover.id = UUID()
        dumbbellPullover.name = "Dumbbell Pullover"
        dumbbellPullover.descrip = """
        Lie on your back on a flat bench with a dumbbell held with both hands above your chest.

        1. Keeping your arms slightly bent, lower the dumbbell in an arc behind your head.

        2. Squeeze your chest and lats to bring the dumbbell back to the starting position.

        3. Perform 8 to 12 reps. Perform up to 3 sets.
        """
        let dumbbellPulloverMuscle1 = Muscle(context: context)
        let dumbbellPulloverMuscle2 = Muscle(context: context)
        let dumbbellPulloverMuscle3 = Muscle(context: context)
        dumbbellPulloverMuscle1.id = UUID()
        dumbbellPulloverMuscle1.name = "Chest"
        dumbbellPulloverMuscle1.intensity = "main"
        dumbbellPulloverMuscle2.id = UUID()
        dumbbellPulloverMuscle2.name = "Lat"
        dumbbellPulloverMuscle2.intensity = "main"
        dumbbellPulloverMuscle3.id = UUID()
        dumbbellPulloverMuscle3.name = "Triceps"
        dumbbellPulloverMuscle3.intensity = "second"
        dumbbellPullover.addToMuscle(dumbbellPulloverMuscle1)
        dumbbellPullover.addToMuscle(dumbbellPulloverMuscle2)
        dumbbellPullover.addToMuscle(dumbbellPulloverMuscle3)
        let dumbbellPulloverEquipment1 = Equipment(context: context)
        dumbbellPulloverEquipment1.id = UUID()
        dumbbellPulloverEquipment1.name = "Flat bench"
        dumbbellPullover.addToEquipment(dumbbellPulloverEquipment1)
        let dumbbellPulloverEquipment2 = Equipment(context: context)
        dumbbellPulloverEquipment2.id = UUID()
        dumbbellPulloverEquipment2.name = "Dumbbell"
        dumbbellPullover.addToEquipment(dumbbellPulloverEquipment2)
        dumbbellPullover.image = "dumbbell-pullover"
    }
    
    func BackExercises() {
        
        let context = container.viewContext
        
        // Dumbbell Pullover
        let dumbbellPullover = Exercise(context: context)
        dumbbellPullover.id = UUID()
        dumbbellPullover.name = "Dumbbell Pullover"
        dumbbellPullover.descrip = """
        Lie on your back on a flat bench with a dumbbell held with both hands above your chest.

        1. Keeping your arms slightly bent, lower the dumbbell in an arc behind your head.

        2. Squeeze your chest and lats to bring the dumbbell back to the starting position.

        3. Perform 8 to 12 reps. Perform up to 3 sets.
        """
        let dumbbellPulloverMuscle1 = Muscle(context: context)
        let dumbbellPulloverMuscle2 = Muscle(context: context)
        let dumbbellPulloverMuscle3 = Muscle(context: context)
        dumbbellPulloverMuscle1.id = UUID()
        dumbbellPulloverMuscle1.name = "Chest"
        dumbbellPulloverMuscle1.intensity = "main"
        dumbbellPulloverMuscle2.id = UUID()
        dumbbellPulloverMuscle2.name = "Lat"
        dumbbellPulloverMuscle2.intensity = "main"
        dumbbellPulloverMuscle3.id = UUID()
        dumbbellPulloverMuscle3.name = "Triceps"
        dumbbellPulloverMuscle3.intensity = "second"
        dumbbellPullover.addToMuscle(dumbbellPulloverMuscle1)
        dumbbellPullover.addToMuscle(dumbbellPulloverMuscle2)
        dumbbellPullover.addToMuscle(dumbbellPulloverMuscle3)
        let dumbbellPulloverEquipment1 = Equipment(context: context)
        dumbbellPulloverEquipment1.id = UUID()
        dumbbellPulloverEquipment1.name = "Flat bench"
        dumbbellPullover.addToEquipment(dumbbellPulloverEquipment1)
        let dumbbellPulloverEquipment2 = Equipment(context: context)
        dumbbellPulloverEquipment2.id = UUID()
        dumbbellPulloverEquipment2.name = "Dumbbell"
        dumbbellPullover.addToEquipment(dumbbellPulloverEquipment2)
        dumbbellPullover.image = "dumbbell-pullover"
        
        // Pull-Up
        let pullUp = Exercise(context: context)
        pullUp.id = UUID()
        pullUp.name = "Pull-Up"
        pullUp.descrip = """
        Grab a pull-up bar with your palms facing forward and your hands shoulder-width apart.

        1. Pull yourself up until your chin is above the bar.

        2. Lower yourself back to the starting position.

        3. Perform 8 to 12 reps. Perform up to 3 sets.
        """
        let pullUpMuscle1 = Muscle(context: context)
        pullUpMuscle1.id = UUID()
        pullUpMuscle1.name = "Lat"
        pullUpMuscle1.intensity = "main"
        let pullUpMuscle2 = Muscle(context: context)
        pullUpMuscle2.id = UUID()
        pullUpMuscle2.name = "Upper Back"
        pullUpMuscle2.intensity = "main"
        let pullUpMuscle3 = Muscle(context: context)
        pullUpMuscle3.id = UUID()
        pullUpMuscle3.name = "Biceps"
        pullUpMuscle3.intensity = "second"
        pullUp.addToMuscle(pullUpMuscle1)
        pullUp.addToMuscle(pullUpMuscle2)
        pullUp.addToMuscle(pullUpMuscle3)
        let pullUpEquipment = Equipment(context: context)
        pullUpEquipment.id = UUID()
        pullUpEquipment.name = "Pull-up bar"
        pullUp.addToEquipment(pullUpEquipment)
        pullUp.image = "pull-up"
        
        // Bent-Over Barbell Row
        let bentOverRow = Exercise(context: context)
        bentOverRow.id = UUID()
        bentOverRow.name = "Bent-Over Barbell Row"
        bentOverRow.descrip = """
        Stand with your feet shoulder-width apart, knees slightly bent, and bend at your hips to grab the barbell with an overhand grip.

        1. Pull the barbell towards your lower chest, keeping your elbows close to your body.

        2. Lower the barbell back to the starting position.

        3. Perform 8 to 12 reps. Perform up to 3 sets.
        """
        let bentOverRowMuscle1 = Muscle(context: context)
        bentOverRowMuscle1.id = UUID()
        bentOverRowMuscle1.name = "Lat"
        bentOverRowMuscle1.intensity = "main"
        let bentOverRowMuscle2 = Muscle(context: context)
        bentOverRowMuscle2.id = UUID()
        bentOverRowMuscle2.name = "Middle Back"
        bentOverRowMuscle2.intensity = "main"
        let bentOverRowMuscle3 = Muscle(context: context)
        bentOverRowMuscle3.id = UUID()
        bentOverRowMuscle3.name = "Biceps"
        bentOverRowMuscle3.intensity = "second"
        bentOverRow.addToMuscle(bentOverRowMuscle1)
        bentOverRow.addToMuscle(bentOverRowMuscle2)
        bentOverRow.addToMuscle(bentOverRowMuscle3)
        let bentOverRowEquipment = Equipment(context: context)
        bentOverRowEquipment.id = UUID()
        bentOverRowEquipment.name = "Barbell"
        bentOverRow.addToEquipment(bentOverRowEquipment)
        bentOverRow.image = "bent-over-barbell-row"
        
        // T-Bar Row
        let tBarRow = Exercise(context: context)
        tBarRow.id = UUID()
        tBarRow.name = "T-Bar Row"
        tBarRow.descrip = """
        Stand with your feet on the foot rests of the T-bar machine, bend over, and grasp the handles with an overhand grip.

        1. Pull the handles towards your lower chest, keeping your elbows close to your body.

        2. Lower the handles back to the starting position.

        3. Perform 8 to 12 reps. Perform up to 3 sets.
        """
        let tBarRowMuscle1 = Muscle(context: context)
        tBarRowMuscle1.id = UUID()
        tBarRowMuscle1.name = "Lat"
        tBarRowMuscle1.intensity = "main"
        let tBarRowMuscle2 = Muscle(context: context)
        tBarRowMuscle2.id = UUID()
        tBarRowMuscle2.name = "Middle Back"
        tBarRowMuscle2.intensity = "main"
        let tBarRowMuscle3 = Muscle(context: context)
        tBarRowMuscle3.id = UUID()
        tBarRowMuscle3.name = "Biceps"
        tBarRowMuscle3.intensity = "second"
        tBarRow.addToMuscle(tBarRowMuscle1)
        tBarRow.addToMuscle(tBarRowMuscle2)
        tBarRow.addToMuscle(tBarRowMuscle3)
        let tBarRowEquipment = Equipment(context: context)
        tBarRowEquipment.id = UUID()
        tBarRowEquipment.name = "T-Bar machine"
        tBarRow.addToEquipment(tBarRowEquipment)
        tBarRow.image = "t-bar-row"
        
        // Seated Cable Row
        let seatedRow = Exercise(context: context)
        seatedRow.id = UUID()
        seatedRow.name = "Seated Cable Row"
        seatedRow.descrip = """
        Sit on the seat and place your feet on the footrests. Grab the cable attachment with an overhand grip.

        1. Pull the handle towards your lower chest, squeezing your shoulder blades together.

        2. Extend your arms back to the starting position.

        3. Perform 8 to 12 reps. Perform up to 3 sets.
        """
        let seatedRowMuscle1 = Muscle(context: context)
        seatedRowMuscle1.id = UUID()
        seatedRowMuscle1.name = "Lat"
        seatedRowMuscle1.intensity = "main"
        let seatedRowMuscle2 = Muscle(context: context)
        seatedRowMuscle2.id = UUID()
        seatedRowMuscle2.name = "Middle Back"
        seatedRowMuscle2.intensity = "main"
        let seatedRowMuscle3 = Muscle(context: context)
        seatedRowMuscle3.id = UUID()
        seatedRowMuscle3.name = "Biceps"
        seatedRowMuscle3.intensity = "second"
        seatedRow.addToMuscle(seatedRowMuscle1)
        seatedRow.addToMuscle(seatedRowMuscle2)
        seatedRow.addToMuscle(seatedRowMuscle3)
        let seatedRowEquipment = Equipment(context: context)
        seatedRowEquipment.id = UUID()
        seatedRowEquipment.name = "Cable machine"
        seatedRow.addToEquipment(seatedRowEquipment)
        seatedRow.image = "seated-cable-row"

        // Deadlift
        let deadlift = Exercise(context: context)
        deadlift.id = UUID()
        deadlift.name = "Deadlift"
        deadlift.descrip = """
        Stand with your feet hip-width apart, toes under the bar. Bend at your hips and knees, grip the bar just outside your legs with an overhand or mixed grip.

        1. Lift the bar by extending your hips and knees to full extension, keeping your back straight.

        2. Lower the bar back to the floor by bending your hips and knees.

        3. Perform 5 to 8 reps. Perform up to 5 sets.
        """
        let deadliftMuscle1 = Muscle(context: context)
        deadliftMuscle1.id = UUID()
        deadliftMuscle1.name = "Lower Back"
        deadliftMuscle1.intensity = "main"
        let deadliftMuscle2 = Muscle(context: context)
        deadliftMuscle2.id = UUID()
        deadliftMuscle2.name = "Lat"
        deadliftMuscle2.intensity = "main"
        let deadliftMuscle3 = Muscle(context: context)
        deadliftMuscle3.id = UUID()
        deadliftMuscle3.name = "Hamstrings"
        deadliftMuscle3.intensity = "main"
        let deadliftEquipment1 = Equipment(context: context)
        deadliftEquipment1.id = UUID()
        deadliftEquipment1.name = "Barbell"
        deadlift.addToEquipment(deadliftEquipment1)
        deadlift.image = "deadlift"
        
        // Dumbbell Row
        let dumbbellRow = Exercise(context: context)
        dumbbellRow.id = UUID()
        dumbbellRow.name = "Dumbbell Row"
        dumbbellRow.descrip = """
        Place one knee and hand on a flat bench, with your other foot on the ground for support. Hold a dumbbell with your arm extended.

        1. Pull the dumbbell towards your hip, squeezing your shoulder blade.

        2. Lower the dumbbell back to the starting position.

        3. Perform 8 to 12 reps per side. Perform up to 3 sets.
        """
        let dumbbellRowMuscle1 = Muscle(context: context)
        dumbbellRowMuscle1.id = UUID()
        dumbbellRowMuscle1.name = "Lat"
        dumbbellRowMuscle1.intensity = "main"
        let dumbbellRowMuscle2 = Muscle(context: context)
        dumbbellRowMuscle2.id = UUID()
        dumbbellRowMuscle2.name = "Middle Back"
        dumbbellRowMuscle2.intensity = "main"
        let dumbbellRowMuscle3 = Muscle(context: context)
        dumbbellRowMuscle3.id = UUID()
        dumbbellRowMuscle3.name = "Biceps"
        dumbbellRowMuscle3.intensity = "second"
        dumbbellRow.addToMuscle(dumbbellRowMuscle1)
        dumbbellRow.addToMuscle(dumbbellRowMuscle2)
        dumbbellRow.addToMuscle(dumbbellRowMuscle3)
        let dumbbellRowEquipment = Equipment(context: context)
        dumbbellRowEquipment.id = UUID()
        dumbbellRowEquipment.name = "Dumbbell"
        dumbbellRow.addToEquipment(dumbbellRowEquipment)
        dumbbellRow.image = "dumbbell-row"
        
        // Lat Pulldown
        let latPulldown = Exercise(context: context)
        latPulldown.id = UUID()
        latPulldown.name = "Lat Pulldown"
        latPulldown.descrip = """
        Sit at a lat pulldown machine with your knees braced under the pads. Grasp the bar with a wide overhand grip.

        1. Pull the bar down towards your upper chest, keeping your torso upright.

        2. Slowly release the bar back to the starting position.

        3. Perform 8 to 12 reps. Perform up to 3 sets.
        """
        let latPulldownMuscle1 = Muscle(context: context)
        latPulldownMuscle1.id = UUID()
        latPulldownMuscle1.name = "Lat"
        latPulldownMuscle1.intensity = "main"
        let latPulldownMuscle2 = Muscle(context: context)
        latPulldownMuscle2.id = UUID()
        latPulldownMuscle2.name = "Middle Back"
        latPulldownMuscle2.intensity = "main"
        let latPulldownMuscle3 = Muscle(context: context)
        latPulldownMuscle3.id = UUID()
        latPulldownMuscle3.name = "Biceps"
        latPulldownMuscle3.intensity = "second"
        latPulldown.addToMuscle(latPulldownMuscle1)
        latPulldown.addToMuscle(latPulldownMuscle2)
        latPulldown.addToMuscle(latPulldownMuscle3)
        let latPulldownEquipment = Equipment(context: context)
        latPulldownEquipment.id = UUID()
        latPulldownEquipment.name = "Lat pulldown machine"
        latPulldown.addToEquipment(latPulldownEquipment)
        latPulldown.image = "lat-pulldown"
        
        // Face Pull
        let facePull = Exercise(context: context)
        facePull.id = UUID()
        facePull.name = "Face Pull"
        facePull.descrip = """
        Attach a rope to a cable machine at shoulder height. Stand with feet shoulder-width apart and grab the ends of the rope with an overhand grip.

        1. Pull the rope towards your face, keeping your elbows high and out.

        2. Slowly release the rope back to the starting position.

        3. Perform 10 to 15 reps. Perform up to 3 sets.
        """
        let facePullMuscle1 = Muscle(context: context)
        facePullMuscle1.id = UUID()
        facePullMuscle1.name = "Rear Delts"
        facePullMuscle1.intensity = "main"
        let facePullMuscle2 = Muscle(context: context)
        facePullMuscle2.id = UUID()
        facePullMuscle2.name = "Lat"
        facePullMuscle2.intensity = "second"
        let facePullMuscle3 = Muscle(context: context)
        facePullMuscle3.id = UUID()
        facePullMuscle3.name = "Upper Back"
        facePullMuscle3.intensity = "second"
        facePull.addToMuscle(facePullMuscle1)
        facePull.addToMuscle(facePullMuscle2)
        facePull.addToMuscle(facePullMuscle3)
        let facePullEquipment = Equipment(context: context)
        facePullEquipment.id = UUID()
        facePullEquipment.name = "Cable machine"
        facePull.addToEquipment(facePullEquipment)
        facePull.image = "face-pull"
        
        // Single-Arm Dumbbell Pullover
        let singleArmPullover = Exercise(context: context)
        singleArmPullover.id = UUID()
        singleArmPullover.name = "Single-Arm Dumbbell Pullover"
        singleArmPullover.descrip = """
        Lie on your back on a flat bench with a dumbbell held with one hand above your chest.

        1. Keeping your arm slightly bent, lower the dumbbell in an arc behind your head.

        2. Squeeze your chest and lat to bring the dumbbell back to the starting position.

        3. Perform 8 to 12 reps per arm. Perform up to 3 sets.
        """
        let singleArmPulloverMuscle1 = Muscle(context: context)
        singleArmPulloverMuscle1.id = UUID()
        singleArmPulloverMuscle1.name = "Chest"
        singleArmPulloverMuscle1.intensity = "main"
        let singleArmPulloverMuscle2 = Muscle(context: context)
        singleArmPulloverMuscle2.id = UUID()
        singleArmPulloverMuscle2.name = "Lat"
        singleArmPulloverMuscle2.intensity = "main"
        let singleArmPulloverMuscle3 = Muscle(context: context)
        singleArmPulloverMuscle3.id = UUID()
        singleArmPulloverMuscle3.name = "Triceps"
        singleArmPulloverMuscle3.intensity = "second"
        singleArmPullover.addToMuscle(singleArmPulloverMuscle1)
        singleArmPullover.addToMuscle(singleArmPulloverMuscle2)
        singleArmPullover.addToMuscle(singleArmPulloverMuscle3)
        let singleArmPulloverEquipment1 = Equipment(context: context)
        singleArmPulloverEquipment1.id = UUID()
        singleArmPulloverEquipment1.name = "Flat bench"
        singleArmPullover.addToEquipment(singleArmPulloverEquipment1)
        let singleArmPulloverEquipment2 = Equipment(context: context)
        singleArmPulloverEquipment2.id = UUID()
        singleArmPulloverEquipment2.name = "Dumbbell"
        singleArmPullover.addToEquipment(singleArmPulloverEquipment2)
        singleArmPullover.image = "single-arm-dumbbell-pullover"
        
        // Inverted Row (Bodyweight Row)
        let invertedRow = Exercise(context: context)
        invertedRow.id = UUID()
        invertedRow.name = "Inverted Row"
        invertedRow.descrip = """
        Set up a barbell in a squat rack or use a suspension trainer. Hang underneath with your body straight and arms fully extended.

        1. Pull your chest towards the bar/trainer, squeezing your shoulder blades together.

        2. Lower your body back to the starting position.

        3. Perform 8 to 12 reps. Perform up to 3 sets.
        """
        let invertedRowMuscle1 = Muscle(context: context)
        invertedRowMuscle1.id = UUID()
        invertedRowMuscle1.name = "Lat"
        invertedRowMuscle1.intensity = "main"
        let invertedRowMuscle2 = Muscle(context: context)
        invertedRowMuscle2.id = UUID()
        invertedRowMuscle2.name = "Middle Back"
        invertedRowMuscle2.intensity = "main"
        let invertedRowMuscle3 = Muscle(context: context)
        invertedRowMuscle3.id = UUID()
        invertedRowMuscle3.name = "Biceps"
        invertedRowMuscle3.intensity = "second"
        invertedRow.addToMuscle(invertedRowMuscle1)
        invertedRow.addToMuscle(invertedRowMuscle2)
        invertedRow.addToMuscle(invertedRowMuscle3)
        let invertedRowEquipment = Equipment(context: context)
        invertedRowEquipment.id = UUID()
        invertedRowEquipment.name = "Barbell or Suspension Trainer"
        invertedRow.addToEquipment(invertedRowEquipment)
        invertedRow.image = "inverted-row"
        
        // Hyperextension
        let hyperextension = Exercise(context: context)
        hyperextension.id = UUID()
        hyperextension.name = "Hyperextension"
        hyperextension.descrip = """
        Lie face down on a hyperextension bench with your hips supported. Cross your arms over your chest.

        1. Lift your torso until it is in line with your legs, squeezing your lower back.

        2. Lower your torso back to the starting position.

        3. Perform 12 to 15 reps. Perform up to 3 sets.
        """
        let hyperextensionMuscle1 = Muscle(context: context)
        hyperextensionMuscle1.id = UUID()
        hyperextensionMuscle1.name = "Lower Back"
        hyperextensionMuscle1.intensity = "main"
        let hyperextensionMuscle2 = Muscle(context: context)
        hyperextensionMuscle2.id = UUID()
        hyperextensionMuscle2.name = "Glutes"
        hyperextensionMuscle2.intensity = "second"
        hyperextension.addToMuscle(hyperextensionMuscle1)
        hyperextension.addToMuscle(hyperextensionMuscle2)
        let hyperextensionEquipment = Equipment(context: context)
        hyperextensionEquipment.id = UUID()
        hyperextensionEquipment.name = "Hyperextension bench"
        hyperextension.addToEquipment(hyperextensionEquipment)
        hyperextension.image = "hyperextension"
        
        // Good Morning
        let goodMorning = Exercise(context: context)
        goodMorning.id = UUID()
        goodMorning.name = "Good Morning"
        goodMorning.descrip = """
        Stand with your feet shoulder-width apart, holding a barbell across your upper back.

        1. Hinge at your hips, lowering your torso until it is parallel to the floor.

        2. Return to the starting position by extending your hips.

        3. Perform 8 to 12 reps. Perform up to 3 sets.
        """
        let goodMorningMuscle1 = Muscle(context: context)
        goodMorningMuscle1.id = UUID()
        goodMorningMuscle1.name = "Lower Back"
        goodMorningMuscle1.intensity = "main"
        let goodMorningMuscle2 = Muscle(context: context)
        goodMorningMuscle2.id = UUID()
        goodMorningMuscle2.name = "Hamstrings"
        goodMorningMuscle2.intensity = "main"
        let goodMorningMuscle3 = Muscle(context: context)
        goodMorningMuscle3.id = UUID()
        goodMorningMuscle3.name = "Glutes"
        goodMorningMuscle3.intensity = "second"
        goodMorning.addToMuscle(goodMorningMuscle1)
        goodMorning.addToMuscle(goodMorningMuscle2)
        goodMorning.addToMuscle(goodMorningMuscle3)
        let goodMorningEquipment = Equipment(context: context)
        goodMorningEquipment.id = UUID()
        goodMorningEquipment.name = "Barbell"
        goodMorning.addToEquipment(goodMorningEquipment)
        goodMorning.image = "good-morning"
        
        // Renegade Row
        let renegadeRow = Exercise(context: context)
        renegadeRow.id = UUID()
        renegadeRow.name = "Renegade Row"
        renegadeRow.descrip = """
        Start in a plank position with a dumbbell in each hand, wrists aligned under shoulders.

        1. Row one dumbbell up towards your hip, keeping your body stable and core engaged.

        2. Lower the dumbbell back to the floor and repeat on the other side.

        3. Perform 8 to 12 reps per side. Perform up to 3 sets.
        """
        let renegadeRowMuscle1 = Muscle(context: context)
        renegadeRowMuscle1.id = UUID()
        renegadeRowMuscle1.name = "Lat"
        renegadeRowMuscle1.intensity = "main"
        let renegadeRowMuscle2 = Muscle(context: context)
        renegadeRowMuscle2.id = UUID()
        renegadeRowMuscle2.name = "Core"
        renegadeRowMuscle2.intensity = "second"
        let renegadeRowMuscle3 = Muscle(context: context)
        renegadeRowMuscle3.id = UUID()
        renegadeRowMuscle3.name = "Shoulders"
        renegadeRowMuscle3.intensity = "second"
        renegadeRow.addToMuscle(renegadeRowMuscle1)
        renegadeRow.addToMuscle(renegadeRowMuscle2)
        renegadeRow.addToMuscle(renegadeRowMuscle3)
        let renegadeRowEquipment = Equipment(context: context)
        renegadeRowEquipment.id = UUID()
        renegadeRowEquipment.name = "Dumbbells"
        renegadeRow.addToEquipment(renegadeRowEquipment)
        renegadeRow.image = "renegade-row"
        
        // Chest-Supported T-Bar Row
        let chestSupportedRow = Exercise(context: context)
        chestSupportedRow.id = UUID()
        chestSupportedRow.name = "Chest-Supported T-Bar Row"
        chestSupportedRow.descrip = """
        Lie face down on an incline bench with your chest supported and grab the handles of a T-bar machine.

        1. Pull the handles towards your lower chest, squeezing your shoulder blades together.

        2. Lower the handles back to the starting position.

        3. Perform 8 to 12 reps. Perform up to 3 sets.
        """
        let chestSupportedRowMuscle1 = Muscle(context: context)
        chestSupportedRowMuscle1.id = UUID()
        chestSupportedRowMuscle1.name = "Lat"
        chestSupportedRowMuscle1.intensity = "main"
        let chestSupportedRowMuscle2 = Muscle(context: context)
        chestSupportedRowMuscle2.id = UUID()
        chestSupportedRowMuscle2.name = "Middle Back"
        chestSupportedRowMuscle2.intensity = "main"
        let chestSupportedRowMuscle3 = Muscle(context: context)
        chestSupportedRowMuscle3.id = UUID()
        chestSupportedRowMuscle3.name = "Biceps"
        chestSupportedRowMuscle3.intensity = "second"
        chestSupportedRow.addToMuscle(chestSupportedRowMuscle1)
        chestSupportedRow.addToMuscle(chestSupportedRowMuscle2)
        chestSupportedRow.addToMuscle(chestSupportedRowMuscle3)
        let chestSupportedRowEquipment = Equipment(context: context)
        chestSupportedRowEquipment.id = UUID()
        chestSupportedRowEquipment.name = "T-Bar machine"
        chestSupportedRow.addToEquipment(chestSupportedRowEquipment)
        chestSupportedRow.image = "chest-supported-t-bar-row"
        
        // Romanian Deadlift (RDL)
        let romanianDeadlift = Exercise(context: context)
        romanianDeadlift.id = UUID()
        romanianDeadlift.name = "Romanian Deadlift (RDL)"
        romanianDeadlift.descrip = """
        Stand with your feet hip-width apart, holding a barbell in front of your thighs.

        1. Hinge at your hips, lowering the barbell along your legs until you feel a stretch in your hamstrings.

        2. Keep your back straight and return to the starting position by extending your hips.

        3. Perform 8 to 12 reps. Perform up to 3 sets.
        """
        let romanianDeadliftMuscle1 = Muscle(context: context)
        romanianDeadliftMuscle1.id = UUID()
        romanianDeadliftMuscle1.name = "Hamstrings"
        romanianDeadliftMuscle1.intensity = "main"
        let romanianDeadliftMuscle2 = Muscle(context: context)
        romanianDeadliftMuscle2.id = UUID()
        romanianDeadliftMuscle2.name = "Lower Back"
        romanianDeadliftMuscle2.intensity = "main"
        let romanianDeadliftMuscle3 = Muscle(context: context)
        romanianDeadliftMuscle3.id = UUID()
        romanianDeadliftMuscle3.name = "Glutes"
        romanianDeadliftMuscle3.intensity = "second"
        romanianDeadlift.addToMuscle(romanianDeadliftMuscle1)
        romanianDeadlift.addToMuscle(romanianDeadliftMuscle2)
        romanianDeadlift.addToMuscle(romanianDeadliftMuscle3)
        let romanianDeadliftEquipment = Equipment(context: context)
        romanianDeadliftEquipment.id = UUID()
        romanianDeadliftEquipment.name = "Barbell"
        romanianDeadlift.addToEquipment(romanianDeadliftEquipment)
        romanianDeadlift.image = "romanian-deadlift"
        
        // Pull-Up (Wide Grip)
        let pullUpWideGrip = Exercise(context: context)
        pullUpWideGrip.id = UUID()
        pullUpWideGrip.name = "Pull-Up (Wide Grip)"
        pullUpWideGrip.descrip = """
        Grab a pull-up bar with your palms facing forward and your hands wider than shoulder-width apart.

        1. Pull yourself up until your chin is above the bar.

        2. Lower yourself back to the starting position.

        3. Perform 8 to 12 reps. Perform up to 3 sets.
        """
        let pullUpWideGripMuscle1 = Muscle(context: context)
        pullUpWideGripMuscle1.id = UUID()
        pullUpWideGripMuscle1.name = "Lat"
        pullUpWideGripMuscle1.intensity = "main"
        let pullUpWideGripMuscle2 = Muscle(context: context)
        pullUpWideGripMuscle2.id = UUID()
        pullUpWideGripMuscle2.name = "Upper Back"
        pullUpWideGripMuscle2.intensity = "main"
        let pullUpWideGripMuscle3 = Muscle(context: context)
        pullUpWideGripMuscle3.id = UUID()
        pullUpWideGripMuscle3.name = "Biceps"
        pullUpWideGripMuscle3.intensity = "second"
        pullUpWideGrip.addToMuscle(pullUpWideGripMuscle1)
        pullUpWideGrip.addToMuscle(pullUpWideGripMuscle2)
        pullUpWideGrip.addToMuscle(pullUpWideGripMuscle3)
        let pullUpWideGripEquipment = Equipment(context: context)
        pullUpWideGripEquipment.id = UUID()
        pullUpWideGripEquipment.name = "Pull-up bar"
        pullUpWideGrip.addToEquipment(pullUpWideGripEquipment)
        pullUpWideGrip.image = "pull-up-wide-grip"
        
        // Barbell Bent-Over Row
        let barbellRow = Exercise(context: context)
        barbellRow.id = UUID()
        barbellRow.name = "Barbell Bent-Over Row"
        barbellRow.descrip = """
        Stand with feet shoulder-width apart, knees slightly bent, and bend at your hips to lower your torso until it's almost parallel to the floor. Hold a barbell with an overhand grip, hands shoulder-width apart.

        1. Pull the barbell towards your lower chest, squeezing your shoulder blades together.

        2. Lower the barbell back to the starting position, maintaining control.

        3. Perform 8 to 12 reps. Perform up to 4 sets.
        """
        let barbellRowMuscle1 = Muscle(context: context)
        barbellRowMuscle1.id = UUID()
        barbellRowMuscle1.name = "Lat"
        barbellRowMuscle1.intensity = "main"
        let barbellRowMuscle2 = Muscle(context: context)
        barbellRowMuscle2.id = UUID()
        barbellRowMuscle2.name = "Middle Back"
        barbellRowMuscle2.intensity = "main"
        let barbellRowMuscle3 = Muscle(context: context)
        barbellRowMuscle3.id = UUID()
        barbellRowMuscle3.name = "Biceps"
        barbellRowMuscle3.intensity = "second"
        barbellRow.addToMuscle(barbellRowMuscle1)
        barbellRow.addToMuscle(barbellRowMuscle2)
        barbellRow.addToMuscle(barbellRowMuscle3)
        let barbellRowEquipment = Equipment(context: context)
        barbellRowEquipment.id = UUID()
        barbellRowEquipment.name = "Barbell"
        barbellRow.addToEquipment(barbellRowEquipment)
        barbellRow.image = "barbell-bent-over-row"
        
        // Pull-Up (Close Grip)
        let pullUpCloseGrip = Exercise(context: context)
        pullUpCloseGrip.id = UUID()
        pullUpCloseGrip.name = "Pull-Up (Close Grip)"
        pullUpCloseGrip.descrip = """
        Grab a pull-up bar with your palms facing towards you and your hands shoulder-width apart.

        1. Pull yourself up until your chin clears the bar.

        2. Lower yourself back to the starting position with control.

        3. Perform 8 to 12 reps. Perform up to 3 sets.
        """
        let pullUpCloseGripMuscle1 = Muscle(context: context)
        pullUpCloseGripMuscle1.id = UUID()
        pullUpCloseGripMuscle1.name = "Lat"
        pullUpCloseGripMuscle1.intensity = "main"
        let pullUpCloseGripMuscle2 = Muscle(context: context)
        pullUpCloseGripMuscle2.id = UUID()
        pullUpCloseGripMuscle2.name = "Upper Back"
        pullUpCloseGripMuscle2.intensity = "main"
        let pullUpCloseGripMuscle3 = Muscle(context: context)
        pullUpCloseGripMuscle3.id = UUID()
        pullUpCloseGripMuscle3.name = "Biceps"
        pullUpCloseGripMuscle3.intensity = "second"
        pullUpCloseGrip.addToMuscle(pullUpCloseGripMuscle1)
        pullUpCloseGrip.addToMuscle(pullUpCloseGripMuscle2)
        pullUpCloseGrip.addToMuscle(pullUpCloseGripMuscle3)
        let pullUpCloseGripEquipment = Equipment(context: context)
        pullUpCloseGripEquipment.id = UUID()
        pullUpCloseGripEquipment.name = "Pull-up bar"
        pullUpCloseGrip.addToEquipment(pullUpCloseGripEquipment)
        pullUpCloseGrip.image = "pull-up-close-grip"
        
        // Dumbbell Shrugs
        let dumbbellShrugs = Exercise(context: context)
        dumbbellShrugs.id = UUID()
        dumbbellShrugs.name = "Dumbbell Shrugs"
        dumbbellShrugs.descrip = """
        Stand with feet shoulder-width apart, holding dumbbells at your sides with palms facing your body.

        1. Shrug your shoulders up towards your ears, squeezing your traps.

        2. Lower your shoulders back down with control.

        3. Perform 12 to 15 reps. Perform up to 3 sets.
        """
        let dumbbellShrugsMuscle1 = Muscle(context: context)
        dumbbellShrugsMuscle1.id = UUID()
        dumbbellShrugsMuscle1.name = "Trapezius"
        dumbbellShrugsMuscle1.intensity = "main"
        let dumbbellShrugsMuscle2 = Muscle(context: context)
        dumbbellShrugsMuscle2.id = UUID()
        dumbbellShrugsMuscle2.name = "Upper Back"
        dumbbellShrugsMuscle2.intensity = "second"
        dumbbellShrugs.addToMuscle(dumbbellShrugsMuscle1)
        dumbbellShrugs.addToMuscle(dumbbellShrugsMuscle2)
        let dumbbellShrugsEquipment = Equipment(context: context)
        dumbbellShrugsEquipment.id = UUID()
        dumbbellShrugsEquipment.name = "Dumbbells"
        dumbbellShrugs.addToEquipment(dumbbellShrugsEquipment)
        dumbbellShrugs.image = "dumbbell-shrugs"
        
        // Dumbbell Bent-Over Reverse Fly
        let reverseFly = Exercise(context: context)
        reverseFly.id = UUID()
        reverseFly.name = "Dumbbell Bent-Over Reverse Fly"
        reverseFly.descrip = """
        Stand with feet hip-width apart, holding dumbbells in front of thighs with palms facing each other. Hinge at your hips and bend your knees slightly.

        1. Raise the dumbbells to the sides until your arms are parallel to the floor, squeezing your shoulder blades together.

        2. Lower the dumbbells back to the starting position with control.

        3. Perform 12 to 15 reps. Perform up to 3 sets.
        """
        let reverseFlyMuscle1 = Muscle(context: context)
        reverseFlyMuscle1.id = UUID()
        reverseFlyMuscle1.name = "Rear Delts"
        reverseFlyMuscle1.intensity = "main"
        let reverseFlyMuscle2 = Muscle(context: context)
        reverseFlyMuscle2.id = UUID()
        reverseFlyMuscle2.name = "Upper Back"
        reverseFlyMuscle2.intensity = "main"
        reverseFly.addToMuscle(reverseFlyMuscle1)
        reverseFly.addToMuscle(reverseFlyMuscle2)
        let reverseFlyEquipment = Equipment(context: context)
        reverseFlyEquipment.id = UUID()
        reverseFlyEquipment.name = "Dumbbells"
        reverseFly.addToEquipment(reverseFlyEquipment)
        reverseFly.image = "dumbbell-bent-over-reverse-fly"
        
        
    }
}

