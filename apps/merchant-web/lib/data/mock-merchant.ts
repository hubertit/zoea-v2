import type { Booking, Business, Listing } from "@/lib/types/merchant";

function iso(d: Date): string {
  return d.toISOString();
}

function daysFromNow(n: number): Date {
  const d = new Date();
  d.setDate(d.getDate() + n);
  return d;
}

function hoursAgo(n: number): Date {
  const d = new Date();
  d.setHours(d.getHours() - n);
  return d;
}

/** Same seed as `merchant-mobile` businesses_screen `_getMockBusinesses` (dates relative). */
export function getSeedBusinesses(): Business[] {
  const now = new Date();
  return [
    {
      id: "b1",
      ownerId: "1",
      name: "Urban Park LTD",
      description: "Merchant company account for managing properties and inventory.",
      category: "other",
      logo: "https://urbanparksuites.com/wp-content/uploads/2022/06/Urban-Park-Suites-Logo.png",
      coverImage: "/urban-park-cover.jpg",
      location: {
        latitude: -1.9494,
        longitude: 30.0588,
        address: "32 KG 218 Street Urban Park",
        city: "Kigali",
        country: "Rwanda",
        district: "Nyarugenge",
      },
      contact: { phone: "+250791430082", email: "info@urbanparksuites.com" },
      isVerified: true,
      isActive: true,
      createdAt: iso(new Date(now.getTime() - 30 * 86400000)),
      updatedAt: iso(now),
      listingsCount: 1,
      rating: 4.7,
      reviewCount: 54,
    },
  ];
}

/** Same seed as `merchant-mobile` listings_screen `_getMockListings`. */
export function getSeedListings(): Listing[] {
  const now = new Date();
  return [
    {
      id: "lp1",
      businessId: "b1",
      name: "Urban Park Suites Hotel",
      description:
        "Hotel listing for Urban Park Suites in Kigali. Manage rooms, gallery, and reviews from the merchant portal.",
      type: "package",
      images: [
        "/urban-park-cover.jpg",
        "https://cf.bstatic.com/xdata/images/hotel/max500/406751666.jpg?k=741bead80c2deb128ea4d08954cbe2e50cf008ec0cdc19f1ee9c36f128bbaf5c&o=",
        "https://cf.bstatic.com/xdata/images/hotel/max500/406753800.jpg?k=3ac866243ab9485bb41d5f327e63c6cdcc5741b91541a51b81d3cfa47ba238b0&o=",
      ],
      priceRange: { minPrice: 150, maxPrice: 250, currency: "USD", unit: "perNight" },
      amenities: ["Outdoor Pool", "Free WiFi", "Free Parking", "Airport Shuttle", "Fitness Center", "Spa", "Restaurant", "Bar"],
      tags: ["Kigali", "Hotel", "Suites"],
      isActive: true,
      isFeatured: true,
      rating: 4.7,
      reviewCount: 54,
      bookingsCount: 0,
      createdAt: iso(new Date(now.getTime() - 40 * 86400000)),
      updatedAt: iso(now),
    },
    {
      id: "l1",
      businessId: "b1",
      name: "Deluxe Room",
      description:
        "Contemporary room with a king bed, sofa, and views of Kigali. Includes complimentary WiFi, HDTV, work desk, and rain shower.",
      type: "room",
      images: [
        "https://cf.bstatic.com/xdata/images/hotel/max300/582461762.jpg?k=22ad1e84c410fafd5d673782f402bf4118c902654f493ca082c6a4344fa7796a&o=",
        "https://cf.bstatic.com/xdata/images/hotel/max300/582461673.jpg?k=6af8c2b08fc6dbeadfaec55e4b39015d57652390a4f1cf39f64940b5f3dc875c&o=",
        "https://cf.bstatic.com/xdata/images/hotel/max300/406752773.jpg?k=75d1694378bbb1b05a23667cc26a80fe1f3487aa0310dc5fc8c64fe15d6131cf&o=",
      ],
      priceRange: { minPrice: 150, maxPrice: 150, currency: "USD", unit: "perNight" },
      amenities: ["WiFi", "AC", "TV", "Mini Bar", "Room Service", "Private Safe", "Tea/Coffee"],
      tags: [],
      isActive: true,
      isFeatured: false,
      rating: 4.8,
      reviewCount: 45,
      bookingsCount: 128,
      createdAt: iso(new Date(now.getTime() - 30 * 86400000)),
      updatedAt: iso(now),
      roomDetails: {
        roomType: "deluxe",
        capacity: 2,
        bedCount: 1,
        bedType: "king",
        size: 30,
        hasBalcony: true,
        hasView: true,
        totalRooms: 10,
        availableRooms: 6,
      },
    },
    {
      id: "l2",
      businessId: "b1",
      name: "Junior Suite",
      description: "Suite-style room with extra space and a cozy living area. Ideal for business travelers.",
      type: "room",
      images: [
        "https://cf.bstatic.com/xdata/images/hotel/max500/406753800.jpg?k=3ac866243ab9485bb41d5f327e63c6cdcc5741b91541a51b81d3cfa47ba238b0&o=",
        "https://cf.bstatic.com/xdata/images/hotel/max500/406751666.jpg?k=741bead80c2deb128ea4d08954cbe2e50cf008ec0cdc19f1ee9c36f128bbaf5c&o=",
      ],
      priceRange: { minPrice: 170, maxPrice: 170, currency: "USD", unit: "perNight" },
      amenities: ["WiFi", "AC", "TV", "Mini Bar", "Room Service", "Private Safe", "Laundry"],
      tags: [],
      isActive: true,
      isFeatured: false,
      rating: 4.5,
      reviewCount: 67,
      bookingsCount: 234,
      createdAt: iso(new Date(now.getTime() - 25 * 86400000)),
      updatedAt: iso(now),
      roomDetails: {
        roomType: "suite",
        capacity: 2,
        bedCount: 1,
        bedType: "double",
        size: 48,
        hasBalcony: false,
        hasView: false,
        totalRooms: 6,
        availableRooms: 3,
      },
    },
    {
      id: "l3",
      businessId: "b1",
      name: "Family Suite",
      description: "Ideal for families. Two bedrooms and a comfortable living room setup.",
      type: "room",
      images: [
        "https://cf.bstatic.com/xdata/images/hotel/max300/406751477.jpg?k=557f5489ccf92a7138c11239456240dc3957cda72b30fcb150cdb9443b3e7086&o=",
      ],
      priceRange: { minPrice: 220, maxPrice: 220, currency: "USD", unit: "perNight" },
      amenities: ["WiFi", "AC", "TV", "Mini Bar", "Room Service", "Tea/Coffee"],
      tags: [],
      isActive: true,
      isFeatured: false,
      rating: 4.6,
      reviewCount: 23,
      bookingsCount: 89,
      createdAt: iso(new Date(now.getTime() - 15 * 86400000)),
      updatedAt: iso(now),
      roomDetails: {
        roomType: "family",
        capacity: 4,
        bedCount: 2,
        bedType: "double",
        size: 60,
        hasBalcony: true,
        hasView: true,
        totalRooms: 4,
        availableRooms: 2,
      },
    },
    {
      id: "l4",
      businessId: "b1",
      name: "Urban Suite",
      description: "Spacious suite with a living room and classic Rwandan interior touches.",
      type: "room",
      images: [
        "https://cf.bstatic.com/xdata/images/hotel/max500/406755562.jpg?k=39b0ba0b95155ec075fdc947ba7a3198b9101b07134cadbc1811aa4e246b74ac&o=",
      ],
      priceRange: { minPrice: 250, maxPrice: 250, currency: "USD", unit: "perNight" },
      amenities: ["WiFi", "AC", "TV", "Mini Bar", "Room Service", "Private Safe", "Laundry", "Tea/Coffee"],
      tags: [],
      isActive: true,
      isFeatured: false,
      rating: 4.7,
      reviewCount: 31,
      bookingsCount: 74,
      createdAt: iso(new Date(now.getTime() - 60 * 86400000)),
      updatedAt: iso(now),
      roomDetails: {
        roomType: "suite",
        capacity: 3,
        bedCount: 2,
        bedType: "queen",
        size: 55,
        hasBalcony: true,
        hasView: true,
        totalRooms: 3,
        availableRooms: 1,
      },
    },
  ];
}

