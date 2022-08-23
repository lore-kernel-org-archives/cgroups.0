From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC PATCH] memcg: use root_mem_cgroup when css is inherited
Date: Tue, 23 Aug 2022 10:33:36 +0200
Message-ID: <YwSQ4APOu/H7lYGL@dhcp22.suse.cz>
References: <1660908562-17409-1-git-send-email-zhaoyang.huang@unisoc.com>
 <Yv+6YjaGAv52yvq9@slm.duckdns.org>
 <CALvZod7QdLSMdBoD2WztL72qS8kJe7F79JuCH6t19rRcw6Pn1w@mail.gmail.com>
 <Yv/EArPDTcCrGqJh@slm.duckdns.org>
 <YwNpI1ydy0yDnBH0@dhcp22.suse.cz>
 <CAGWkznEB+R0YBaBFBL7dPqs8R=qKC6+ixTWEGCYy2PaczXkaPA@mail.gmail.com>
 <YwRjyx6wFLk8WTDe@dhcp22.suse.cz>
 <CAGWkznGaYTv4u4kOo-rupfyWzDNJXNKTchwP6dbUK-=UXWm47w@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1661243617; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JXhtiVs1Pea0+3tSyFvIt2OFwCvUnOkhvBpBR3hLHJ0=;
        b=itIsnssHRKDHR9XCvqruAA80oSf8XNyabWsyTGumPDHDXGN9IEy42MmKzZi7rYCqRALpUy
        anrc2/ssKuHRWVtuu0qrWAxP8cCFlfwjJKBTlxdsmpO0ESwlj3fToH3WoPcL+5pXSPOu2e
        Jtss8aiqbHbTvHKhu+P2bl7GijmoUo0=
Content-Disposition: inline
In-Reply-To: <CAGWkznGaYTv4u4kOo-rupfyWzDNJXNKTchwP6dbUK-=UXWm47w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zhaoyang Huang <huangzhaoyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "zhaoyang.huang" <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ke Wang <ke.wang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

On Tue 23-08-22 14:03:04, Zhaoyang Huang wrote:
> On Tue, Aug 23, 2022 at 1:21 PM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> >
> > On Tue 23-08-22 10:31:57, Zhaoyang Huang wrote:
[...]
> > > I would like to quote the comments from google side for more details
> > > which can also be observed from different vendors.
> > > "Also be advised that when you enable memcg v2 you will be using
> > > per-app memcg configuration which implies noticeable overhead because
> > > every app will have its own group. For example pagefault path will
> > > regress by about 15%. And obviously there will be some memory overhead
> > > as well. That's the reason we don't enable them in Android by
> > > default."
> >
> > This should be reported and investigated. Because per-application memcg
> > vs. memcg in general shouldn't make much of a difference from the
> > performance side. I can see a potential performance impact for no-memcg
> > vs. memcg case but even then 15% is quite a lot.
> Less efficiency on memory reclaim caused by multi-LRU should be one of
> the reason, which has been proved by comparing per-app memcg on/off.
> Besides, theoretically workingset could also broken as LRU is too
> short to compose workingset.

Do you have any data to back these claims? Is this something that could
be handled on the configuration level? E.g. by applying low limit
protection to keep the workingset in the memory?

> > > > My very vague understanding is that the Android system would like to
> > > > freeze specific applications and for that it requires each application
> > > > to live in its own cgroup. This clashes with a requirement to age and
> > > > reclaim memory on a different granularity (aka no per process reclaim).
> > > > So in fact something that cgroup v1 would achieve by having 2
> > > > hierarchies, one for the freezer which would have a dedicated cgroup for
> > > > each application and the other for the memory controller where tasks are
> > > > grouped by a different criteria. This would rule out that a global (or
> > > > any external memory pressure) reclaim would age LRUs that contain a mix
> > > > bag of application pages rather than iterate over per-application LRUs.
> > > > Is that understanding correct?
> > > Correct, this is just our confusion. Besides, we believe that charge
> > > the pages to implicit memory enabled parent control group doesn't make
> > > sense as the memory cannot be managed at all.
> >
> > I do not get that part. The parent can manange and control the memory
> > usage so how come it cannot be managed at all?
> What I mean is the kind of parent which is enabled implicitly by
> enabling on its sibling group like belowing hierarchy. Imagine that C
> has no intention of memory control but has to be enabled as B would
> have it. IMO, it doesn't make sense to charge C1's memory.current to C
> until an explicitly echo "+memory" >  C/subtree_control.
> A----B---B1
>      \ C---C1

So let me just expand your example for clarity

A.cgroup.controllers = memory
A.cgroup.subtree_control = memory

A/B.cgroup.controllers = memory
A/B.cgroup.subtree_control = memory
A/B/B1.cgroup.controllers = memory

A/C.cgroup.controllers = memory
A/C.cgroup.subtree_control = ""
A/C/C1.cgroup.controllers = ""

Is your concern that C1 is charged to A/C or that you cannot actually make
A/C.cgroup.controllers = "" because you want to maintain memory in A?
Because that would be breaking the internal node constrain rule AFAICS.

Or maybe you just really want a different hierarchy where
A == root_cgroup and want the memory acocunted in B
(root/B.cgroup.controllers = memory) but not in C (root/C.cgroup.controllers = "")?

That would mean that C memory would be maintained on the global (root
memcg) LRUs which is the only internal node which is allowed to have
resources because it is special.
-- 
Michal Hocko
SUSE Labs
