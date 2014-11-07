//
//  DLAnimationViewController.m
//  RSN
//
//  Created by Pablo Segura on 11/7/14.
//  Copyright (c) 2014 DreamLabs. All rights reserved.
//

#import "DLAnimationViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "DLCenterViewController.h"

@interface DLAnimationViewController ()

@end

@implementation DLAnimationViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the vi
    
}
-(void)viewDidAppear:(BOOL)animated{
    // vibrate
    for (int i = 1; i < 4; i++) {
        [self performSelector:@selector(vibe:) withObject:self afterDelay:i *.4f];
    }
    [self animateSplashScreen];
    [self performSelector:@selector(showMainMenu) withObject:nil afterDelay:1.1];
   
}

-(void)vibe:(id)sender {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

- (void)showMainMenu {
    [self performSegueWithIdentifier:@"goToMainView" sender:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)animateSplashScreen{
    self.viewToAnimate.transform = CGAffineTransformMakeTranslation(5.0, -5.0);
    [UIView animateWithDuration:0.14
                          delay:0.0
                        options:UIViewAnimationOptionAutoreverse
                     animations:^{
                         UIView.animationRepeatCount = 6;
                         self.viewToAnimate.transform = CGAffineTransformMakeTranslation(-5.0, 5.0);
                     }
                     completion:^(BOOL finished){
                         self.viewToAnimate.transform = CGAffineTransformIdentity;
                     }];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
