# Bookings Feature Readiness Analysis

**Date**: December 28, 2024  
**Status**: ✅ **READY TO IMPLEMENT** (with minor adjustments needed)

---

## Executive Summary

The bookings feature is **ready for implementation**. Both UI screens are complete and backend endpoints are available. However, we need to:

1. ✅ Create `BookingsService` in Flutter
2. ✅ Update `Booking` model to support both hotel and restaurant bookings
3. ✅ Integrate API calls into booking screens
4. ⚠️ Handle time format conversion (UI: "12:00 PM" → API: "19:00")
5. ⚠️ Map contact info to `guests[]` array for restaurant bookings

---

## 1. Backend API Status ✅

### 1.1 Endpoints Available

All required endpoints are implemented and ready:

| Endpoint | Method | Status | Purpose |
|----------|--------|--------|---------|
| `/api/bookings` | GET | ✅ | Get user bookings (with filters) |
| `/api/bookings/upcoming` | GET | ✅ | Get upcoming bookings |
| `/api/bookings/:id` | GET | ✅ | Get booking details |
| `/api/bookings` | POST | ✅ | Create booking |
| `/api/bookings/:id` | PUT | ✅ | Update booking |
| `/api/bookings/:id/cancel` | POST | ✅ | Cancel booking |
| `/api/bookings/:id/confirm-payment` | POST | ✅ | Confirm payment |

**All endpoints require JWT authentication** ✅

### 1.2 CreateBookingDto Structure

The DTO supports both hotel and restaurant bookings via `bookingType` discriminator:

**Common Fields:**
- `bookingType`: 'hotel' | 'restaurant' | 'event' | 'tour' ✅
- `guestCount`: number ✅
- `adults`: number ✅
- `children`: number ✅
- `specialRequests`: string ✅
- `guests[]`: BookingGuestDto[] ✅

**Hotel-Specific Fields:**
- `listingId`: UUID ✅
- `roomTypeId`: UUID ✅
- `checkInDate`: ISO date string ✅
- `checkOutDate`: ISO date string ✅

**Restaurant-Specific Fields:**
- `listingId`: UUID ✅
- `tableId`: UUID (optional) ✅
- `bookingDate`: ISO date string ✅
- `bookingTime`: string (e.g., "19:00") ✅
- `partySize`: number ✅

**Status**: ✅ **Backend DTO is complete and matches requirements**

---

## 2. Flutter UI Status ✅

### 2.1 Dining Booking Screen (`dining_booking_screen.dart`)

**Status**: ✅ **UI is complete**

**Data Collected:**
- ✅ `_selectedDate`: DateTime (single date)
- ✅ `_selectedTimeSlot`: String (e.g., "12:00 PM")
- ✅ `_guestCount`: int (1-20)
- ✅ `_fullName`: String
- ✅ `_contactNumber`: String
- ✅ `_email`: String
- ✅ `_specialRequests`: String
- ✅ `_couponCode`: String (mock implementation)

**Issues to Address:**
1. ⚠️ Time format conversion needed: "12:00 PM" → "19:00" (24-hour format)
2. ⚠️ Contact info needs to be mapped to `guests[]` array
3. ⚠️ No API integration yet (mock data)
4. ⚠️ Coupon validation is mocked (needs backend endpoint)

**Navigation:**
- ✅ Navigates to `/dining-booking-confirmation` with booking data

### 2.2 Accommodation Booking Screen (`accommodation_booking_screen.dart`)

**Status**: ✅ **UI is complete**

**Data Collected:**
- ✅ `_checkInDate`: DateTime
- ✅ `_checkOutDate`: DateTime
- ✅ `_guestCount`: int (1-10)
- ✅ `_roomCount`: int (1-5)
- ✅ `selectedRooms`: Map<String, Map<String, dynamic>> (pre-selected)
- ✅ `_specialRequests`: String
- ✅ `_couponCode`: String (mock implementation)

