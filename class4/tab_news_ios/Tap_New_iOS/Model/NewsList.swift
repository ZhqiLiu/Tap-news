//
//  NewsList.swift
//  Tap_New_iOS
//
//  Created by Yichi Zhang on 1/7/18.
//  Copyright © 2018 Yichi Zhang. All rights reserved.
//

import Foundation
import Firebase

class NewsList {
    var newsList = [News]()
    let priority = [1, 2, 3, 2, 1, 3, 5, 7, 8, 9, 9]
    let titles = [
        "Jim Harbaugh, Michigan football and the challenging path ahead",
        "University of Michigan's Mcity releases threat-identifying tool for automated vehicles",
        "CMU team publishes paper on how their poker-playing AI beat the best humans",
        "Carnegie Mellon’s ‘Superhuman AI’ bests leading Texas Hold’em poker pros",
        "Apple's New Flagship - iPhone X",
        "HomePod - Apple's Siri Speaker",
        "Rajon Rondo says he doesn't have a problem with Ray Allen",
        "NBA fines Pelicans' Alvin Gentry $15,000 for public criticism of refs",
        "A tiny oral history: The viral James Harden crossover",
        "Harden, Rockets beat Pelicans for 21st win in 22 games",
        "Harden, Rockets beat Pelicans for 21st win in 22 games"
        ]
    
    let descriptions = [
        "The day before the Outback Bowl, I wrote about reality in college football. How there's no inbetween or shades of gray at the top. You either did something or you didn't. \n Michigan, I wrote, fell into the latter category. The Wolverines didn't accomplish enough in 2017 to gain ground on Big Ten front-runner Ohio State and allowed programs like Penn State and Michigan State to surge forward in an ever-competitive Big Ten East Division. \n The next day, U-M fell flat in the Outback Bowl. That result probably added to a bubbling level of vitriol from the portion of the fan base that's growing sick and tired of being sick and tired, but it didn't really change anything. Michigan had major problems in 2017 and the result of the Outback Bowl was never going to change that. \n Jim Harbaugh's coaching staff already has been tweaked. More change is on the way. Chances are Harbaugh didn't hop off an airplane and onto an ice-cold Michigan runway on Monday night with a smile.",
        "A new report published by University of Michigan's automated vehicle testing facility, Mcity, lays forward several security vulnerabilities that must be overcome before automated and connected vehicles can become widely adopted. \n In the report, titled \"Assessing Risk: Identifying and Analyzing Cybersecurity Threats to Automated Vehicles,\" researchers imagine three scenarios in which self-driving vehicles show signs of security attacks. \n First, an automated vehicle veers off its navigation route, takes its driver to a desolate road, pulls over and stops. \n Second, when the driver calls his or her vehicle to come to a store, and instead receives a ransom message demanding a $100 bitcoin transfer in return for the vehicle. \n Third, a self-driving vehicle won't move from the driveway, since it senses it's been hacked and the driver's home has been preprogramed as its safe destination.",
        "Tuomas Sandholm, a Carnegie Mellon University professor of computer science, and Noam Brown, a Ph.D. student in computer science at CMU, published a paper in Science that detailed how Libratus managed to beat four of the best no-limit Texas Hold'em poker players in the world this year.",
        "A new paper published by Science today details how Libratus, an AI developed by researchers at Carnegie Mellon’s computer science department, managed to take on and defeat top industry professionals at one of the most challenging forms of poker: No-limit Texas Hold’em. Yes, the same variant of poker that swept the nation during the heady days of the early to mid-aughts.",
        "The iPhone X, pronounced \"iPhone 10,\" was introduced at Apple's September 2017 event as a classic \"One more thing...\" addition to the iPhone 8 and 8 Plus product lineup. According to Apple, the iPhone X represents the biggest technological leap forward since the original iPhone was introduced 10 years ago in 2007, and it sets the path for the next decade of iPhone development.",
        "At the 2017 Worldwide Developers Conference in June, Apple unveiled its much-rumored Siri-based speaker, the HomePod. HomePod, which has been in the works for years, is designed to reinvent the way music is enjoyed in the home, and, according to Apple, it does something that no other company has managed to do -- combines a smart speaker with incredible sound.",
        "Rajon Rondo says he's confused over why his name is being brought up in connection to Ray Allen's new book after he has moved on from his tumultuous relationship with Allen. In 'From the Outside: My Journey through Life and the Game I Love,' which will be published March 27, Allen, who retired from the NBA in 2014, writes that Chris Paul would have been a Celtic in 2011, but coach Doc Rivers wouldn't send Rondo to New Orleans because of Rivers",
        "New Orleans Pelicans coach Alvin Gentry's heated rant against the referees Saturday night will cost him $15,000. The NBA announced its fine against Gentry on Sunday for public criticism of the officiating following the Pelicans' 107-101 home defeat to the Houston Rockets. Among Gentry's complaints was a foul that was called against Pelicans point guard Jrue Holiday while Houston's James Harden was shooting a 3 from the corner midway through the fourth quarter. The controversial call sent the crowd at Smoothie King Center into a frenzy and eventually earned Gentry a technical foul for arguing.",
        "New Orleans Pelicans coach Alvin Gentry went on an epic tirade after Saturday's 107-101 loss to the Houston Rockets on Saturday night (March 17) about how star forward Anthony Davis 'never gets a call' from officials. Gentry pointed to how often Rockets guard James Harden gets the benefit of the doubt from officials on foul calls and said that Davis isn't treated the same way. Many fans praised Gentry for the way he defended his superstar, but some thought his rant was a bit misguided.",
        "NEW ORLEANS -- James Harden's craftiness in the clutch ignited Houston's offense -- as well as Pelicans coach Alvin Gentry's temper. Harden had 32 points and 11 rebounds, and the Rockets won for the 21st time in 22 games, beating New Orleans 107-101 on Saturday night. Harden's highlights included his usual array of explosive drives and pull-up jumpers, including a 27-foot, straight-on 3 that put the Rockets up by nine with 1:31 left. He also drew a foul on a missed 3-pointer in which he threw his arms forward toward Pelicans guard Jrue Holiday as he went up for the shot with 5:39 left. A fuming Gentry saw that call as wrong and pivotal.",
        "NEW ORLEANS -- James Harden's craftiness in the clutch ignited Houston's offense -- as well as Pelicans coach Alvin Gentry's temper. Harden had 32 points and 11 rebounds, and the Rockets won for the 21st time in 22 games, beating New Orleans 107-101 on Saturday night. Harden's highlights included his usual array of explosive drives and pull-up jumpers, including a 27-foot, straight-on 3 that put the Rockets up by nine with 1:31 left. He also drew a foul on a missed 3-pointer in which he threw his arms forward toward Pelicans guard Jrue Holiday as he went up for the shot with 5:39 left.",
        "It began like so many Rockets possessions. James Harden dribbled upcourt with Houston leading the LA Clippers 28-7 in what would ultimately be a 105-92 road victory for the Rockets. Harden began to drive to his left as Clippers defender Wesley Johnson tried to keep up. And then ... rest in peace, Wesley Johnson's ankles. Harden's brutal crossover left Johnson on his rear end, and Harden stepped back, stared at Johnson on the ground and drilled a 3 that got the Rockets bench on its feet, left the Staples Center abuzz and rocked Twitter. Here's how one of the season's most memorable -- and meme-worthy -- moments went down."
        ]
    
