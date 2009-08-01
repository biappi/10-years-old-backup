//
//  SetupTableViewController.h
//  AutoVelox
//
//  Created by Alessio Bonu on 26/07/09.
//  Copyright 2009 Navionics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Autovelox2ProAppDelegate.h"
#import "AutoVeloxProViewController.h"

@interface SetupTableViewController : UITableViewController {
	UISwitch *fissi;
	UISwitch *mobili;
	UISwitch *ecopass;
	UISwitch *tutor;
	Autovelox2ProAppDelegate *controller;
	AutoVeloxProViewController * autoContr;
	UITableView *tableView;	
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andController:(Autovelox2ProAppDelegate*)avad andAutoController:(AutoVeloxProViewController*) cont; 


@end
