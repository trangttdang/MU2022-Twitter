//
//  ComposeViewController.m
//  twitter
//
//  Created by Trang Dang on 6/21/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"
#import "TimelineViewController.h"

@interface ComposeViewController ()
@property (weak, nonatomic) IBOutlet UITextView *composeTweetTextView;
@property (weak, nonatomic) IBOutlet UILabel *charLeftLabel;


@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.composeTweetTextView.delegate = self;
}


- (IBAction)didClose:(id)sender {
//    [self dismissViewControllerAnimated:true completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)didTapPost:(id)sender {
            [[APIManager shared] postStatusWithText:self.composeTweetTextView.text completion:^(Tweet *tweet, NSError *error) {
                if(error){
                    NSLog(@"Error composing Tweet: %@", error.localizedDescription);
                }
                else{
                    [self.delegate didTweet:tweet];
                    NSLog(@"Compose Tweet Success!");
//                    [self dismissViewControllerAnimated:true completion:nil];
                    [self.navigationController popViewControllerAnimated:YES];

                }
                
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


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    // TODO: Check the proposed new text character count

    // TODO: Allow or disallow the new text
    // Set the max character limit
    int characterLimit = 140;

    // Construct what the new text would be if we allowed the user's latest edit
    NSString *newText = [self.composeTweetTextView.text stringByReplacingCharactersInRange:range withString:text];

    // TODO: Update character count label
    NSString *characterLeft = [NSString stringWithFormat:@"%lu", 140 - newText.length];
    
    self.charLeftLabel.text = [characterLeft stringByAppendingString:@"/140"];
    // Should the new text should be allowed? True/False
    return newText.length < characterLimit;
}

@end
