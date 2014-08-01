MSSE652
=======

MSSE652 - Enterprise iOS Software Development

Week 1

- Tab Bar Controller is created (Contacts, Tasks, First, My Nav)
- FirstViewController and SecondViewController has a modal segue and an unwind segue
- My Nav has a TableViewController(SCIS Programs) and cell click push segues to another TableViewController(SCIS Courses)

Week 2

- Added new domain - Program (holds program information)
- Added new domain - Course (holds course information)
- Added new service - NSURLSessionService (downloads SCIS programs and courses for tableview)
- Updated SCISProgramsTableViewController
- Updated SCISCoursesTableViewController
- Added tests

Week 3

- Added AFNetworkingService
- Added AFNetworkingServiceTests

Week 4

- Implement Core Data
- Create Program and Course managed objects
- Implement RestKit using CocoaPods
- Map Program and Course using RestKit to Core Data

Week 5

- Added Social framework (Mail, Messages, Twitter, Facebook)
- Added action right bar button item to SCISProgramsViewController

Week 6

- Implemented iCloud sync
- Added table view to TasksViewController to hold tasks
- Added right bar button to add tasks
- Added AddTaskViewController to save tasks

Week 7

- Created SocketSvc to connect to chat server using NSStream
- Created MessageViewController to hold a tableview for messages and a send button

Week 8

- Removed SocketSvc
- Implemented SocketRocket library
- MessageViewController is now SRWebSocketDelegate
