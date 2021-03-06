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
#import "TestAES.h"
#import "TestVerify.h"
#import "TestSHA.h"
#import "TestHMAC.h"

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

- (IBAction)handleTestAESButtonTap:(id)sender {
    [TestAES test_ane];
}

- (IBAction)handleTestVerifyButtonTap:(id)sender {
    [TestVerify test_ane];
}

- (IBAction)handleTestSHAButtonTap:(id)sender {
    [TestSHA test_ane];
}

- (IBAction)handleTestHMACButtonTap:(id)sender {
    [TestHMAC test_ane];
}

@end
