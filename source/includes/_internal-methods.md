# Internal API Methods

These methods work the same as all of the public API methods, however they are restricted for internal DDC use only.

## API.insertMenuContent(target, arrayOfObjects)

> Usage

```javascript
(async APILoader => {
	const API = await APILoader.create();

	API.insertMenuContent('primary-menu', [{
		position: 'top',
		primaryText: 'Some User',
		secondaryText: 'some.user@emailclient.com',
		href: '#',
		expanded: true,
		menuIcon: true,
		subItems: [
			{
				text: 'Profile',
				href: 'https://www.domain.com/profile/',
				onclick: (e) => {
					e.preventDefault();
					alert('Would have gone to the Profile linked in `href`, but preventDefault stopped it.');
				}
			},
			{
				text: 'Shopping Cart (1)',
				href: 'https://www.domain.com/cart/'
			},
			{
				text: 'Orders (0)',
				href: 'https://www.domain.com/orders/'
			},
			{
				text: 'Documents',
				href: 'https://www.domain.com/documents/'
			},
		],
		callback: (elem, meta, data) => {
			console.log(elem, meta, data);
		}
	},
	{
		position: 'bottom',
		primaryText: 'Sign Out',
		href: 'https://www.domain.com/logout/',
		onclick: (e) => {
			e.preventDefault();
			alert('Hello World!');
		},
		callback: (elem, meta, data) => {
			console.log(elem, meta, data);
		}
	}]);
})(window.DDC.APILoader);
```

The `insertMenuContent` method allows you to add custom items to the primary navigation menu of Dealer.com sites. You can specify where the items should appear, the primary and secondary text for each item, and any sub-items that should be displayed when the main item is expanded.

The `target` parameter specifies the navigation menu to target. The only currently supported value is 'primary-menu'.

The `arrayOfObjects` parameter is an array of objects describing the menu items to be inserted. Each object can include the following properties:

Property | Description
-------------- | --------------
`position` | The location where the item should be inserted in the menu. The supported values are `top` and `bottom`.
`primaryText` | The main text for the menu item.
`secondaryText` | Additional text that appears beneath the primary text in the menu item.
`href` | The URL where the user should be directed when they click the menu item.
`subItems` | An array of sub-menu items that appear when the main item is expanded. Each sub-item can include the `text` and `href` properties, as well as an `onclick` property specifying a function to be executed when the sub-item is clicked.
`callback` | A function to be called after the menu item has been inserted. This function is passed three parameters: the newly-inserted HTML element (`elem`), the 'page event' object (`meta`), and the original data passed to the `insertMenuContent` function (`data`).
`expanded` | A boolean value indicating whether the menu item should be expanded to show any sub-items when the page loads. The default value is `false`.
`menuIcon` | A boolean value indicating whether an icon should be displayed next to the menu item. The default value is `false`.

The `callback` function you specify is called with three parameters:

Name | Description
-------------- | --------------
`elem` | `{HTMLElement}` The newly-inserted HTML element.
`meta` | `{object}` The 'page event' object. For more information, see the [page event documentation](https://dealerdotcom.github.io/web-integration-api-docs/#page-event).
`data` | `{object}` The original data you passed to the `insertMenuContent` function.

In addition to inserting static content, you can also add interactive functionality to the menu items by providing `onclick` functions. For example, you can prevent the default link behavior and display an alert message when a menu item is clicked, as demonstrated in the example code.

## API.updateLink(intent, setupFunction(meta)) (internal)
The `updateLink` method is used to override links on the page where the integration is enabled.

In order to use this functionality, the integration's schema in WISE needs to have a content mapping entry with the content type as `links`.

The purpose of content needs to be the overriding links functionality (e.g., X-Time overriding Service Scheduler pages). Then we need to select all the Page Aliases that we would like to target. The PageAlias list can be overriden in the site level to capture any SITEBUILDER pages as well.

The WIAPI will determine the link of the corresponding Page Alias in the sitemap, allowing you to modify the link element.

The current supported intent types are: 

`payment-search`

`pre-approval`

`quote-build`

`schedule-service`

`value-a-trade`

We only support limited attributes of the link to be modified in order to preserve the look and feel of the link.

The attributes that can be modified are `href`, `target`, `onclick`, `popover` and `attributes (data-*)`.

> Usage:

```javascript
(async APILoader => {
	const API = await APILoader.create();
	API.updateLink('x-time', meta => {
		return {
			href: 'https://www.yourdomain.com/?account=' + meta.accountId,
			target: '_blank',
		}
	});
})(window.DDC.APILoader);
```

## Content Modification (deprecated)

The `updateLink` method replaces this functionality.

This method allows you to modify content on a page level. Right now we only support the modification of the `schedule-service` button. By using this method you can modify the link attributes of all the schedule service buttons on a page.

> Usage:

```javascript
(async APILoader => {
	const API = await APILoader.create();
	API.modifyContent('schedule-service', {
		schema: {
			// Attributes of the link you want to add or modify
		}
	});
})(window.DDC.APILoader);
```

> Schema Object:

```javascript
{
	"href": "String", // Link to a new service page
	"target": "String", // Set the target attribute of the anchor tag
	"onclick": "Function", // Set an onClick event handler for the button. Remember to reset the href of the button while setting a click event.
	"popover": "Object", // Popover settings for your button, eg {title: "heading", content: "popover text"}
	"attributes": "Object" // List of all data attributes that you would want to add to the button
}
```

> Example Implementation:

```javascript
(async APILoader => {
	const API = await APILoader.create();
	API.modifyContent('schedule-service', {
		schema: {
			"href": "/schedule-form.htm",
			"target": "_blank",
			"attributes": {
				"data-width": "400px",
				"data-title": "My custom service"
			}
		}
	});
})(window.DDC.APILoader);
```
