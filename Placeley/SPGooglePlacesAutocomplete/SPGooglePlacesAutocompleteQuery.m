//
//  SPGooglePlacesAutocompleteQuery.m
//  SPGooglePlacesAutocomplete
//
//  Created by Stephen Poletto on 7/17/12.
//  Copyright (c) 2012 Stephen Poletto. All rights reserved.
//

#define	kAccounting	@"accounting"
#define	kAirport	@"airport"
#define	kAmusementPark	@"amusement_park"
#define	kAquarium	@"aquarium"
#define	kArtGallery	@"art_gallery"
#define	kAtm	@"atm"
#define	kBakery	@"bakery"
#define	kBank	@"bank"
#define	kBar	@"bar"
#define	kBeautySalon	@"beauty_salon"
#define	kBicycleStore	@"bicycle_store"
#define	kBookStore	@"book_store"
#define	kBowlingAlley	@"bowling_alley"
#define	kBusStation	@"bus_station"
#define	kCafe	@"cafe"
#define	kCampground	@"campground"
#define	kCarDealer	@"car_dealer"
#define	kCarRental	@"car_rental"
#define	kCarRepair	@"car_repair"
#define	kCarWash	@"car_wash"
#define	kCasino	@"casino"
#define	kCemetery	@"cemetery"
#define	kChurch	@"church"
#define	kCityHall	@"city_hall"
#define	kClothingStore	@"clothing_store"
#define	kConvenienceStore	@"convenience_store"
#define	kCourthouse	@"courthouse"
#define	kDentist	@"dentist"
#define	kDepartmentStore	@"department_store"
#define	kDoctor	@"doctor"
#define	kElectrician	@"electrician"
#define	kElectronicsStore	@"electronics_store"
#define	kEmbassy	@"embassy"
#define	kEstablishment	@"establishment"
#define	kFinance	@"finance"
#define	kFireStation	@"fire_station"
#define	kFlorist	@"florist"
#define	kFood	@"food"
#define	kFuneralHome	@"funeral_home"
#define	kFurnitureStore	@"furniture_store"
#define	kGasStation	@"gas_station"
#define	kGeneralContractor	@"general_contractor"
#define	kGeocode	@"geocode"
#define	kGrocerySupermarket	@"grocery_or_supermarket"
#define	kGym	@"gym"
#define	kHairCare	@"hair_care"
#define	kHardwareStore	@"hardware_store"
#define	kHealth	@"health"
#define	kHindu_temple	@"hindu_temple"
#define	kHomeGoodsStore	@"home_goods_store"
#define	kHospital	@"hospital"
#define	kInsuranceAgency	@"insurance_agency"
#define	kJewelryStore	@"jewelry_store"
#define	kLaundry	@"laundry"
#define	kLawyer	@"lawyer"
#define	kLibrary	@"library"
#define	kLiquorStore	@"liquor_store"
#define	kLocalGovernmentOffice	@"local_government_office"
#define	kLocksmith	@"locksmith"
#define	kLodging	@"lodging"
#define	kMealDelivery	@"meal_delivery"
#define	kMealTakeaway	@"meal_takeaway"
#define	kMosque	@"mosque"
#define	kMovieTental	@"movie_rental"
#define	kMovieTheater	@"movie_theater"
#define	kMovingCompany	@"moving_company"
#define	kMuseum	@"museum"
#define	kNightClub	@"night_club"
#define	kPainter	@"painter"
#define	kPark	@"park"
#define	kParking	@"parking"
#define	kPetStore	@"pet_store"
#define	kPharmacy	@"pharmacy"
#define	kPhysiotherapist	@"physiotherapist"
#define	kPlaceWorship	@"place_of_worship"
#define	kPlumber	@"plumber"
#define	kPolice	@"police"
#define	kPostOffice	@"post_office"
#define	kRealEstateAgency	@"real_estate_agency"
#define	kRestaurant	@"restaurant"
#define	kRoofingContractor	@"roofing_contractor"
#define	kRvPark	@"rv_park"
#define	kSchool	@"school"
#define	kShoeStore	@"shoe_store"
#define	kShoppingMall	@"shopping_mall"
#define	kSpa	@"spa"
#define	kStadium	@"stadium"
#define	kStorage	@"storage"
#define	kStore	@"store"
#define	kSubwayStation	@"subway_station"
#define	kSynagogue	@"synagogue"
#define	kTaxiStand	@"taxi_stand"
#define	kTrainStation	@"train_station"
#define	kTravelAgency	@"travel_agency"
#define	kUniversity	@"university"
#define	kVeterinaryCare	@"veterinary_care"
#define	kZoo	@"zoo"


#import "SPGooglePlacesAutocompleteQuery.h"
#import "SPGooglePlacesAutocompletePlace.h"

@interface SPGooglePlacesAutocompleteQuery()
@property (nonatomic, copy) SPGooglePlacesAutocompleteResultBlock resultBlock;
@end

@implementation SPGooglePlacesAutocompleteQuery

