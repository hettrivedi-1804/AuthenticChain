# AuthenticChain

A minimal, on-chain product authenticity checker for local shops. Shop owners add products by serial on Ethereum-compatible chain (Ganache). Customers verify by uploading a QR code—no backend or login.

Dark, glassmorphism UI with gradient accents. Customer flow is QR-only for simplicity and reliability.

## Tech Stack
- **Smart Contract:** Solidity 0.8.x, Truffle
- **Chain:** Ganache (HTTP RPC http://127.0.0.1:7545)
- **Frontend:** HTML + TailwindCSS + Vanilla JS + Web3.js

## Contract
- `addProduct(serialNumber, productName)` — Owner-only; stores name keyed by serial. Prevents duplicates.
- `getProduct(serialNumber)` — Public view; returns product name or empty string.

Source: `contracts/ProductVerification.sol`

## Features
- **Owner (owner.html)**
  - Connect MetaMask (Ganache). Only deployer (owner) can add.
  - Add fields: Serial, Product Name (on-chain). Optional local metadata: Brand, Model, Warranty (months).
  - Generate QR per product:
    - Full QR (default): includes serial + base64 metadata (brand, model, warranty, enteredBy address).
    - Short QR: serial only, for maximum readability.
  - Local “My Products” list is stored in browser for convenience (not on-chain).

- **Customer (customer.html)**
  - Upload QR image to verify. Camera scanning and manual serial lookup are removed for a simple, robust flow.
  - Shows product name from chain and metadata (if QR was full): brand, model, warranty, enteredBy.
  - One-click PDF download with the displayed details.

## Prerequisites
- Node.js LTS
- Truffle: `npm i -g truffle`
- Ganache running at `http://127.0.0.1:7545`
- MetaMask configured for Ganache (import an account/private key from Ganache)

## Setup & Deploy
1. Start Ganache on `127.0.0.1:7545`.
2. In project root:
   ```bash
   truffle compile
   truffle migrate --reset --network development
   ```
3. Copy the deployed address from `build/contracts/ProductVerification.json` → `networks["5777"].address`.
4. Update `CONTRACT_ADDRESS` in both `owner.html` and `customer.html`.
5. Serve the files (recommended):
   ```bash
   npx serve .
   # then open http://localhost:3000/owner.html and /customer.html (or use VS Code Live Server)
   ```

## Usage
- Owner: open `owner.html`, connect wallet, add product (serial + name), then generate/download QR.
- Customer: open `customer.html`, click “Upload QR”, select the PNG from owner page. View details, download PDF.

## Tips
- If QR upload fails, re-generate a full QR (Short QR disabled) to include metadata; ensure the image is a clean PNG.
- If “Unable to fetch product”: confirm Ganache is running on 7545 and the contract address matches the latest deploy.
- After Ganache reset, re-deploy and update `CONTRACT_ADDRESS` in both pages.

## File Structure
```
withoutbackend/
├─ contracts/
│  └─ ProductVerification.sol
├─ migrations/
│  └─ 1_deploy_product_verification.js
├─ build/contracts/ProductVerification.json
├─ truffle-config.js
├─ owner.html
├─ customer.html
└─ README.md
```

## License
MIT
