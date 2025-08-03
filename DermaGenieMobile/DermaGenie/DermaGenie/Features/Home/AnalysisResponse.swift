
import Foundation

struct AnalysisResponse: Decodable {
    let diagnoses: [String]
    let suggestion: String


    private enum CodingKeys: String, CodingKey {
        case modelResult    = "model_result"
        case skinCareAdvice = "skin_care_advice"
    }

    
    private struct DynamicKey: CodingKey {
        var stringValue: String
        init?(stringValue: String) { self.stringValue = stringValue }
        var intValue: Int? { nil }
        init?(intValue: Int) { return nil }
    }

   
    private struct Detection: Decodable {
        let className: String
        enum CodingKeys: String, CodingKey { case className = "class_name" }
    }

   
    private struct Model: Decodable {
        let detections: [Detection]
    }

    init(from decoder: Decoder) throws {
        let root = try decoder.container(keyedBy: CodingKeys.self)
        suggestion = try root.decode(String.self, forKey: .skinCareAdvice)

        
        let modelResult = try root.nestedContainer(keyedBy: DynamicKey.self,
                                                   forKey: .modelResult)
        let outputsKey = DynamicKey(stringValue: "model_outputs")!
        let outputs = try modelResult.nestedContainer(keyedBy: DynamicKey.self,
                                                      forKey: outputsKey)

        var allDetections: [Detection] = []
        for key in outputs.allKeys {
            let model = try outputs.decode(Model.self, forKey: key)
            allDetections.append(contentsOf: model.detections)
        }

        diagnoses = Array(Set(allDetections.map { $0.className }))
    }
}
