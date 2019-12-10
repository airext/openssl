//
//  ViewController.m
//  ANXOpenSSLTest
//
//  Created by Max Rozdobudko on 04.12.2019.
//

#import "ViewController.h"

#import "TestRSA.h"
#import "TestBase64.h"
#import "TestHex.h"

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

- (IBAction)handleTestBase64ButtonTap:(id)sender {
    [TestBase64 test_ane];
}

- (IBAction)handleTestHexButtonTap:(id)sender {
    [TestHex test_ane];
}
@end
