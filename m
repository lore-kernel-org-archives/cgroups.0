From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch] mm, memcg: provide a stat to describe reclaimable
 memory
Date: Fri, 17 Jul 2020 12:37:57 -0700 (PDT)
Message-ID: <alpine.DEB.2.23.453.2007171226310.3398972@chino.kir.corp.google.com>
References: <alpine.DEB.2.23.453.2007142018150.2667860@chino.kir.corp.google.com> <20200715131048.GA176092@chrisdown.name> <alpine.DEB.2.23.453.2007151046320.2788464@chino.kir.corp.google.com> <20200717121750.GA367633@chrisdown.name>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=i5w4LeVU5Ef3HXHSWFYKzyIvwNIZHN+Yh+rz6r0uMmY=;
        b=duEtAC7+t+gDLXkZPbHYCT3BTLKqJu7mTT3ioFk2ZD+MEB3lM7+9bNetpIYa7CPYfD
         96OxRjjHkcEh/MOt0HagIqaAhdNz42j9aA3WZvGZjdqK1RJiHEATC6fbBCs8xef+uX2U
         xu6Mw2ITReMWYNcTGExDruskXOLof7vnT+b6jaZhzBSGuLHYATcQ/WSgTdIjfDLoM9Cb
         Vxrl/krLn3ObJ0p3dlhPZjbqrNmFFs5gdk4gUZ4f6+HdpG3OB9qog7iBglnm5DGeSJd0
         IWyMnqREAg+u4di1F0J8guKzQXU4VIzc5AfKlHoHVECH+e2IYItGxaL+HKGqPb0+u9cN
         /kPQ==
In-Reply-To: <20200717121750.GA367633-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Fri, 17 Jul 2020, Chris Down wrote:

> > With the proposed anon_reclaimable, do you have any reliability concerns?
> > This would be the amount of lazy freeable memory and memory that can be
> > uncharged if compound pages from the deferred split queue are split under
> > memory pressure.  It seems to be a very precise value (as slab_reclaimable
> > already in memory.stat is), so I'm not sure why there is a reliability
> > concern.  Maybe you can elaborate?
> 
> Ability to reclaim a page is largely about context at the time of reclaim. For
> example, if you are running at the edge of swap, at a metric that truly
> describes "reclaimable memory" will contain vastly different numbers from one
> second to the next as cluster and page availability increases and decreases.
> We may also have to do things like look for youngness at reclaim time, so I'm
> not convinced metrics like this makes sense in the general case.
...
> Again, I'm curious why this can't be solved by artificial workingset
> pressurisation and monitoring. Generally, the most reliable reclaim metrics
> come from operating reclaim itself.
> 

Perhaps this is best discussed in the context I gave in the earlier 
thread: imagine a thp-backed heap of 64MB and then a malloc implementation 
doing MADV_DONTNEED over all but one page in every one of these 
pageblocks.

On a 4.3 kernel, for example, memory.current for the heap segment is now 
(64MB / 2MB) * 4KB = 128KB because we have synchronous splitting and 
uncharging of the underlying hugepage.  On a 4.15 kernel, for example, 
memory.current is still 64MB because the underlying hugepages are still 
charged to the memcg due to deferred split queues.

For any application that monitors this, pressurization is not going to 
help: the memory will be reclaimed under memcg pressure but we aren't 
facing that pressure yet.  Userspace could identify this as a memory leak 
unless we describe what anon memory is actually reclaimable in this 
context (including on systems without swap).  For any entity that uses 
this information to infer if new work can be scheduled in this memcg (the 
reason MemAvailable exists in /proc/meminfo at the system level), this is 
now dramatically skewed.

At worse, on a swapless system, this memory is seen from userspace as 
unreclaimable because it's charged anon.

Do you have other suggestions for how userspace can understand what anon 
is reclaimable in this context before encountering memory pressure?  If 
so, it may be a great alternative to this: I haven't been able to think of 
such a way other than an anon_reclaimable stat.
