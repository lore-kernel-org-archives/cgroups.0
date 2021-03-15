From: David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 1/8] memcg: accounting for fib6_nodes cache
Date: Mon, 15 Mar 2021 09:13:50 -0600
Message-ID: <39f3f0ba-e169-f44f-3aae-5ebaca3c42a0@gmail.com>
References: <YEnWUrYOArju66ym@dhcp22.suse.cz>
 <85b5f428-294b-af57-f496-5be5fddeeeea@virtuozzo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MvLffGY2PDS6HPT4gIfMBvNzZ4NCk1hS/akJFXwFv14=;
        b=dbLAM1WhoHTn5xOOeGVbScgJG8gKQo/OU/0p6mPUVY8/4ztpqRilTab/zD2yGj8jFV
         SZ75dAe4FSJby+OEsdztV8G6t3PwMNXiFcN/a6Ktn/7my3KQkW6FuQGOQFqLjfiVJ7f9
         F85VM8OUp1CMxUf730d5r299PKD0Ro+Di0SlRDXrw3K2bxqsV+pvqUSj18U56UPe+mgt
         PgOKe9oq190jzbwH018/UWMDnCvztwrydvpgdfsq0ASIfniK4xBmDfu2bZORyJG5vTGT
         KM148mzuMsV37ZSwJ44qdikeMjx+SGTn+RpUvh78GWpH1QC6W/WYwEfSWbh1WeiQ03ZO
         jlLA==
In-Reply-To: <85b5f428-294b-af57-f496-5be5fddeeeea-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Hideaki YOSHIFUJI <yoshfuji-VfPWfsRibaP+Ru+s062T9g@public.gmane.org>, David Ahern <dsahern-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On 3/15/21 6:23 AM, Vasily Averin wrote:
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
> ---
>  mm/memcontrol.c    | 2 +-
>  net/ipv6/ip6_fib.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 

Acked-by: David Ahern <dsahern-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>


