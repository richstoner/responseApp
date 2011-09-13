//
//  MainMenuViewController.m
//  moleidapp
//
//  Created by Rich Stoner on 6/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainMenuViewController.h"
#import "QuartzCore/QuartzCore.h"


@implementation MainMenuViewController

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
    [mainMenuTable release];
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
    isFirstLoad=YES;
    
    printf("Loading MainMenuViewController\n");
	CGRect mainScreenFrame = [[UIScreen mainScreen] applicationFrame];	
	UIView *primaryView = [[UIView alloc] initWithFrame:mainScreenFrame];
    [primaryView setBackgroundColor:[UIColor lightGrayColor]];
    self.view = primaryView;
    [primaryView release];
    
    [self configureMenu];    
}


-(void) configureMenu
{
    CGRect newFrame = self.view.frame;
    newFrame.origin.y += 40.0f;
    
    mainMenuTable = [[UITableView alloc] initWithFrame:newFrame style:UITableViewStyleGrouped];
    
    mainMenuTable.delegate = self;
    mainMenuTable.dataSource = self;
    mainMenuTable.separatorColor = [UIColor redColor];;
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
    return 4;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            //start trial
            return 1;
            break;
        case 1:
            //Experiment settings
            return 3;            
            break;
        case 2:
            //trial settings
            return 4;            
            break;
        case 3:
            //review last
            return 1;            
            break;
            
        default:
            break;
    }
    return  0;
}

- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 80.0f;
            break;
            
        default:
            return 50.0f;            
            break;
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [ NSString stringWithFormat: @"%d:%d", [ indexPath indexAtPosition: 0 ], [ indexPath indexAtPosition:1 ]];
    
    UITableViewCell *cell = [ tableView dequeueReusableCellWithIdentifier: CellIdentifier];
    
    tableView.separatorColor = [UIColor darkGrayColor];
    
    if (cell == nil) {
        cell = [ [ [ UITableViewCell alloc ] initWithFrame: CGRectZero reuseIdentifier: CellIdentifier] autorelease ];
        
        switch (indexPath.section) {
            case 0:
                switch (indexPath.row) {
                    case 0:
                        cell.textLabel.text = @"Start Experiment";
                        cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:24];
                        [cell.textLabel setTextAlignment:UITextAlignmentCenter];
                        [[cell textLabel] setTextColor:[UIColor whiteColor]];
                        [cell setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"mesh-background.png"]]];
                        cell.selectionStyle = UITableViewCellSelectionStyleGray;
                        break;
                    default:
                        break;
                }
                break;
            case 1:
                switch (indexPath.row) {
                    case 0:
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        subjectIDTextField = [[UITextField alloc] initWithFrame:CGRectMake(110, 12, 550, 30)];
                        subjectIDTextField.textColor = [UIColor blueColor];
                        subjectIDTextField.font = [UIFont fontWithName:@"Helvetica" size:20];
                        subjectIDTextField.placeholder = @"enter the subject id here";
                        subjectIDTextField.backgroundColor = [UIColor clearColor];
                        subjectIDTextField.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
                        subjectIDTextField.autocapitalizationType = UITextAutocapitalizationTypeNone; // no auto capitalization support
                        subjectIDTextField.textAlignment = UITextAlignmentLeft;
                        subjectIDTextField.clearButtonMode = UITextFieldViewModeAlways;                        
                        [subjectIDTextField setEnabled: YES];
                        cell.textLabel.text = @"Subject";

                        [[cell contentView] addSubview:subjectIDTextField];

                        break;
                        
                    case 1:
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        trialsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 150, 50)];
                        [trialsLabel setText:@"Trials: 1"];
                        [trialsLabel setBackgroundColor:[UIColor clearColor]];
                        trialsLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
                        [[cell contentView] addSubview:trialsLabel];
                        
                        trialsSlider = [ [ UISlider alloc ] initWithFrame: CGRectMake(150, 0, 150, 50) ];
                        trialsSlider.autoresizingMask = UIViewAutoresizingFlexibleWidth;
                        trialsSlider.minimumValue = 1.0;
                        trialsSlider.maximumValue = 10.0;
                        trialsSlider.tag = 0;
                        trialsSlider.value = 1;
                        trialsSlider.continuous = NO;
                        
                        [trialsSlider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventTouchDragInside];
                        [[cell contentView] addSubview: trialsSlider ];
                        
                        break;
                    case 2:
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;                        
                        
                        touchSizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 150, 50)];
                        [touchSizeLabel setText:@"Size: 1.0"];
                        [touchSizeLabel setBackgroundColor:[UIColor clearColor]];
                        touchSizeLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
                        [[cell contentView] addSubview:touchSizeLabel];
                        
                        touchSizeSlider = [ [ UISlider alloc ] initWithFrame: CGRectMake(150, 0, 150, 50) ];
                        touchSizeSlider.autoresizingMask = UIViewAutoresizingFlexibleWidth;
                        touchSizeSlider.minimumValue = 0.1;
                        touchSizeSlider.maximumValue = 3.0;
                        touchSizeSlider.tag = 1;
                        touchSizeSlider.value = 1.0;
                        touchSizeSlider.continuous = YES;
                        
                        [touchSizeSlider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventTouchDragInside];
                        [[cell contentView] addSubview: touchSizeSlider ];
                        
                        break;                        
                    default:
                        break;
                }             
                break;
            case 2:
                switch (indexPath.row) {
                    case 0:                        
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        fixationDurationLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 150, 50)];
                        [fixationDurationLabel setText:@"Fixation: 5.0s"];
                        [fixationDurationLabel setBackgroundColor:[UIColor clearColor]];
                        fixationDurationLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
                        [[cell contentView] addSubview:fixationDurationLabel];
                        
                        fixationDurationSlider = [ [ UISlider alloc ] initWithFrame: CGRectMake(200, 0, 100, 50) ];
                        fixationDurationSlider.autoresizingMask = UIViewAutoresizingFlexibleWidth;
                        fixationDurationSlider.minimumValue = 0.2;
                        fixationDurationSlider.maximumValue = 20.0;
                        fixationDurationSlider.tag = 2;
                        fixationDurationSlider.value = 5.0;
                        fixationDurationSlider.continuous = NO;
                        
                        [fixationDurationSlider  addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventTouchDragInside];
                        [[cell contentView] addSubview: fixationDurationSlider ];
                        
                        break;
                    case 1:
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;                                                
                        preparationDurationLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 150, 50)];
                        [preparationDurationLabel setText:@"Preparation: 5.0s"];
                        [preparationDurationLabel setBackgroundColor:[UIColor clearColor]];
                        preparationDurationLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
                        
                        [[cell contentView] addSubview:preparationDurationLabel];
                        
                        preparationDurationSlider = [ [ UISlider alloc ] initWithFrame: CGRectMake(200, 0, 100, 50) ];
                        preparationDurationSlider.autoresizingMask = UIViewAutoresizingFlexibleWidth;
                        preparationDurationSlider.minimumValue = 0.2;
                        preparationDurationSlider.maximumValue = 20.0;
                        preparationDurationSlider.tag = 3;
                        preparationDurationSlider.value = 5.0;
                        preparationDurationSlider.continuous = YES;
                        
                        [preparationDurationSlider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventTouchDragInside];
                        [[cell contentView] addSubview: preparationDurationSlider ];
                        
                        break;                       
                    case 2:
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;                        
                        
                        movementDurationLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 150, 50)];
                        [movementDurationLabel setText:@"Movement: 5.0s"];
                        [movementDurationLabel setBackgroundColor:[UIColor clearColor]];
                        movementDurationLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
                        
                        [[cell contentView] addSubview:movementDurationLabel];
                        
                        movementDurationSlider = [ [ UISlider alloc ] initWithFrame: CGRectMake(200, 0, 100, 50) ];
                        movementDurationSlider.autoresizingMask = UIViewAutoresizingFlexibleWidth;
                        movementDurationSlider.minimumValue = 0.2;
                        movementDurationSlider.maximumValue = 20.0;
                        movementDurationSlider.tag = 4;
                        movementDurationSlider.value = 5.0;
                        movementDurationSlider.continuous = YES;
                        
                        [movementDurationSlider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventTouchDragInside];
                        [[cell contentView] addSubview: movementDurationSlider ];
                        
                        break;
                        
                    case 3:
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;                        
                        
                        movementStepsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 150, 50)];
                        [movementStepsLabel setText:@"Steps: 6"];
                        [movementStepsLabel setBackgroundColor:[UIColor clearColor]];
                        movementStepsLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
                        
                        [[cell contentView] addSubview:movementStepsLabel];
                        
                        movementStepsSlider = [ [ UISlider alloc ] initWithFrame: CGRectMake(200, 0, 100, 50) ];
                        movementStepsSlider.autoresizingMask = UIViewAutoresizingFlexibleWidth;
                        movementStepsSlider.minimumValue = 1.0;
                        movementStepsSlider.maximumValue = 20.0;
                        movementStepsSlider.tag = 5;
                        movementStepsSlider.value = 6.0;
                        movementStepsSlider.continuous = YES;
                        
                        [movementStepsSlider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventTouchDragInside];
                        [[cell contentView] addSubview: movementStepsSlider ];
                        
                        break; 
                    default:
                        break;
                }             
                

                break;
            case 3:
                switch (indexPath.row) {
                    case 0:
                        cell.textLabel.text = @"Review Last"; 
                        break;
                    default:
                        break;
                }
                break;
            default:
                break;
        }
    }
    return cell;
}

