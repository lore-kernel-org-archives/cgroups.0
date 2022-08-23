From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC PATCH] memcg: use root_mem_cgroup when css is inherited
Date: Tue, 23 Aug 2022 13:51:39 +0200
Message-ID: <YwS/S9Sd1OWnT81Q@dhcp22.suse.cz>
References: <1660908562-17409-1-git-send-email-zhaoyang.huang@unisoc.com>
 <Yv+6YjaGAv52yvq9@slm.duckdns.org>
 <CALvZod7QdLSMdBoD2WztL72qS8kJe7F79JuCH6t19rRcw6Pn1w@mail.gmail.com>
 <Yv/EArPDTcCrGqJh@slm.duckdns.org>
 <YwNpI1ydy0yDnBH0@dhcp22.suse.cz>
 <CAGWkznEB+R0YBaBFBL7dPqs8R=qKC6+ixTWEGCYy2PaczXkaPA@mail.gmail.com>
 <YwRjyx6wFLk8WTDe@dhcp22.suse.cz>
 <CAGWkznGaYTv4u4kOo-rupfyWzDNJXNKTchwP6dbUK-=UXWm47w@mail.gmail.com>
 <YwSQ4APOu/H7lYGL@dhcp22.suse.cz>
 <CAGWkznGd6mgareABseMKY5p0f1=5dkfVkj=NS7_B6OkXBYSwyw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1661255499; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=opjEw1Z8QcMCfQyBa8x+WY+gq+Oq1yKc++/AzCqaoWU=;
        b=sbBf3Wnoq6V3v1nY8ZASzf5RJBIXdPR0x956qhC1pNlrjYoRG49jus6j2ofp/GzefduyRn
        gprvqR8MWsOXyRImqrJoVfAqPjupFmSMfE2UPw94YXQ6NGjsS+Zfj3u54mB8LJPlahQvrp
        N5vS2vFPkqLfs2QZdoTqh1gJ43dkvGM=
Content-Disposition: inline
In-Reply-To: <CAGWkznGd6mgareABseMKY5p0f1=5dkfVkj=NS7_B6OkXBYSwyw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zhaoyang Huang <huangzhaoyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "zhaoyang.huang" <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ke Wang <ke.wang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

On Tue 23-08-22 17:20:59, Zhaoyang Huang wrote:
> On Tue, Aug 23, 2022 at 4:33 PM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> >
> > On Tue 23-08-22 14:03:04, Zhaoyang Huang wrote:
> > > On Tue, Aug 23, 2022 at 1:21 PM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> > > >
> > > > On Tue 23-08-22 10:31:57, Zhaoyang Huang wrote:
> > [...]
> > > > > I would like to quote the comments from google side for more details
> > > > > which can also be observed from different vendors.
> > > > > "Also be advised that when you enable memcg v2 you will be using
> > > > > per-app memcg configuration which implies noticeable overhead because
> > > > > every app will have its own group. For example pagefault path will
> > > > > regress by about 15%. And obviously there will be some memory overhead
> > > > > as well. That's the reason we don't enable them in Android by
> > > > > default."
> > > >
> > > > This should be reported and investigated. Because per-application memcg
> > > > vs. memcg in general shouldn't make much of a difference from the
> > > > performance side. I can see a potential performance impact for no-memcg
> > > > vs. memcg case but even then 15% is quite a lot.
> > > Less efficiency on memory reclaim caused by multi-LRU should be one of
> > > the reason, which has been proved by comparing per-app memcg on/off.
> > > Besides, theoretically workingset could also broken as LRU is too
> > > short to compose workingset.
> >
> > Do you have any data to back these claims? Is this something that could
> > be handled on the configuration level? E.g. by applying low limit
> > protection to keep the workingset in the memory?
> I don't think so. IMO, workingset works when there are pages evicted
> from LRU and then refault which provide refault distance for pages.
> Applying memcg's protection will have all LRU out of evicted which
> make the mechanism fail.

It is really hard to help you out without any actual data. The idea was
though to use the low limit protection to adaptively configure
respective memcgs to reduce refaults. You already have data about
refaults ready so increasing the limit for often refaulting memcgs would
reduce the trashing.

[...]
> > A.cgroup.controllers = memory
> > A.cgroup.subtree_control = memory
> >
> > A/B.cgroup.controllers = memory
> > A/B.cgroup.subtree_control = memory
> > A/B/B1.cgroup.controllers = memory
> >
> > A/C.cgroup.controllers = memory
> > A/C.cgroup.subtree_control = ""
> > A/C/C1.cgroup.controllers = ""
> Yes for above hierarchy and configuration.
> >
> > Is your concern that C1 is charged to A/C or that you cannot actually make
> > A/C.cgroup.controllers = "" because you want to maintain memory in A?
> > Because that would be breaking the internal node constrain rule AFAICS.
> No. I just want to keep memory on B.

That would require A to be without controllers which is not possible due
to hierarchical constrain.

> > Or maybe you just really want a different hierarchy where
> > A == root_cgroup and want the memory acocunted in B
> > (root/B.cgroup.controllers = memory) but not in C (root/C.cgroup.controllers = "")?
> Yes.
> >
> > That would mean that C memory would be maintained on the global (root
> > memcg) LRUs which is the only internal node which is allowed to have
> > resources because it is special.
> Exactly. I would like to have all groups like C which have no parent's
> subtree_control = memory charge memory to root. Under this
> implementation, memory under enabled group will be protected by
> min/low while other groups' memory share the same LRU to have
> workingset things take effect.

One way to achieve that would be shaping the hierarchy the following way
	    root
	/         \
no_memcg[1]      memcg[2]
||||||||         |||||
app_cgroups     app_cgroups

with 
no_memcg.subtree_control = ""
memcg.subtree_control = memory

no?

You haven't really described why you need per application freezer cgroup
but I suspect you want to selectively freeze applications. Is there
any obstacle to have a dedicated frozen cgroup and migrate tasks to be
frozen there?
-- 
Michal Hocko
SUSE Labs
