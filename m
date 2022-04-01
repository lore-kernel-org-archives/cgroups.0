From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH resend] memcg: introduce per-memcg reclaim interface
Date: Fri, 1 Apr 2022 15:03:09 +0200
Message-ID: <Ykb4DVt0eKrstDWv@dhcp22.suse.cz>
References: <20220331084151.2600229-1-yosryahmed@google.com>
 <20220331173350.1fe09370479a4a6f916b477d@linux-foundation.org>
 <CAAPL-u-_Da0qe7h_o70HCz4gPtjT8_bjx4rVNdgKZh3KNruzpA@mail.gmail.com>
 <CAJD7tkarUYM6fjty8FXn9gtR=RVWgksa3LNwswi1Ug1LPnLt4g@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1648818191; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=L8Fv6ZDQ8m+qPC8dDpr3Y/+f6kvNVrRdMcIsE+f6ZEU=;
        b=lubng6AuK16ZqODySVuFbAIiNelcW5AfzZgr4sNsal07K8TvFn3bNcchUYwkoBlOMOeKLp
        BtLjH2snjDWIO1W3RF9RbkPDG+a/s+0v1MjSq4/BODP/3y/3mddKI4fF4Hxdnm1mZcB+1b
        hW0uhc+1XDp1BKTMZ1QPAnz025krtu8=
Content-Disposition: inline
In-Reply-To: <CAJD7tkarUYM6fjty8FXn9gtR=RVWgksa3LNwswi1Ug1LPnLt4g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Wei Xu <weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Fri 01-04-22 02:17:28, Yosry Ahmed wrote:
> On Thu, Mar 31, 2022 at 8:38 PM Wei Xu <weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> >
> > On Thu, Mar 31, 2022 at 5:33 PM Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> > >
> > > On Thu, 31 Mar 2022 08:41:51 +0000 Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> > >
> > > > --- a/mm/memcontrol.c
> > > > +++ b/mm/memcontrol.c
> > > > @@ -6355,6 +6355,38 @@ static ssize_t memory_oom_group_write(struct kernfs_open_file *of,
> > > >       return nbytes;
> > > >  }
> > > >
> > > > +static ssize_t memory_reclaim(struct kernfs_open_file *of, char *buf,
> > > > +                           size_t nbytes, loff_t off)
> > > > +{
> > > > +     struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
> > > > +     unsigned int nr_retries = MAX_RECLAIM_RETRIES;
> > > > +     unsigned long nr_to_reclaim, nr_reclaimed = 0;
> > > > +     int err;
> > > > +
> > > > +     buf = strstrip(buf);
> > > > +     err = page_counter_memparse(buf, "", &nr_to_reclaim);
> > > > +     if (err)
> > > > +             return err;
> > > > +
> > > > +     while (nr_reclaimed < nr_to_reclaim) {
> > > > +             unsigned long reclaimed;
> > > > +
> > > > +             if (signal_pending(current))
> > > > +                     break;
> > > > +
> > > > +             reclaimed = try_to_free_mem_cgroup_pages(memcg,
> > > > +                                             nr_to_reclaim - nr_reclaimed,
> > > > +                                             GFP_KERNEL, true);
> > > > +
> > > > +             if (!reclaimed && !nr_retries--)
> > > > +                     break;
> > > > +
> > > > +             nr_reclaimed += reclaimed;
> > > > +     }
> > >
> > > Is there any way in which this can be provoked into triggering the
> > > softlockup detector?
> >
> > memory.reclaim is similar to memory.high w.r.t. reclaiming memory,
> > except that memory.reclaim is stateless, while the kernel remembers
> > the state set by memory.high.  So memory.reclaim should not bring in
> > any new risks of triggering soft lockup, if any.

Memory reclaim already has cond_resched even if there is nothing
reclaimable. See shrink_node_memcgs

> > > Is it optimal to do the MAX_RECLAIM_RETRIES loop in the kernel?
> > > Would additional flexibility be gained by letting userspace handle
> > > retrying?
> >
> > I agree it is better to retry from the userspace.
> 
> Thanks Andrew and Wei for looking at this. IIUC the
> MAX_RECLAIM_RETRIES loop was modeled after the loop in memory.high as
> well. Is there a reason why it should be different here?

No, I would go with the same approach other interfaces use. I am not a
great fan of MAX_RECLAIM_RETRIES - especially when we have a bail out on
signals - but if we are to change this then let's do it consisently.

-- 
Michal Hocko
SUSE Labs
