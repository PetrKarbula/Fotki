//
//  AppDelegate.h
//  Fotki
//
//  Created by maly Kuba on 23/11/13.
//  Copyright (c) 2013 Craneballs_Barcelona. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "SidebarViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MainViewController *mainView;
@property (strong, nonatomic) SidebarViewController *sideBarView;


@end
