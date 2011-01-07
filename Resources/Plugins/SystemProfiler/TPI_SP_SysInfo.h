// Created by Codeux Software <support AT codeux DOT com> <https://github.com/codeux/Textual>
// You can redistribute it and/or modify it under the new BSD license.

@interface TPI_SP_SysInfo : NSObject 

+ (NSString *)compiledOutput;
+ (NSString *)model;
+ (NSString *)processor;
+ (NSNumber *)processorCount;
+ (NSString *)processorL2CacheSize;
+ (NSString *)processorL3CacheSize;
+ (NSString *)processorClockSpeed;
+ (NSString *)physicalMemorySize;
+ (NSString *)loadAverages;
+ (NSString *)systemUptime;
+ (NSString *)diskInfo;
+ (NSString *)getNetworkStats;
+ (NSString *)graphicsCardInfo;
+ (NSString *)getAllVolumesAndSizes;
+ (NSString *)applicationMemoryUsage;
+ (NSString *)getAllScreenResolutions;
+ (NSString *)applicationAndSystemUptime;
+ (NSString *)getBandwidthStats:(IRCWorld *)world;
+ (NSString *)getCurrentThemeInUse:(IRCWorld *)world;

+ (NSString *)formattedDiskSize:(TXFSLongInt)size;
+ (NSString *)formattedCPUFrequency:(double)rate;

@end