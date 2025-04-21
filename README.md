# admobads

A Capacitor plugin for displaying web content in a WebView.

## Install

```bash
npm install admobads
npx cap sync
```

## API

<docgen-index>

* [`open(...)`](#open)
* [`close()`](#close)

</docgen-index>

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

### open(...)

```typescript
open(options: { url: string; showCloseButton?: boolean; }) => Promise<void>
```

Opens a WebView with the provided URL

| Param         | Type                                                     | Description                                                           |
| ------------- | -------------------------------------------------------- | --------------------------------------------------------------------- |
| **`options`** | <code>{ url: string; showCloseButton?: boolean; }</code> | Options containing the URL to open and whether to show a close button |

--------------------


### close()

```typescript
close() => Promise<void>
```

Closes the currently open WebView

--------------------

</docgen-api>