**Issues to Address:**
1. ⚠️ `roomTypeId` extraction from `selectedRooms` needed
2. ⚠️ No API integration yet (mock data)
3. ⚠️ Price calculation is mocked
4. ⚠️ Coupon validation is mocked (needs backend endpoint)
5. ⚠️ Special requests field exists but not captured in state

**Navigation:**
- ✅ Navigates to `/booking-confirmation/:id` (hardcoded ID currently)

---

## 3. Flutter Model Status ⚠️

### 3.1 Current Booking Model

**Location**: `apps/public-mobile/lib/core/models/booking.dart`

**Issues:**
1. ❌ Only supports hotel bookings (has `checkInDate`, `checkOutDate`)
2. ❌ Missing restaurant fields (`bookingDate`, `bookingTime`, `partySize`, `tableId`)
3. ❌ `BookingGuest` uses `firstName`/`lastName` but backend uses `fullName`
4. ❌ Missing `roomTypeId`, `roomId` for hotel bookings
5. ❌ Missing `adults` and `children` fields
6. ❌ Missing `bookingNumber` field

**Status**: ⚠️ **Model needs update to match backend schema**

---

## 4. Missing Service ⚠️

### 4.1 BookingsService

**Status**: ❌ **Does not exist**

**Required Methods:**
1. `getBookings({page, limit, status, type})` - Get user bookings
2. `getUpcomingBookings({limit})` - Get upcoming bookings
3. `getBooking(String id)` - Get booking details
4. `createHotelBooking({...})` - Create hotel booking
5. `createRestaurantBooking({...})` - Create restaurant booking
6. `updateBooking(String id, {...})` - Update booking
7. `cancelBooking(String id, {reason})` - Cancel booking
8. `confirmPayment(String id, {paymentMethod, paymentReference})` - Confirm payment

**Status**: ⚠️ **Service needs to be created**

---

## 5. Data Mapping Requirements

### 5.1 Dining Booking → API Request

**UI Data:**
```dart
_selectedDate: DateTime(2025, 12, 1)
_selectedTimeSlot: "12:00 PM"
_guestCount: 4
_fullName: "John Doe"
_contactNumber: "+250788123456"
_email: "john@example.com"
_specialRequests: "Window seat preferred"
```

**Required API Request:**
```json
{
  "bookingType": "restaurant",
  "listingId": "uuid-here",
  "bookingDate": "2025-12-01",
  "bookingTime": "12:00",  // Convert from "12:00 PM"
  "partySize": 4,
  "guestCount": 4,
  "specialRequests": "Window seat preferred",
  "guests": [
    {
      "fullName": "John Doe",
      "phone": "+250788123456",
      "email": "john@example.com",
      "isPrimary": true
    }
  ]
}
```

**Conversion Needed:**
- ✅ Date: `DateTime` → ISO string (`"2025-12-01"`)
- ⚠️ Time: `"12:00 PM"` → `"12:00"` (24-hour format)
- ✅ Contact info → `guests[]` array with `isPrimary: true`

### 5.2 Accommodation Booking → API Request

**UI Data:**
```dart
_checkInDate: DateTime(2025, 12, 1)
_checkOutDate: DateTime(2025, 12, 5)
_guestCount: 2
_roomCount: 1
selectedRooms: {
  "room-uuid": {
    "roomType": {...},
    "quantity": 1
  }
}
_specialRequests: "Late checkout"
```

**Required API Request:**
```json
{
  "bookingType": "hotel",
  "listingId": "uuid-here",
  "roomTypeId": "uuid-from-selectedRooms",
  "checkInDate": "2025-12-01",
  "checkOutDate": "2025-12-05",
  "guestCount": 2,
  "adults": 2,
  "children": 0,
  "specialRequests": "Late checkout",
  "guests": [
    {
      "fullName": "User Full Name",
      "email": "user@example.com",
      "phone": "+250788000000",
      "isPrimary": true
    }
  ]
}
```

