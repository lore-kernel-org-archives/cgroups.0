From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2 6/6] zswap: memcg accounting
Date: Fri, 13 May 2022 17:14:26 +0200
Message-ID: <20220513151426.GC16096@blackbody.suse.cz>
References: <20220510152847.230957-1-hannes@cmpxchg.org>
 <20220510152847.230957-7-hannes@cmpxchg.org>
 <20220511173218.GB31592@blackbody.suse.cz>
 <YnwJUL90fuoHs3YW@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1652454868; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nyTU5ErQmQ0NdqPj7xjplU/5OPBXUdJ8mJObumbOOaE=;
        b=A6yJ4U9KldExWhFuocfsPhkK8P9HeRgSb8fmB2eY9z7Sp7ko3TqOhgQnKM+TJjvYGD/z3+
        2Je6BK2N+LYUAG7wici8UElgk0u8iqwoqsJtw8+x2adxjqmD0U06Eg+UegyuFNXj9dyMKC
        etWrpypIyhItSwwSEGkVmpbAI6xPQ5M=
Content-Disposition: inline
In-Reply-To: <YnwJUL90fuoHs3YW-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dan Streetman <ddstreet-EkmVulN54Sk@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Wed, May 11, 2022 at 03:06:56PM -0400, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
> Correct. After which the uncompressed page is reclaimed and uncharged.
> So the zswapout process will reduce the charge bottom line.

A zswap object falling under memory.current was my first thinking, I was
confused why it's exported as a separate counter memory.zswap.current
(which IMO suggests disjoint counting) and it doubles a
memory.stat:zswap entry.

Is the separate memory.zswap.current good for anything? (Except maybe
avoiding global rstat flush on memory.stat read but that'd be an
undesired precendent.)

(Ad the eventually reduced footprint, the transitional excursion above
memcg's (or ancestor's) limit should be limited by number of parallel
reclaims running (each one at most a page, right?), so it doesn't seem
necessary to tackle (now).)

> memory.zswap.* are there to configure zswap policy, within the
> boundaries of available memory - it's by definition a subset.

I see how the .max works when equal to 0 or "max". The intermediate
values are more difficult to reason about.
Also, I can see that on the global level, zswap is configured relatively
(/sys/module/zswap/parameters/max_pool_percent).
You wrote that the actual configured value is workload specific, would
it be simpler to have also relative zswap limit per memcg?

(Relative wrt memory.max, it'd be rather just a convenience with this
simple ratio, however, it'd correspond to the top level limit. OTOH, the
relatives would have counter-intuitive hierarchical behavior. I don't
mean this should be changed, rather wondering why this variant was
chosen.)


> +bool obj_cgroup_may_zswap(struct obj_cgroup *objcg)
> +{
> +     struct mem_cgroup *memcg, *original_memcg;
> +     bool ret = true;
> +
> +     original_memcg = get_mem_cgroup_from_objcg(objcg);
> +     for (memcg = original_memcg; memcg != root_mem_cgroup;
> +          memcg = parent_mem_cgroup(memcg)) {
> +             unsigned long max = READ_ONCE(memcg->zswap_max);
> +             unsigned long pages;
> +
> +             if (max == PAGE_COUNTER_MAX)
> +                     continue;
> +             if (max == 0) {
> +                     ret = false;
> +                     break;
> +             }
> +
> +             cgroup_rstat_flush(memcg->css.cgroup);

Here, I think it'd be better not to bypass mem_cgroup_flush_stats() (the
mechanism is approximate and you traverse all ancestors anyway), i.e.
mem_cgroup_flush_stats() before the loop instead of this.

Thanks,
Michal

