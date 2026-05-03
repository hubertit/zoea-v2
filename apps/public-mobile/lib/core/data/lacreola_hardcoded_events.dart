import '../models/event.dart';

/// Temporary: La Creola weekly lineup until it is served from the API.
/// Posters under `assets/images/lacreola/` (from Desktop `lacreola1.jpeg`–`lacreola4.jpeg`).
const bool kIncludeLaCreolaHardcodedEvents = true;

const String _kLaCreolaLocation = 'KG 28 Ave, Kimihurura, Kigali';
const String _kReservation =
    '+250793084995 / reservation@lacreola.com';

DateTime _nextWeeklySlotMonday1Sunday7({
  required int weekday,
  required int hour,
  required int minute,
}) {
  final now = DateTime.now();
  var d = DateTime(now.year, now.month, now.day, hour, minute);
  var add = weekday - d.weekday;
  if (add < 0) add += 7;
  d = d.add(Duration(days: add));
  if (d.isBefore(now)) {
    d = d.add(const Duration(days: 7));
  }
  return d;
}

String _bulletList(List<String> items) =>
    items.map((e) => '• $e').join('\n');

String _laCreolaDescription({
  required String days,
  required String scheduleTime,
  String? priceLines,
  required List<String> offers,
  String? entertainmentLine,
}) {
  final sb = StringBuffer()
    ..writeln('Weekly at La Creola.')
    ..writeln()
    ..writeln('Schedule: $days')
    ..writeln('Time: $scheduleTime');
  if (priceLines != null && priceLines.trim().isNotEmpty) {
    sb.writeln('Price / packages:');
    sb.writeln(priceLines.trim());
    sb.writeln();
  }
  if (offers.isNotEmpty) {
    sb.writeln('Offers:\n${_bulletList(offers)}\n');
  }
  if (entertainmentLine != null && entertainmentLine.trim().isNotEmpty) {
    sb.writeln(entertainmentLine.trim());
    sb.writeln();
  }
  sb.writeln('Reservations & info: $_kReservation');
  return sb.toString().trim();
}

