//
//  MainMenuViewController.m
//  moleidapp
//
//  Created by Rich Stoner on 6/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AboutMenuViewController.h"
#import "QuartzCore/QuartzCore.h"


@implementation AboutMenuViewController

#pragma mark -
#pragma mark Initialization and teardown

- (id)initWithScreen:(UIScreen *)newScreenForDisplay;
{
    if ((self = [super initWithNibName:nil bundle:nil])) 
	{
        menuOptions = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    
    [headerToolbar release];
    [mainMenuTable release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
}

-(void)loadView
{
    isFirstLoad=YES;
    
    printf("Loading AboutMenuViewController\n");
	CGRect mainScreenFrame = [[UIScreen mainScreen] applicationFrame];	
	UIView *primaryView = [[UIView alloc] initWithFrame:mainScreenFrame];
    
    NSMutableDictionary* aboutMID = [[NSMutableDictionary alloc] init];
    [aboutMID setValue:@"About MoleID" forKey:@"label"];
    [aboutMID setValue:@"http://www.google.com" forKey:@"url"];

    NSMutableDictionary* aboutMoles = [[NSMutableDictionary alloc] init];
    [aboutMoles setValue:@"About Moles" forKey:@"label"];
    [aboutMoles setValue:@"http://www.webmd.com" forKey:@"url"];

    NSMutableDictionary* aboutCancer = [[NSMutableDictionary alloc] init];
    [aboutCancer setValue:@"Skin Cancer Information" forKey:@"label"];
    [aboutCancer setValue:@"http://www.cancer.org" forKey:@"url"];
    
    NSMutableDictionary* findDoctor = [[NSMutableDictionary alloc] init];
    [findDoctor setValue:@"Find a doctor" forKey:@"label"];
    [findDoctor setValue:@"http://www.cancer.org" forKey:@"url"];
    
//    menuOptions = [NSMutableArray arrayWithObjects:aboutMID, aboutMoles, aboutCancer, findDoctor, nil];
    [menuOptions addObjectsFromArray:[NSArray arrayWithObjects:aboutMID, aboutMoles, aboutCancer, findDoctor, nil]];
    
    [aboutMID release];
    [aboutMoles release];
    [aboutCancer release];
    [findDoctor release];
    
    self.view = primaryView;

    
    [primaryView release];
    
    [self configureMenu];
}


-(void) configureMenu
{
    mainMenuTable = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    
    mainMenuTable.delegate = self;
    mainMenuTable.dataSource = self;
    mainMenuTable.separatorColor = nil;
    mainMenuTable.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:mainMenuTable];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Table view data source 
#pragma mark -

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return [menuOptions count];        
            break;
        case 1:
            return 1;
            break;
            
        default:
            break;
    }
    
    return 0;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    SiteCell *cell = (SiteCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[SiteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];        
    }
    
    tableView.separatorColor = [UIColor clearColor];
    
    NSDictionary* tempDict = [menuOptions objectAtIndex:indexPath.row];
    
    switch (indexPath.section) {
        case 0:
            [cell setMainText:[tempDict objectForKey:@"label"]];

            break;
        case 1:
            
            [cell setMainText:@"Main Menu"];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            break;
            
        default:
            break;
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return @"";
}



- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{        
    if (indexPath.section == 1) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowMainMenu" object:nil];    
        [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO];
    }
    else
    {
        NSString* urlString = [[menuOptions objectAtIndex:indexPath.row] objectForKey:@"url"];
        NSLog(@"%@\n", urlString);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowWeb" object:urlString];    
        [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO];
    }
}   

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 80.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return nil;
    }
    
    // Create label with section title
    UILabel *label = [[[UILabel alloc] init] autorelease];
    label.frame = CGRectMake(0, 0, self.view.frame.size.width, 50);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont fontWithName:@"Helvetica" size:16];
    label.text = sectionTitle;
    
    // Create header view and add label as a subview
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    [view autorelease];
    [view addSubview:label];
    return view;
}





@end
