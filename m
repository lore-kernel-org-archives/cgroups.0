From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: Possible race in obj_stock_flush_required() vs drain_obj_stock()
Date: Sun, 2 Oct 2022 09:16:50 -0700
Message-ID: <Yzm5cukBe6IfyAs7@P9FQF9L96D.lan>
References: <1664546131660.1777662787.1655319815@gmail.com>
 <Yzc0yZwDB8GG+4t7@P9FQF9L96D.corp.robot.car>
 <b91e75f4-b09c-85aa-c6ad-2364dab9af92@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1664727415;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0nWc8MunwJqD9KPrKGnLf0JLwwF80l+3rGQtQR1k1PY=;
        b=Lyp+X/s8OqKJKuTIQTX8DMlSg4GRJZi9mxdh9lNhazDQEJafn4I+NEUkPaMVKQROjW8jQO
        E1+vpn71+zP2lxW8Hun8+foAsB2/MD50vrWPHXfMiBIV0s6BIjURXDE9XMgMw/fvt7Unu3
        lwwcAn9mHtZtvVE9xgAefgJKiFyTTO8=
Content-Disposition: inline
In-Reply-To: <b91e75f4-b09c-85aa-c6ad-2364dab9af92-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexander Fedorov <halcien-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Sat, Oct 01, 2022 at 03:38:43PM +0300, Alexander Fedorov wrote:
> On 30.09.2022 21:26, Roman Gushchin wrote:
> > On Fri, Sep 30, 2022 at 02:06:48PM +0000, Alexander Fedorov wrote:
> >> 1) First CPU:
> >>    css_killed_work_fn() -> mem_cgroup_css_offline() ->
> >> drain_all_stock() -> obj_stock_flush_required()
> >>         if (stock->cached_objcg) {
> >>
> >> This check sees a non-NULL pointer for *another* CPU's `memcg_stock`
> >> instance.
> >>
> >> 2) Second CPU:
> >>   css_free_rwork_fn() -> __mem_cgroup_free() -> free_percpu() ->
> >> obj_cgroup_uncharge() -> drain_obj_stock()
> >> It frees `cached_objcg` pointer in its own `memcg_stock` instance:
> >>         struct obj_cgroup *old = stock->cached_objcg;
> >>         < ... >
> >>         obj_cgroup_put(old);
> >>         stock->cached_objcg = NULL;
> >>
> >> 3) First CPU continues after the 'if' check and re-reads the pointer
> >> again, now it is NULL and dereferencing it leads to kernel panic:
> >> static bool obj_stock_flush_required(struct memcg_stock_pcp *stock,
> >>                                      struct mem_cgroup *root_memcg)
> >> {
> >> < ... >
> >>         if (stock->cached_objcg) {
> >>                 memcg = obj_cgroup_memcg(stock->cached_objcg);
> > 
> > Great catch!
> > 
> > I'm not sure about switching to rcu primitives though. In all other cases
> > stock->cached_objcg is accessed only from a local cpu, so using rcu_*
> > function is an overkill.
> > 
> > How's something about this? (completely untested)
> 
> Tested READ_ONCE() patch and it works.

Thank you!

> But are rcu primitives an overkill?
> For me they are documenting how actually complex is synchronization here.

I agree, however rcu primitives will add unnecessary barriers on hot paths.
In this particular case most accesses to stock->cached_objcg are done from
a local cpu, so no rcu primitives are needed. So in my opinion using a
READ_ONCE() is preferred.

Thanks!
