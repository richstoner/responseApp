//
//  MainMenuViewController.m
//  moleidapp
//
//  Created by Rich Stoner on 6/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WebViewController.h"
#import "QuartzCore/QuartzCore.h"

@implementation WebViewController


#pragma mark -
#pragma mark Initialization and teardown

- (id)initWithScreen:(UIScreen *)newScreenForDisplay;
{
    if ((self = [super initWithNibName:nil bundle:nil])) 
	{

    }
    return self;
}

- (void)dealloc
{
    [webview release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)loadView
{   
    
    printf("Loading WebView\n");
	CGRect mainScreenFrame = [[UIScreen mainScreen] applicationFrame];	
	UIView *primaryView = [[UIView alloc] initWithFrame:mainScreenFrame];
    self.view = primaryView;
    [primaryView release];
    
    
    
    webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 45, 320, 370)];
    webview.delegate = self;
    webview.opaque = YES;
    webview.backgroundColor = [UIColor lightGrayColor];
    [webview setScalesPageToFit:YES];
    //    _webview.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //    _webview.layer.borderWidth = 1.0f;
    //    _webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, kHeaderHeight, mainScreenFrame.size.width, mainScreenFrame.size.height - 2*kHeaderHeight )];
    //    [self loadRemoteURL:@"http://www.cancer.org"];
    
    [self loadLocalFile];
    [self.view addSubview:webview];
    
    
    NSArray *laterContent = [NSArray arrayWithObjects: @"Back", nil];
    backButton = [[UISegmentedControl alloc] initWithItems:laterContent];
    CGRect frame = CGRectMake(200, 435, 100,30);
    backButton.frame = frame;
    backButton.selectedSegmentIndex = -1;
    [backButton addTarget:self action:@selector(backPress:) forControlEvents:UIControlEventValueChanged];
    backButton.segmentedControlStyle = UISegmentedControlStyleBar;
    backButton.tintColor = [UIColor lightGrayColor];
    backButton.momentary = YES;
    backButton.alpha = 1.0;
    [backButton setHighlighted:YES];
    [self.view addSubview:backButton];
    [backButton release];

    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activityIndicator setFrame:CGRectMake(20, 435, 30, 30)];
    [self.view addSubview:activityIndicator];
    
}

-(void)     backPress:(id)sender
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowAbout" object:nil];    

    
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [activityIndicator startAnimating];
    //    myLabel.hidden = FALSE;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [activityIndicator stopAnimating];
    //    myLabel.hidden = TRUE;
}


-(void)     loadLocalFile
{

    NSString* htmlpath = [[NSBundle mainBundle] pathForResource:@"helpview" ofType:@"html"];
    NSData *htmlData = [NSData dataWithContentsOfFile:htmlpath];  
    NSString *filepath = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:filepath];
    [webview loadData:htmlData MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:baseURL];

}

-(void)     loadRemoteURL:(NSString*)remoteURL
{
    NSURL * baseURL = [NSURL URLWithString:remoteURL];
    NSURLRequest * baseRequest = [NSURLRequest requestWithURL:baseURL];
    [webview loadRequest:baseRequest];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
