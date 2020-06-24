//
//  DemoUtils.m
//  CollectionViewCustomLayout
//
//  Created by 路 on 2020/6/24.
//  Copyright © 2020 路. All rights reserved.
//

#import "DemoUtils.h"
#import <CommonCrypto/CommonDigest.h>

@implementation DemoUtils

+ (NSString *)MD5String:(NSString *)string; {
    const char *ptr = [string UTF8String];
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(ptr, (unsigned int)strlen(ptr), md5Buffer);
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x",md5Buffer[i]];
    }
    return output;
}

+ (void)setImageURL:(NSURL *)url forImageView:(UIImageView *)imageView; {
    if (!url) {
        return;
    }
    NSString *temp = NSTemporaryDirectory();
    NSString *file = [temp stringByAppendingPathComponent:[DemoUtils MD5String:url.absoluteString]];
    NSFileManager *fileManger = [NSFileManager defaultManager];
    BOOL isDirectory;
    BOOL exists = [fileManger fileExistsAtPath:file isDirectory:&isDirectory];
    if (exists && !isDirectory) {
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfFile:file]];
        imageView.image = image;
        return;
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        UIImage *resultImage = [UIImage imageWithData:imageData];
        if (resultImage) {
            [imageData writeToFile:file atomically:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                imageView.image = resultImage;
                CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
                anim.values = @[@(0) ,@(1)];
                anim.duration = .25;
                [imageView.layer addAnimation:anim forKey:nil];
            });
        }
    });
}

+ (NSArray <NSDictionary *>*)listData; {
    // Demo 模拟数据
    NSMutableArray *result = [NSMutableArray array];
    [result addObject:@{
        @"id":@"1",
        @"content":@"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=2416805585,2146803482&fm=26&gp=0.jpg",
    }];
    [result addObject:@{
        @"id":@"2",
        @"content":@"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=2107577769,1753645967&fm=26&gp=0.jpg",
    }];
    [result addObject:@{
        @"id":@"3",
        @"content":@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=1304587362,1002579215&fm=26&gp=0.jpg",
    }];
    [result addObject:@{
        @"id":@"4",
        @"content":@"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=134401425,3736048277&fm=26&gp=0.jpg",
    }];
    [result addObject:@{
        @"id":@"5",
        @"content":@"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=349448199,555215941&fm=26&gp=0.jpg",
    }];
    [result addObject:@{
        @"id":@"6",
        @"content":@"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1627797084,2009532404&fm=26&gp=0.jpg",
    }];
    [result addObject:@{
        @"id":@"7",
        @"content":@"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=3520688972,1810691836&fm=26&gp=0.jpg",
    }];
    [result addObject:@{
        @"id":@"8",
        @"content":@"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=2095382647,2010577844&fm=26&gp=0.jpg",
    }];
    [result addObject:@{
        @"id":@"9",
        @"content":@"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1945418946,2445174864&fm=15&gp=0.jpg",
    }];
    [result addObject:@{
        @"id":@"10",
        @"content":@"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=3483415840,2446087639&fm=26&gp=0.jpg",
    }];
    return result.copy;
}
@end
