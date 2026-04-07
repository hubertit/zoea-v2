import { PrismaClient } from '@prisma/client';
const prisma = new PrismaClient();

async function main() {
  const categories = await prisma.category.findMany({
    where: { slug: 'dining' },
    include: {
      children: {
        include: {
          _count: { select: { children: true } }
        }
      }
    }
  });
  console.log(JSON.stringify(categories[0].children, null, 2));
}
main().finally(() => prisma.$disconnect());
