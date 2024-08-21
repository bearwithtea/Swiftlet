import Foundation

public class UpdateSet
{
    public init()
    {
    }

    func getUserActionChoice() -> String?
    {
        print("What action would you like to perform on your sets?")
        print("Update a Set: 1")
        print("Delete a Set: 2")

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

    func deleteSet(filePath: String)
    {
        let fileURL = URL(fileURLWithPath: filePath)

        if !FileManager.default.fileExists(atPath: fileURL.path)
        {
            print("File does not exist at path: \(filePath)")
            return
        }

        var isDirectory: ObjCBool = false
        if FileManager.default.fileExists(atPath: fileURL.path, isDirectory: &isDirectory)
        {
            if isDirectory.boolValue
            {
                print("Path points to a directory, not a file.")
                return
            }
        }

        do
        {
            try FileManager.default.removeItem(at: fileURL)
            print("Deleted set at path: \(filePath)")
        }
        catch
        {
            print("Failed to delete set at path \(filePath): \(error.localizedDescription)")
        }
    }

    func getFileURL() -> URL?
    {
        print("Enter the file path of the set you want to update or delete:")
        guard let filePath = readLine(), !filePath.isEmpty else
        {
            print("No file path provided.")
            return nil
        }
        return URL(fileURLWithPath: filePath)
    }

    func updateSet()
    {
        guard let fileURL = getFileURL() else
        {
            print("Failed to get file URL.")
            return
        }

        do
        {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            var studySetData = try decoder.decode(CreateSet.StudySetData.self, from: data)

            var existingQuestionsDictionary = convertQuestionsArrayToDictionary(questions: studySetData.questions)

            print("You are now adding more questions to the set: \(studySetData.name)")
            print("If you would like to save your work, type 'save' into the question prompt.")
            print("If you would like to exit without saving, type 'exit' into the question prompt.")

            var questionNumber = existingQuestionsDictionary.keys.max() ?? 0

            while true
            {
                print("Question: ")
                guard let question = readLine(), !question.isEmpty else
                {
                    print("No input provided.")
                    continue
                }

                if question.lowercased() == "save"
                {
                    print("Saving your work!")
                    studySetData.questions = Array(existingQuestionsDictionary.values)
                    let encoder = JSONEncoder()
                    encoder.outputFormatting = .prettyPrinted
                    let updatedData = try encoder.encode(studySetData)
                    try updatedData.write(to: fileURL)
                    print("Set updated and saved to \(fileURL.path)")
                    return
                }
                else if question.lowercased() == "exit"
                {
                    print("Exiting without saving!")
                    return
                }

                print("Answer: ")
                guard let answer = readLine(), !answer.isEmpty else
                {
                    print("No input provided.")
                    continue
                }

                questionNumber += 1
                existingQuestionsDictionary[questionNumber] = CreateSet.SetQuestions(question: question, answer: answer)
            }
        }
        catch
        {
            print("Error loading or updating file: \(error.localizedDescription)")
        }
    }

    private func convertQuestionsArrayToDictionary(questions: [CreateSet.SetQuestions]) -> [Int: CreateSet.SetQuestions]
    {
        var dictionary: [Int: CreateSet.SetQuestions] = [:]
        for (index, question) in questions.enumerated()
        {
            dictionary[index + 1] = question
        }
        return dictionary
    }
}
