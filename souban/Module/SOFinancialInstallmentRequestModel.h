//
//  SOFinancialInstallmentRequestModel.h
//  souban
//
//  Created by Rawlings on 1/26/16.
//  Copyright © 2016 wajiang. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface SOFinancialInstallmentRequestModel : JSONModel

@property (nonatomic, strong) NSString *buildingName;/**< 	楼盘名称 */
@property (nonatomic, strong) NSString *job;/**<  工作行业 */
@property (nonatomic, strong) NSNumber *monthlyAmount;/**< 月供 */
@property (nonatomic, strong) NSString *name;/**<  姓名 */
@property (nonatomic, strong) NSString *phoneNum;/**<  手机号码 */
@property (nonatomic, strong) NSString *remarks;/**< 备注 */

@end
