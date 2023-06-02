From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH net-next v5 3/3] sock: Fix misuse of sk_under_memory_pressure()
Date: Fri, 2 Jun 2023 20:53:22 +0000
Message-ID: <20230602205322.ehxm2q2mbg5laa5s@google.com>
References: <20230602081135.75424-1-wuyun.abel@bytedance.com> <20230602081135.75424-4-wuyun.abel@bytedance.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685739204; x=1688331204;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+fG+5ZSAkptAZFJidv7/9+oyabWoMFk8mfKUsXGlGg0=;
        b=wK1p09WOIIRnkXa564ureFQ57MRy9iMKrPOln0YwwE/Rw8OZR3fzlJZiq5HBxRLpkH
         3ZcKf8jeGec78koGS+8A3fzef2GGzvuzmiXEkdpPRekeof/+cw6itBzIXeP7oBplDYXu
         RENyUJUpLE4LR2JQJKLwMtUUm7+E4iikGt4Sa6bxosnO3BgwDDOIAsBpL4kHgB50kBVu
         jGC0TjJFLJqBV/tIiCMA1TyH0A1nt94H+9HtXZ3Hep/sBNd17pXa7SPMg3qYJ1Mx2YN+
         DXOflqNAt8Jq1N6cDVlWptPE+gccL71iYSJLkLd/wHhKkhEewij5gwtzW4oGkN0siEub
         SP9A==
In-Reply-To: <20230602081135.75424-4-wuyun.abel@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Abel Wu <wuyun.abel@bytedance.com>
Cc: "David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Muchun Song <muchun.song@linux.dev>, Simon Horman <simon.horman@corigine.com>, netdev@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Jun 02, 2023 at 04:11:35PM +0800, Abel Wu wrote:
> The status of global socket memory pressure is updated when:
> 
>   a) __sk_mem_raise_allocated():
> 
> 	enter: sk_memory_allocated(sk) >  sysctl_mem[1]
> 	leave: sk_memory_allocated(sk) <= sysctl_mem[0]
> 
>   b) __sk_mem_reduce_allocated():
> 
> 	leave: sk_under_memory_pressure(sk) &&
> 		sk_memory_allocated(sk) < sysctl_mem[0]

There is also sk_page_frag_refill() where we can enter the global
protocol memory pressure on actual global memory pressure i.e. page
allocation failed. However this might be irrelevant from this patch's
perspective as the focus is on the leaving part.

> 
> So the conditions of leaving global pressure are inconstant, which

*inconsistent

> may lead to the situation that one pressured net-memcg prevents the
> global pressure from being cleared when there is indeed no global
> pressure, thus the global constrains are still in effect unexpectedly
> on the other sockets.
> 
> This patch fixes this by ignoring the net-memcg's pressure when
> deciding whether should leave global memory pressure.
> 
> Fixes: e1aab161e013 ("socket: initial cgroup code.")
> Signed-off-by: Abel Wu <wuyun.abel@bytedance.com>

This patch looks good.
