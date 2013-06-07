//
//  MCSystemSettingViewController.h
//  MCGame
//
//  Created by kwan terry on 13-6-3.
//
//

#import <UIKit/UIKit.h>

@interface MCSystemSettingViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    IBOutlet UITableView * soundSettingTable;
    IBOutlet UITableView * magicCubeSettingTable;
}
-(IBAction)goBackMainMenu:(id)sender;
@end
