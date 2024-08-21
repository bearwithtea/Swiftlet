import Foundation

public class UserMenu
{
    let fileManager: FileManager = FileManager.default

    public init()
    {
    }

    func checkForDirectory() -> String?
    {
        print("Is this your first time using Swiftlet? (Y/N)")

        if let response = readLine()?.uppercased()
        {
            if response == "Y"
            {
                print("Please paste the full file path for where you want to store your sets: ")

                if let filePath: String = readLine(), !filePath.isEmpty
                {
                    do
                    {
                        try fileManager.createDirectory(atPath: filePath, withIntermediateDirectories: true, attributes: nil)
                        print("Directory created at path: \(filePath)")
                        return filePath
                    }
                    catch
                    {
                        print("Error creating directory: \(error.localizedDescription)")
                    }
                }
                else
                {
                    print("No file path provided.")
                }
            }
            else
            {
                print("Welcome back to Swiftlet!")
                print("Please paste the full file path for where your sets are stored:")
                if let filePath: String = readLine(), !filePath.isEmpty
                {
                    printAllCurrentSetsInDirectory(filePath: filePath)
                    return filePath
                }
                else
                {
                    print("No file path provided.")
                }
            }
        }
        else
        {
            print("No response provided.")
        }
        return nil
    }

    func printAllCurrentSetsInDirectory(filePath: String)
    {
        do
        {
            let filesAtDirectory = try fileManager.contentsOfDirectory(atPath: filePath)

            print("The current sets in this directory are: ")

            for file in filesAtDirectory
            {
                print(file)
            }
        }
        catch
        {
            print("Failed to read directory: \(error)")
        }
    }

    func getUserActionChoice() -> String?
    {
        print("What do you want to do today?")
        print("Create New Set: 1")
        print("Study a Set: 2")
        print("Edit a Set: 3")

        if let choice: String = readLine(), !choice.isEmpty
        {
            return choice
        }
        else
        {
            print("No choice provided.")
            return nil
        }
    }

    func sendUserBasedOnAction(choice: String, setName: String, setQuestionsDictionary: [Int: CreateSet.SetQuestions])
    {
        let createSetInstance = CreateSet()
        let readSetInstance = ReadSet()
        let updateSetInstance = UpdateSet()

        switch choice
        {
            case "1":
                if var setData = createSetInstance.createSetData()
                {
                    setData = createSetInstance.addSetQuestionsAndAnswers(setData: setData)
                }
            case "2":
                if let fileURL = readSetInstance.getFileURL()
                {
                    if let studySetData = readSetInstance.readSet(from: fileURL)
                    {
                        readSetInstance.promptUserForAnswers(from: studySetData)
                    }
                }
            case "3":
                print("Edit a Set functionality needs to be implemented.")
        default:
            print("Invalid choice, please enter: 1, 2, or 3.")
            if let newChoice = getUserActionChoice()
            {
                sendUserBasedOnAction(choice: newChoice, setName: setName, setQuestionsDictionary: setQuestionsDictionary)
            }
        }
    }
}
