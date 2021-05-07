const {Elm} = require('./src/Main.elm')
const pagesInit = require('elm-pages')

pagesInit({
    mainElmModule: Elm.Main
}).then(app => {
    const cookieName = 'mj-consent'
    const expirationDays = 30

    const cookie = document.cookie.match(`(^| )${cookieName}=([^;]+)`)
    if (cookie && cookie[2]) {
        app.ports.consentRead.send(JSON.parse(cookie[2]))
    } else {
        app.ports.consentRead.send({accepted: false})
    }

    app.ports.consentWrite.subscribe((state) => {
        if (state.accepted) {
            const date = new Date()
            date.setTime(date.getTime() + (expirationDays * 24 * 60 * 60 * 1000))
            document.cookie = cookieName + '=' + JSON.stringify(state) + '; expires=' + date.toUTCString() + '; path=/; SameSite=None; Secure'
        }
    })
})