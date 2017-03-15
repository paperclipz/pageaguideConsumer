

#import "DataManager.h"
#import "EnumType.h"
#import "LoadingManager.h"
#import "AFHTTPSessionManager.h"

#define IS_SIMULATOR NO

#define SERVICE_TOKEN @"iw-V8JRku6nEmUnz7GJOpsJ_0-D7z0resdYmnJQirsU"

@interface ConnectionManager :NSObject
@property(nonatomic,strong)NSString* serverPath;
@property(nonatomic,strong)NSString* subPath;

#pragma mark - Get Network Status

+ (NSString*)getServerPath;

+ (BOOL)isNetworkAvailable;

#pragma mark - Default Declaration

+ (id)Instance;

+ (DataManager*)dataManager;

#pragma mark - Request Server method

- (void)storeServerData:(id)obj requestType:(ServerRequestType)type;

+ (void)requestServerWith:(AFNETWORK_TYPE)networkType serverRequestType:(ServerRequestType)serverType parameter:(NSDictionary*)parameter appendString:(NSString*)appendString success:(IDBlock)success failure:(IErrorBlock)failure;

+(void)requestServerWithNSURLSession:(AFNETWORK_TYPE)networkType serverRequestType:(ServerRequestType)serverType parameter:(NSDictionary*)parameter appendString:(NSString*)appendString success:(IDBlock)success failure:(IErrorBlock)failure;


-(BOOL)validateBeforeRequest:(ServerRequestType)type;

@end
