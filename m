From: patchwork-bot+netdevbpf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Subject: Re: [PATCH net] net-memcg: avoid stalls when under memory pressure
Date: Mon, 24 Oct 2022 18:20:18 +0000
Message-ID: <166663561831.26708.58782572819195454.git-patchwork-notify@kernel.org>
References: <20221021160304.1362511-1-kuba@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666635618;
        bh=QCZRAB01/HVGTv6Ncloc2hbCHm9JQtsbxlhg6H9axV8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eLCYFiAFx0kcI4Sw9M34QyjQ7nEvBvnHyKeoXTQlDoB1lRTuzjQN0LbEPooaSm5+w
         uI3Du1ao003VIBjxkNp+jElnpyQR1zlXiDyhbcSKYJnNbBOnznT3xbQETysVR3muWe
         1B24Jzmkd2RHfCwLT0Um5kUxLsby2XiaLfbmKrpA9nrzIHPsaFp1xrBJQDs0VfQuxN
         xM7xZAPO7pW3rpY+q/nd9qahaLj6yJqX3yvuJhcHoJZL7NUvotMav+LvL/ltOc8qWo
         e/diZMnUQuc2k/T3E4xW+c6FTnF6Ko2RIGTghQWSXvg4iii+2hYvLCXYJdJnG7fOk7
         Li2TWLQwb+r0g==
In-Reply-To: <20221021160304.1362511-1-kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, weiwan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, ncardwell-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, ycheng-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>:

On Fri, 21 Oct 2022 09:03:04 -0700 you wrote:
> As Shakeel explains the commit under Fixes had the unintended
> side-effect of no longer pre-loading the cached memory allowance.
> Even tho we previously dropped the first packet received when
> over memory limit - the consecutive ones would get thru by using
> the cache. The charging was happening in batches of 128kB, so
> we'd let in 128kB (truesize) worth of packets per one drop.
> 
> [...]

Here is the summary with links:
  - [net] net-memcg: avoid stalls when under memory pressure
    https://git.kernel.org/netdev/net/c/720ca52bcef2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


