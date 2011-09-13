//
//  MainMenuViewController.h
//  moleidapp
//
//  Created by Rich Stoner on 6/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GuiConstants.h"
#import "SiteCell.h"

@interface AboutMenuViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    UIScreen* mainScreen;
    
    //view
    UIToolbar* headerToolbar;
    UITableView* mainMenuTable;
    
    NSMutableArray* menuOptions;
    
    //state
    BOOL isFirstLoad;
}


- (id)      initWithScreen:(UIScreen *)newScreenForDisplay;
- (void)    configureMenu;

@end
