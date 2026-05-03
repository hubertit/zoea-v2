import type { Event } from '@/lib/api/events';

/** Temporary local lineup — set false to hide. Posters under `/public/events/lacreola/`. */
export const INCLUDE_LACREOLA_EVENTS = true;

const LOCATION = 'KG 28 Ave, Kimihurura, Kigali';
const RESERVATION = '+250793084995 / reservation@lacreola.com';

const FRI = 5;
const SUN = 0;
const THU = 4;
const TUE = 2;

/** Next occurrence of weekday (JS getDay semantics: Sun = 0). */
function nextWeeklySlotJs(weekday: number, hour: number, minute: number): Date {
  const now = new Date();
  const d = new Date(
    now.getFullYear(),
    now.getMonth(),
    now.getDate(),
    hour,
    minute,
    0,
    0,
  );
  let add = weekday - d.getDay();
  if (add < 0) add += 7;
  d.setDate(d.getDate() + add);
  if (d.getTime() < now.getTime()) {
    d.setDate(d.getDate() + 7);
  }
  return d;
}

function bullets(items: string[]) {
  return items.map((e) => `• ${e}`).join('\n');
}

function laCreolaDescription(opts: {
  days: string;
  scheduleTime: string;
  priceLines?: string | null;
  offers: string[];
  entertainmentLine?: string | null;
}) {
  let s = `Weekly at La Creola.\n\nSchedule: ${opts.days}\nTime: ${opts.scheduleTime}`;
  if (opts.priceLines?.trim()) {
    s += `\nPrice / packages:\n${opts.priceLines.trim()}\n`;
  }
  if (opts.offers.length > 0) {
    s += `\nOffers:\n${bullets(opts.offers)}\n`;
  }
  if (opts.entertainmentLine?.trim()) {
    s += `\n${opts.entertainmentLine.trim()}\n`;
  }
  s += `\nReservations & info: ${RESERVATION}`;
  return s.trim();
}

function mkTicket(
  id: number,
  price: number,
  name: string,
  at: Date,
): NonNullable<Event['event']['tickets'][number]> {
  const iso = at.toISOString();
  return {
    id,
    price,
    name,
    disabled: false,
    type: 'standard',
    orderType: 'buy',
    currency: 'RWF',
    createdAt: iso,
    updatedAt: iso,
    description: undefined,
  };
}

function wrapEvent(now: Date, spec: Omit<Event, 'createdAt' | 'updatedAt'>): Event {
  const iso = now.toISOString();
  return {
    ...spec,
    createdAt: iso,
    updatedAt: iso,
  };
}

