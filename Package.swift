// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TouchEPlugin",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "TouchEPlugin",
            targets: ["TouchEPlugin"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.5.4"),
        .package(url: "https://github.com/ninjaprox/NVActivityIndicatorView.git", from: "5.1.1"),
        .package(url: "https://github.com/SDWebImage/SDWebImage.git", from: "5.18.6"),
        .package(url: "https://github.com/evgenyneu/Cosmos.git", from: "24.0.0"),
        .package(url: "https://github.com/olbartek/FSPagerView.git", from: "0.8.3"),
        .package(url: "https://github.com/aws-amplify/aws-sdk-ios-spm.git", from: "2.27.6")
    ],
    
    targets: [
        .target(
            name: "TouchEPlugin",
            dependencies: ["Alamofire", "NVActivityIndicatorView", "SDWebImage", "Cosmos", "FSPagerView",
                           .product(name: "AWSAuthCore", package: "aws-sdk-ios-spm"),
                           .product(name: "AWSS3", package: "aws-sdk-ios-spm"),
                           .product(name: "AWSMobileClientXCF", package: "aws-sdk-ios-spm"),
                           .product(name: "AWSCognitoIdentityProviderASF", package: "aws-sdk-ios-spm")
                          ],
            resources: [
                //MARK: - TableViewCell
                .copy("TblCell/AccountDetailsCell.xib"),
                .copy("TblCell/ActorDetailTableViewCell.xib"),
                .copy("TblCell/AddressCell.xib"),
                .copy("TblCell/AttributeCell.xib"),
                .copy("TblCell/AttributeItemCell.xib"),
                .copy("TblCell/BrandImageCell.xib"),
                .copy("TblCell/CartAttributeCVCell.xib"),
                .copy("TblCell/CartItemCell.xib"),
                .copy("TblCell/CartSectionCell.xib"),
                .copy("TblCell/CategoriesTableViewCell.xib"),
                .copy("TblCell/CustomerReviewTBLCell.xib"),
                .copy("TblCell/GenresTBLCell.xib"),
                .copy("TblCell/LiveProductCell.xib"),
                .copy("TblCell/OrderSummearyCell.xib"),
                .copy("TblCell/MoreProductTBLCell.xib"),
                .copy("TblCell/ProductImageDetailsCell.xib"),
                .copy("TblCell/PriceShippingCell.xib"),
                .copy("TblCell/PaymentCardCell.xib"),
                .copy("TblCell/OrderCell.xib"),
                .copy("TblCell/OrderDetailTBLCell.xib"),
                .copy("TblCell/OrderListHeaderCell.xib"),
                .copy("TblCell/OrderListCell.xib"),
                .copy("TblCell/PersonalinformationTBLCell.xib"),
                .copy("TblCell/PosttoTBLCell.xib"),
                .copy("TblCell/PaymentDetailsTBLCell.xib"),
                .copy("TblCell/ItemTBLCell.xib"),
                .copy("TblCell/RecentMovieCell.xib"),
                
                
                //MARK: - TableViewHeaderFooterView
                .copy("TblHeaderFooterView/CartHeaderView.xib"),
                
                //MARK: - CollectionViewCell
                .copy("CollectionCell/CategoriesCollectionViewCell.xib"),
                .copy("CollectionCell/VideoProductCVCell.xib"),
                .copy("CollectionCell/ActorimageCollectionViewCell.xib"),
                .copy("CollectionCell/customerReviewCVCell.xib"),
                .copy("CollectionCell/MoreProductCell.xib"),
                .copy("CollectionCell/OrderStatusCell.xib"),
                .copy("CollectionCell/AddressCVCell.xib"),
                .copy("CollectionCell/CardCVCell.xib"),
                .copy("CollectionCell/StoreTitleCell.xib"),
                .copy("CollectionCell/SelectedFilterCell.xib"),
                .copy("CollectionCell/VideoListCVCell.xib"),
                
                //MARK: - ViewController
                .copy("Controller/ActorDetailsVC.xib"),
                .copy("Controller/AddAddressVC.xib"),
                .copy("Controller/BrandDetailsVC.xib"),
                .copy("Controller/ChangePasswordVC.xib"),
                .copy("Controller/CheckOutVC.xib"),
                .copy("Controller/EditProfileVC.xib"),
                .copy("Controller/HomeViewController.xib"),
                .copy("Controller/MyCartVC.xib"),
                .copy("Controller/OrderDetailVC.xib"),
                .copy("Controller/OrderListVC.xib"),
                .copy("Controller/ShowListViewController.xib"),
                .copy("Controller/VideoDetailViewController.xib"),
                .copy("Controller/VideoViewController.xib"),
                .copy("Controller/ProdutDetailsVC.xib"),
                .copy("Controller/ProfileVC.xib"),
                .copy("Controller/VideoDetailsFromOtherVC.xib")
                
            ]
        ),
    ]
)
