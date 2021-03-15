From: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 1/8] memcg: accounting for fib6_nodes cache
Date: Mon, 15 Mar 2021 10:09:42 -0700
Message-ID: <20210315100942.3cc98bb4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <YEnWUrYOArju66ym@dhcp22.suse.cz>
        <85b5f428-294b-af57-f496-5be5fddeeeea@virtuozzo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615828184;
        bh=zcAvAGDwBXL4yn9+QAipdGh2ahuWzmm+14R4I24+RkE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=g6Iu0CEZAFaH5Jg9ZoCgtWqgWKonb1NUFHkQBS+M3GiQKDr1/V6urCCfAQusUacWg
         9IEoYmTBriW3L1iLGoMQh2ng98CeiB7GT/qpZofsexz8wcH6gvisOU2jD2eAplAtwL
         tvvDVOYwUEK+SvCMDpY+hA+Yi6q4KV4Mapbp6Ucwe2s8nzGdNn/GKT6uq0EXtFKNzo
         +ejhdyR3aultI9g8H7wVlV7YZMKr5CLOEXJKDHKrK5Ag/yYSyY5suey7dsE0njPUx7
         NkDKeAQ8MzgpRtH80v5cxNtdnVLw8+yLToIOKa9Fk44xUGUlAjzRc/N+F423u/jgac
         zuQYZjBJXc+Rw==
In-Reply-To: <85b5f428-294b-af57-f496-5be5fddeeeea-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Hideaki YOSHIFUJI <yoshfuji-VfPWfsRibaP+Ru+s062T9g@public.gmane.org>, David Ahern <dsahern-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On Mon, 15 Mar 2021 15:23:00 +0300 Vasily Averin wrote:
> An untrusted netadmin inside a memcg-limited container can create a
> huge number of routing entries. Currently, allocated kernel objects
> are not accounted to proper memcg, so this can lead to global memory
> shortage on the host and cause lot of OOM kiils.
> 
> One such object is the 'struct fib6_node' mostly allocated in
> net/ipv6/route.c::__ip6_ins_rt() inside the lock_bh()/unlock_bh() section:
> 
>  write_lock_bh(&table->tb6_lock);
>  err = fib6_add(&table->tb6_root, rt, info, mxc);
>  write_unlock_bh(&table->tb6_lock);
> 
> It this case is not enough to simply add SLAB_ACCOUNT to corresponding
> kmem cache. The proper memory cgroup still cannot be found due to the
> incorrect 'in_interrupt()' check used in memcg_kmem_bypass().
> To be sure that caller is not executed in process contxt
> '!in_task()' check should be used instead

Sorry for a random question, I didn't get the cover letter. 

What's the overhead of adding SLAB_ACCOUNT?

Please make sure you CC netdev on series which may impact networking.
