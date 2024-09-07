import Foundation

struct Question: Codable
{
    let question: String
    let answer: String
}

struct StudySetData: Codable
{
    let name: String
    let description: String
    let questions: [Question]
}

public class ReadSet
{
    public init()
    { }

    func getFileURL() -> URL?
    {
        print("What is the full file path of the set that you would like to study?")
        guard let filePath = readLine(), !filePath.isEmpty else
        {
            print("No input provided.")
            return nil
        }

        let fileURL = URL(fileURLWithPath: filePath)

        if fileURL.pathExtension.lowercased() == "json"
        {
            return fileURL
        }
        else
        {
            print("The file is not a JSON file. Please provide a valid JSON file.")
            return nil
        }
    }

    func readSet(from fileURL: URL) -> StudySetData?
    {
        do
        {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            let studySetData = try decoder.decode(StudySetData.self, from: data)
            return studySetData
        } catch
        {
            print("Error reading or decoding file: \(error.localizedDescription)")
            return nil
        }
    }

    func promptUserForAnswers(from studySetData: StudySetData)
    {
        var numCorrect: Int = 0
        var numIncorrect: Int = 0

        print("Studying Set: \(studySetData.name)")
        print("Description: \(studySetData.description)\n")

        var userAnswers: [String: String] = [:]

        for (index, question) in studySetData.questions.enumerated()
        {
            print("Q\(index + 1): \(question.answer)")
            print("Your answer: ", terminator: "")

            if let userAnswer = readLine() {
                userAnswers[question.question] = userAnswer

                if userAnswer.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == question.answer.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() {
                    numCorrect += 1
                }
                else
                {
                    print("Close Enough? (Y/N): ")
                    guard let closeEnoughAnswer = readLine(), !closeEnoughAnswer.isEmpty else
                    {
                        print("No input provided.")
                        numIncorrect += 1
                        continue
                    }

                    if closeEnoughAnswer.uppercased() == "Y"
                    {
                        numCorrect += 1
                    }
                    else
                    {
                        numIncorrect += 1
                    }
                }
            }
            else
            {
                print("No input provided.")
                userAnswers[question.question] = "No answer"
                numIncorrect += 1
            }
        }

        print("\nYour answers:")
        for (question, answer) in userAnswers
        {
            print("Q: \(question)")
            print("A: \(answer)\n")
        }

        print("Results:")
        let totalQuestions = numCorrect + numIncorrect
        let percentageCorrect: Double = totalQuestions > 0 ? (Double(numCorrect) / Double(totalQuestions)) * 100 : 0.0
        print("Correct answers: \(numCorrect)")
        print("Incorrect answers: \(numIncorrect)")
        print("Overall Score: \(String(format: "%.2f", percentageCorrect))%")
    }
}
