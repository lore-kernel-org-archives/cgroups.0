From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH RESEND net-next 1/2] net-memcg: Scopify the indicators of
 sockmem pressure
Date: Fri, 21 Jul 2023 17:20:39 -0700
Message-ID: <ZLsg1wklldKkVI2Z@P9FQF9L96D.corp.robot.car>
References: <20230711124157.97169-1-wuyun.abel@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1689985248;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=A7C+8fr0BBPGVeSyRwGjl6x7NUz9yaHHzvCjQiFNnwk=;
        b=reFwmzSJKDypmXEH61HXIerGh6JIYZnQqxTMEmPW+WGdsJVV2gP66kkp6rKtbHLPm4hu0e
        yvBiZt6XWYSXhyo/57SYZv/ujqH6Tu6OfJrUrvcVzIB7aKgM1WpQnyOWZfA/3AOr4Recow
        xRrMKjl726QaHrI7xqB5PF1dcABIDi4=
Content-Disposition: inline
In-Reply-To: <20230711124157.97169-1-wuyun.abel-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Abel Wu <wuyun.abel-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Ahern <dsahern-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kefeng Wang <wangkefeng.wang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kuniyuki Iwashima <kuniyu-vV1OtcyAfmbQT0dZR+AlfA@public.gmane.org>, Martin KaFai Lau <martin.lau-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Alexander Mikhalitsyn <alexander-uFy+/5nkmnuaMJb+Lgu22Q@public.gmane.org>, Breno Leitao <leitao-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>, David Howells <dhowel>

On Tue, Jul 11, 2023 at 08:41:43PM +0800, Abel Wu wrote:
> Now there are two indicators of socket memory pressure sit inside
> struct mem_cgroup, socket_pressure and tcpmem_pressure.

Hi Abel!

> When in legacy mode aka. cgroupv1, the socket memory is charged
> into a separate counter memcg->tcpmem rather than ->memory, so
> the reclaim pressure of the memcg has nothing to do with socket's
> pressure at all.

But we still might set memcg->socket_pressure and propagate the pressure,
right?
If you're changing this, you need to provide a bit more data on why it's
a good idea. I'm not saying the current status is perfect, but I think we need
a bit more justification for this change.

> While for default mode, the ->tcpmem is simply
> not used.
> 
> So {socket,tcpmem}_pressure are only used in default/legacy mode
> respectively. This patch fixes the pieces of code that make mixed
> use of both.
> 
> Signed-off-by: Abel Wu <wuyun.abel-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> ---
>  include/linux/memcontrol.h | 4 ++--
>  mm/vmpressure.c            | 8 ++++++++
>  2 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 5818af8eca5a..5860c7f316b9 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -1727,8 +1727,8 @@ void mem_cgroup_sk_alloc(struct sock *sk);
>  void mem_cgroup_sk_free(struct sock *sk);
>  static inline bool mem_cgroup_under_socket_pressure(struct mem_cgroup *memcg)
>  {
> -	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && memcg->tcpmem_pressure)
> -		return true;
> +	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
> +		return !!memcg->tcpmem_pressure;

So here you can have something like
   if (cgroup_subsys_on_dfl(memory_cgrp_subsys)) {
        do {
            if (time_before(jiffies, READ_ONCE(memcg->socket_pressure)))
                  return true;
        } while ((memcg = parent_mem_cgroup(memcg)));
   } else {
	return !!READ_ONCE(memcg->socket_pressure);
   }

And, please, add a bold comment here or nearby the socket_pressure definition
that it has a different semantics in the legacy and default modes.

Overall I think it's a good idea to clean these things up and thank you
for working on this. But I wonder if we can make the next step and leave only
one mechanism for both cgroup v1 and v2 instead of having this weird setup
where memcg->socket_pressure is set differently from different paths on cgroup
v1 and v2.

Thanks!
