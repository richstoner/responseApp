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



@interface MainMenuViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate> {
    UIScreen* mainScreen;
            
//view
    UITableView* mainMenuTable;
    
    UITextField *subjectIDTextField; 
    
    UISlider* trialsSlider;
    UILabel* trialsLabel;

    UISlider* touchSizeSlider;
    UILabel* touchSizeLabel;
    
    UISlider* fixationDurationSlider;
    UILabel* fixationDurationLabel;
    
    UISlider* preparationDurationSlider;
    UILabel* preparationDurationLabel;
    
    UISlider* movementDurationSlider;
    UILabel* movementDurationLabel;
    
    UISlider* movementStepsSlider;
    UILabel* movementStepsLabel;
        
//state
    BOOL isFirstLoad;
}

-(id)   initWithScreen:(UIScreen *)newScreenForDisplay;
-(void) configureMenu;

@end
