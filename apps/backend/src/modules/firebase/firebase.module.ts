import { Module, Global } from '@nestjs/common';
import { FirebaseService } from './firebase.service';
import { IntegrationsModule } from '../integrations/integrations.module';

@Global()
@Module({
  imports: [IntegrationsModule],
  providers: [FirebaseService],
  exports: [FirebaseService],
})
export class FirebaseModule {}
