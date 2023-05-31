# Insert Locations

Insert locations are areas of pages where you can safely insert markup. These exist in commonly used areas, such as below vehicle pricing on search and detail pages. This section details the current available locations. Please let us know if there are other locations you want to target beyond those listed here.

See the <a href="#api-insert-name-callback-elem-meta">insert documentation</a> for more details on the insert method.

## Vehicle Media

> Usage:

```javascript
(async APILoader => {
	const API = await APILoader.create();
	API.insert('vehicle-media', (elem, meta) => {
		// This element is positioned below the vehicle image area on vehicle search pages.
	});
})(window.DDC.APILoader);
```

> Example Implementation:

```javascript
(async APILoader => {
	const API = await APILoader.create();
	API.subscribe('page-load-v1', ev => {
		if (ev.payload.searchPage) {
			API.insert('vehicle-media', (elem, meta) => {
				const button = API.create('button', {
					text: 'Watch Video',
					href: 'https://www.providerdomain.com/path/video-player.html?vin=' + meta.vin,
					classes: 'btn btn-primary dialog',
					style: 'margin-top: 12px;',
					attributes: {
						'target': '_blank'
					}
				});
				API.append(elem, button);
			});
		}
	});
})(window.DDC.APILoader);
```

This element is positioned below the vehicle image area on vehicle search pages.

## Vehicle Badge

> Usage:

```javascript
(async APILoader => {
	const API = await APILoader.create();
	API.insert('vehicle-badge', (elem, meta) => {
		// This element is positioned below the vehicle tech specs area on vehicle search and detail pages.
	});
})(window.DDC.APILoader);
```

> Example Implementation:

```javascript
(async APILoader => {
	const API = await APILoader.create();
	API.subscribe('page-load-v1', ev => {
		if (ev.payload.searchPage || ev.payload.detailPage) {
			API.insert('vehicle-badge', (elem, meta) => {
				if (meta.inventoryType !== 'used') {
					return;
				}

				const img = document.createElement('img'),
					a = document.createElement('a');

				img.src = 'https://static.dealer.com/v8/global/images/franchise/white/logo-certified-carfax-free-lrg.png';
				img.alt = 'Carfax Free Report';

				a.href = 'https://www.carfax.com/VehicleHistory/p/Report.cfx?partner=DLR_3&vin=' + meta.vin;
				a.target = '_blank';
				a.innerHTML = img.outerHTML;

				API.append(elem, a);
			});
		}
	});
})(window.DDC.APILoader);
```

This element is positioned below the vehicle tech specs area on vehicle search and detail pages.


## Vehicle Payments

> Usage:

```javascript
(async APILoader => {
	const API = await APILoader.create();

	const callback = (elem, meta) => {
		// Insert your content here.
	}

	API.insert('vehicle-payments-primary', callback);
	API.insert('vehicle-payments', callback);
})(window.DDC.APILoader);
```

> Example Implementation:

```javascript
(async APILoader => {
	const API = await APILoader.create();
	API.subscribe('page-load-v1', ev => {

		const { searchPage, detailPage } = ev.payload;

		const callback = (elem, meta) => {
			const button = API.create('button', {
				text: 'Vehicle Payments',
				href: '#',
				classes: 'btn btn-primary'
			})
			API.append(elem, button);
		};

		// Only execute the code on search results and vehicle details pages.
		if (searchPage || detailPage) {
			
			// This element exists only on the "Grid View" layout of the vehicle search page.
			// The content appears below the primary price of the vehicle and above the "Info", "Specials" and "Pricing" tabs.
			// Use this in addition to the `vehicle-payments` location if you want your content to be shown before the user clicks on the pricing tab.
			if (searchPage) {
				API.insert('vehicle-payments-primary', callback);
			}

			// This element is positioned directly below the vehicle pricing area on vehicle search and detail pages.
			// On the "Grid View" layout of the vehicle search page, this content is placed inside the "Pricing" tab, below the vehicle price.
			API.insert('vehicle-payments', callback);
		}
	});
})(window.DDC.APILoader);
```

This element is positioned directly below the vehicle pricing area on vehicle search and detail pages.


## Vehicle Pricing

> Usage:

```javascript
(async APILoader => {
	const API = await APILoader.create();
	API.insert('vehicle-pricing', (elem, meta) => {
		// This element is positioned after the vehicle-payments insert location, and is placed below the pricing/incentives area on vehicle search and detail pages.
	});
})(window.DDC.APILoader);
```

> Example Implementation:

