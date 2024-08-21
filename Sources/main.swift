import Foundation

let userMenu = UserMenu()
let createSet = CreateSet()
let readSet = ReadSet()
let updateSet = UpdateSet()

func main() {
    guard let filePath = userMenu.checkForDirectory() else
    {
        print("Failed to get a valid directory path.")
        return
    }

    guard let actionChoice = userMenu.getUserActionChoice() else
    {
        print("Failed to get user action choice.")
        return
    }

    switch actionChoice
    {
    case "1":
        if var setData = createSet.createSetData()
        {
            setData = createSet.addSetQuestionsAndAnswers(setData: setData)

            guard let saveDirectory = createSet.getSaveDirectory() else
            {
                print("Failed to get save directory.")
                return
            }
            createSet.saveToFile(studySetData: setData, toDirectory: saveDirectory)
        }
        else
        {
            print("Failed to create set data.")
        }

    case "2":
        if let fileURL = readSet.getFileURL()
        {
            if let studySetData = readSet.readSet(from: fileURL)
            {
                readSet.promptUserForAnswers(from: studySetData)
            }
            else
            {
                print("Failed to read set.")
            }
        }
        else
        {
            print("Failed to get file URL.")
        }

    case "3":
        let updateChoice = updateSet.getUserActionChoice()
        switch updateChoice
        {
        case "1":
            updateSet.updateSet()

        case "2":
            guard let fileURL = updateSet.getFileURL() else
            {
                print("Failed to get file URL.")
                return
            }
            updateSet.deleteSet(filePath: fileURL.lastPathComponent)

        default:
            print("Invalid choice for update/delete.")
        }

    default:
        print("Invalid choice. Please enter 1, 2, or 3.")
    }
}

main()