-(void)sliderAction:(id)sender
{
    switch ([sender tag]) {
        case 0:
//            printf("trials slide\n");
            
            [trialsLabel setText:[NSString stringWithFormat:@"Trials: %d", (int)trialsSlider.value]];
            [trialsLabel setNeedsDisplay];
            
            break;
        case 1:
//            printf("size slide\n");
            
            [touchSizeLabel setText:[NSString stringWithFormat:@"Size: %1.1f", touchSizeSlider.value]];
            [touchSizeLabel setNeedsDisplay];
            break;  
            
        case 2:
            [fixationDurationLabel setText:[NSString stringWithFormat:@"Fixation: %1.1fs", fixationDurationSlider.value]];
            [fixationDurationLabel setNeedsDisplay];
            break;  
        case 3:
            [preparationDurationLabel setText:[NSString stringWithFormat:@"Preparation: %1.1fs", preparationDurationSlider.value]];
            [preparationDurationLabel setNeedsDisplay];
            break;  
        case 4:
            [movementDurationLabel setText:[NSString stringWithFormat:@"Movement: %1.1fs", movementDurationSlider.value]];
            [movementDurationLabel setNeedsDisplay];
            break;  
        case 5:
            [movementStepsLabel setText:[NSString stringWithFormat:@"Steps: %d", (int)movementStepsSlider.value]];
            [movementStepsLabel setNeedsDisplay];
            break;  
            
            
        default:
            break;
    }
}
    
    
        
//        
//        
//        switch ([ indexPath indexAtPosition: 0]) {
//            case(0):
//                switch([ indexPath indexAtPosition: 1]) {
//                    case(0):
//                        {
                            

                            
                            
                            //                        UISlider *musicVolumeControl = [ [ UISlider alloc ] initWithFrame: CGRectMake(170, 0, 125, 50) ];
//                        musicVolumeControl.minimumValue = 0.0;
//                        musicVolumeControl.maximumValue = 10.0;
//                        musicVolumeControl.tag = 0;
//                        musicVolumeControl.value = 3.5;
//                        musicVolumeControl.continuous = YES;
//                        [musicVolumeControl addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
//                        [ cell addSubview: musicVolumeControl ];
                        
