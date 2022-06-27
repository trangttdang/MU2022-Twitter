//
//  DetailTweetViewController.h
//  twitter
//
//  Created by Trang Dang on 6/22/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
#import "TweetCell.h"

NS_ASSUME_NONNULL_BEGIN
@protocol DetailTweetViewControllerDelegate
- (void)didTweet:(Tweet *)tweet;
- (void)didUnRetweet:(Tweet *)tweet;
- (void)didTapFavorite:(Tweet *)tweet;
@end
@interface DetailTweetViewController : UIViewController
@property (strong,nonatomic) Tweet *tweet;
@property (strong,nonatomic) TweetCell *tweetCell;
@property (nonatomic,weak) id<DetailTweetViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
