
import Foundation

struct AnalysisResponse: Decodable {
  
    let diagnoses: [String]
    let suggestion: String

    private enum CodingKeys: String, CodingKey {
        case modelResult    = "model_result"
        case skinCareAdvice = "skin_care_advice"
    }
   
    private struct ModelResult: Decodable {
        let modelOutputs: ModelOutputs
        enum CodingKeys: String, CodingKey { case modelOutputs = "model_outputs" }
    }
    private struct ModelOutputs: Decodable {
        let modelB: ModelB
        enum CodingKeys: String, CodingKey { case modelB = "model_b" }
    }
    private struct ModelB: Decodable { let detections: [Detection] }
    private struct Detection: Decodable {
        let className: String
        enum CodingKeys: String, CodingKey { case className = "class_name" }
    }

    init(from decoder: Decoder) throws {
        let root = try decoder.container(keyedBy: CodingKeys.self)
        suggestion = try root.decode(String.self, forKey: .skinCareAdvice)

        let result      = try root.decode(ModelResult.self, forKey: .modelResult)
        let detections  = result.modelOutputs.modelB.detections
      
        diagnoses = Array(Set(detections.map { $0.className }))
    }
}
