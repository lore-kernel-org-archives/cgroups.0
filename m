From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v2 4/4] mm/memcg: Protect memcg_stock with a local_lock_t
Date: Wed, 16 Feb 2022 13:08:55 -0500
Message-ID: <Yg09t/j5Z0X9L7aX@cmpxchg.org>
References: <20220211223537.2175879-1-bigeasy@linutronix.de>
 <20220211223537.2175879-5-bigeasy@linutronix.de>
 <YgqB77SaViGRAtgt@cmpxchg.org>
 <Yg0dctKholvzADYP@linutronix.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CU/AXfwa3Im1uRiNONAlogBiTBFdbTVUfdiUCLuEKiU=;
        b=yiK42wLBMgMpyLohAN1o3Njdrw1GDrndn/LnvGp1r/2/zpQQ19LDq26SHKCoy4MABR
         KnxhFYtTwOz86H7aytfUSLMEqPySVagV3hwu/eHxBVMcZ+urO7BETp5mTcoi4NO/XgkK
         Tv15THJP3UINtYcAQ6rhbrjp0fnwzUYkzGsjWdBC8HSW9U1klmFXz6mTaIZ6VhliM1HV
         Qf7FqeaE4l2ShY8jI6dBkaUF5j9eg0KZcydK99isY/wyAgg/OBAHndTRvv7SYEG49fO7
         nuIfwtpUfWaqZa5ANse9pWfIHdyqGc3Lt3FgZxZ+FRNW3Kk56RBywgCH3RKsxKRAgl/2
         54sQ==
Content-Disposition: inline
In-Reply-To: <Yg0dctKholvzADYP-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, kernel test robot <oliver.sang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Wed, Feb 16, 2022 at 04:51:14PM +0100, Sebastian Andrzej Siewior wrote:
> On 2022-02-14 11:23:11 [-0500], Johannes Weiner wrote:
> > Hi Sebastian,
> Hi Johannes,
> 
> > This is a bit dubious in terms of layering. It's an objcg operation,
> > but what's "locked" isn't the objcg, it's the underlying stock. That
> > function then looks it up again, even though we have it right there.
> > 
> > You can open-code it and factor out the stock operation instead, and
> > it makes things much simpler and clearer.
> > 
> > I.e. something like this (untested!):
> 
> This then:
> 
> ------>8------
> 
> From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Date: Wed, 16 Feb 2022 13:25:49 +0100
> Subject: [PATCH] mm/memcg: Opencode the inner part of
>  obj_cgroup_uncharge_pages() in drain_obj_stock()
> 
> Provide the inner part of refill_stock() as __refill_stock() without
> disabling interrupts. This eases the integration of local_lock_t where
> recursive locking must be avoided.
> Open code obj_cgroup_uncharge_pages() in drain_obj_stock() and use
> __refill_stock(). The caller of drain_obj_stock() already disables
> interrupts.
> 
> [bigeasy: Patch body around Johannes' diff ]
> 
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>

I thought you'd fold it into yours, but separate patch works too,
thanks!

Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

One important note, though:

> @@ -3151,8 +3155,17 @@ static void drain_obj_stock(struct memcg_stock_pcp *stock)
>  		unsigned int nr_pages = stock->nr_bytes >> PAGE_SHIFT;
>  		unsigned int nr_bytes = stock->nr_bytes & (PAGE_SIZE - 1);
>  
> -		if (nr_pages)
> -			obj_cgroup_uncharge_pages(old, nr_pages);
> +		if (nr_pages) {
> +			struct mem_cgroup *memcg;
> +
> +			memcg = get_mem_cgroup_from_objcg(old);
> +
> +			if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
> +				page_counter_uncharge(&memcg->kmem, nr_pages);
> +			__refill_stock(memcg, nr_pages);

This doesn't take "memcg: add per-memcg total kernel memory stat"
queued in -mm into account and so will break kmem accounting.

Make sure to rebase the patches to the -mm tree before sending it
out. You can find it here: https://github.com/hnaz/linux-mm
