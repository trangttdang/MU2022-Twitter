//
//  TweetCell.h
//  twitter
//
//  Created by Trang Dang on 6/20/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
#import "User.h"
//#import "ComposeViewController.h"

NS_ASSUME_NONNULL_BEGIN
@protocol TweetCellDelegate
- (void)didTweet:(Tweet *)tweet;
- (void)didUnRetweet:(Tweet *)tweet;
- (void)didTapProfileImage:(Tweet *) tweet;
- (void)didTapFavorite:(Tweet *)tweet;


@end


@interface TweetCell : UITableViewCell
//@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateCreatedLabel;
@property (weak, nonatomic) IBOutlet UILabel *userScreenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (nonatomic,strong) Tweet *tweet;
@property (nonatomic,weak) id<TweetCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UITextView *textTextView;
@property (weak, nonatomic) IBOutlet UIImageView *mediaImageView;
//@property (weak, nonatomic) IBOutlet UIButton *profileImageButton;
@property (weak, nonatomic) IBOutlet UILabel *inReplyToScreenNameLabel;

@end

NS_ASSUME_NONNULL_END
