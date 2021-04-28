#!/bin/bash

## gets free disk space as naked number
freediskspace=$(df -hP / | awk '{print $5}' |tail -1|sed 's/%$//g')
## Tags me in case disc space is lover than 10%
alarm=90
desc="Pi-Hole"
warning=":warning: :warning: :warning: :warning: :warning: :warning:"


#run applications
/usr/local/bin/pihole -v &> piholever.txt
/usr/local/sbin/pihole-updatelists &> piholelists.txt
#/usr/local/sbin/pihole-updatelists --no-gravity &> piholelists.txt ## for testing without gravity update


#handle piholever.txt
readarray -t piver <piholever.txt
readarray -t piv <<<"${piver[0]}"
readarray -t ltev <<<"${piver[1]}"
readarray -t ftlv <<<"${piver[2]}"

pivv=( ${piv[0]} )
ltevv=( ${ltev[0]} )
ftlvv=( ${ftlv[0]} )
pivcur=${pivv[3]}
ltecur=${ltevv[3]}
ftlcur=${ftlvv[3]}

pilat=$(sed 's/[)]//' <<< ${pivv[5]})
ltelat=$(sed 's/[)]//' <<< ${ltevv[5]})
ftllat=$(sed 's/[)]//' <<< ${ftlvv[5]})

updatecount=0
noupdate="Up to date :white_check_mark:"
availupdate="Update available! :x:"
disccolor=65280

str2=$(tail -1 piholelists.txt)
echo "$str2"
#Pi-Hole update check
   
#  || [[ $ltecur == $ltelat ]] || [[ $ftlcur == $ftllat ]]
piholeversioncheck() {   
   if [[ $pivcur == $pilat ]];
   then

   piverout=${noupdate}

   else

   piverout=${availupdate}
   #updatehint1=":information_source:"
   disccolor=1752220
   fi
}

lteversioncheck() {   
   if [[ $ltecur == $ltelat ]];
   then

   lteverout=${noupdate}
   else

   lteverout=${availupdate}
   #updatehint2=":arrow_up::warning:"
   disccolor=1752220
   fi
}

ftlversioncheck() {   
   if [[ $ftlcur == $ftllat ]];
   then

   ftlverout=${noupdate}

   else

   ftlverout=${availupdate}
   #updatehint3=":information_source:"
   disccolor=1752220
   fi
}

#run update checks
piholeversioncheck
lteversioncheck
ftlversioncheck


#piver=$(pihole -v &> piholever.txt)
#testvar="${piholever[3]}"
#echo "$piver"
#echo "$piholever"
#echo "$testvar"

discord_webhook='https://discordapp.com/api/webhooks/YOURWEBHOOK'

if [[ $freediskspace > $alarm ]];
then

    send_discord_notification() {
        author_url="${12}" && [[ -z ${12} ]] && author_url="https://domain.com/icons/pihole.png"
        json='{
		"embeds": [
            {
            "description": "'${desc}'",
            "color": '16711680',
            "fields": [
                {
                "name": "Ad Lists:",
                "value": "```'${str2}'```"
                },
				{
                "name": "Pi-Hole:",
                "value": "'${piverout}'",
				"inline": true
                },
				{
                "name": "AdminLTE:",
                "value": "'${lteverout}'",
				"inline": true
                },
				{
                "name": "FTL:",
                "value": "'${ftlverout}'",
				"inline": true
                },
				{
                "name": "Diskspace used:",
                "value": "```diff\n-Attention!- '${freediskspace}'%\n```",
				"inline": true
                },
				{
                "name": "Diskspace low!",
                "value":"'${warning}'"
                }
            ],
            "author": {
                "name": "'${desc}'",
                "icon_url": "'${author_url}'"
            },
            "footer": {
                "text": "Made by Gabe"
            },
            "timestamp": "'$(date -u +'%FT%T.%3NZ')'"
            }
        ],
		"content": " <@116742056298283010> ",
        "username": "'${desc}'",
        "avatar_url": "https://domain.com/icons/pihole.png"
        }'
        curl -fsSL -H "User-Agent: Gabe" -H "Content-Type: application/json" -d "${json}" $discord_webhook > /dev/null
}

 send_discord_notification "$discord_webhook"
	
else

    send_discord_notification() {
        author_url="${12}" && [[ -z ${12} ]] && author_url="https://domain.com/icons/pihole.png"
        json='{
        "embeds": [
            {
            "color": "'${disccolor}'",
            "fields": [
                {
                "name": "Ad Lists:",
                "value": "```'${str2}'```"
                },
				{
                "name": "Pi-Hole:",
                "value": "'${piverout}'",
				"inline": true
                },
				{
                "name": "AdminLTE:",
                "value": "'${lteverout}'",
				"inline": true
                },
				{
                "name": "FTL:",
                "value": "'${ftlverout}'",
				"inline": true
                },
				                {
                "name": "Diskspace used:",
                "value": "```'${freediskspace}'%```",
				"inline": true
                }
            ],
            "author": {
                "name": "'${desc}'",
                "icon_url": "'${author_url}'"
            },
            "footer": {
                "text": "Made by Gabe"
            },
            "timestamp": "'$(date -u +'%FT%T.%3NZ')'"
            }
        ],
        "username": "'${desc}'",
        "avatar_url": "https://domain.com/icons/pihole.png"
        }'
        curl -fsSL -H "User-Agent: Gabe" -H "Content-Type: application/json" -d "${json}" $discord_webhook > /dev/null
}

send_discord_notification "$discord_webhook"

fi;