- (id)initWithApiKey:(NSString *)apiKey {
    self = [super init];
    if (self) {
        // Setup default property values.
        self.sensor = YES;
        self.key = apiKey;
        self.offset = NSNotFound;
        self.location = CLLocationCoordinate2DMake(-1, -1);
        self.radius = 500;
        self.types = SPPlaceTypeInvalid;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Query URL: %@", [self googleURLString]];
}


- (NSString *)googleURLString {
    
    NSString *    searchLocations = [NSString stringWithFormat:@"%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@%@|%@|%@|%@|%@|%@|%@|%@|%@%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@", kAccounting, kAirport,  kAmusementPark,   kAquarium,    kArtGallery,  kAtm,  kBakery,   kBank,   kBar,   kBeautySalon, kBicycleStore,    kBookStore,  kBowlingAlley,   kBusStation,   kCafe,   kCampground,  kCarDealer,   kCarRental,  kCarRepair,   kCarWash, kCasino,    kCemetery,    kChurch,  kCityHall,    kClothingStore,  kConvenienceStore,   kCourthouse,  kDentist,  kDepartmentStore,  kDoctor, kElectrician,kElectronicsStore, kEmbassy, kEstablishment, kFinance, kFireStation, kFlorist,    kFood,    kFuneralHome,    kFurnitureStore,   kGasStation,     kGeneralContractor,   kGeocode,  kGrocerySupermarket,  kGym,   kHairCare, kHardwareStore, kHealth,   kRestaurant,    kCafe,   kBakery,  kFood,   kLodging, kMealDelivery,  kMealTakeaway,kNightClub,kMuseum,   kParking,   kPetStore,   kPharmacy,   kPlumber,    kPolice,    kPostOffice,    kRealEstateAgency,   kRestaurant,     kRvPark,     kSchool,    kShoeStore,   kShoppingMall, kSpa ,kStadium,   kStore,   kTaxiStand,   kTrainStation,    kUniversity,    kZoo];

    NSMutableString *url = [NSMutableString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&sensor=%@&key=%@",
                            [self.input stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                            SPBooleanStringForBool(self.sensor), self.key];
    if (self.offset != NSNotFound) {
        [url appendFormat:@"&offset=%u", self.offset];
    }
    if (self.location.latitude != -1) {
        [url appendFormat:@"&location=%f,%f", self.location.latitude, self.location.longitude];
    }
    if (self.radius != NSNotFound) {
        [url appendFormat:@"&radius=%f", self.radius];
    }
    if (self.language) {
        [url appendFormat:@"&language=%@", self.language];
    }
    if (searchLocations != nil) {
        [url appendFormat:@"&types=%@", SPPlaceTypeStringForPlaceType(searchLocations)];
    }
    return url;
}

- (void)cleanup {
    googleConnection = nil;
    responseData = nil;
    self.resultBlock = nil;
}

- (void)cancelOutstandingRequests {
    [googleConnection cancel];
    [self cleanup];
}

- (void)fetchPlaces:(SPGooglePlacesAutocompleteResultBlock)block {
    if (!self.key) {
        return;
    }
    
    if (SPIsEmptyString(self.input)) {
        // Empty input string. Don't even bother hitting Google.
        block(@[], nil);
        return;
    }
    
    [self cancelOutstandingRequests];
    self.resultBlock = block;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[self googleURLString]]];
    googleConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    responseData = [[NSMutableData alloc] init];
}

#pragma mark -
#pragma mark NSURLConnection Delegate

- (void)failWithError:(NSError *)error {
    if (self.resultBlock != nil) {
        self.resultBlock(nil, error);
    }
    [self cleanup];
}

- (void)succeedWithPlaces:(NSArray *)places {
    NSMutableArray *parsedPlaces = [NSMutableArray array];
    for (NSDictionary *place in places) {
        [parsedPlaces addObject:[SPGooglePlacesAutocompletePlace placeFromDictionary:place apiKey:self.key]];
    }
    if (self.resultBlock != nil) {
        self.resultBlock(parsedPlaces, nil);
    }
    [self cleanup];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    if (connection == googleConnection) {
        [responseData setLength:0];
    }
}

- (void)connection:(NSURLConnection *)connnection didReceiveData:(NSData *)data {
    if (connnection == googleConnection) {
        [responseData appendData:data];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if (connection == googleConnection) {
        [self failWithError:error];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (connection == googleConnection) {
        NSError *error = nil;
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
        if (error) {
            [self failWithError:error];
            return;
        }
        if ([response[@"status"] isEqualToString:@"ZERO_RESULTS"]) {
            [self succeedWithPlaces:@[]];
            return;
        }
        if ([response[@"status"] isEqualToString:@"OK"]) {
            [self succeedWithPlaces:response[@"predictions"]];
            return;
        }
        
        // Must have received a status of OVER_QUERY_LIMIT, REQUEST_DENIED or INVALID_REQUEST.
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: response[@"status"]};
        [self failWithError:[NSError errorWithDomain:@"com.spoletto.googleplaces" code:kGoogleAPINSErrorCode userInfo:userInfo]];
    }
}

@end