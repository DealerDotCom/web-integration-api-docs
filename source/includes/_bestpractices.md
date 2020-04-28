# Best Practices

## Performance

* **Use a CDN** - This will get your assets closer to your users, which lowers download time.
* **Serve content from as few files as possible** - This allows for optimal downloads.
* **Serve content from as few domains as possible** - This reduces the number of https connections the browser must make.
* **Serve content using compression (brotli or gzip)** - This reduces the over the wire cost of your assets.
* **Minify your JavaScript and CSS** - This reduces the over the wire cost of your assets.
* **Avoid polyfilling items that DDC already polyfills** - This reduces the amount of work the browser has to do.
