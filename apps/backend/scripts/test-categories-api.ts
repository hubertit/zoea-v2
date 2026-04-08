import { NestFactory } from '@nestjs/core';
import { AppModule } from '../src/app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule, { logger: false });
  const server = app.getHttpServer();
  // We can't easily query the nest API locally this way without starting it properly
  // Let's just check the CategoriesController/Service instead
}
bootstrap();
