//
//  SOFinancialMortgageRequestModel.h
//  souban
//
//  Created by Rawlings on 1/26/16.
//  Copyright © 2016 wajiang. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface SOFinancialMortgageRequestModel : JSONModel

@property (nonatomic, strong) NSNumber *applyAmount;/**< 申请金额 */
@property (nonatomic, strong) NSNumber *blockId;/**< 商圈Id	 */
@property (nonatomic, strong) NSString *buildingName;/**< 楼盘名称 */
@property (nonatomic, strong) NSString *leaseStatus;/**< 	租赁状态  是，否 */
@property (nonatomic, strong) NSString *name;/**<  */
@property (nonatomic, strong) NSString *phoneNum;/**<  */
@property (nonatomic, strong) NSString *remarks;/**< 备注 */

@end
