//
//  appAppDelegate.h
//  app
//
//  Created by Rich Stoner on 6/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MainMenuViewController.h"
#import "AboutMenuViewController.h"
#import "ExperimentViewController.h"
#import "WebViewController.h"

#import "FJTransitionController.h"

@interface appAppDelegate : NSObject <UIApplicationDelegate> {
    
    MainMenuViewController* mainMenuViewController;
    AboutMenuViewController* aboutMenuViewController;
    ExperimentViewController* experimentViewController;
    WebViewController* webViewController;

    FJTransitionController *viewController;
    UIToolbar* headerToolbar;
    UIImageView *splashView;
    UILabel*    currentSceneLabel;

}

@property (nonatomic, retain) IBOutlet FJTransitionController *viewController;
@property (nonatomic, retain) IBOutlet UIWindow *window;

-(void) configureHeader;

@end
