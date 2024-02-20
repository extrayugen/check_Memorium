import Foundation
import FirebaseFirestore

// `TimeCapsule` 데이터 모델 정의
struct TimeCapsule {
    var id: String // Firestore 문서 ID
    var title: String // 캡슐 제목
    var description: String // 캡슐 설명
    var location: GeoPoint // 캡슐 위치 (위도, 경도)
    var createTime: Timestamp // 캡슐 생성 시간
    var unlockTime: Timestamp // 캡슐 열리는 시간
    var creator: String // 만든 계정의 ID
}