    let sources = ["GoBlue", "GoBlue", "CMU", "CMU", "CMU", "Apple", "Apple", "Apple", "Celtics", "NBA", "Rockets", "Rockets", "Rockets"]
    let imageUrls = [
        "https://cdn.bleacherreport.net/images/team_logos/328x328/michigan_wolverines_football.png",
        "https://cdn.bleacherreport.net/images/team_logos/328x328/michigan_wolverines_football.png",
        "https://www.cmu.edu/marcom/brand-standards/images/red-seal-greater-than-two-inches-min.png",
        "https://www.cmu.edu/marcom/brand-standards/images/red-seal-greater-than-two-inches-min.png",
        "https://www.apple.com/ac/structured-data/images/knowledge_graph_logo.png",
        "https://www.apple.com/ac/structured-data/images/knowledge_graph_logo.png",
        "https://upload.wikimedia.org/wikipedia/en/thumb/8/8f/Boston_Celtics.svg/1200px-Boston_Celtics.svg.png",
        "https://espntheundefeated.files.wordpress.com/2017/05/nba-logo.png",
        "https://www.basketnews.lt/paveikslelis-107067-vbg.jpg",
        "https://www.basketnews.lt/paveikslelis-107067-vbg.jpg",
        "https://www.basketnews.lt/paveikslelis-107067-vbg.jpg"
        ]
    
    init() {
        print(titles.count, descriptions.count, sources.count, imageUrls.count)
        for i in 0...titles.count-1 {
            newsList.append(News(priority: priority[i], title: titles[i], description: descriptions[i], source: sources[i], imageUrl: imageUrls[i]))
        }
        
//        sendToFirebase() //initializeDB
    }
    
    func sendToFirebase() {
        let NewsDB = Database.database().reference().child("News")
        for news in self.newsList {
            let dbNews = [
                "priority": String(news.priority),
                "title": news.title,
                "description": news.description,
                "source": news.source,
                "imageUrl": news.imageUrl
            ]
            
            NewsDB.childByAutoId().setValue(dbNews) {
                (error, reference) in
                if((error) != nil) {
                    print(error!)
                }
                else {
                    print("News saved successfully!")
                }
                
            }
        }
    }
}
