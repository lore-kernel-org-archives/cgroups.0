From: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [PATCH v2 4/4] mm/memcg: Protect memcg_stock with a local_lock_t
Date: Thu, 17 Feb 2022 10:28:57 +0100
Message-ID: <Yg4VWfeCLGFnjQ1W@linutronix.de>
References: <20220211223537.2175879-1-bigeasy@linutronix.de>
 <20220211223537.2175879-5-bigeasy@linutronix.de>
 <YgqB77SaViGRAtgt@cmpxchg.org>
 <Yg0dctKholvzADYP@linutronix.de>
 <Yg09t/j5Z0X9L7aX@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1645090139;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Rfvk1TOpsNNoE1/dc+0M3aPmjLaMlI/s+kkO3n5aMnQ=;
        b=ahyvfRlUu+y1KuuXpCSjq/hC1mJ3pNLNUyJvxv/xP4hYG6KeYo59Dj4gUndCvKWWUZdF1p
        EPzoK4ASLFCn3+4Zbgqv9k2m9pMI1ajmY/+SpyTonH2vfz2jhWTGg15JeT462vIjsHFsAH
        BWBV7oTuNRfvO7mEyPsLBiHrsmDPHidirIJ8JL0BYVl/POyR06dg+XdIFquu17PHBqhOch
        Lny7nvsdX2Flzu4avyejdflrLAuzTqBfDXP4/4weyxp0TgXrMneEkreuzdiL+7zVbbDt2e
        k/iO/2mDhnWgOEglvVuWk6b14ZNS4BgvV9SVMkAYaeVtlZmx0fiNCnhh6gSSNg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1645090139;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Rfvk1TOpsNNoE1/dc+0M3aPmjLaMlI/s+kkO3n5aMnQ=;
        b=i+s1ymebTXcUUlUub/3iQBKh1aNTNiyfZAF8JndxUG78GwiZI+oPjOskJmV/LT8enJ8XXZ
        sU3FfP1KL5y5AHBg==
Content-Disposition: inline
In-Reply-To: <Yg09t/j5Z0X9L7aX-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, kernel test robot <oliver.sang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On 2022-02-16 13:08:55 [-0500], Johannes Weiner wrote:
> I thought you'd fold it into yours, but separate patch works too,
> thanks!
> 
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Thank you.

> One important note, though:
> 
> > @@ -3151,8 +3155,17 @@ static void drain_obj_stock(struct memcg_stock_pcp *stock)
> >  		unsigned int nr_pages = stock->nr_bytes >> PAGE_SHIFT;
> >  		unsigned int nr_bytes = stock->nr_bytes & (PAGE_SIZE - 1);
> >  
> > -		if (nr_pages)
> > -			obj_cgroup_uncharge_pages(old, nr_pages);
> > +		if (nr_pages) {
> > +			struct mem_cgroup *memcg;
> > +
> > +			memcg = get_mem_cgroup_from_objcg(old);
> > +
> > +			if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
> > +				page_counter_uncharge(&memcg->kmem, nr_pages);
> > +			__refill_stock(memcg, nr_pages);
> 
> This doesn't take "memcg: add per-memcg total kernel memory stat"
> queued in -mm into account and so will break kmem accounting.
>
> Make sure to rebase the patches to the -mm tree before sending it
> out. You can find it here: https://github.com/hnaz/linux-mm

Thank you, rebased on-top.

Sebastian