/** Same seed as `merchant-mobile` bookings_screen `_getMockBookings`. */
export function getSeedBookings(): Booking[] {
  const now = new Date();
  return [
    {
      id: "1",
      listingId: "l1",
      businessId: "b1",
      customerId: "c1",
      customerName: "John Doe",
      customerEmail: "john@email.com",
      customerPhone: "+250788123456",
      type: "accommodation",
      status: "pending",
      totalAmount: 300,
      currency: "USD",
      paymentMethod: "momo",
      paymentStatus: "paid",
      createdAt: iso(hoursAgo(2)),
      updatedAt: iso(now),
      listingName: "Deluxe Room",
      businessName: "Urban Park Suites Hotel",
      specialRequests: "Late check-in around 10 PM",
      accommodationDetails: {
        checkInDate: iso(daysFromNow(1)),
        checkOutDate: iso(daysFromNow(3)),
        nights: 2,
        roomCount: 1,
        guestCount: 2,
        roomType: "Deluxe Room",
        guests: [],
      },
    },
    {
      id: "2",
      listingId: "l2",
      businessId: "b1",
      customerId: "c2",
      customerName: "Jane Smith",
      customerEmail: "jane@email.com",
      type: "accommodation",
      status: "confirmed",
      totalAmount: 170,
      currency: "USD",
      paymentMethod: "cash",
      paymentStatus: "paid",
      createdAt: iso(hoursAgo(5)),
      updatedAt: iso(now),
      listingName: "Junior Suite",
      businessName: "Urban Park Suites Hotel",
      accommodationDetails: {
        checkInDate: iso(daysFromNow(2)),
        checkOutDate: iso(daysFromNow(4)),
        nights: 2,
        roomCount: 1,
        guestCount: 2,
        roomType: "Junior Suite",
        guests: [],
      },
    },
    {
      id: "3",
      listingId: "l3",
      businessId: "b1",
      customerId: "c3",
      customerName: "Mike Johnson",
      customerEmail: "mike@email.com",
      customerPhone: "+1234567890",
      type: "accommodation",
      status: "confirmed",
      totalAmount: 220,
      currency: "USD",
      paymentMethod: "card",
      paymentStatus: "paid",
      createdAt: iso(new Date(now.getTime() - 3 * 86400000)),
      updatedAt: iso(now),
      listingName: "Family Suite",
      businessName: "Urban Park Suites Hotel",
      accommodationDetails: {
        checkInDate: iso(daysFromNow(7)),
        checkOutDate: iso(daysFromNow(10)),
        nights: 3,
        roomCount: 1,
        guestCount: 3,
        roomType: "Family Suite",
        guests: [],
      },
    },
  ];
}
