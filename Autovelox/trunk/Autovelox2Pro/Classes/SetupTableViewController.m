//
//  SetupTableViewController.m
//  AutoVelox
//
//  Created by Alessio Bonu on 26/07/09.
//  Copyright 2009 Navionics. All rights reserved.
//

#import "SetupTableViewController.h"




@implementation SetupTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andController:(Autovelox2ProAppDelegate*)avad andAutoController:(AutoVeloxProViewController *)c; 
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) 
	{
		controller=avad;
		autoContr=c;
	}
    return self;
}


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView 
{
	CGRect frame = CGRectMake(0,0,320,480);
	self.view = [[[UIView alloc] initWithFrame:frame] autorelease];
	self.view.backgroundColor=[UIColor blackColor];
	tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,320,480) style:UITableViewStyleGrouped];
	tableView.delegate = self;
	tableView.dataSource = self;
	
	tableView.autoresizingMask =UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
	[self.view addSubview:tableView];
	fissi=[[UISwitch alloc] initWithFrame:CGRectMake(200, 10, 80, 20) ];
	mobili=[[UISwitch alloc] initWithFrame:CGRectMake(200, 10, 80, 20) ];
	tutor=[[UISwitch alloc] initWithFrame:CGRectMake(200, 10, 80, 20) ];
	ecopass=[[UISwitch alloc] initWithFrame:CGRectMake(200, 10, 80, 20) ];
	NSUserDefaults * def=[NSUserDefaults standardUserDefaults];
	int i=[def integerForKey:@"Fissi"];
	if(i)
		[fissi setOn:YES];
	else 
		[fissi setOn:NO];
	i=[def integerForKey:@"Mobili"];
	if(i)
		[mobili setOn:YES];
	else 
		[mobili setOn:NO];
	i=[def integerForKey:@"Tutor"];
	if(i)
		[tutor setOn:YES];
	else 
		[tutor setOn:NO];
	i=[def integerForKey:@"Ecopass"];
	if(i)
		[ecopass setOn:YES];
	else 
		[ecopass setOn:NO];

}


- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)dealloc 
{
	[controller release];
	[tableView release];
	[fissi release];
	[mobili release];
	[tutor release];
	[ecopass release];	
    [super dealloc];
}

// Override to allow orientations other than the default portrait orientation.
/*- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
	
    return NO;
}*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
	return 2;		//Il +1 a causa dell'aggiunta del setting dei parametri della mail e del login di facebook
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{	
	
	switch (section)
	{
			
		case 0:
			return 4;
		case 1:
			return 1;	
	}
	
	return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
{
	switch (section)
	{

		case 0:
			return @"Seleziona la tipologia di punti di interesse che vuoi visualizzare.";
		case 1:
			return @"\n";
			
	}
	
	return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableview cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{	
	UITableViewCell * cell;
	cell = [tableview dequeueReusableCellWithIdentifier:@"autovelox"];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"autovelox"] autorelease];
		cell.editing = NO;
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
		//cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
	}
	switch (indexPath.section) {

		case 0:
			if(indexPath.row==0)
			{
				cell.textLabel.text=@"Autovelox fissi";
				[cell addSubview:fissi];
				
			}
			else if(indexPath.row==1)
			{
				cell.textLabel.text=@"Autovelox mobili";
				[cell addSubview:mobili];
			}
			else if(indexPath.row==2)
			{
				cell.textLabel.text=@"Tutor";
				[cell addSubview:tutor];
			}	
			else if(indexPath.row==3)
			{
				cell.textLabel.text=@"Ecopass";
				[cell addSubview:ecopass];
			}	
			break;
		case 1:
			cell.selectionStyle=UITableViewCellSelectionStyleBlue;
			cell.textLabel.textAlignment=UITextAlignmentCenter;
			cell.textLabel.text=@"Torna alla mappa";
			break;
		default:
			break;
	}
	return cell;
}

-(void) done
{
	NSUserDefaults * def=[NSUserDefaults standardUserDefaults];
	if([fissi isOn])
	{
		[def setInteger:1 forKey:@"Fissi"];
		autoContr.fissi=YES;
	}
	else
	{
		[def setInteger:0 forKey:@"Fissi"];
		autoContr.fissi=NO;
	}
	if([mobili isOn])
	{
		[def setInteger:1 forKey:@"Mobili"];
		autoContr.mobili=YES;
	}
	else
	{
		[def setInteger:0 forKey:@"Mobili"];
		autoContr.mobili=NO;
	}
	if([tutor isOn])
	{
		[def setInteger:1 forKey:@"Tutor"];
		autoContr.tutor=YES;
	}
	else
	{
		[def setInteger:0 forKey:@"Tutor"];
		autoContr.tutor=NO;
	}
	if([ecopass isOn])
	{
		[def setInteger:1 forKey:@"Ecopass"];
		autoContr.ecopass=YES;
	}
	else
	{
		[def setInteger:0 forKey:@"Ecopass"];
		autoContr.ecopass=NO;
	}
	
	UIViewAnimationTransition  trans = UIViewAnimationTransitionFlipFromRight;
	[UIView beginAnimations: nil context: nil];
	[UIView setAnimationTransition: trans forView:[self.view window]  cache: YES];
	[UIView setAnimationDuration:1.0];
	[self.view removeFromSuperview];
	[UIView commitAnimations];
	
	
}



- (void)tableView:(UITableView *)tableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
	switch (indexPath.section) {

		case 0:
			break;
		case 1:
			[self done];
			break;	
		default:
			break;
	}
}


@end
