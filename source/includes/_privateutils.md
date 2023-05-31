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

> Usage:

```javascript
(async APILoader => {
	const API = await APILoader.create();
	const settings = await API.privateUtils.getSettings();

	// Output the settings that are applicable for the current page.
	API.log(settings);

})(window.DDC.APILoader);
```

This retreives a JavaScript object of your integration's configuration for the current website and page. At this time, most integrations do not use these `settings` options. It should be noted that `settings` are not the same as integration `configs`. Configs are for a particular integration and provide data for how that integration should behave on a given site. Settings may apply to an entire site, or a particular page of a site, and may be used by multiple integrations or on-platform functionality. Think of `settings` more like a feature flag that is enabled on a site or specific page, rather than a configuration option that is intended for one integration.

The way this works is that the values for specific field names in Integration Configs are copied into the Settings for a given page. This is currently used by the My Wallet integration. When the integration is enabled, [these fields in the config](https://ghe.coxautoinc.com/DDC-WebPlatform/ddc-js-api/blob/master/src/utils/settings.js#L9) are noticed and copied into the page settings by the API. This is useful so that we can tell other functionality on the platform to behave accordingly.

Other methods such as `hideDefaultPayments` and `showDefaultPayments` may also control the configured `settings` on deamnd. There is an `addToSettings` function in the `privateUtils` which could be exposed and used directly, but is currently only available indirectly through the helper functions to hide and show payments.