//                        [ musicVolumeControl release ];
//                        }
//                        break;
//                }
//            case(1):
//                switch ([ indexPath indexAtPosition: 1 ]) {
//                    case(0):
//                    {
//                        UITextField *playerTextField = [ [ UITextField alloc ] initWithFrame: CGRectMake(150, 10, 145, 34) ];
//                        playerTextField.adjustsFontSizeToFitWidth = YES;
//                        playerTextField.textColor = [UIColor blackColor];
//                        playerTextField.font = [UIFont systemFontOfSize:17.0];
//                        playerTextField.placeholder = @"";
//                        playerTextField.backgroundColor = [UIColor clearColor];
//                        playerTextField.autocorrectionType = UITextAutocorrectionTypeNo;        // no auto correction support
//                        playerTextField.autocapitalizationType = UITextAutocapitalizationTypeNone; // no auto capitalization support
//                        playerTextField.textAlignment = UITextAlignmentRight;
//                        playerTextField.keyboardType = UIKeyboardTypeDefault; // use the default type input method (entire keyboard)
//                        playerTextField.returnKeyType = UIReturnKeyDone;
//                        playerTextField.tag = 0;
//                        playerTextField.delegate = self;
//                        
//                        playerTextField.clearButtonMode = UITextFieldViewModeNever; // no clear 'x' button to the right
//                        playerTextField.text = @"";
//                        [ playerTextField setEnabled: YES ];
//                        [ cell addSubview: playerTextField ];
//                        cell.textLabel.text = @"Player"; // OS3
//                        //       cell.text = @"Player";
//                        [playerTextField release];
//                    }
//                        break;
//                    case(1):
//                    {
//                        UISwitch *resetControl = [ [ UISwitch alloc ] initWithFrame: CGRectMake(200, 10, 0, 0) ];
//                        resetControl.on = YES;
//                        resetControl.tag = 1;
//                        [resetControl addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
//                        [ cell addSubview: resetControl ];
//                        cell.textLabel.text = @"Reset"; // OS3
//                        //       cell.text = @"Reset";
//                        [resetControl release];
//                    }
//                        break;
//                    case(2):
//                    {
//                        UISwitch *debugControl = [ [ UISwitch alloc ] initWithFrame: CGRectMake(200, 10, 0, 0) ];
//                        debugControl.on = NO;
//                        debugControl.tag = 2;
//                        [debugControl addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
//                        [ cell addSubview: debugControl ];
//                        cell.textLabel.text = @"Debug"; // OS3
//                        //       cell.text = @"Debug";
//                        [debugControl release];
//                    }
//                        break;
//                }
//                break;
//            case(2):
//            {
//                UITextField *versionControl = [ [ UITextField alloc ] initWithFrame: CGRectMake(170, 10, 125, 38) ];
//                versionControl.text = @"1.0.0 Rev. B";
//                [ cell addSubview: versionControl ];
//                
//                [ versionControl setEnabled: YES ];
//                versionControl.tag = 2;
//                versionControl.delegate = self;
//                cell.textLabel.text = @"Version"; // OS3
//                //     cell.text = @"Version";
//                [versionControl release];
//            }
//                break;
//        }
//    }
//    
//    return cell;
//}
//                        
//                        
//                        
//    
//    
//    
//    
//    
//    
//    
//    
//    
    
//    static NSString *CellIdentifier = @"Cell";
//    SiteCell *cell = (SiteCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    
//    if (cell == nil) {
//        cell = [[[SiteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];        
//        }
//    
//    tableView.separatorColor = [UIColor darkGrayColor];
//
//    
//    switch (indexPath.section) {
//        case 0:
//            
//            [cell setMainText:@"Start Experiment"];
//            
//            break;
//        case 1:
//            
//            switch (indexPath.row) {
//                case 0:
//                    [cell setMainText:@"Number of Trials"];
//                    break;
//                case 1:
//                    [cell setMainText:@"Dot size"];
//                    break;
//
//                    
//                default:
//                    break;
//            } 
//            
//            
//            
//            
//            break;
//        case 2:
//            [cell setMainText:@"What is this"];
//            
//            break;
////        case 3:
////            
////            break;
//            
//        default:
//            break;
//    }
//    
//    return cell;
//}
    
