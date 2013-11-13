From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch] mm, memcg: add memory.oom_control notification for system
 oom
Date: Wed, 13 Nov 2013 14:19:00 -0800 (PST)
Message-ID: <alpine.DEB.2.02.1311131416460.23211@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1310301838300.13556@chino.kir.corp.google.com> <20131031054942.GA26301@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=yvDBsXhVU3M2Ku0e4xM3d5j44EUnjqSFUy8capkb53M=;
        b=QLHvhCn/2Zmtpp32J/P6hGah2YNLULkbOvJDOHgcsrtIt3Fq8ZUDnMz6/lpUpm6mre
         +GO7ymijvUOeBQi2rzATAgMVZX2ELyw24p00z0VNJ7+J6sxZVVqEBk0b9c6aJFn+KYbx
         UYC4elQSHb6Cuf/fu9WmsuDoKrUO1xqwyv4JtsR+y9mjCj2AEUYsy9Xelu5lzHMvR7Gk
         rt3/+gnOOz5AWt0MPUd+VX9rbU9LcggaLrIuRzD2LxKznn3WTVIUKk8BdisaY9NipUir
         Kyh2cyFiKCPArExaiwi5pvIOMrf6ELOlLxB/r3OIcOeSYkTmDJTr680eZ1vA2hYjznve
         cnXg==
In-Reply-To: <20131031054942.GA26301-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, 31 Oct 2013, Johannes Weiner wrote:

> > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > --- a/include/linux/memcontrol.h
> > +++ b/include/linux/memcontrol.h
> > @@ -155,6 +155,7 @@ static inline bool task_in_memcg_oom(struct task_struct *p)
> >  }
> >  
> >  bool mem_cgroup_oom_synchronize(bool wait);
> > +void mem_cgroup_root_oom_notify(void);
> >  
> >  #ifdef CONFIG_MEMCG_SWAP
> >  extern int do_swap_account;
> > @@ -397,6 +398,10 @@ static inline bool mem_cgroup_oom_synchronize(bool wait)
> >  	return false;
> >  }
> >  
> > +static inline void mem_cgroup_root_oom_notify(void)
> > +{
> > +}
> > +
> >  static inline void mem_cgroup_inc_page_stat(struct page *page,
> >  					    enum mem_cgroup_stat_index idx)
> >  {
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -5641,6 +5641,15 @@ static void mem_cgroup_oom_notify(struct mem_cgroup *memcg)
> >  		mem_cgroup_oom_notify_cb(iter);
> >  }
> >  
> > +/*
> > + * Notify any process waiting on the root memcg's memory.oom_control, but do not
> > + * notify any child memcgs to avoid triggering their per-memcg oom handlers.
> > + */
> > +void mem_cgroup_root_oom_notify(void)
> > +{
> > +	mem_cgroup_oom_notify_cb(root_mem_cgroup);
> > +}
> > +
> >  static int mem_cgroup_usage_register_event(struct cgroup_subsys_state *css,
> >  	struct cftype *cft, struct eventfd_ctx *eventfd, const char *args)
> >  {
> > diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> > --- a/mm/oom_kill.c
> > +++ b/mm/oom_kill.c
> > @@ -632,6 +632,10 @@ void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
> >  		return;
> >  	}
> >  
> > +	/* Avoid waking up processes for oom kills triggered by sysrq */
> > +	if (!force_kill)
> > +		mem_cgroup_root_oom_notify();
> 
> We have an API for global OOM notifications, please just use
> register_oom_notifier() instead.
> 

We can't use register_oom_notifier() because we don't want to notify the 
root memcg for a system oom handler if existing oom notifiers free memory 
(powerpc or s390).  We also don't want to notify the root memcg when 
current is exiting or has a pending SIGKILL, we just want to silently give 
it access to memory reserves and exit.  The mem_cgroup_root_oom_notify() 
here is placed correctly.
