//
//  ViewController.swift
//  SQLLite
//
//  Created by Brian on 11/6/15.
//  Copyright © 2015 Razeware LLC. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fileManager = NSFileManager.defaultManager()
        var sqliteDB: COpaquePointer = nil
        var dbUrl: NSURL? = nil
        
        
        do {
            let baseUrl = try fileManager.URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
            dbUrl = baseUrl.URLByAppendingPathComponent("swift2.sqlite")
        } catch {
            print(error)
        }
        
        if let dbUrl = dbUrl {
            
            let fmdb = FMDatabase(path: dbUrl.absoluteString)
            fmdb.open()
            let sqlStatement = "create table if not exists Tutorials (ID Integer Primary key AutoIncrement, Title Text, Author Text, PublicationDate Date);";
            let insertStatement = "insert into Tutorials (Title, Author, PublicationDate) values ('Intro to SQLite', 'Ray Wenderlich', '2014-08-10 11:00:00')"
            do {
                try fmdb.executeUpdate(sqlStatement, values: nil)
                try fmdb.executeUpdate(insertStatement, values: nil)
            } catch {
                print("error: \(error)")
            }
            let selectSql = "select * from tutorials"
            let fmResult = fmdb.executeQuery(selectSql, withParameterDictionary: nil)
            while fmResult.next() {
                let rowID = fmResult.intForColumn("ID")
                let title = fmResult.stringForColumn("Title")
                let author = fmResult.stringForColumn("Author")
                let date = fmResult.stringForColumn("PublicationDate")
                print("rowID: \(rowID) title: \(title) author: \(author) date: \(date)")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

