//
//  DataHelper.swift
//  Sketchtacts
//
//  Created by Heather Davis on 4/17/20.
//  Copyright © 2020 Cody Frederick. All rights reserved.
//

import Foundation
import CoreData

public class DataHelper {
    let context: NSManagedObjectContext
    let event: Event
    init(context: NSManagedObjectContext, event: Event) {
        self.context = context
        self.event = event
    }
    
    public func seed() {
             let people = [
                (firstName: "Flory", lastName:"Bartram", email: "fbartram0@forbes.com", company: "Devify", training: true, coaching: true, development: false, event: self.event, eligibleFlag: true),
                (firstName: "Stevena", lastName:"Culshaw", email: "sculshaw1@scribd.com", company: "Meezzy", training: false, coaching: false, development: false, event: self.event, eligibleFlag: true),
                (firstName: "Donna", lastName:"Heffy", email: "dheffy2@w3.org", company: "Mybuzz", training: true, coaching: true, development: false, event: self.event, eligibleFlag: true),
                (firstName: "Gay", lastName:"Mintoff", email: "gmintoff3@storify.com", company: "Yacero", training: true, coaching: false, development: true, event: self.event, eligibleFlag: true),
                (firstName: "Batholomew", lastName:"Enders", email: "benders4@de.vu", company: "Cogilith", training: false, coaching: false, development: true, event: self.event, eligibleFlag: true),
                (firstName: "Xenos", lastName:"Oehme", email: "xoehme5@marriott.com", company: "Twiyo", training: false, coaching: false, development: false, event: self.event, eligibleFlag: true),
                (firstName: "Ailey", lastName:"Lockie", email: "alockie6@gmpg.org", company: "Blogpad", training: false, coaching: false, development: true, event: self.event, eligibleFlag: true),
                (firstName: "Marthe", lastName:"Willison", email: "mwillison7@fema.gov", company: "Kwideo", training: true, coaching: false, development: true, event: self.event, eligibleFlag: true),
                (firstName: "Isabelle", lastName:"Rasp", email: "irasp8@wsj.com", company: "Skyble", training: false, coaching: false, development: true, event: self.event, eligibleFlag: true),
                (firstName: "Sargent", lastName:"Ivanikhin", email: "sivanikhin9@nbcnews.com", company: "Yadel", training: true, coaching: true, development: false, event: self.event, eligibleFlag: true),
                (firstName: "Vyky", lastName:"Renvoise", email: "vrenvoisea@ovh.net", company: "Zoomlounge", training: false, coaching: true, development: false, event: self.event, eligibleFlag: true),
                (firstName: "Maude", lastName:"Simionato", email: "msimionatob@soup.io", company: "Gigashots", training: true, coaching: false, development: false, event: self.event, eligibleFlag: true),
                (firstName: "Blake", lastName:"Cuttler", email: "bcuttlerc@amazon.com", company: "Flashdog", training: true, coaching: true, development: true, event: self.event, eligibleFlag: true),
                (firstName: "Ermengarde", lastName:"Collett", email: "ecollettd@globo.com", company: "Edgewire", training: false, coaching: true, development: true, event: self.event, eligibleFlag: true),
                (firstName: "Pattie", lastName:"Knowler", email: "pknowlere@phpbb.com", company: "Jazzy", training: true, coaching: true, development: true, event: self.event, eligibleFlag: true),
                (firstName: "Penelopa", lastName:"Carren", email: "pcarrenf@apple.com", company: "Voonyx", training: true, coaching: true, development: false, event: self.event, eligibleFlag: true),
                (firstName: "Brittne", lastName:"Millichap", email: "bmillichapg@dropbox.com", company: "Linklinks", training: false, coaching: false, development: false, event: self.event, eligibleFlag: true),
                (firstName: "Britt", lastName:"Warratt", email: "bwarratth@engadget.com", company: "Zoomlounge", training: true, coaching: false, development: true, event: self.event, eligibleFlag: true),
                (firstName: "Amble", lastName:"Worham", email: "aworhami@furl.net", company: "Jabbersphere", training: true, coaching: false, development: true, event: self.event, eligibleFlag: true),
                (firstName: "Derek", lastName:"Moncarr", email: "dmoncarrj@washington.edu", company: "Tambee", training: true, coaching: true, development: true, event: self.event, eligibleFlag: true),
                (firstName: "Welsh", lastName:"Catling", email: "wcatlingk@ycombinator.com", company: "Meevee", training: false, coaching: true, development: false, event: self.event, eligibleFlag: true),
                (firstName: "Micheil", lastName:"Stanyforth", email: "mstanyforthl@ezinearticles.com", company: "Roodel", training: true, coaching: true, development: false, event: self.event, eligibleFlag: true),
                (firstName: "Mahala", lastName:"Redford", email: "mredfordm@hao123.com", company: "Layo", training: false, coaching: true, development: false, event: self.event, eligibleFlag: true),
                (firstName: "Karim", lastName:"MacIntosh", email: "kmacintoshn@ezinearticles.com", company: "Dynabox", training: false, coaching: false, development: true, event: self.event, eligibleFlag: true),
                (firstName: "Clyve", lastName:"Trainer", email: "ctrainero@google.ru", company: "Wikizz", training: true, coaching: false, development: false, event: self.event, eligibleFlag: true),
                (firstName: "Dorise", lastName:"Cornelisse", email: "dcornelissep@kickstarter.com", company: "Oozz", training: true, coaching: true, development: false, event: self.event, eligibleFlag: true),
                (firstName: "Ulberto", lastName:"Paler", email: "upalerq@diigo.com", company: "Mita", training: false, coaching: false, development: true, event: self.event, eligibleFlag: true),
                (firstName: "Malena", lastName:"Tregonna", email: "mtregonnar@soundcloud.com", company: "Kwimbee", training: true, coaching: true, development: true, event: self.event, eligibleFlag: true),
                (firstName: "Cherri", lastName:"Gudgen", email: "cgudgens@ucoz.com", company: "Pixoboo", training: false, coaching: true, development: false, event: self.event, eligibleFlag: true),
                (firstName: "Jonis", lastName:"Ferriday", email: "jferridayt@mail.ru", company: "Layo", training: true, coaching: false, development: false, event: self.event, eligibleFlag: true),
            ]
    
            for person in people {
                let newPerson = NSEntityDescription.insertNewObject(forEntityName: "Person", into: context) as! Person
                newPerson.firstName = person.firstName
                newPerson.lastName = person.lastName
                newPerson.email = person.email
                newPerson.company = person.company
                newPerson.training = person.training
                newPerson.development = person.development
                newPerson.coaching = person.coaching
                newPerson.eligibleFlag = person.eligibleFlag
                newPerson.event = person.event
            }
    
            do {
                try context.save()
            } catch _ {
            }
        }
}
