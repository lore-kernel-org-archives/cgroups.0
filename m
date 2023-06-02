From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH net-next v5 1/3] net-memcg: Fold dependency into memcg
 pressure cond
Date: Fri, 2 Jun 2023 20:25:49 +0000
Message-ID: <20230602202549.7nvrv4bx4cu7qxdn@google.com>
References: <20230602081135.75424-1-wuyun.abel@bytedance.com> <20230602081135.75424-2-wuyun.abel@bytedance.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685737551; x=1688329551;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=E/w9dpHTMqgkLEKvl14+NZFKAOeWHv5+6Cm9LcEp2Pk=;
        b=yLQeX37dgxp9PBBi8VizndbTFQ0QUx+l8iC6lB7aHf3WHqlzVM0sr3Knbm3N2EWBhw
         eZqpYVjs3t3t1cmAGoCNORvLZ8+FHUiHEBRNL7D6U6HSt7vWq9CRTVbjf660HFdOYef1
         R97noyMAORChP/anS1o79GwHXO2AK1/h+l1kpywQpPrYYYroDrmPZE/yWMiufDsascoF
         OLfw0QrP0qttpoClFMjgNKc8UoPuf2u3EbtL+JKqUsVnx0s+fHYPrwPOiysst7WXYUE4
         FUzN8Gk9kCSOktftMRWy2E51SlIaTtlyrVESbO6KanMkf4BVwX+YmFT1EMvmNOATbh9/
         kw+A==
In-Reply-To: <20230602081135.75424-2-wuyun.abel-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Abel Wu <wuyun.abel-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: "David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Simon Horman <simon.horman-JqlR5BE4aJhWk0Htik3J/w@public.gmane.org>, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Jun 02, 2023 at 04:11:33PM +0800, Abel Wu wrote:
> The callers of mem_cgroup_under_socket_pressure() should always make
> sure that (mem_cgroup_sockets_enabled && sk->sk_memcg) is true. So
> instead of coding around all the callsites, put the dependencies into
> mem_cgroup_under_socket_pressure() to avoid redundancy and possibly
> bugs.
> 
> This change might also introduce slight function call overhead *iff*
> the function gets expanded in the future. But for now this change
> doesn't make binaries different (checked by vimdiff) except the one
> net/ipv4/tcp_input.o (by scripts/bloat-o-meter), which is probably
> negligible to performance:
> 
> add/remove: 0/0 grow/shrink: 1/2 up/down: 5/-5 (0)
> Function                                     old     new   delta
> tcp_grow_window                              573     578      +5
> tcp_try_rmem_schedule                       1083    1081      -2
> tcp_check_space                              324     321      -3
> Total: Before=44647, After=44647, chg +0.00%
> 
> So folding the dependencies into mem_cgroup_under_socket_pressure()
> is generally a good thing and provides better readablility.
> 

I don't see how it is improving readability. If you have removed the use
of mem_cgroup_sockets_enabled completely from the networking then I can
understand but this change IMHO will actually decrease the readability
because the later readers will have to reason why we are doing this
check at some places but not other.

