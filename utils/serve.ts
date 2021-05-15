import { createProxyMiddleware } from 'http-proxy-middleware'
import parseUrl from 'parseurl'
import express from 'express'
import * as path from 'path'
import got from 'got'
import { asString, environmentDecoder } from 'environment-decoder'

const env = environmentDecoder({
    COCKPIT_API_TOKEN: asString,
    COCKPIT_BASE_URL: asString,
    COCKPIT_MODE: asString,
})

const app = express()

app.use('/image/api', (req, res) => {
    const parsedURL = parseUrl(req)
    if (parsedURL) {
        const assetURL = `${env.COCKPIT_BASE_URL}/api/cockpit/image?token=${env.COCKPIT_API_TOKEN}&src=${env.COCKPIT_BASE_URL}/storage/uploads${parsedURL.pathname}&${parsedURL.query}`
        got.stream(assetURL).pipe(res)
    }
})

// on start mode point proxy to elm app
if (env.COCKPIT_MODE === 'start') {
    app.use(
        '*',
        createProxyMiddleware({
            target: 'http://localhost:3000',
            changeOrigin: true,
        }),
    )
} else if (env.COCKPIT_MODE === 'serve') {
    // on serve mode point application to dist folder
    app.use(express.static(path.join(`${__dirname}/../dist/`)))
}

app.listen(8000)

console.log(`🚀  app running "${env.COCKPIT_MODE}" on http://localhost:8000`)
