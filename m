From: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH v2] mm: Add nodes= arg to memory.reclaim
Date: Thu, 1 Dec 2022 22:24:14 -0800
Message-ID: <CAHS8izPCh+=iUMVP4Xa7FLXc=xtWc7VkLSpk2gugL=f0koBb=Q@mail.gmail.com>
References: <20221130020328.1009347-1-almasrymina@google.com>
 <20221201213202.ycdaymwojd5plyrk@google.com> <CAHS8izOn3Kr8vqxHYxEoGVoCXKmysRKNsvXpJ2EumxDU6JfSDQ@mail.gmail.com>
 <F2917C72-A6F4-4969-B044-211F0D3856F1@linux.dev>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Te7nlf3tgyUNylw2aLfROy5KSdSnYYCg2lheu+/mNdA=;
        b=Art8F8H5odERe6K4OJ3za/Tpr9HcQMtpyUw+7q20j9n80APvjUKLAAlCGf1PtUSU2X
         Nc6j/6jRvymlfAU/yUZQbQCrW/qVUZa6Wfl8kaPO2RHQe5gbo7mi5RM7qWIZuFUVop/U
         g86j/y5PvFCJz08peZHJF2OKYM8EGbJrv7R0Ah8CW8xACEEFrLXA18RhzmSGzhijdNr0
         JZCPDK8PyDAMZOWOrbKygSFcoALwbQzlQu4LgBXoNVfdgnEY8zgoDKsexwFDTrw8Aff2
         X6n0ewZAndF6JrFPEh/du/7DLAQ0hqZb+9wk4dCFJbWMcIXW5LA9PmPbkMTSKQBIpNbh
         M5Xw==
In-Reply-To: <F2917C72-A6F4-4969-B044-211F0D3856F1-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Huang Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, fvdl-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Doc Mailing List <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Thu, Dec 1, 2022 at 10:05 PM Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org> wrote:
>
>
>
> > On Dec 2, 2022, at 06:10, Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> >
> > On Thu, Dec 1, 2022 at 1:32 PM Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> >>
> >> On Tue, Nov 29, 2022 at 06:03:27PM -0800, Mina Almasry wrote:
> >> [...]
> >>> diff --git a/mm/vmscan.c b/mm/vmscan.c
> >>> index 7b8e8e43806b..23fc5b523764 100644
> >>> --- a/mm/vmscan.c
> >>> +++ b/mm/vmscan.c
> >>> @@ -6735,7 +6735,8 @@ unsigned long mem_cgroup_shrink_node(struct mem_cgroup *memcg,
> >>> unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
> >>>                                         unsigned long nr_pages,
> >>>                                         gfp_t gfp_mask,
> >>> -                                        unsigned int reclaim_options)
> >>> +                                        unsigned int reclaim_options,
> >>> +                                        nodemask_t nodemask)
> >>
> >> Can you please make this parameter a nodemask_t* and pass NULL instead
> >> of NODE_MASK_ALL?
> >
> > Thank you very much for the review. I sure can in the next version. To
> > be honest I thought about that and made the parameter nodemask_t
> > because I thought the call sites would be more readable. I.e. this:
> >
> >    try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL,
> > MEMCG_RECLAIM_MAY_SWAP,  NODE_MASK_ALL);
>
> nodemask_t is an array, which can be large depending on CONFIG_NODES_SHIFT.
> I don't think passing a big array is an efficient way. So I agree with Shakeel.
>

Ah, yes, I think the nodemask_t ends up compiling to something like:

typedef struct {
    unsigned long name[BITS_TO_LONGS(MAX_NUMNODES)]
 } nodemask_t;

If it was an array it would be passed by reference anway, but I think
if it is a struct containing an array the array will get copied
indeed. Sure, I will fix in the next version.

> Thanks.
>
> >
> > Would be more readable than this:
> >
> >    try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL,
> > MEMCG_RECLAIM_MAY_SWAP,  NULL);
> >
> > But the tradeoff is that the callers need include/linux/nodemask.h.
> > But yes I can fix in the next version.
> >
>
