# Private Utility Methods (Internal DDC use only)

These utilities methods are only intended to be used internally by DDC and not provided as options to third party companies building integrations. This is partially because these utilities have very specific use cases and may not be problematic to share more broadly.

## API.privateUtils.hideDefaultPayments()

> Usage:

```javascript
(async APILoader => {
	const API = await APILoader.create();
	await API.privateUtils.hideDefaultPayments();
	// Payments are now hidden and other payment content may now be inserted.
})(window.DDC.APILoader);
```

Calling this function results in the batch payments being hidden across the current site. An item is set on the `wiapiSettings` entry in the user's session storage. Here's an example value from the `wiapiSettings` storage:

```{
    "INVENTORY_LISTING_DEFAULT_AUTO_NEW": {
        "hideDefaultPayments": true
    }
}
```

That session storage entry is then read in by the `wsm-pricing-display` module and ultimately is used by `ws-detailed-pricing` and `ws-inv-listing` to determine if on-platform batch payments should remain displayed or hidden.

## API.privateUtils.getSettings()

**Usage:**

```javascript
(async APILoader => {
	const API = await APILoader.create();
	const settings = await API.privateUtils.getSettings();

	// Output the settings object for the current page.
	API.log(settings);
})(window.DDC.APILoader);
```

More details about specific fields in the config used by this method can be found [here](https://ghe.coxautoinc.com/DDC-WebPlatform/ddc-js-api/blob/master/src/utils/settings.js#L9). Please note, though, that at the moment, most integrations do not utilize these `settings` options.
```

This function returns a JavaScript object representing the sitewide settings that are applied for integrations on the current website or page of a site.

One important thing to note is that integrations `settings` are not the same as integration `configs`. While `configs` provide data on how a single integration should operate on a specific website, `settings` may apply to the whole site or a specific page, and may be utilized by multiple integrations or on-platform functionalities. It's best to think of `settings` as a feature flag enabled on a website or a specific page (or a "site property"), rather than a configuration option exclusive to a single integration.

The function works by copying values for [specific field names](https://ghe.coxautoinc.com/DDC-WebPlatform/ddc-js-api/blob/master/src/utils/settings.js#L9) from integration `configs` into the `settings` for a given page. This functionality is currently in use by the [My Wallet integration](https://ghe.coxautoinc.com/DDC-WebPlatform/ddc-mywallet-integration). When the integration is enabled, specific fields in the config are detected and copied into the page settings by the API. This proves useful in signaling other platform functionalities to act accordingly.

Other methods such as `hideDefaultPayments` and `showDefaultPayments` may alter the configured `settings` on the fly. The `privateUtils` object also contains an `addToSettings` function which could potentially be used directly, though it's currently only indirectly accessible via the helper functions to hide and show payments.

