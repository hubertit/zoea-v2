import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

function slugify(name: string): string {
  return name
    .toLowerCase()
    .trim()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '');
}

async function main() {
  const rwanda = await prisma.country.findFirst({
    where: {
      OR: [
        { code: 'RW' as any },
        { code2: 'RW' as any },
        { name: { equals: 'Rwanda', mode: 'insensitive' } },
      ],
    },
    select: { id: true, name: true, code: true, code2: true },
  });

  if (!rwanda) {
    throw new Error('Rwanda country not found');
  }

  console.log(`Country found: ${rwanda.name} (${rwanda.id})`);

  const renameMap: Array<{ oldName: string; newName: string }> = [
    { oldName: 'Gisenyi', newName: 'Rubavu' },
    { oldName: 'Ruhengeri', newName: 'Musanze' },
    { oldName: 'Butare', newName: 'Huye' },
  ];

  for (const { oldName, newName } of renameMap) {
    const oldRow = await prisma.city.findFirst({
      where: {
        countryId: rwanda.id,
        name: { equals: oldName, mode: 'insensitive' },
      },
      select: { id: true, name: true, slug: true },
    });

    if (!oldRow) {
      console.log(`SKIP rename: "${oldName}" not found`);
      continue;
    }

    const newExists = await prisma.city.findFirst({
      where: {
        countryId: rwanda.id,
        name: { equals: newName, mode: 'insensitive' },
        NOT: { id: oldRow.id },
      },
      select: { id: true, name: true },
    });

    if (newExists) {
      console.log(
        `SKIP rename: "${oldName}" -> "${newName}" because "${newExists.name}" already exists (${newExists.id})`,
      );
      continue;
    }

    await prisma.city.update({
      where: { id: oldRow.id },
      data: {
        name: newName,
        slug: slugify(newName),
      },
    });
    console.log(`OK rename: "${oldName}" -> "${newName}"`);
  }

  const karongi = await prisma.city.findFirst({
    where: {
      countryId: rwanda.id,
      OR: [
        { name: { equals: 'Karongi', mode: 'insensitive' } },
        { slug: 'karongi' },
      ],
    },
    select: { id: true, name: true, slug: true },
  });

  if (karongi) {
    console.log(`SKIP create: Karongi already exists (${karongi.id})`);
  } else {
    const created = await prisma.city.create({
      data: {
        countryId: rwanda.id,
        name: 'Karongi',
        slug: 'karongi',
        isActive: true,
      },
      select: { id: true, name: true, slug: true },
    });
    console.log(`OK create: ${created.name} (${created.id})`);
  }

  const cities = await prisma.city.findMany({
    where: { countryId: rwanda.id },
    select: { name: true, slug: true, isActive: true },
    orderBy: { name: 'asc' },
  });

  console.log('\nFinal Rwanda city list:');
  for (const c of cities) {
    console.log(`- ${c.name} (${c.slug}) active=${Boolean(c.isActive)}`);
  }
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });

