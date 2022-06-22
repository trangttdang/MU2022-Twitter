//
//  TweetCell.m
//  twitter
//
//  Created by Trang Dang on 6/20/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "Tweet.h"
#import "User.h"
#import "APIManager.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)didTapFavorite:(id)sender {
    // Send a POST request to the POST favorites/create endpoint
     [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
         if(error){
              NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
         }
         else{
             NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
             [self.delegate didTapFavorite:tweet];
         }
     }];
    
    self.tweet.favorited = YES;
    self.tweet.favoriteCount += 1;
    [self.favoriteButton setImage:[UIImage imageNamed:@"favor-icon-red"] forState:UIControlStateNormal];
    
    [self refreshData];
    
}

- (void)refreshData{
    self.userNameLabel.text = self.tweet.user.name;
    self.textLabel.text = self.tweet.text;
    self.dateCreatedLabel.text = self.tweet.createdAtString;
    self.userScreenNameLabel.text = self.tweet.user.screenName;
    self.retweetCountLabel.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    self.favoriteCountLabel.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    
}
@end