```javascript
(async APILoader => {
	const API = await APILoader.create();
	API.subscribe('page-load-v1', ev => {
		// Only execute the code on search results and vehicle details pages.
		if (ev.payload.searchPage || ev.payload.detailPage) {
			API.insert('vehicle-pricing', (elem, meta) => {
				let lowPrice = Math.round(meta.finalPrice - 1000);
				let highPrice = Math.round(meta.finalPrice + 1000);
				const button = API.create('button', {
					text: 'Search This Price Range',
					href: '/' + meta.inventoryType + '-inventory/index.htm?internetPrice=' + lowPrice.toString() + '-' + highPrice.toString(),
					classes: 'btn btn-primary',
					style: 'margin-top: 12px;'
				})
				API.append(elem, button);
			});
		}
	});
})(window.DDC.APILoader);
```

This element is positioned after the vehicle-payments insert location, and is placed below the pricing/incentives area on vehicle search and detail pages.


## Vehicle Media Container

> Usage:

```javascript
(async APILoader => {
	const API = await APILoader.create();
	API.insert('vehicle-media-container', (elem, meta) => {
		// This element is the media gallery container on vehicle details pages.
		// Injecting into this location will replace the media gallery with the elements you insert.
	});
})(window.DDC.APILoader);
```

> Example Implementation:

```javascript
(async APILoader => {
	const API = await APILoader.create();
	API.subscribe('page-load-v1', ev => {
		if (ev.payload.detailPage) {
			API.insert('vehicle-media-container', (elem, meta) => {
				const containerEl = document.createElement('div');
				containerEl.style = 'background-color: #ff0000; font-size: 30px; width: 100%; height: 540px; margin: 0 auto; padding: 100px; text-align: center;';
				containerEl.innerHTML = 'Your media container goes here.';
				API.append(elem, containerEl);
			});
		}
	});
})(window.DDC.APILoader);
```

This element is the media gallery container on vehicle details pages. Injecting into this location will replace the media gallery with the elements you insert.


## Listings Page Search Facets - Pricing Facet

> Usage:

```javascript
(async APILoader => {
	const API = await APILoader.create();
	API.insert('search-facet-pricing', async (elem) => {
		const markup = document.createElement('div');
		markup.setAttribute('style', 'background: #f00;')
		markup.innerHTML = 'Your content goes here.';
		API.append(elem, markup);
	});
})(window.DDC.APILoader);
```

> Example Implementation:

```javascript
(async APILoader => {
	const API = await APILoader.create();
	API.subscribe('page-load-v1', ev => {
		if (!ev.payload.searchPage) {
			return;
		}

		API.insert('search-facet-pricing', async (elem) => {
			const markup = document.createElement('div');
			markup.setAttribute('style', 'background: #f00;')
			markup.innerHTML = 'Your content goes here.';
			API.append(elem, markup);
		});
	});
})(window.DDC.APILoader);
```

This element is positioned on the Search Results Page, within the Search Facets area. It is placed below the first (and typically only) Pricing related facet.

On the Details page, it is positioned at the top of the vehicle information, below the media gallery.

You can target either the listings or details page by first subscribing to the <a href="#page-load-v1">`page-load-v1`</a> event, then using the <a href="#page-event">event</a> values of `payload.searchPage` and `payload.detailPage` to check the page type.


## Vehicle Banners

> Usage:

```javascript
(async APILoader => {
	const API = await APILoader.create();
	API.insert('listings-placeholder-2', async (elem) => {
		const markup = document.createElement('div');
		markup.setAttribute('style', 'background: #f00;')
		markup.innerHTML = 'Your content goes here.';
		API.append(elem, markup);
	});
})(window.DDC.APILoader);
```

> Example Implementation:

```javascript
(async APILoader => {
	const API = await APILoader.create();
	API.subscribe('page-load-v1', ev => {
		if (!ev.payload.searchPage) {
			return;
		}

		API.insert('listings-placeholder-2', async (elem, meta) => {
			const markup = document.createElement('div');
			markup.setAttribute('style', 'background: #f00;')
			markup.innerHTML = 'Your device type is ' + meta.layoutType;
			API.append(elem, markup);
		});
	});
})(window.DDC.APILoader);
```

There are four "Listings Banners" locations on the Search Results Page, interspersed evenly between the vehicles displayed. These locations are useful for inserting relevant content that a user would expect to see in a list alongside vehicles.

As an example use case, `listings-placeholder-1` is used to place a widely adopted "My Wallet" integration on many websites. For this reason, it is preferable to use locations 2, 3 or 4 instead when possible.

