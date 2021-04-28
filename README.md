# Pi-Hole-Discord-Notification


This is a simple script i made to learn a bit about bash coding.
It's not optimized and some things might be doable in a more proper way. (PRs welcome)

Change discord_webhook='https://discordapp.com/api/webhooks/YOURWEBHOOK' to your discord webhook url

Change "content": " <@116742056298283010> ", to your user id in discord. Right click your name, copy id with dev options enabled.
This will tag you if the space on the SD is filled over 90%.

And the author_url="https://domain.com/icons/pihole.png" to where ever you host your icons.

I use it on my Raspi 3, starting the script via a cron job.

The script is heavily inspired by https://hotio.dev/pullio/ and Pullio was used as reference.
