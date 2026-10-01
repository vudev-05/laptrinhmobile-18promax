export class Transaction {
  id: string;
  merchantId: string;
  bankConnectionId: string;
  externalTransactionId: string | null;
  bankCode: string;
  amount: number;
  direction: 'IN' | 'OUT';
  content: string;
  occurredAt: Date;
  receivedAt: Date;
  source: 'NOTIFICATION' | 'WEBHOOK' | 'BANK_API' | 'MANUAL';
  fingerprint: string;
  status: 'MATCHED' | 'UNMATCHED' | 'IGNORED';
}
