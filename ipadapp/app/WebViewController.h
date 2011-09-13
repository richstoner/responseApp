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

@interface WebViewController : UIViewController <UIWebViewDelegate> {
    UIScreen* mainScreen;
    
    //view
    UIWebView* webview;

    UISegmentedControl* backButton;
    
    UIActivityIndicatorView* activityIndicator;
}

- (id)      initWithScreen:(UIScreen *)newScreenForDisplay;
-(void)     loadLocalFile;
-(void)     loadRemoteURL:(NSString*)remoteURL;

@end
