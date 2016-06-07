//
//  SOFinancialProviceModel.h
//  souban
//
//  Created by Rawlings on 1/27/16.
//  Copyright © 2016 wajiang. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol SOFinancialAreaModel <NSObject>
@end
@interface SOFinancialAreaModel : JSONModel
@property (nonatomic, strong) NSString *areaCode;/**<  */
@property (nonatomic, strong) NSString *name;/**<  */
@end


@protocol SOFinancialCityModel <NSObject>
@end
@interface SOFinancialCityModel : JSONModel
@property (nonatomic, strong) NSArray<SOFinancialAreaModel> *areas;/**< 区域 */
@property (nonatomic, strong) NSString *code;/**<  */
@property (nonatomic, strong) NSString *name;/**<  */
@end


@interface SOFinancialProviceModel : JSONModel
@property (nonatomic, strong) NSArray<SOFinancialCityModel> *citys;/**<  */
@property (nonatomic, strong) NSString *code;/**<  */
@property (nonatomic, strong) NSString *name;/**<  */

@end
