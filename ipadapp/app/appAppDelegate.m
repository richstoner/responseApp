/*
 * Created by Rich Stoner, September 10th, 2011
 * 
 * Copyright (c) 2011 Rich Stoner
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 
 * Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the following disclaimer.
 * 
 * Redistributions in binary form must reproduce the above copyright
 * notice, this list of conditions and the following disclaimer in the
 * documentation and/or other materials provided with the distribution.
 * 
 * Neither the name of the project's author nor the names of its
 * contributors may be used to endorse or promote products derived from
 * this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 * TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 */


#import "appAppDelegate.h"

@implementation appAppDelegate

@synthesize window;
@synthesize viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[[UIApplication sharedApplication] setStatusBarHidden:YES];    
    
    // allocate view controllers
    mainMenuViewController          = [[MainMenuViewController alloc] initWithScreen:[UIScreen mainScreen]];    
    experimentViewController        = [[ExperimentViewController alloc] initWithScreen:[UIScreen mainScreen]];    
    webViewController               = [[WebViewController alloc] initWithScreen:[UIScreen mainScreen]];

    // register view controllers in 'nav controller'
    [self.viewController setViewController:mainMenuViewController forKey:@"Main"];
    [self.viewController setViewController:experimentViewController forKey:@"Experiment"];
    [self.viewController setViewController:webViewController forKey:@"Web"];
    
    // load default
    [self.viewController loadViewControllerForKey:@"Main"];

    // create view stack
    [window addSubview:viewController.view];    
    [self configureHeader];
    [window makeKeyAndVisible];
	[window layoutSubviews];	
    
    // configure listeners
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showMain:) name:@"ShowMainMenu" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showExperiment:) name:@"ShowExperiment" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSceneLabel:) name:@"UpdateSceneLabel" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createExperiment:) name:@"CreateExperiment" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addTrial:) name:@"addTrials" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showWeb:) name:@"ShowWeb" object:nil];

    return YES;
}

-(void)showWeb:(NSNotification*)notification
{
    [self.viewController loadViewControllerForKey:@"Web" 
                               appearingViewOnTop:YES 
                                       setupBlock:^(UIViewController *appearingViewController) {
                                           
                                           appearingViewController.view.alpha = 0;
                                           setViewControllerCenterPoint(FJPositionOffScreenBottom, appearingViewController);
                                           
                                       } appearingViewAnimationBlock:^(UIViewController *appearingViewController) {
                                           
                                           appearingViewController.view.alpha = 1.0;
                                           setViewControllerCenterPoint(FJPositionCenter, appearingViewController);
                                           
                                       } disappearingViewAnimationBlock:^(UIViewController *disappearingViewController) {
                                           
                                           setViewControllerCenterPoint(FJPositionOffScreenTop, disappearingViewController);
                                           
                                           
                                       }];
  
    [webViewController loadLocalFile];
    
//    [webViewController loadRemoteURL:[notification object]];
//    NSLog(@"To load: %@\n", [notification object]);

}

-(void)updateSceneLabel:(NSNotification*)notification
{
    NSString* sceneLabel = [notification object];
    
    [currentSceneLabel setText:sceneLabel];
    
}

-(void)showMain:(NSNotification*)notification
{
    
    [self.viewController loadViewControllerForKey:@"Main" 
                               appearingViewOnTop:YES 
                                       setupBlock:^(UIViewController *appearingViewController) {
                                           
                                           appearingViewController.view.alpha = 0;
                                           setViewControllerCenterPoint(FJPositionOffScreenBottom, appearingViewController);
                                           
                                       } appearingViewAnimationBlock:^(UIViewController *appearingViewController) {
                                           
                                           appearingViewController.view.alpha = 1.0;
                                           setViewControllerCenterPoint(FJPositionCenter, appearingViewController);
                                           
                                       } disappearingViewAnimationBlock:^(UIViewController *disappearingViewController) {
                                           
                                           setViewControllerCenterPoint(FJPositionOffScreenTop, disappearingViewController);
                                           
                                           
                                       }];
    
    
}

