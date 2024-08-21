import Foundation

public class CreateSet
{
    public init() {}

    struct SetQuestions: Codable
    {
        var question: String
        var answer: String
    }

    struct StudySetData: Codable
    {
        var name: String
        var description: String
        var className: String
        var questions: [SetQuestions]
    }

    func createSetData() -> StudySetData?
    {
        print("Set Name: ")
        guard let setName = readLine(), !setName.isEmpty else
        {
            print("No input provided.")
            return nil
        }

        print("Set Description: ")
        guard let setDescription = readLine(), !setDescription.isEmpty else
        {
            print("No input provided.")
            return nil
        }

        print("Set Class: ")
        guard let setClass = readLine(), !setClass.isEmpty else
        {
            print("No input provided.")
            return nil
        }

        return StudySetData(name: setName, description: setDescription, className: setClass, questions: [])
    }

    func addSetQuestionsAndAnswers(setData: StudySetData) -> StudySetData
    {
        print("You are now adding questions and answers for \(setData.name)")
        print("If you would like to save your work, type 'save' into the question prompt.")
        print("If you would like to delete your work, type 'exit' into the question prompt.")

        var setQuestions = setData.questions
        var questionNumber = setQuestions.count

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
                return StudySetData(name: setData.name, description: setData.description, className: setData.className, questions: setQuestions)
            }
            else if question.lowercased() == "exit"
            {
                print("Exiting without saving!")
                return setData
            }

            print("Answer: ")
            guard let answer = readLine(), !answer.isEmpty else
            {
                print("No input provided.")
                continue
            }

            questionNumber += 1
            setQuestions.append(SetQuestions(question: question, answer: answer))
        }
    }

    func saveToFile(studySetData: StudySetData, toDirectory directoryURL: URL)
    {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do
        {
            let data = try encoder.encode(studySetData)
            let fileName = "\(studySetData.name).json"
            let fileURL = directoryURL.appendingPathComponent(fileName)
            try data.write(to: fileURL)
            print("Set saved to \(fileURL.path)")
        }
        catch
        {
            print("Failed to save data: \(error)")
        }
    }

    func getSaveDirectory() -> URL?
    {
        print("Please provide the directory path where you want to save the set:")
        guard let directoryPath = readLine(), !directoryPath.isEmpty else
        {
            print("No directory path provided.")
            return nil
        }

        let directoryURL = URL(fileURLWithPath: directoryPath, isDirectory: true)

        if FileManager.default.fileExists(atPath: directoryURL.path, isDirectory: nil)
        {
            return directoryURL
        }
        else
        {
            print("The directory does not exist.")
            return nil
        }
    }

    func convertQuestionsArrayToDictionary(questions: [SetQuestions]) -> [Int: SetQuestions]
    {
        var dictionary: [Int: SetQuestions] = [:]
        for (index, question) in questions.enumerated()
        {
            dictionary[index + 1] = question
        }
        return dictionary
    }
}
