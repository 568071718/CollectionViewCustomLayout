//
//  DemoUtils.h
//  CollectionViewCustomLayout
//
//  Created by 路 on 2020/6/24.
//  Copyright © 2020 路. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DemoUtils : NSObject

+ (NSArray <NSDictionary *>*)listData; // 模拟列表数据
+ (NSString *)MD5String:(NSString *)string;
+ (void)setImageURL:(NSURL *)url forImageView:(UIImageView *)imageView;
@end

NS_ASSUME_NONNULL_END
