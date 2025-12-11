# 🛡️ Clarity 4.0 Trustless Aggregator (TAG)

**TAG** is a next-generation decentralized finance (DeFi) aggregator built on Stacks, designed to maximize security and improve user experience by leveraging the advanced features introduced in Clarity 4.0.

This protocol addresses key security and UX issues in composable DeFi by enforcing **on-chain code verification** and integrating native **Passkey authentication** with time-delayed recovery mechanisms.

## ✨ Core Clarity 4.0 Integrations

TAG utilizes the following features to deliver a uniquely secure experience:

1.  **Trustless Composability Registry:** Uses `(contract-hash?)` to verify the code hash of external protocols before any interaction, ensuring we only deal with audited and untampered contract code.
2.  **Asset Guardrails:** Employs `(restrict-assets?)` to establish strict post-conditions, preventing external calls from moving more assets than explicitly allowed, providing an automatic on-chain rollback mechanism against malicious or buggy external calls.
3.  **Passkey Smart Wallet:** Integrates `(secp256r1-verify)` to enable secure, biometric-based transaction signing (Passkey) instead of traditional private keys, enhancing user experience.
4.  **Time-Based Security:** Leverages `(stacks-block-time)` to implement time-locked withdrawals and a cancellation window for emergency recovery scenarios.