-(void)showExperiment:(NSNotification*)notification
{
    
    NSDictionary* notificationDict = [notification object];
    
    NSNumber* numberOfTrials = [notificationDict objectForKey:@"trials"];
    NSNumber* touchSize = [notificationDict objectForKey:@"touch"];
        
    [self.viewController loadViewControllerForKey:@"Experiment" 
                               appearingViewOnTop:YES 
                                       setupBlock:^(UIViewController *appearingViewController) {
                                           
                                           appearingViewController.view.alpha = 0;
                                           setViewControllerCenterPoint(FJPositionOffScreenBottom, appearingViewController);
                                           
                                       } appearingViewAnimationBlock:^(UIViewController *appearingViewController) {
                                           
                                           appearingViewController.view.alpha = 1.0;
                                           setViewControllerCenterPoint(FJPositionCenter, appearingViewController);
                                           
                                       } disappearingViewAnimationBlock:^(UIViewController *disappearingViewController) {
                                           
                                           setViewControllerCenterPoint(FJPositionOffScreenTop, disappearingViewController);
                                           
                                           
                                       }];
    
    [experimentViewController configureExperimentTrials:[numberOfTrials intValue] andTouchSize:[touchSize floatValue]];
    [experimentViewController setSubjectID:[notificationDict objectForKey:@"subject"]];
    [experimentViewController setFixationDuration:[notificationDict objectForKey:@"fixation"]];
    [experimentViewController setPreparationDuration:[notificationDict objectForKey:@"preparation"]];
    [experimentViewController setMovementDuration:[notificationDict objectForKey:@"movement"]];
    [experimentViewController setMovementSteps:[notificationDict objectForKey:@"steps"]];

    [experimentViewController printSummary];
    [experimentViewController startExperiment];
}


-(void) configureHeader
{
    // create flat background toolbar
    headerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, window.frame.size.width, kHeaderHeight )];
    CGSize btbsize = [headerToolbar frame].size;
    UIView* btbfake = [[UIView alloc] initWithFrame:CGRectMake(0,0,btbsize.width, btbsize.height)];
    [btbfake setBackgroundColor:[UIColor whiteColor]];
    [headerToolbar insertSubview:btbfake atIndex:0];
    [btbfake release];
    
    // create main title label
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, kHeaderHeight)];
    titleLabel.text = @"Response App";
    titleLabel.textColor = [UIColor blackColor];
    [titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:18]];
    titleLabel.userInteractionEnabled = YES;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = UITextAlignmentLeft;

    
    currentSceneLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, kHeaderHeight)];
    currentSceneLabel.text = @"Ready";
    currentSceneLabel.textColor = [UIColor lightGrayColor];
    [currentSceneLabel setFont:[UIFont fontWithName:@"Helvetica" size:18]];
    currentSceneLabel.userInteractionEnabled = NO;
    currentSceneLabel.backgroundColor = [UIColor clearColor];
    currentSceneLabel.textAlignment = UITextAlignmentRight;
    
    
    // label item
    UIBarButtonItem * titleItem = [[UIBarButtonItem alloc] initWithCustomView:titleLabel];

    // spacer item(s)
    UIBarButtonItem * flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:nil action:nil];
    
    UIBarButtonItem * sceneItem = [[UIBarButtonItem alloc] initWithCustomView:currentSceneLabel];
    
    // toolbar array
    NSArray * headerToolBarItems = [NSArray arrayWithObjects:titleItem, flexItem, sceneItem, nil];
    [headerToolbar setItems:headerToolBarItems animated:NO];
    
    // release bar items
    [titleItem release];
    [sceneItem release];
    [backItem release];
    [flexItem release];
    [titleLabel release];
    
    // add drop shadow
    UIBezierPath* path = [UIBezierPath bezierPathWithRect:headerToolbar.frame];
    headerToolbar.layer.shadowPath = path.CGPath;
    headerToolbar.layer.shadowRadius = 20.0;
    headerToolbar.layer.shadowOpacity = 0.7;
    headerToolbar.layer.shadowOffset = CGSizeMake(0,-4);

    // add to main window
    [window addSubview:headerToolbar];
    
    
}

- (void)startupAnimationDone:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    [splashView removeFromSuperview];
    [splashView release];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [viewController release];
    [headerToolbar release];
    [window release];
    [super dealloc];
}

@end
