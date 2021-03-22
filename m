From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 2/2] mm: memcontrol: deprecate swapaccounting=0 mode
Date: Mon, 22 Mar 2021 11:53:41 -0400
Message-ID: <YFi9hVQM9maWyhWv@cmpxchg.org>
References: <20210319054944.50048-1-hannes@cmpxchg.org>
 <20210319054944.50048-2-hannes@cmpxchg.org>
 <alpine.LSU.2.11.2103191633350.1043@eggly.anvils>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=E5pR4bhxZETSxTpVA3uMOpN6g18ZTkn19HmQ/Nnh+4o=;
        b=EHV7q9LwYDxGRVPpLfLVmAGUPg55im2cpNJ3+h7ZlJ1Ip9KZXSuVb095YaAk3LoOe/
         TgStUPZvFQicUOGPKSakFK2kCfiXea14bbW2LFqTMzJHAQ699cVZK8BAkp+LNTaytRUn
         Xp4dYojRqHJtOPYC1Y+13U+2/rglDmFPvm8uzwDef0JIWnPky/yXvAcfWJVfTw1hGDwY
         QkFU8zUYaLJLXnZzSQddyAL1Lp/z6sVM4sS/u2Utm0nw571hVtcoCo3bbORJzj5JccAO
         05Tbf0Ttjbba+BA460+lrwKiAcZ1gqEgq2hUl1t2MsaiTHwbFZ74Gz6I60bixo9cDDrQ
         GvwQ==
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.2103191633350.1043-fupSdm12i1nKWymIFiNcPA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Fri, Mar 19, 2021 at 05:37:05PM -0700, Hugh Dickins wrote:
> On Fri, 19 Mar 2021, Johannes Weiner wrote:
> 
> > The swapaccounting= commandline option already does very little
> > today. To close a trivial containment failure case, the swap ownership
> > tracking part of the swap controller has recently become mandatory
> > (see commit 2d1c498072de ("mm: memcontrol: make swap tracking an
> > integral part of memory control") for details), which makes up the
> > majority of the work during swapout, swapin, and the swap slot map.
> > 
> > The only thing left under this flag is the page_counter operations and
> > the visibility of the swap control files in the first place, which are
> > rather meager savings. There also aren't many scenarios, if any, where
> > controlling the memory of a cgroup while allowing it unlimited access
> > to a global swap space is a workable resource isolation stragegy.
> > 
> > On the other hand, there have been several bugs and confusion around
> > the many possible swap controller states (cgroup1 vs cgroup2 behavior,
> > memory accounting without swap accounting, memcg runtime disabled).
> > 
> > This puts the maintenance overhead of retaining the toggle above its
> > practical benefits. Deprecate it.
> > 
> > Suggested-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> 
> This crashes, and needs a fix: see below (plus some nits).
> 
> But it's a very welcome cleanup: just getting rid of all those
> !cgroup_memory_noswap double negatives is a relief in itself.
> 
> It does suggest eliminating CONFIG_MEMCG_SWAP altogether (just
> using #ifdef CONFIG_SWAP instead, in those parts of CONFIG_MEMCG code);
> but you're right that's a separate cleanup, and not nearly so worthwhile
> as this one (I notice CONFIG_MEMCG_SWAP in some of the arch defconfigs,
> and don't know whether whoever removes CONFIG_MEMCG_SWAP would be
> obligated to remove those too).

2d1c498072de ("mm: memcontrol: make swap tracking an integral part of
memory control") made it invisible to the user already, I only kept
the symbol for convenience in the Makefile:

obj-$(CONFIG_MEMCG_SWAP) += swap_cgroup.o

But I guess we could replace it with

ifdef CONFIG_SWAP
obj-$(CONFIG_MEMCG) += swap_cgroup.c
endif

and I agree, everywhere else it's currently used would be nicer
without it. I'll send a separate patch.

> > @@ -99,7 +92,11 @@ static DECLARE_WAIT_QUEUE_HEAD(memcg_cgwb_frn_waitq);
> >  /* Whether legacy memory+swap accounting is active */
> >  static bool do_memsw_account(void)
> >  {
> > -	return !cgroup_subsys_on_dfl(memory_cgrp_subsys) && !cgroup_memory_noswap;
> > +	/* cgroup2 doesn't do mem+swap accounting */
> > +	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
> > +		return false;
> > +
> > +	return true;
> 
> Nit: I'm not fond of the "if (boolean()) return true; else return false;"
> codestyle, and would prefer the straightforward
> 
> 	return !cgroup_subsys_on_dfl(memory_cgrp_subsys);
> 
> but you've chosen otherwise, so, okay.

I prefer a series of branches if a single expression becomes unwieldy,
and individual conditions deserve their own comments.

But it's indeed pretty silly in this case, I'll make it a single line.

> > @@ -7124,7 +7121,7 @@ long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
> >  {
> >  	long nr_swap_pages = get_nr_swap_pages();
> >  
> > -	if (cgroup_memory_noswap || !cgroup_subsys_on_dfl(memory_cgrp_subsys))
> > +	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
> 
> That needs to check mem_cgroup_disabled() where it used to check
> cgroup_memory_noswap.  The convolutions are confusing (which is
> precisely why this is such a welcome cleanup), but without a
> mem_cgroup_disabled() (or NULL memcg) check there, the
> cgroup_disable=memory case oopses on NULLish pointer dereference
> when mem_cgroup_get_nr_swap_pages() is called from get_scan_count().
> 
> (This little function has been repeatedly troublesome that way.)

Sigh, yes, this will hopefully be the last instance of this bug...

Thanks for catching that, I'll fix it up.

> > @@ -7141,7 +7138,7 @@ bool mem_cgroup_swap_full(struct page *page)
> >  
> >  	if (vm_swap_full())
> >  		return true;
> > -	if (cgroup_memory_noswap || !cgroup_subsys_on_dfl(memory_cgrp_subsys))
> > +	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
> 
> Would it now be better to say "if (do_memsw_account())" there?

Yes, I'll change that.

> Or would it be better to eliminate do_memsw_account() altogether,
> and just use !cgroup_subsys_on_dfl(memory_cgrp_subsys) throughout?

I have found do_memsw_account() useful in the past to find those
related pieces. The details elude me know but I remember searching for
this string often during the recent work in this area.

> (Though I don't find "cgroup_subsys_on_dfl" very informative.)

This routinely bothers me as well, but I have not been able to come up
with a good replacement.

memcg_v1()? memcg_legacy_mode()? memory_cgroup_in_bytes()?

> > @@ -7291,27 +7287,13 @@ static struct cftype memsw_files[] = {
> >  	{ },	/* terminate */
> >  };
> >  
> > -/*
> > - * If mem_cgroup_swap_init() is implemented as a subsys_initcall()
> > - * instead of a core_initcall(), this could mean cgroup_memory_noswap still
> > - * remains set to false even when memcg is disabled via "cgroup_disable=memory"
> > - * boot parameter. This may result in premature OOPS inside
> > - * mem_cgroup_get_nr_swap_pages() function in corner cases.
> > - */
> >  static int __init mem_cgroup_swap_init(void)
> >  {
> > -	/* No memory control -> no swap control */
> > -	if (mem_cgroup_disabled())
> > -		cgroup_memory_noswap = true;
> > -
> > -	if (cgroup_memory_noswap)
> > -		return 0;
> > -
> 
> Shakeel suggested "if (mem_cgroup_disabled()) return 0;" here,
> and that was the first thing I tried when I got the crash.

It really isn't obviously safe. I'll put it back in.
