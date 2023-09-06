//
//  DiaryTableRepository.swift
//  PhotoGramRealm
//
//  Created by 이승현 on 2023/09/04.
//


import Foundation
import RealmSwift

protocol DiaryTableRepositoryType: AnyObject {
    func findFileURL() -> URL?
    func fetch() -> Results<DiaryTable>
    func fetchFilter() -> Results<DiaryTable>
    func createItem(_ item: DiaryTable)
    func updateItem(_id: ObjectId, diaryTitle: String, diaryContents: String)
}

class DiaryTableRepository: DiaryTableRepositoryType {
    
    private let realm = try! Realm()
    
    func checkSchemaVersion() {
        do {
            let version = try schemaVersionAtURL(realm.configuration.fileURL!)
            print("Schema Version: \(version)")
        } catch {
            print(error)
        }
    }
    
    func findFileURL() -> URL? {
        let fileURL = realm.configuration.fileURL // 실제 데이터 저장 파일 경로
        return fileURL
    }
    
    func fetch() -> Results<DiaryTable> {
        let data = realm.objects(DiaryTable.self).sorted(byKeyPath: "diaryDate", ascending: false)
        return data
    }
    
    func fetchFilter() -> Results<DiaryTable> {
        // filter
        // realm filter는 제약이 조금 많다.
        // 특수한 케이스 필터가 많이 없어서 복잡한 filter가 필요하다면 realm을 써야되는지 한번 다시 생각해볼 것.
        let result = realm.objects(DiaryTable.self).where {
            // 1. Contain
//             caseInsensitive (대소문자 구분 X)
//            $0.diaryTitle.contains("제목", options: .caseInsensitive)
            
            // 2. Bool
//            $0.diaryLike == true
            
            // 3. 사진이 있는 데이터만 불러오기
            $0.photo != nil
            //4. 2개 같이 쓰는 법
            //($0.diaryPhotoURL != nil) && ($0.diaryLike == true)
        }
        return result
    }
    
    func createItem(_ item: DiaryTable) {
        do {
            try realm.write {
                realm.add(item)
                print("Realm Add Succeed")
            }
        } catch {
            print("error")
        }
    }
    
    func updateItem(_id: ObjectId, diaryTitle: String, diaryContents: String) {
        // realm 데이터 저장이 안될리는 거의 없는데 그래도 일말의 가능성을 보고 do, catch 에러 잡기
        do {
            try realm.write {
                realm.create(
                    DiaryTable.self,
                    value: [
                        "_id": _id,
                        "diaryTitle": diaryTitle,
                        "diaryContents": diaryContents
                    ],
                    update: .modified
                )
//                realm.add(item, update: .modified)
            }
        } catch {
            print("error")
        }
    }
}
