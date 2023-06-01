# Internal Insert Locations

These insert locations work the same as all of the public locations, however they are restricted for internal DDC use only.

See the <a href="#api-insert-name-callback-elem-meta">insert documentation</a> for more details on the insert method.

## Header Toolbar

> Usage:

```javascript
(async APILoader => {
	const API = await APILoader.create();

	API.subscribe('page-load-v1', (ev) => {
		const callback = (e) => {
			alert('In callback function!');
			console.log('Event Details:', e);
		};

		if (ev.payload.layoutType === 'mobile') {
			API.insert('header-toolbar', (elem, meta) => {
				const node = document.createElement('div');
				node.innerHTML = '<i class="ddc-icon ddc-icon-star ddc-icon-size-xlarge"></i>';
				node.addEventListener('click', callback);
				API.append(elem, node);
			});
		}
	});
})(window.DDC.APILoader);

```

This element is positioned in the _mobile_ header toolbar, typically next to the MyCars icon. The placement can be controlled with the use of an itemlist. This is configured for the site in DVS, in this way:

```xml
<window-preferences-override id='default-mobile:template-navbar1'>
	<preference name='itemlist.id' value='mobile-header-icons'/>
</window-preferences-override>
<window-preferences-override id='landing-mobile:template-navbar1'>
	<preference name='itemlist.id' value='mobile-header-icons'/>
</window-preferences-override>
```

And then in the itemlist folder, add a file called `mobile-header-icons.xml` with content similar to this:

```xml
<?xml version='1.0' encoding='UTF-8'?>
<item-list id='mobile-header-icons' itemClassName='com.dealer.modules.cms.navigation.NavButtonImpl'>
	<item componentName='menu' iconClass='ddc-icon-menu'/>
	<item iconClass='ddc-icon-tool-wrench-screwdriver' url='/schedule-service.htm'/>
	<item componentName='call' iconClass='ddc-icon-call' />
	<item componentName='wiapi'/>
	<item componentName='mycars' iconClass='ddc-icon-mycars-viewed'/>
</item-list>
```

The desired itemlist configuration for the site in question may differ from this example. The key is to add this item to the list where you want the `mobile-header-icons` location to be placed:

`<item componentName='wiapi'/>`

Once that is in place, the `header-toolbar` insert functionality will be available on the mobile site.