//    
//    static NSString *CellIdentifier = @"Cell";
//    SiteCell *cell = (SiteCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[[SiteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
//        
//    }
//    
//    tableView.separatorColor = [UIColor clearColor];
//    
//    NSDictionary *dictionary = [m_sitesArray objectAtIndex:indexPath.section];
//    NSArray *array = [dictionary objectForKey:@"Sites"];
//    AnatomicSiteDescription * cellValue = (AnatomicSiteDescription*)[array objectAtIndex:indexPath.row];
//    [cell setMainText:cellValue.longname];
//    
//    return cell;
//}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return @"";
            break;
            
        case 1:
            return @"Experiment Settings";
            break;            
            
        case 2:
            return @"Trial Settings";
            break;                   
        case 3:
            return @"Review";
            break;                
        default:
            break;
    }
    
    return @"";
}



- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return indexPath;
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    NSMutableDictionary *toSend = [NSMutableDictionary dictionary];
    [toSend setObject:[NSNumber numberWithFloat:touchSizeSlider.value] forKey:@"touch"];
    [toSend setObject:[NSNumber numberWithFloat:trialsSlider.value] forKey:@"trials"];
    [toSend setObject:[NSNumber numberWithFloat:fixationDurationSlider.value] forKey:@"fixation"];
    [toSend setObject:[NSNumber numberWithFloat:preparationDurationSlider.value] forKey:@"preparation"];    
    [toSend setObject:[NSNumber numberWithFloat:movementDurationSlider.value] forKey:@"movement"];      
    [toSend setObject:[NSNumber numberWithFloat:movementStepsSlider.value] forKey:@"steps"];
    [toSend setObject:subjectIDTextField.text forKey:@"subject"];
    
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowExperiment" object:toSend];    
            break;
        case 2:
            break;
    }
}

-(void) alertViewCancel:(UIAlertView *)alertView
{
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{ 
    NSString* messageString = [NSString stringWithFormat:@"Subject: %@\n%d Trial(s)", subjectIDTextField.text, (int)trialsSlider.value];
    switch (indexPath.section) {
        case 0:
            // show id
            if([subjectIDTextField.text length] > 0)
            {
                
                
                UIAlertView *alert =
                
                [[UIAlertView alloc] initWithTitle: @"Ready to begin experiment?"
                                           message: messageString
                                          delegate: self
                                 cancelButtonTitle: @"Back"
                                 otherButtonTitles: @"Yes", nil];
//                                                 otherButtonTitles: @"I already have one.", @"Yes!", nil];
                [alert show];
                [alert release];

            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please enter subject id" message:nil delegate:nil cancelButtonTitle:@"ok"  otherButtonTitles:nil];
                [alert show];
                [alert release];   
            }
            break;
        case 1:
            
            break;
        case 2:
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowAbout" object:nil];    

            // show id
            
            break;            
        default:
            break;
    }
    
    
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO];


}   

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];

    if (sectionTitle == nil) {
        return nil;
    }
    
    // Create label with section title
    UILabel *label = [[[UILabel alloc] init] autorelease];
    label.frame = CGRectMake(10, 0, self.view.frame.size.width, 30);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont fontWithName:@"Helvetica" size:16];
    label.text = sectionTitle;
    
    
    //    UIButton * infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    //    infoButton.alpha = 0.25f;
    //    infoButton.tag = section;
    //    [infoButton setFrame:CGRectMake(kSiteWidth - 30 , 18, 15, 15)];
    //    [infoButton addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
    //    
    
    // Create header view and add label as a subview
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    [view autorelease];
    [view addSubview:label];
    //    [view addSubview:infoButton];
    return view;
}





@end