**Conversion Needed:**
- ✅ Dates: `DateTime` → ISO strings
- ⚠️ Extract `roomTypeId` from `selectedRooms` map
- ⚠️ Get user info from logged-in user (not collected in UI)
- ⚠️ Calculate `adults` and `children` (currently only `guestCount`)

---

## 6. Implementation Checklist

### Phase 1: Service & Model Setup ✅
- [ ] Create `BookingsService` class
- [ ] Update `Booking` model to support both types
- [ ] Update `BookingGuest` model (use `fullName` instead of `firstName`/`lastName`)
- [ ] Add missing fields (`bookingNumber`, `adults`, `children`, `roomTypeId`, etc.)

### Phase 2: Dining Booking Integration
- [ ] Create `createRestaurantBooking` method
- [ ] Add time format conversion helper ("12:00 PM" → "12:00")
- [ ] Map contact info to `guests[]` array
- [ ] Integrate API call in `_confirmBooking` method
- [ ] Handle API errors and validation
- [ ] Update navigation to use real booking ID

### Phase 3: Accommodation Booking Integration
- [ ] Create `createHotelBooking` method
- [ ] Extract `roomTypeId` from `selectedRooms`
- [ ] Get user info from `UserService` or `TokenStorageService`
- [ ] Calculate `adults` and `children` (or default to `adults = guestCount`)
- [ ] Integrate API call in `_buildBottomBar` onPressed
- [ ] Handle API errors and validation
- [ ] Update navigation to use real booking ID

### Phase 4: Additional Features
- [ ] Implement coupon validation API call (if endpoint exists)
- [ ] Add booking list screen integration
- [ ] Add booking cancellation
- [ ] Add payment confirmation
- [ ] Add error handling and user feedback

---

## 7. Key Differences Summary

| Aspect | Dining (OpenTable-style) | Stay (Booking.com-style) |
|--------|--------------------------|--------------------------|
| **Date** | Single `bookingDate` | Range `checkInDate` + `checkOutDate` |
| **Time** | ✅ Required (`bookingTime`) | ❌ Not used |
| **Resource** | Table (optional `tableId`) | Room (`roomTypeId` required) |
| **Contact Info** | ✅ Collected in UI | ❌ Uses logged-in user |
| **Guest Count** | `partySize` (1-20) | `guestCount` (1-10) |
| **Price** | Per person × guests | Room price × rooms × nights |

---

## 8. Recommendations

### 8.1 Immediate Actions

1. **Create BookingsService** with type-specific create methods
2. **Update Booking model** to match backend schema exactly
3. **Add time conversion helper** for restaurant bookings
4. **Integrate API calls** in both booking screens
5. **Add proper error handling** for validation and conflicts

### 8.2 Nice-to-Have

1. **Coupon validation API** (if not exists, create endpoint)
2. **Availability checking** before booking (prevent conflicts)
3. **Real-time price calculation** from backend
4. **Room availability** checking for hotels
5. **Time slot availability** checking for restaurants

---

## 9. Conclusion

**Status**: ✅ **READY TO IMPLEMENT**

**What's Ready:**
- ✅ Backend API endpoints
- ✅ Backend DTO structure
- ✅ Flutter UI screens
- ✅ Navigation flows

**What's Needed:**
- ⚠️ Create `BookingsService`
- ⚠️ Update `Booking` model
- ⚠️ Integrate API calls
- ⚠️ Handle data conversions
- ⚠️ Add error handling

**Estimated Implementation Time**: 2-3 hours for full integration

**Risk Level**: 🟢 **Low** - All components exist, just need wiring together

---

## 10. Next Steps

1. Create `BookingsService` with all required methods
2. Update `Booking` model to support both types
3. Integrate dining booking screen with API
4. Integrate accommodation booking screen with API
5. Test both flows end-to-end
6. Add error handling and user feedback

