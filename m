From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH] mm/memcg: Free percpu stats memory of dying memcg's
Date: Thu, 21 Apr 2022 10:59:54 -0700
Message-ID: <YmGbmrH/Hg1VJlUc@carbon>
References: <20220421145845.1044652-1-longman@redhat.com>
 <YmGHYNuAp8957ouq@carbon>
 <112a4d7f-bc53-6e59-7bb8-6fecb65d045d@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1650564000;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=k9KJFoROadhQEi217HirEqtdLkXBsecvLOO9CIt2GKE=;
        b=GU+fP14UtB62v1iOUhU2TiO8Tiqpbg/dnJjCrtcQl6Lp7MGa9EyUFAlQNpj0j1rTfbFAmr
        ZVJv/GJLYHVIE9+l0NHbkjyOMoQcQZHPDxoCBeMOaIczAgyyq/bilbi/9kSuTEsDEFBj4C
        foH+6WlVvovyemQkAHrZ6cVl9IVCKWo=
Content-Disposition: inline
In-Reply-To: <112a4d7f-bc53-6e59-7bb8-6fecb65d045d-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>

On Thu, Apr 21, 2022 at 01:28:20PM -0400, Waiman Long wrote:
> 
> On 4/21/22 12:33, Roman Gushchin wrote:
> > On Thu, Apr 21, 2022 at 10:58:45AM -0400, Waiman Long wrote:
> > > For systems with large number of CPUs, the majority of the memory
> > > consumed by the mem_cgroup structure is actually the percpu stats
> > > memory. When a large number of memory cgroups are continuously created
> > > and destroyed (like in a container host), it is possible that more
> > > and more mem_cgroup structures remained in the dying state holding up
> > > increasing amount of percpu memory.
> > > 
> > > We can't free up the memory of the dying mem_cgroup structure due to
> > > active references in some other places. However, the percpu stats memory
> > > allocated to that mem_cgroup is a different story.
> > > 
> > > This patch adds a new percpu_stats_disabled variable to keep track of
> > > the state of the percpu stats memory. If the variable is set, percpu
> > > stats update will be disabled for that particular memcg. All the stats
> > > update will be forward to its parent instead. Reading of the its percpu
> > > stats will return 0.
> > > 
> > > The flushing and freeing of the percpu stats memory is a multi-step
> > > process. The percpu_stats_disabled variable is set when the memcg is
> > > being set to offline state. After a grace period with the help of RCU,
> > > the percpu stats data are flushed and then freed.
> > > 
> > > This will greatly reduce the amount of memory held up by dying memory
> > > cgroups.
> > > 
> > > By running a simple management tool for container 2000 times per test
> > > run, below are the results of increases of percpu memory (as reported
> > > in /proc/meminfo) and nr_dying_descendants in root's cgroup.stat.
> > Hi Waiman!
> > 
> > I've been proposing the same idea some time ago:
> > https://lore.kernel.org/all/20190312223404.28665-7-guro-b10kYP2dOMg@public.gmane.org/T/ .
> > 
> > However I dropped it with the thinking that with many other fixes
> > preventing the accumulation of the dying cgroups it's not worth the added
> > complexity and a potential cpu overhead.
> > 
> > I think it ultimately comes to the number of dying cgroups. If it's low,
> > memory savings are not worth the cpu overhead. If it's high, they are.
> > I hope long-term to drive it down significantly (with lru-pages reparenting
> > being the first major milestone), but it might take a while.
> > 
> > I don't have a strong opinion either way, just want to dump my thoughts
> > on this.
> 
> I have quite a number of customer cases complaining about increasing percpu
> memory usages. The number of dying memcg's can go to tens of thousands. From
> my own investigation, I believe that those dying memcg's are not freed
> because they are pinned down by references in the page structure. I am aware
> that we support the use of objcg in the page structure which will allow easy
> reparenting, but most pages don't do that and it is not easy to do this
> conversion and it may take quite a while to do that.

The big question is whether there is a memory pressure on those systems.
If yes, and the number of dying cgroups is growing, it's worth investigating.
It might be due to the sharing of pagecache pages and this will be ultimately
fixed with implementing of the pagecache reparenting. But it also might be due
to other bugs, which are fixable, so it would be great to understand.

So if there is a memory pressure and dying cgroups are still accumulating,
we need to investigate and fix it.

If there is (almost) no memory pressure, it's a proactive reclaim question.
There are several discussions and projects going on in this area.

Releasing percpu memory is more a workaround of the problem rather than fix.
In the end, if we're accumulating dying cgroups, we're still leaking memory,
just at a smaller pace (which is good, of course).

Thanks!
