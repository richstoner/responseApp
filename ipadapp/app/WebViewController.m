/*
 * Created by Rich Stoner, September 10th, 2011
 * 
 * Copyright (c) 2011 Rich Stoner, wholeslide.com
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

#import "WebViewController.h"
#import "QuartzCore/QuartzCore.h"

@implementation WebViewController

@synthesize webView;

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
    
	CGRect mainScreenFrame = [[UIScreen mainScreen] applicationFrame];	
	UIView *primaryView = [[UIView alloc] initWithFrame:mainScreenFrame];
    self.view = primaryView;
    [primaryView release];
    
    webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 45, mainScreenFrame.size.width, mainScreenFrame.size.height - 110)];
    webview.delegate = self;
    webview.opaque = YES;
    webview.backgroundColor = [UIColor lightGrayColor];
    webview.dataDetectorTypes = UIDataDetectorTypeNone;

    [webview setScalesPageToFit:YES];
    
    [self loadLocalFile];
    [self.view addSubview:webview];
    
    
    NSArray *laterContent = [NSArray arrayWithObjects: @"Back", nil];
    backButton = [[UISegmentedControl alloc] initWithItems:laterContent];
    CGRect frame = CGRectMake( mainScreenFrame.size.width - 130, mainScreenFrame.size.height - 45, 100,30);
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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowMainMenu" object:nil];    

    
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [activityIndicator startAnimating];
    //    myLabel.hidden = FALSE;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [activityIndicator stopAnimating];
    //    myLabel.hidden = TRUE;
}


-(void) loadLocalFile
{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* lastTrialPath = [NSString stringWithFormat:@"%@/lastTrial.html", documentsDirectory];
    
//    NSString* htmlpath = [[NSBundle mainBundle] pathForResource:@"helpview" ofType:@"html"];
    NSData *htmlData = [NSData dataWithContentsOfFile:lastTrialPath];  
    NSString *filepath = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:filepath];
    [webview loadData:htmlData MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:baseURL];

}

-(void) loadHowToFile
{
//    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSApplicationDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    NSString* lastTrialPath = [NSString stringWithFormat:@"%@/helpview.html", documentsDirectory];
    
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