List<Event> laCreolaHardcodedEvents({DateTime? clock}) {
  if (!kIncludeLaCreolaHardcodedEvents) return const [];

  final now = clock ?? DateTime.now();
  EventContext laCreolaCtx() => EventContext(
        id: 1,
        name: 'La Creola',
        description: '',
        createdAt: now,
        updatedAt: now,
      );

  EventOwner laCreolaOwner() => EventOwner(
        id: -91,
        username: 'lacreola',
        name: 'La Creola',
        email: 'reservation@lacreola.com',
        imageUrl: '',
        bgUrl: null,
        isPrivate: false,
        accountType: 'business',
        isActive: true,
        createdAt: now,
        maxDistance: 0,
        bio: null,
        isVerified: true,
        organizerProfileVerified: true,
        isCallerSubscribedToUser: false,
        isUserSubscribedToCaller: false,
      );

  const emptyLoc =
      EventLocation(type: 'Point', coordinates: <double>[]);

  EventTicket ticket({
    required int id,
    required int price,
    required String name,
    DateTime? t,
  }) =>
      EventTicket(
        id: id,
        price: price,
        name: name,
        disabled: false,
        type: 'standard',
        orderType: 'buy',
        currency: 'RWF',
        createdAt: t ?? now,
        updatedAt: t ?? now,
        description: null,
      );

  Event wrap({
    required int id,
    required String slug,
    required String name,
    required String flyerAsset,
    required String description,
    required DateTime start,
    required DateTime end,
    List<EventTicket> tickets = const [],
  }) =>
      Event(
        id: id,
        eventId: id,
        userId: -91,
        creatorId: -91,
        isBlocked: false,
        slug: slug,
        organizerProfileId: -91,
        type: 'event',
        createdAt: now,
        updatedAt: now,
        commentCount: '0',
        likeCount: '0',
        sincCount: '0',
        hasLiked: false,
        event: EventDetails(
          id: id,
          userId: -91,
          name: name,
          description: description,
          organizerProfileId: -91,
          flyer: flyerAsset,
          imageId: 0,
          fileId: 0,
          location: emptyLoc,
          locationName: _kLaCreolaLocation,
          isAcceptable: true,
          eventContextId: 1,
          maxAttendance: 200,
          attending: 0,
          startDate: start,
          endDate: end,
          createdAt: now,
          updatedAt: now,
          setup: 'indoor',
          privacy: 'public',
          postId: 0,
          ongoing: true,
          tickets: tickets,
          attachments: const [],
          eventContext: laCreolaCtx(),
        ),
        owner: laCreolaOwner(),
      );

  final friStart = _nextWeeklySlotMonday1Sunday7(
    weekday: DateTime.friday,
    hour: 17,
    minute: 0,
  );
  final friEnd =
      DateTime(friStart.year, friStart.month, friStart.day, 23, 0);

  final sunStart = _nextWeeklySlotMonday1Sunday7(
    weekday: DateTime.sunday,
    hour: 11,
    minute: 0,
  );
  final sunEnd =
      DateTime(sunStart.year, sunStart.month, sunStart.day, 15, 0);

  final thStart = _nextWeeklySlotMonday1Sunday7(
    weekday: DateTime.thursday,
    hour: 17,
    minute: 0,
  );
  final thEnd =
      DateTime(thStart.year, thStart.month, thStart.day, 23, 59);

  final tuStart = _nextWeeklySlotMonday1Sunday7(
    weekday: DateTime.tuesday,
    hour: 17,
    minute: 0,
  );
  final tuEnd =
      DateTime(tuStart.year, tuStart.month, tuStart.day, 23, 59);

  return [
    wrap(
      id: -91001,
      slug: 'lacreola-friday-barbecue',
      name: 'Friday Barbecue',
      flyerAsset: 'assets/images/lacreola/lacreola1.jpeg',
      description: _laCreolaDescription(
        days: 'Every Friday',
        scheduleTime: '5 PM — late',
        priceLines: '40K per person',
        offers: [
          '20% off all bottles',
          '15% off all cocktails',
        ],
        entertainmentLine:
            'Entertainment: live music by Mellow Band',
      ),
      start: friStart,
      end: friEnd,
      tickets: [
        ticket(id: 1, price: 40000, name: 'General', t: friStart),
      ],
    ),
    wrap(
      id: -91002,
      slug: 'lacreola-sunday-brunch',
      name: 'Sunday Brunch',
      flyerAsset: 'assets/images/lacreola/lacreola2.jpeg',
      description: _laCreolaDescription(
        days: 'Every Sunday',
        scheduleTime: '11 AM — 3 PM',
        priceLines:
            'Non-Alcoholic Brunch 35K\nAlcoholic Brunch 70K',
        offers: [
          'One sparkling wine bottle included (brunch)',
          '50% off second sparkling wine',
        ],
        entertainmentLine: 'Entertainment: DJ Nekki',
      ),
      start: sunStart,
      end: sunEnd,
      tickets: [
        ticket(id: 1, price: 35000, name: 'Non-Alcoholic Brunch'),
        ticket(id: 2, price: 70000, name: 'Alcoholic Brunch'),
      ],
    ),
    wrap(
      id: -91003,
      slug: 'lacreola-thirsty-thursday',
      name: 'Thirsty Thursday',
      flyerAsset: 'assets/images/lacreola/lacreola3.jpeg',
      description: _laCreolaDescription(
        days: 'Every Thursday',
        scheduleTime: '17:00 till closing',
        priceLines: null,
        offers: [
          '20% off all bottles',
          '15% off all cocktails',
        ],
        entertainmentLine: null,
      ),
      start: thStart,
      end: thEnd,
      tickets: const [],
    ),
    wrap(
      id: -91004,
      slug: 'lacreola-midweek-affairs',
      name: 'Midweek Affairs',
      flyerAsset: 'assets/images/lacreola/lacreola4.jpeg',
      description: _laCreolaDescription(
        days: 'Every Tuesday & Wednesday',
        scheduleTime: '17:00 till closing',
        priceLines: null,
        offers: [
          'Buy 2 Get 1 Free on all bottles',
          '20% off all bottles',
          '15% off all cocktails',
        ],
        entertainmentLine: null,
      ),
      start: tuStart,
      end: tuEnd,
      tickets: const [],
    ),
  ];
}

List<Event> filterLaCreolaEventsForSearch(
  List<Event> laCreola,
  String query,
) {
  if (!kIncludeLaCreolaHardcodedEvents) return const [];
  final t = query.trim().toLowerCase();
  if (t.isEmpty) return laCreola;
  return laCreola.where((e) {
    final d = e.event;
    final blob =
        '${d.name} ${d.locationName} ${d.description}'.toLowerCase();
    return blob.contains(t);
  }).toList();
}

/// Resolves a La Creola demo event when opening `/event/:id` without navigation [extra].
Event? lookupLaCreolaHardcodedEventById(int id) {
  if (!kIncludeLaCreolaHardcodedEvents) return null;
  for (final e in laCreolaHardcodedEvents()) {
    if (e.id == id) return e;
  }
  return null;
}
