From: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH net-next 1/2] net-memcg: Scopify the indicators of
 sockmem pressure
Date: Mon, 26 Jun 2023 12:58:18 -0700
Message-ID: <20230626125818.74193aea@kernel.org>
References: <20230625142820.47185-1-wuyun.abel@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687809500;
        bh=ldB+MatWlVsNCLZ0mR+Yj//TS0gmW2dKp23REUfd6MU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=u697IQCtWc7mPfP5qNsMU2uWqPdgmV1hJ9wSJ61mq7qWHcO0fSuOP1QJw+GQeHeJH
         yz3fVEY9D+3Y2y0raE7vu687ZMFBltGJd3Hbyz5/t59QlAG5BYc6OUe21J6p2bNMVf
         OFGKjOGg70AKDzOnVr+EfgC/iuPcBNc0vy+l4Bv2s2efBnkJHfTS8DYof2UJupzYOc
         FS4iuCYuKTQ+vdUlmXxHzPYvwMhsLdhSlxZx2f6bZWgp4nNp2LWcKxhCIuuJAQb1oC
         e1bDUJvq8rLTipdMQC6SN1Xtd48ku1uo9jnnBTMDyzo9BLxP76wRPO06DnbgNaGR/F
         w1PG4+jOG5OGw==
In-Reply-To: <20230625142820.47185-1-wuyun.abel-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Abel Wu <wuyun.abel-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Ahern <dsahern-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kuniyuki Iwashima <kuniyu-vV1OtcyAfmbQT0dZR+AlfA@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin KaFai Lau <martin.lau-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Alexander Mikhalitsyn <alexander-uFy+/5nkmnuaMJb+Lgu22Q@public.gmane.org>, Breno Leitao <leitao-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Xing <kern>

On Sun, 25 Jun 2023 22:28:10 +0800 Abel Wu wrote:
> Now there are two indicators of socket memory pressure sit inside
> struct mem_cgroup, socket_pressure and tcpmem_pressure.
> 
> When in legacy mode aka. cgroupv1, the socket memory is charged
> into a separate counter memcg->tcpmem rather than ->memory, so
> the reclaim pressure of the memcg has nothing to do with socket's
> pressure at all. While for default mode, the ->tcpmem is simply
> not used.
> 
> So {socket,tcpmem}_pressure are only used in default/legacy mode
> respectively. This patch fixes the pieces of code that make mixed
> use of both.

The merge window for 6.5 has now started, let's defer this until 6.6.

Please repost in ~2 weeks.
-- 
pw-bot: defer
