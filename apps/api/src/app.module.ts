import { Module } from '@nestjs/common';
import { AppController } from './app.controller.js';
import { AppService } from './app.service.js';
import { AuthModule } from './auth/auth.module.js';
import { MerchantsModule } from './merchants/merchants.module.js';
import { BankConnectionsModule } from './bank-connections/bank-connections.module.js';
import { TransactionsModule } from './transactions/transactions.module.js';
import { OrdersModule } from './orders/orders.module.js';

@Module({
  imports: [AuthModule, MerchantsModule, BankConnectionsModule, TransactionsModule, OrdersModule],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
