//
//  ViewController.m
//  ANXOpenSSLTest
//
//  Created by Max Rozdobudko on 04.12.2019.
//

#import "ViewController.h"

#import "TestRSA.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

#pragma mark - Actions

- (IBAction)handleTestRSAButtonTap:(id)sender {
    [TestRSA.sharedInstance test_ane];
}

@end
