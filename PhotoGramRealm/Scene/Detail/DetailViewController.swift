//
//  DetailViewController.swift
//  PhotoGramRealm
//
//  Created by 이승현 on 2023/09/05.
//

import Foundation
import UIKit
import RealmSwift

class DetailViewController: BaseViewController {
    
    var data: DiaryTable?
    let realm = try! Realm()
    let repository = DiaryTableRepository()
    
    let titleTextField: WriteTextField = {
        let view = WriteTextField()
        view.placeholder = "제목을 입력해주세요"
        view.textColor = .white
        return view
    }()
    
    let contentTextField: WriteTextField = {
        let view = WriteTextField()
        view.placeholder = "내용을 입력해주세요"
        view.textColor = .white
        return view
    }()
    //⭐️⭐️⭐️
    override func configure() {
        super.configure()
        view.addSubview(titleTextField)
        view.addSubview(contentTextField)
        
        guard let data = data else { return }
        titleTextField.text = data.diaryTitle
        contentTextField.text = data.contents
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "수정", style: .plain, target: self, action: #selector(editButtonClicked))
        
        print(data.diaryTitle)
    }
    //⭐️⭐️⭐️
    @objc func editButtonClicked() {
        
//        let item = DiaryTable(value: ["_id": data._id, "diaryTitle": titleTextField.text!, "diaryContents": contentTextField.text!])
        
//        //1번방안 do, catch 안써도 되긴함
//        try! realm.write {
//            realm.add(item, update: .modified) //수정하겠다!
//        }
//
//        //2번방안 do, catch
//        do {
//            try realm.write {
//                realm.add(item, update: .modified)
//            }
//        } catch {
//            print("error")
//        }
        
        //Realm Updated 함수를 따로 파일을 만들어서 호출 위의 방식과 같음
        guard let data = data else { return }
        
        repository.updateItem(
            _id: data._id,
            diaryTitle: titleTextField.text!,
            diaryContents: contentTextField.text!
        )
        
        navigationController?.popViewController(animated: true)
    }
    
    
    
    override func setConstraints() {
        
        titleTextField.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(50)
            make.center.equalTo(view)
        }
        contentTextField.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(50)
            make.centerX.equalTo(view)
            make.centerY.equalTo(view).offset(60)
        }
    }
    
    
}
