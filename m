From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: Possible race in obj_stock_flush_required() vs drain_obj_stock()
Date: Fri, 30 Sep 2022 11:26:17 -0700
Message-ID: <Yzc0yZwDB8GG+4t7@P9FQF9L96D.corp.robot.car>
References: <1664546131660.1777662787.1655319815@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1664562382;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bozQYQ1ItXY9G43M8jtCYuxizhROlKE4s9wubZ56+HI=;
        b=H0/2RA6SRRc9Ov2ipdLFhQzKpskdAcFqVeHK/w0k4kMBSIWDjWIjS4H6iezwdKQNZhPrJP
        Z4V5fJulEcg9gMXtU5v6Se/9LrwVmrWmztvXtwBi45Tw9kGx0yn42NOLYVhvr8t4EVEoDe
        x+/JTiACIIk6+RkL8sTZrui+9hC9FNs=
Content-Disposition: inline
In-Reply-To: <1664546131660.1777662787.1655319815-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexander Fedorov <halcien-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Fri, Sep 30, 2022 at 02:06:48PM +0000, Alexander Fedorov wrote:
> Hi,
> 
> reposting this to the mainline list as requested and with updated patch.
> 
> I've encountered a race on kernel version 5.10.131-rt72 when running
> LTP cgroup_fj_stress_memory* tests and need help with understanding
> synchronization in mm/memcontrol.c, it seems really not-trivial...
> Have also checked patches in the latest mainline kernel but do not see
> anything similar to the problem.  Realtime patch also does not seem to
> be the culprit: it just changed preemption to migration disabling and
> irq_disable to local_lock.
> 
> It goes as follows:
> 
> 1) First CPU:
>    css_killed_work_fn() -> mem_cgroup_css_offline() ->
> drain_all_stock() -> obj_stock_flush_required()
>         if (stock->cached_objcg) {
> 
> This check sees a non-NULL pointer for *another* CPU's `memcg_stock`
> instance.
> 
> 2) Second CPU:
>   css_free_rwork_fn() -> __mem_cgroup_free() -> free_percpu() ->
> obj_cgroup_uncharge() -> drain_obj_stock()
> It frees `cached_objcg` pointer in its own `memcg_stock` instance:
>         struct obj_cgroup *old = stock->cached_objcg;
>         < ... >
>         obj_cgroup_put(old);
>         stock->cached_objcg = NULL;
> 
> 3) First CPU continues after the 'if' check and re-reads the pointer
> again, now it is NULL and dereferencing it leads to kernel panic:
> static bool obj_stock_flush_required(struct memcg_stock_pcp *stock,
>                                      struct mem_cgroup *root_memcg)
> {
> < ... >
>         if (stock->cached_objcg) {
>                 memcg = obj_cgroup_memcg(stock->cached_objcg);

Great catch!

I'm not sure about switching to rcu primitives though. In all other cases
stock->cached_objcg is accessed only from a local cpu, so using rcu_*
function is an overkill.

How's something about this? (completely untested)

Also, please add
Fixes: bf4f059954dc ("mm: memcg/slab: obj_cgroup API")

Thank you!
