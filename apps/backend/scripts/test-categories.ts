import { PrismaClient } from '@prisma/client';
const prisma = new PrismaClient();

async function main() {
  const categories = await prisma.category.findMany({
    include: {
      _count: {
        select: { children: true }
      }
    },
    take: 5
  });
  console.log(JSON.stringify(categories, null, 2));
}
main()
  .catch(e => console.error(e))
  .finally(async () => await prisma.$disconnect());
