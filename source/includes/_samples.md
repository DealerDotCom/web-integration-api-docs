# Sample Code

## Resizing an `iframe` Based on Content Changes

> iframe Code:

```javascript
function sendResizeMessage() {
  window.parent.postMessage({
    type: 'IFRAME_HEIGHT_RESIZE',
    frameHeight: document.body.offsetHeight + 10 /* a little extra for good measure */
  }, '*');
}

if (window.ResizeObserver) {
  var heightObserver = new ResizeObserver(function() {
    sendResizeMessage();
  });
  heightObserver.observe(document.body);
} else {
  // IE 11
  setInterval(
    sendResizeMessage,
    500 /* ms */
  );
}
```

> Integration Code:

```javascript
(function (WIAPI) {
  API = new WIAPI();

  API.insert('content', function (elem, meta) {
    var iframeElem = document.createElement('iframe');
    iframeElem.src = '/path-to-iframe.htm';
    iframeElem.classList.add('my-integration-name-iframe');
    API.append(elem, iframeElem);
  });

  function setIframeHeight(e) {
    if (e.origin !== 'https://yourdomain.com') {
      // You should ALWAYS verify the origin matches the third party domain
      // the iframe is loaded from. For more information, see:
      // https://developer.mozilla.org/en-US/docs/Web/API/Window/postMessage#Security_concerns
      return;
    }

    if (e.data.type === 'IFRAME_HEIGHT_RESIZE' && e.data.frameHeight) {
      var iframes = document.getElementsByClassName('my-integration-name-iframe');
      if (iframes.length === 1) {
        iframes[0].style.height = e.data.frameHeight + 'px';
      }
    }
  }

  window.addEventListener('message', setIframeHeight, false);
})(window.DDC.API);
```

An integration may want to insert an iframe that resizes as its contents change. One possible way to accomplish this is for the iframe to determine when content changes and to use `postMessage` to communicate between the iframe and the integration code running on the outer page. `ResizeObserver` is one way to determine content changes, however, it is not supported in IE11. For IE11, one possible solution is to fallback to polling. The integration running on the outer page can then listen for the message from the iframe to initiate changing the height.

You can see this sample code from the pane on the right of this page running [here](https://webapitestddc.cms.us-west-2.web.dealer.com/growing-iframe-example.htm).