Available Listings Placeholder location names:

- listings-placeholder-1
- listings-placeholder-2
- listings-placeholder-3
- listings-placeholder-4


## Primary Banner

> Usage:

```javascript
(async APILoader => {
	const API = await APILoader.create();
	API.insert('primary-banner', (elem, meta) => {
		// This element is typically positioned in a prominent location above the vehicle listings on the Search Results Page.
		// On the Details page, it is near the top of the vehicle information, below the media gallery.
	});
})(window.DDC.APILoader);
```

> Example Implementation:

```javascript
(async APILoader => {
	const API = await APILoader.create();
	API.subscribe('page-load-v1', ev => {
		if (ev.payload.searchPage || ev.payload.detailPage) {
			API.insert('primary-banner', (elem, meta) => {
				const img = document.createElement('img'),
					a = document.createElement('a');

				img.src = 'https://pictures.dealer.com/d/ddcdemohonda/0217/15bd9bd8ecf0b2a292a91cecb08c595bx.jpg';
				img.alt = 'New 2015 Honda Pilot';
				img.title = 'New 2015 Honda Pilot';

				a.href = '/specials/new.htm';
				a.innerHTML = img.outerHTML;

				API.append(elem, a);
			});
		}
	});
})(window.DDC.APILoader);
```

This element is positioned in a prominent location above the vehicle listings on the Search Results Page.

On the Details page, it is positioned at the top of the vehicle information, below the media gallery.

You can target either the listings or details page by first subscribing to the <a href="#page-load-v1">`page-load-v1`</a> event, then using the <a href="#page-event">event</a> values of `payload.searchPage` and `payload.detailPage` to check the page type.

## Secondary Content

> Usage:

```javascript
(async APILoader => {
	const API = await APILoader.create();
	API.insert('secondary-content', (elem, meta) => {
		// This element is the a secondary content container on vehicle details pages roughly 2/3 of the way down.
		// It may also be added custom to one or more standalone pages on the website.
	});
})(window.DDC.APILoader);
```

> Example Implementation:

```javascript
(async APILoader => {
	const API = await APILoader.create();
	API.subscribe('page-load-v1', (ev) => {
		if (!ev.payload.detailPage) {
			return;
		}

		API.insert('secondary-content', (elem, meta) => {
			const containerEl = document.createElement('div');
			containerEl.style = 'background-color: #ff0000; font-size: 30px; width: 100%; height: 540px; margin: 0 auto; padding: 100px; text-align: center;';
			containerEl.innerHTML = 'Your secondary content container goes here.';
			API.append(elem, containerEl);
		});
	});
})(window.DDC.APILoader);
```

By default, this element is roughly 2/3 of the way down on vehicle details pages.

Because this may also be present on one or two standalone pages as custom additions, it is likely you will want to exclusively target Vehicle Details pages by first subscribing to the <a href="#page-load-v1">`page-load-v1`</a> event, then using the <a href="#page-event">event</a> value of `payload.detailPage` to check the page type.

## Content

> Usage:

```javascript
(async APILoader => {
	const API = await APILoader.create();
	API.insert('content', (elem, meta) => {
		// This element is will only insert on pages created by us for your purposes.
		// It may also be present on pages created for another integration.
	});
})(window.DDC.APILoader);
```

> Example Implementation:

```javascript
(async APILoader => {
	const API = await APILoader.create();
	API.subscribe('page-load-v1', ev => {
		if (ev.payload.pageName === 'YOUR_LANDING_PAGE') { // Note: Replace 'pageName' with the one we provide at page creation.
			API.insert('content', (elem, meta) => {
				const containerEl = document.createElement('div');
				containerEl.classList = 'bg-neutral-950 text-light';
				containerEl.style = 'font-size: 35px; width: 100%; height: 540px; margin: 0 auto; padding: 100px; text-align: center;';
				containerEl.innerHTML = 'Your content container goes here.';
				API.append(elem, containerEl);
			});
		}
	});
})(window.DDC.APILoader);
```

This element will represent the entirety of the empty space between the header and footer on a custom landing page.

The example implementation can be tested here:
<a href="https://www.roimotors.com/tools/your-landing-page.htm">https://www.roimotors.com/tools/your-landing-page.htm</a>

You will need to subscribe to the <a href="#page-load-v1">`page-load-v1`</a> event, then use the <a href="#page-event">event</a> value of `payload.pageName` to ensure you only target your dedicated landing page.

Once ready for production, you will need to work with us to ensure we provide a landing page with this target.
