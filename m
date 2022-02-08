From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v5 3/4] mm/page_owner: Print memcg information
Date: Tue, 8 Feb 2022 20:11:17 +0100
Message-ID: <YgLAVdYRU6HPl6aF@dhcp22.suse.cz>
References: <20220208000532.1054311-1-longman@redhat.com>
 <20220208000532.1054311-4-longman@redhat.com>
 <YgJeWth50eP9L0PK@dhcp22.suse.cz>
 <e897adca-168e-13db-8001-4afbef3aa648@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1644347478; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yttcmkKs+bAIvSGjq/8ZnP5VxhwV7JekAzQGhUXqisI=;
        b=dy1JqXXlQZKUE8/PmDrCJFOZy2foFZ/0AkY+ce/Jfjk0EAJ4M/lil/28r3sujk4pPJXcXn
        LKKg/TAy1nG4NLYKEYKZ7u4qAeV9pJ4PEwZWlGdbQcLwNUB+UQzTgAlm2a5hTKs7NPnirl
        L7PkvJFco7fjr5MZF52Jd5A6UXJCwLc=
Content-Disposition: inline
In-Reply-To: <e897adca-168e-13db-8001-4afbef3aa648-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Sergey Senozhatsky <senozhatsky-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Rapoport <rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Rafael Aquini <aquini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Rapoport <rppt-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>

On Tue 08-02-22 13:40:57, Waiman Long wrote:
> On 2/8/22 07:13, Michal Hocko wrote:
> > On Mon 07-02-22 19:05:31, Waiman Long wrote:
> > > It was found that a number of dying memcgs were not freed because
> > > they were pinned by some charged pages that were present. Even "echo 1 >
> > > /proc/sys/vm/drop_caches" wasn't able to free those pages. These dying
> > > but not freed memcgs tend to increase in number over time with the side
> > > effect that percpu memory consumption as shown in /proc/meminfo also
> > > increases over time.
> > I still believe that this is very suboptimal way to debug offline memcgs
> > but memcg information can be useful in other contexts and it doesn't
> > cost us anything except for an additional output so I am fine with this.
>
> I am planning to have a follow-up patch to add a new debugfs file for just
> printing page information associated with dying memcgs only. It will be
> based on the existing page_owner code, though. So I need to get this patch
> in first.

Sure. I would give a shot the drgn approach as this can be much more
versatile without any additional kernel code.

[...]

> > > +	dying = (memcg->css.flags & CSS_DYING);
> > Is there any specific reason why you haven't used mem_cgroup_online?
> Not really. However, I think checking for CSS_DYING makes more sense now
> that I using the term "dying".

I do not really care much but I though CSS_DYING is a cgroup internal
thing. We have a highlevel API so I thought it would be used
preferably.
-- 
Michal Hocko
SUSE Labs
