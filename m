From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [patch] mm, memcg: add memory.oom_control notification for
 system oom
Date: Wed, 13 Nov 2013 22:25:08 -0500
Message-ID: <20131114032508.GL707@cmpxchg.org>
References: <alpine.DEB.2.02.1310301838300.13556@chino.kir.corp.google.com>
 <20131031054942.GA26301@cmpxchg.org>
 <alpine.DEB.2.02.1311131416460.23211@chino.kir.corp.google.com>
 <20131113233419.GJ707@cmpxchg.org>
 <alpine.DEB.2.02.1311131649110.6735@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=GkQuuzav53t0CPj3SBdpGzIGo8jjppRZc6xjygjABjM=;
	b=XvNwQjh2y34cDcENw3HG2b398jYW5Bcl5eyIWttxaGjZk51Ga5r9MA1TmL9KA4eUS6vfVqy4aXPcgHOBL+cFWb0CgX2YFzkVF3kZoDzLgY4zHBMbEdGyBNbrxcftett9RTFfdQFzmkp9KnIP/kje8NhNJB5sdg50/W3MdZKcfO0=;
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1311131649110.6735@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org

On Wed, Nov 13, 2013 at 04:56:09PM -0800, David Rientjes wrote:
> On Wed, 13 Nov 2013, Johannes Weiner wrote:
> 
> > > > > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > > > > --- a/include/linux/memcontrol.h
> > > > > +++ b/include/linux/memcontrol.h
> > > > > @@ -155,6 +155,7 @@ static inline bool task_in_memcg_oom(struct task_struct *p)
> > > > >  }
> > > > >  
> > > > >  bool mem_cgroup_oom_synchronize(bool wait);
> > > > > +void mem_cgroup_root_oom_notify(void);
> > > > >  
> > > > >  #ifdef CONFIG_MEMCG_SWAP
> > > > >  extern int do_swap_account;
> > > > > @@ -397,6 +398,10 @@ static inline bool mem_cgroup_oom_synchronize(bool wait)
> > > > >  	return false;
> > > > >  }
> > > > >  
> > > > > +static inline void mem_cgroup_root_oom_notify(void)
> > > > > +{
> > > > > +}
> > > > > +
> > > > >  static inline void mem_cgroup_inc_page_stat(struct page *page,
> > > > >  					    enum mem_cgroup_stat_index idx)
> > > > >  {
> > > > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > > > --- a/mm/memcontrol.c
> > > > > +++ b/mm/memcontrol.c
> > > > > @@ -5641,6 +5641,15 @@ static void mem_cgroup_oom_notify(struct mem_cgroup *memcg)
> > > > >  		mem_cgroup_oom_notify_cb(iter);
> > > > >  }
> > > > >  
> > > > > +/*
> > > > > + * Notify any process waiting on the root memcg's memory.oom_control, but do not
> > > > > + * notify any child memcgs to avoid triggering their per-memcg oom handlers.
> > > > > + */
> > > > > +void mem_cgroup_root_oom_notify(void)
> > > > > +{
> > > > > +	mem_cgroup_oom_notify_cb(root_mem_cgroup);
> > > > > +}
> > > > > +
> > > > >  static int mem_cgroup_usage_register_event(struct cgroup_subsys_state *css,
> > > > >  	struct cftype *cft, struct eventfd_ctx *eventfd, const char *args)
> > > > >  {
> > > > > diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> > > > > --- a/mm/oom_kill.c
> > > > > +++ b/mm/oom_kill.c
> > > > > @@ -632,6 +632,10 @@ void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
> > > > >  		return;
> > > > >  	}
> > > > >  
> > > > > +	/* Avoid waking up processes for oom kills triggered by sysrq */
> > > > > +	if (!force_kill)
> > > > > +		mem_cgroup_root_oom_notify();
> > > > 
> > > > We have an API for global OOM notifications, please just use
> > > > register_oom_notifier() instead.
> > > > 
> > > 
> > > We can't use register_oom_notifier() because we don't want to notify the 
> > > root memcg for a system oom handler if existing oom notifiers free memory 
> > > (powerpc or s390).  We also don't want to notify the root memcg when 
> > > current is exiting or has a pending SIGKILL, we just want to silently give 
> > > it access to memory reserves and exit.  The mem_cgroup_root_oom_notify() 
> > > here is placed correctly.
> > 
> > This is all handwaving.
> 
> I'm defining the semantics of the system oom notification for the root 
> memcg.  Userspace oom handlers are not going to want to wakeup when a 
> kernel oom notifier is capable of freeing memory to prevent the oom killer 
> from doing anything at all or if current simply needs access to memory 
> reserves to make forward progress.  Userspace oom handlers want a wakeup 
> when a process must be killed to free memory, and thus this is correctly 
> placed.

Userspace may very much be interested in an OOM situation, REGARDLESS
of what action needs to be taken.  Userspace has always the ability to
filter out events and look at the stats after the notification, but it
can not know situations it's not told about.

> > Somebody called out_of_memory() after they
> > failed reclaim, the machine is OOM.
> 
> While momentarily oom, the oom notifiers in powerpc and s390 have the 
> ability to free memory without requiring a kill.

So either

1) they should be part of the regular reclaim process, or

2) their invocation is severe enough to not be part of reclaim, at
   which point we should probably tell userspace about the OOM

> > The fact that current is exiting
> > without requiring a kill is coincidental and irrelevant.  You want an
> > OOM notification, use the OOM notifiers, that's what they're for.
> > 
> 
> I think you're misunderstanding the kernel oom notifiers, they exist 
> solely to free memory so that the oom killer actually doesn't have to kill 
> anything.  The fact that they use kernel notifiers is irrelevant and 
> userspace oom notification is separate.  Userspace is only going to want a 
> notification when the oom killer has to kill something, the EXACT same 
> semantics as the non-root-memcg memory.oom_control.

That's actually not true, we invoke the OOM notifier before calling
mem_cgroup_out_of_memory(), which then may skip the kill in favor of
letting current exit.  It does this for when the kernel handler is
enabled, which would be the equivalent for what you are implementing.
