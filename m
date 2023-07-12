From: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RESEND net-next 1/2] net-memcg: Scopify the indicators
 of sockmem pressure
Date: Tue, 11 Jul 2023 20:45:37 -0700
Message-ID: <20230711204537.04cb1124@kernel.org>
References: <20230711124157.97169-1-wuyun.abel@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689133539;
        bh=kV1aAg4a4cV9uuw2PocMUWykoJKk/tyIh0MW/t13PJs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GD62fC1aPLT4Chb4Q2u79JyVL01BCjTdBo6PhaMSEQghTJVJ2XMfb8K4IA+5zMHhm
         Jw5/r04qhJG3aBR8GiU4bqed0fsjfTvIcbfb6yTVO/VaN9jYHTc9bLnaqE6xisBuL2
         DFlYzM4h3GDQcPSUU8/iQpd3F3709bWbKmrIjdADvjUlCi170bJr8v5f93PdOLp2wg
         nARXUSE+et76TRzo+W1gxu3XwSJZf7jgKK72NG0sQ02KHSbo3GZ+nPTpLCh6eWNMR1
         38TqTfOPM7T4rqJJpU4+HxdOul3kyGc7D8rFNUpml/fi7eSw5LpV8FvkUIEcjwXB8S
         4b6xx+Y7a3Kvw==
In-Reply-To: <20230711124157.97169-1-wuyun.abel-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Abel Wu <wuyun.abel-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Ahern <dsahern-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kefeng Wang <wangkefeng.wang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kuniyuki Iwashima <kuniyu-vV1OtcyAfmbQT0dZR+AlfA@public.gmane.org>, Martin KaFai Lau <martin.lau-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Alexander Mikhalitsyn <alexander-uFy+/5nkmnuaMJb+Lgu22Q@public.gmane.org>, Breno Leitao <leitao-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>, David

On Tue, 11 Jul 2023 20:41:43 +0800 Abel Wu wrote:
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

Eric Dumazet is currently AFK, can we wait for him to return 
(in about a week) before merging?