export function buildLaCreolaEvents(clock?: Date): Event[] {
  if (!INCLUDE_LACREOLA_EVENTS) return [];
  const now = clock ?? new Date();

  const laCreolaOwner: Event['owner'] = {
    id: -91,
    username: 'lacreola',
    name: 'La Creola',
    email: 'reservation@lacreola.com',
    imageUrl: '',
    bgUrl: undefined,
    isPrivate: false,
    accountType: 'business',
    isActive: true,
    createdAt: now.toISOString(),
    maxDistance: 0,
    bio: undefined,
    isVerified: true,
    organizerProfileVerified: true,
    isCallerSubscribedToUser: false,
    isUserSubscribedToCaller: false,
  };

  const ctx = {
    id: 1,
    name: 'La Creola',
    description: '',
  };

  const friStart = nextWeeklySlotJs(FRI, 17, 0);
  const friEnd = new Date(friStart);
  friEnd.setHours(23, 0, 0, 0);

  const sunStart = nextWeeklySlotJs(SUN, 11, 0);
  const sunEnd = new Date(sunStart);
  sunEnd.setHours(15, 0, 0, 0);

  const thStart = nextWeeklySlotJs(THU, 17, 0);
  const thEnd = new Date(thStart);
  thEnd.setHours(23, 59, 59, 0);

  const tuStart = nextWeeklySlotJs(TUE, 17, 0);
  const tuEnd = new Date(tuStart);
  tuEnd.setHours(23, 59, 59, 0);

  const baseDetails = (
    id: number,
    name: string,
    flyerPath: string,
    description: string,
    start: Date,
    end: Date,
    tickets: Event['event']['tickets'],
  ): Event['event'] => ({
    id,
    userId: -91,
    name,
    description,
    organizerProfileId: -91,
    flyer: flyerPath,
    imageId: 0,
    fileId: 0,
    location: { type: 'Point', coordinates: [] },
    locationName: LOCATION,
    isAcceptable: true,
    eventContextId: 1,
    maxAttendance: 200,
    attending: 0,
    startDate: start.toISOString(),
    endDate: end.toISOString(),
    createdAt: now.toISOString(),
    updatedAt: now.toISOString(),
    setup: 'indoor',
    privacy: 'public',
    postId: 0,
    ongoing: true,
    tickets,
    attachments: [],
    eventContext: ctx,
  });

  return [
    wrapEvent(now, {
      id: -91001,
      eventId: -91001,
      userId: -91,
      creatorId: -91,
      isBlocked: false,
      slug: 'lacreola-friday-barbecue',
      organizerProfileId: -91,
      type: 'event',
      commentCount: '0',
      likeCount: '0',
      sincCount: '0',
      hasLiked: false,
      event: baseDetails(
        -91001,
        'Friday Barbecue',
        '/events/lacreola/lacreola1.jpeg',
        laCreolaDescription({
          days: 'Every Friday',
          scheduleTime: '5 PM — late',
          priceLines: '40K per person',
          offers: ['20% off all bottles', '15% off all cocktails'],
          entertainmentLine:
            'Entertainment: live music by Mellow Band',
        }),
        friStart,
        friEnd,
        [mkTicket(1, 40000, 'General', friStart)],
      ),
      owner: laCreolaOwner,
    }),
    wrapEvent(now, {
      id: -91002,
      eventId: -91002,
      userId: -91,
      creatorId: -91,
      isBlocked: false,
      slug: 'lacreola-sunday-brunch',
      organizerProfileId: -91,
      type: 'event',
      commentCount: '0',
      likeCount: '0',
      sincCount: '0',
      hasLiked: false,
      event: baseDetails(
        -91002,
        'Sunday Brunch',
        '/events/lacreola/lacreola2.jpeg',
        laCreolaDescription({
          days: 'Every Sunday',
          scheduleTime: '11 AM — 3 PM',
          priceLines: 'Non-Alcoholic Brunch 35K\nAlcoholic Brunch 70K',
          offers: [
            'One sparkling wine bottle included (brunch)',
            '50% off second sparkling wine',
          ],
          entertainmentLine: 'Entertainment: DJ Nekki',
        }),
        sunStart,
        sunEnd,
        [
          mkTicket(1, 35000, 'Non-Alcoholic Brunch', sunStart),
          mkTicket(2, 70000, 'Alcoholic Brunch', sunStart),
        ],
      ),
      owner: laCreolaOwner,
    }),
    wrapEvent(now, {
      id: -91003,
      eventId: -91003,
      userId: -91,
      creatorId: -91,
      isBlocked: false,
      slug: 'lacreola-thirsty-thursday',
      organizerProfileId: -91,
      type: 'event',
      commentCount: '0',
      likeCount: '0',
      sincCount: '0',
      hasLiked: false,
      event: baseDetails(
        -91003,
        'Thirsty Thursday',
        '/events/lacreola/lacreola3.jpeg',
        laCreolaDescription({
          days: 'Every Thursday',
          scheduleTime: '17:00 till closing',
          priceLines: null,
          offers: ['20% off all bottles', '15% off all cocktails'],
          entertainmentLine: null,
        }),
        thStart,
        thEnd,
        [],
      ),
      owner: laCreolaOwner,
    }),
    wrapEvent(now, {
      id: -91004,
      eventId: -91004,
      userId: -91,
      creatorId: -91,
      isBlocked: false,
      slug: 'lacreola-midweek-affairs',
      organizerProfileId: -91,
      type: 'event',
      commentCount: '0',
      likeCount: '0',
      sincCount: '0',
      hasLiked: false,
      event: baseDetails(
        -91004,
        'Midweek Affairs',
        '/events/lacreola/lacreola4.jpeg',
        laCreolaDescription({
          days: 'Every Tuesday & Wednesday',
          scheduleTime: '17:00 till closing',
          priceLines: null,
          offers: [
            'Buy 2 Get 1 Free on all bottles',
            '20% off all bottles',
            '15% off all cocktails',
          ],
          entertainmentLine: null,
        }),
        tuStart,
        tuEnd,
        [],
      ),
      owner: laCreolaOwner,
    }),
  ];
}

export function findLaCreolaEvent(id: number): Event | undefined {
  if (!INCLUDE_LACREOLA_EVENTS) return undefined;
  return buildLaCreolaEvents().find((e) => e.id === id);
}

export function filterLaCreolaForSearch(
  lacreola: Event[],
  query: string,
): Event[] {
  if (!INCLUDE_LACREOLA_EVENTS) return [];
  const t = query.trim().toLowerCase();
  if (t === '') return lacreola;
  return lacreola.filter((e) => {
    const blob = `${e.event.name} ${e.event.locationName} ${e.event.description}`.toLowerCase();
    return blob.includes(t);
  });
}
