//
//  ANXOpenSSLConversionRoutines.h
//  OpenSSL
//
//  Created by Max Rozdobudko on 03.12.2019.
//

#import <Foundation/Foundation.h>
#import "FlashRuntimeExtensions.h"

NS_ASSUME_NONNULL_BEGIN

@interface ANXOpenSSLConversionRoutines : NSObject

+ (FREObject)convertNSStringToFREObject:(NSString*)string;
+ (NSString*)convertFREObjectToNSString:(FREObject)string;

+ (BOOL)convertFREObjectToBool:(FREObject)value;
+ (FREObject)convertBoolToFREObject:(BOOL)value;

+ (NSInteger)convertFREObjectToNSInteger:(FREObject)integer withDefault:(NSInteger)defaultValue;
+ (FREObject)convertNSIntegerToFREObject:(NSInteger)integer;

+ (NSString*)readNSStringFrom:(FREObject)object field:(NSString*)field withDefaultValue:(NSString* _Nullable)defaultValue;
+ (BOOL)readBoolFrom:(FREObject)object field:(NSString*)field withDefaultValue:(BOOL)defaultValue;
+ (NSInteger)readNSIntegerFrom:(FREObject)object field:(NSString*)field withDefaultValue:(NSInteger)defaultValue;
+ (NSInteger)readNSIntegerFrom:(FREObject)object field:(NSString*)field withRawValueField:(NSString*)rawValueField withDefaultValue:(NSInteger)defaultValue;

+ (FREObject)createByteArrayWithLength:(int32_t)length;

@end

NS_ASSUME_NONNULL_END
