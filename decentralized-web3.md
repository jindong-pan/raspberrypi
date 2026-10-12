# Build a React + IPFS Web3 DApp

We'll build a working starter project called Decentralized Web3 Portal with:

- React + Vite for the frontend.
- MetaMask wallet connection using `wagmi` and `viem`.
- IPFS pinning through Pinata for decentralized website hosting.
- Wallet address and network display, connection status, and disconnect support.
- A production build ready to deploy to IPFS.

The first version will connect to a wallet and display the connected account. It won't require a smart contract or expose any private keys. You can add smart-contract transactions later.

## 1. How the application works

React frontend

UI, wallet button, account details

MetaMask + wagmi

Wallet permissions and account connection

Ethereum-compatible blockchain

Read account network; smart contracts can be added later

Pinata + IPFS

Publish the built frontend and keep its content available

A key design principle: the wallet connects directly from the visitor's browser. Your Pinata API secret will never be included in the frontend code.

## 2. Create the project

Install Node.js (the current LTS release is a good choice) and npm, then open a terminal.

The following commands create the React project and install the wallet libraries used in the official wagmi connection guide.&#x20;

[image](https://www.google.com/s2/favicons?domain=https://vite.dev\&sz=32)

Vite

+1



```
npm create vite@latest decentralized-web3 -- --template react
cd decentralized-web3
npm install
npm install wagmi viem @tanstack/react-query
npm run dev
```

Open the local address printed by Vite, usually `http://localhost:5173`.

## 3. Project structure

We'll keep the project small and easy to extend.

decentralized-web3/

`index.html`

`vite.config.js`

`src/`

`main.jsx` — React entry point

`App.jsx` — DApp interface and wallet controls

`config.js` — supported blockchain networks

`index.css` — page styling

`dist/`

Generated when you build

Replace or create the following files.

## 4. Source code

### File A — `vite.config.js`

The relative base path allows built assets to resolve when the site is accessed through an IPFS CID rather than the root of a conventional domain. Vite supports this configuration for deployments where the final public path isn't known in advance.&#x20;

[image](https://www.google.com/s2/favicons?domain=https://vite.dev\&sz=32)

Vite

+1



```

import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  base: './',
})

```

### File B — `src/config.js`

We'll support Ethereum Mainnet and Sepolia testnet, and use an injected browser wallet connector. Sepolia is a good place to start experimenting before you add transactions.

```

import { createConfig, http } from 'wagmi'
import { mainnet, sepolia } from 'wagmi/chains'
import { injected } from 'wagmi/connectors'

export const config = createConfig({
  chains: [mainnet, sepolia],
  connectors: [
    injected({
      shimDisconnect: true,
    }),
  ],
  transports: {
    [mainnet.id]: http(),
    [sepolia.id]: http(),
  },
})

```

This uses wagmi's injected connector, which supports browser wallets that expose the standard Ethereum provider interface.&#x20;

[image](https://www.google.com/s2/favicons?domain=https://wagmi.sh\&sz=32)

Wagmi

+1



### File C — `src/main.jsx`

This initializes React, wagmi, and TanStack Query.

```

import React from 'react'
import ReactDOM from 'react-dom/client'
import { WagmiProvider } from 'wagmi'
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'

import { config } from './config'
import App from './App'
import './index.css'

const queryClient = new QueryClient()

ReactDOM.createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <WagmiProvider config={config}>
      <QueryClientProvider client={queryClient}>
        <App />
      </QueryClientProvider>
    </WagmiProvider>
  </React.StrictMode>,
)

```

### File D — `src/App.jsx`

This is the main DApp interface. It lets visitors connect a wallet, see their account and active network, copy their address, and disconnect.

```

import { useAccount, useConnect, useDisconnect, useChainId } from 'wagmi'

const supportedNetworks = {
  1: 'Ethereum Mainnet',
  11155111: 'Sepolia Testnet',
}

function shortenAddress(address) {
  if (!address) return ''
  return `${address.slice(0, 6)}...${address.slice(-4)}`
}

export default function App() {
  const { address, isConnected, status } = useAccount()
  const { connect, connectors, isPending, error } = useConnect()
  const { disconnect } = useDisconnect()
  const chainId = useChainId()

  async function copyAddress() {
    if (!address) return

    try {
      await navigator.clipboard.writeText(address)
      window.alert('Wallet address copied')
    } catch {
      window.alert('Could not copy address. Please copy it manually.')
    }
  }

  return (
    <main className="page">
      <nav className="navbar">
        <a className="brand" href="./">
          <span className="brand-icon">◈</span>
          Web3 Portal
        </a>
        <span className="network-pill">
          {supportedNetworks[chainId] || `Chain ${chainId}`}
        </span>
      </nav>

      <section className="hero">
        <div className="eyebrow">DECENTRALIZED APPLICATION</div>
        <h1>Your gateway to Web3.</h1>
        <p className="subtitle">
          Connect your wallet and explore a web powered by
          blockchain technology and decentralized storage.
        </p>

        <section className="wallet-card">
          <div className="wallet-icon">◈</div>
          <h2>{isConnected ? 'Wallet connected' : 'Connect your wallet'}</h2>
          <p className="muted">
            {isConnected
              ? 'Your wallet is connected to this application.'
              : 'Connect a browser wallet to get started.'}
          </p>

          {!isConnected ? (
            <div className="connect-options">
              {connectors.map((connector) => (
                <button
                  className="primary-button"
                  key={connector.uid}
                  disabled={isPending}
                  onClick={() => connect({ connector })}
                >
                  {isPending
                    ? 'Waiting for wallet...'
                    : `Connect ${connector.name}`}
                </button>
              ))}
            </div>
          ) : (
            <>
              <div className="account-box">
                <span className="status-dot" />
                <span className="account-address">
                  {shortenAddress(address)}
                </span>
                <button className="copy-button" onClick={copyAddress}>
                  Copy address
                </button>
              </div>

              <div className="details">
                <div>
                  <span className="detail-label">Network</span>
                  <strong>
                    {supportedNetworks[chainId] || `Chain ${chainId}`}
                  </strong>
                </div>
                <div>
                  <span className="detail-label">Chain ID</span>
                  <strong>{chainId}</strong>
                </div>
              </div>

              <button
                className="secondary-button"
                onClick={() => disconnect()}
              >
                Disconnect wallet
              </button>
            </>
          )}

          {error && (
            <p className="error-message" role="alert">
              {error.message}
            </p>
          )}

          {!isConnected && !error && (
            <p className="footnote">
              Connection status: {status}
            </p>
          )}
        </section>

        <div className="feature-grid">
          <article className="feature">
            <span className="feature-icon">01</span>
            <h3>Wallet first</h3>
            <p>Your account stays under your control.</p>
          </article>
          <article className="feature">
            <span className="feature-icon">02</span>
            <h3>IPFS hosted</h3>
            <p>Frontend files are addressed by content.</p>
          </article>
          <article className="feature">
            <span className="feature-icon">03</span>
            <h3>Ready to extend</h3>
            <p>Add contracts and decentralized data next.</p>
          </article>
        </div>
      </section>

      <footer>
        Built with React, wagmi, viem and IPFS.
        <br />
        Connecting a wallet does not itself authorize a transaction.
      </footer>
    </main>
  )
}

```

### File E — `src/index.css`

This stylesheet gives the DApp a responsive, dark Web3 dashboard appearance.

```

:root {
  font-family: Inter, ui-sans-serif, system-ui, sans-serif;
  color: #f4f7fb;
  background: #0a1020;
  font-synthesis: none;
  text-rendering: optimizeLegibility;
  -webkit-font-smoothing: antialiased;
}

* {
  box-sizing: border-box;
}

body {
  margin: 0;
  min-width: 320px;
  min-height: 100vh;
}

button {
  font: inherit;
  cursor: pointer;
}

button:disabled {
  opacity: 0.65;
  cursor: wait;
}

.page {
  width: min(1080px, 100%);
  margin: auto;
  padding: 24px;
}

.navbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
}

.brand {
  color: white;
  text-decoration: none;
  font-size: 20px;
  font-weight: 750;
}

.brand-icon {
  color: #9a8cff;
  margin-right: 10px;
}

.network-pill {
  padding: 8px 12px;
  background: #18233a;
  border: 1px solid #2b3a57;
  border-radius: 99px;
  font-size: 12px;
  color: #c8d4ef;
}

.hero {
  padding-top: 76px;
  text-align: center;
}

.eyebrow {
  color: #a99bff;
  letter-spacing: 0.16em;
  font-size: 11px;
  font-weight: 800;
}

h1 {
  font-size: clamp(38px, 7vw, 64px);
  line-height: 1.06;
  letter-spacing: -0.055em;
  margin: 18px 0;
}

.subtitle {
  color: #aab6cc;
  max-width: 600px;
  margin: 0 auto;
  line-height: 1.8;
}

.wallet-card {
  width: min(470px, 100%);
  margin: 38px auto 0;
  padding: 30px;
  border: 1px solid #293753;
  border-radius: 22px;
  background: linear-gradient(145deg, #151f35, #101729);
  box-shadow: 0 25px 80px #0005;
}

.wallet-icon {
  width: 56px;
  height: 56px;
  margin: auto;
  display: grid;
  place-items: center;
  font-size: 30px;
  color: #b3a7ff;
  background: #29234c;
  border-radius: 16px;
}

h2 {
  margin: 18px 0 8px;
  font-size: 23px;
}

.muted,
.footnote {
  color: #9ba9c1;
  font-size: 13px;
  line-height: 1.6;
}

.connect-options {
  margin-top: 24px;
}

.primary-button,
.secondary-button {
  width: 100%;
  padding: 13px 16px;
  border-radius: 11px;
  font-weight: 700;
}

.primary-button {
  color: white;
  border: 1px solid #9382ff;
  background: #7865e9;
}

.primary-button:hover {
  background: #8978f5;
}

.secondary-button {
  margin-top: 20px;
  color: #d8e0f0;
  border: 1px solid #34435e;
  background: #19243a;
}

.account-box {
  margin-top: 24px;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 10px;
  flex-wrap: wrap;
  background: #0c1426;
  border: 1px solid #2c3b57;
  padding: 14px;
  border-radius: 12px;
}

.status-dot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background: #48d6a0;
}

.account-address {
  font-weight: 700;
  font-variant-numeric: tabular-nums;
}

.copy-button {
  border: 0;
  background: transparent;
  color: #b6aaff;
  font-size: 12px;
}

.details {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 12px;
  margin-top: 18px;
  text-align: left;
}

.details > div {
  display: grid;
  gap: 8px;
  padding: 14px;
  border: 1px solid #293753;
  border-radius: 12px;
  overflow-wrap: anywhere;
}

.detail-label {
  color: #9ba9c1;
  font-size: 12px;
}

.details strong {
  font-size: 13px;
}

.error-message {
  color: #ff9d9d;
  font-size: 13px;
  overflow-wrap: anywhere;
}

.footnote {
  margin-bottom: 0;
}

.feature-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 16px;
  margin-top: 56px;
  text-align: left;
}

.feature {
  padding: 22px;
  border: 1px solid #26334d;
  border-radius: 16px;
  background: #111a2c;
}

.feature-icon {
  color: #a99bff;
  font-size: 12px;
  font-weight: 800;
}

.feature h3 {
  margin: 14px 0 8px;
}

.feature p {
  color: #9ba9c1;
  font-size: 13px;
  line-height: 1.7;
}

footer {
  padding: 42px 0 16px;
  text-align: center;
  color: #7f8ca5;
  font-size: 12px;
  line-height: 1.9;
}

@media (max-width: 600px) {
  .page {
    padding: 18px;
  }

  .hero {
    padding-top: 54px;
  }

  .wallet-card {
    padding: 22px;
  }

  .feature-grid {
    grid-template-columns: 1fr;
    margin-top: 32px;
  }
}

```

### File F — `index.html`

Make sure the root HTML file contains the React entry point.

```

<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta
      name="description"
      content="A decentralized Web3 portal hosted on IPFS."
    />
    <title>Web3 Portal | Decentralized Application</title>
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.jsx"></script>
  </body>
</html>

```

Your `package.json` can remain as generated by Vite. Verify that it has the usual `dev`, `build`, and `preview` scripts.

## 5. Run and test the DApp locally

Start the development server:

```
npm run dev
```

Open the local URL in a browser where MetaMask is installed.

Test 1 — Load the interface

Confirm that the Web3 Portal page renders and displays the wallet connection button.

Test 2 — Connect MetaMask

Click the connection button and approve the connection request in MetaMask. The page should display your shortened wallet address and chain ID.

Test 3 — Disconnect

Click Disconnect wallet and confirm that the interface returns to its disconnected state.

Test 4 — Production build

Run the production build and check the generated site locally.

Run:

```
npm run build
npm run preview
```

Vite generates your static site in `dist/`. The preview server is for local testing, not production hosting.&#x20;

[image](https://www.google.com/s2/favicons?domain=https://vite.dev\&sz=32)

Vite

+1



## 6. Deploy the website to Pinata and IPFS

[How to Easily Host a Website on IPFS | Pinata](https://images.openai.com/static-rsc-4/JvzTixUm5wZuusppvW_C-JytOlE0hqkhMtQ6aTENrFGkqAJzPRwt6KsgB90sNYEBfLsLflxS1vicM4yhFa_Mu1h-4mHI7OYRE2yCrOTQMV6EK6V7xkl0pfJNSsNJ15n5Q1kskk3RvkgeUBGW0vkYCTQFXgQ9zf5mnmtRmv9L8j0?purpose=inline)

Step 1 — Create a Pinata account

Visit [Pinata](https://pinata.cloud/) and sign in or create an account.

[How IPFS is Changing the Game for Data Storage and Access](https://images.openai.com/static-rsc-4/MiNxlc9qr-CtAG5qyaZ6vyIu4SBLnaNMmKwqO-8OPCSxAvppaKz4dChNEP-KDsjkcbpUatwi4le599_6PK7zT29oPpAFHye0EgxhBpzZsa6QB-0c56LRRrjpoJwXtyge_u2snPhucILVMYetO2PnJAfpfI9SmZDBjkqqc1Y4zEQ?purpose=inline)

Step 2 — Upload the build directory

Open the upload interface and upload the contents of your project's `dist/` directory as a directory or folder. Preserve `index.html` and all generated asset files.

[Explore the anatomy of a CID in ProtoSchool’s newest tutorial | IPFS Blog & News](https://images.openai.com/static-rsc-4/fJ6cc6gU5-QD6UV5k3931-K1hKBR5Bn9RHkSsE8zplF1tz4ae0F-ab_1YA3uH65-rg5bEoA2yws3g3B1QRMmancp3LNVIDp-6X3EEibm6NWJw3yOlGPAzD0xq0Y7ix4gJ8jXfv3njBDAAWCgAwiL0INkpWb00om8u0BYbQtZoVQ?purpose=inline)

Step 3 — Save the CID

Pinata will provide a content identifier (CID) for the uploaded website. Save it; this identifies that specific version of your site's content.

[My first Web3 webpage | Dries Buytaert](https://images.openai.com/static-rsc-4/4CheQFq27XGVBpUBd3-wu23Ed6g6BZwTCVkm_-bfV8OJdiYT5c-2fZMNRmA-sse_adS8iNBxzCa345jAFoT7pCracjkb3GGnNcFm3xXgESOeUXoFFqI94CqUgyGwXtu1r9p7dRUB1V7q-ftcFpJcF6jLrGBBXdNeDt7mtnbh0_U?purpose=inline)

Step 4 — Open the website

Use the gateway URL provided by Pinata, or try the public gateway format below.

IPFS documentation describes this directory-upload and CID-based publishing workflow.&#x20;

[image](https://www.google.com/s2/favicons?domain=https://docs.ipfs.tech\&sz=32)

IPFS Docs

+1



Your URL will look like this:

```
https://gateway.pinata.cloud/ipfs/YOUR_CID/
```

Replace `YOUR_CID` with the actual CID returned by Pinata. This is a URL template, not a published link to your project.

For production, consider a dedicated gateway and a CID-specific subdomain, which is preferable for isolating browser origins. Keep in mind that pinning helps keep content available but doesn't guarantee permanent availability by itself.

## 7. Important security considerations

- Never put a Pinata API secret in React code. Anything included in the built frontend can be inspected by visitors. Upload through Pinata's dashboard or use a protected backend for automated publishing.
- Connecting a wallet is not authentication by itself. If you later add user accounts, use a signed message with a nonce and server-side signature verification.
- Don't request transaction signatures unnecessarily. This starter only connects to the wallet; it does not transfer tokens or interact with a contract.
- Treat IPFS content as public. Do not upload private keys, passwords, confidential documents, or unencrypted private user data.
- Remember that frontend decentralization is not complete backend decentralization. Your initial app uses IPFS for hosting, but blockchain reads still depend on RPC endpoints.

## 8. What to build next

Once this starter works, the most useful next upgrade is to add a smart contract and a real decentralized application feature.

A. On-chain profile

Let users connect a wallet and create a public profile stored in a smart contract.

B. IPFS file publishing

Let users upload files or metadata to IPFS and display their resulting CIDs.

C. Wallet-based login

Verify signed messages to establish user sessions without asking users to create conventional passwords.

D. Automated deployment

Build a workflow that publishes each approved release to IPFS and records the new CID.

My recommendation: get the wallet connection working first, deploy it to IPFS, and then add one feature at a time. That gives you a reliable foundation without needing to deploy a smart contract before the frontend is ready.
