From: Wei Xu <weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH resend] memcg: introduce per-memcg reclaim interface
Date: Tue, 5 Apr 2022 18:07:49 -0700
Message-ID: <CAAPL-u_6XqQYtLAMNFvEo+0XU2VR=XYm0T9btL=g6rVVW2h93w@mail.gmail.com>
References: <20220331084151.2600229-1-yosryahmed@google.com>
 <YkcEMdsi9G5y8mX4@dhcp22.suse.cz> <CAAPL-u_i-Mp-Bo7LtP_4aJscY=1JHG_y1H_-A7N_HRAgtz+arg@mail.gmail.com>
 <87y20nzyw4.fsf@yhuang6-desk2.ccr.corp.intel.com> <CAAPL-u8wjtBRE7KZyZjoQ0eTJecnW35uEXAE3KU0M+AvL=5-ug@mail.gmail.com>
 <87o81fujdc.fsf@yhuang6-desk2.ccr.corp.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RgvBhB60r34bKOm2tCGx0FLu0SdJzIYZfN+oE6mYW4Y=;
        b=UCNyZ54P2mgXYG0SUsGZv0scK1xaO99fPJQNVGaOcBBfVEqjvQWJbhpUIt9gU/3XWy
         i1AIqrFuz6OljshjkJ4io2XcByq5P5phDtENYPHWUiAXdmExOJbEGf4bnIsPloqvrSVp
         gfVTsJ6ugbeqHqj8t+OgchC3cON2X9yJ4tb8TPAbmr5MyrtpuZFB8QOzD9zlxC7nWjRd
         0djc5eUqkeqQREev7dlWuZK7CObjNQPhXfsRPHPVaMTGnFug9sCPmEJQgAMVooK/KPYU
         auxh5Czx04A5jkdZ/uXqiokinos3NqmfNX1n5/a/CgMMMmh4nQvDTOvQxE4YeRMHkAaZ
         uFdg==
In-Reply-To: <87o81fujdc.fsf-fFUE1NP8JkzwuUmzmnQr+vooFf0ArEBIu+b9c/7xato@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Huang, Ying" <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:DOCUMENTATION" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Tue, Apr 5, 2022 at 5:49 PM Huang, Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>
> Wei Xu <weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> writes:
>
> > On Sat, Apr 2, 2022 at 1:13 AM Huang, Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> >>
> >> Wei Xu <weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> writes:
> >>
> >> > On Fri, Apr 1, 2022 at 6:54 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> >> >>
> >> >> On Thu 31-03-22 08:41:51, Yosry Ahmed wrote:
> >> >> > From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> >> >> >
> >>
> >> [snip]
> >>
> >> >> > Possible Extensions:
> >> >> > --------------------
> >> >> >
> >> >> > - This interface can be extended with an additional parameter or flags
> >> >> >   to allow specifying one or more types of memory to reclaim from (e.g.
> >> >> >   file, anon, ..).
> >> >> >
> >> >> > - The interface can also be extended with a node mask to reclaim from
> >> >> >   specific nodes. This has use cases for reclaim-based demotion in memory
> >> >> >   tiering systens.
> >> >> >
> >> >> > - A similar per-node interface can also be added to support proactive
> >> >> >   reclaim and reclaim-based demotion in systems without memcg.
> >> >> >
> >> >> > For now, let's keep things simple by adding the basic functionality.
> >> >>
> >> >> Yes, I am for the simplicity and this really looks like a bare minumum
> >> >> interface. But it is not really clear who do you want to add flags on
> >> >> top of it?
> >> >>
> >> >> I am not really sure we really need a node aware interface for memcg.
> >> >> The global reclaim interface will likely need a different node because
> >> >> we do not want to make this CONFIG_MEMCG constrained.
> >> >
> >> > A nodemask argument for memory.reclaim can be useful for memory
> >> > tiering between NUMA nodes with different performance.  Similar to
> >> > proactive reclaim, it can allow a userspace daemon to drive
> >> > memcg-based proactive demotion via the reclaim-based demotion
> >> > mechanism in the kernel.
> >>
> >> I am not sure whether nodemask is a good way for demoting pages between
> >> different types of memory.  For example, for a system with DRAM and
> >> PMEM, if specifying DRAM node in nodemask means demoting to PMEM, what
> >> is the meaning of specifying PMEM node? reclaiming to disk?
> >>
> >> In general, I have no objection to the idea in general.  But we should
> >> have a clear and consistent interface.  Per my understanding the default
> >> memcg interface is for memory, regardless of memory types.  The memory
> >> reclaiming means reduce the memory usage, regardless of memory types.
> >> We need to either extending the semantics of memory reclaiming (to
> >> include memory demoting too), or add another interface for memory
> >> demoting.
> >
> > Good point.  With the "demote pages during reclaim" patch series,
> > reclaim is already extended to demote pages as well.  For example,
> > can_reclaim_anon_pages() returns true if demotion is allowed and
> > shrink_page_list() can demote pages instead of reclaiming pages.
>
> These are in-kernel implementation, not the ABI.  So we still have
> the opportunity to define the ABI now.
>
> > Currently, demotion is disabled for memcg reclaim, which I think can
> > be relaxed and also necessary for memcg-based proactive demotion.  I'd
> > like to suggest that we extend the semantics of memory.reclaim to
> > cover memory demotion as well.  A flag can be used to enable/disable
> > the demotion behavior.
>
> If so,
>
> # echo A > memory.reclaim
>
> means
>
> a) "A" bytes memory are freed from the memcg, regardless demoting is
>    used or not.
>
> or
>
> b) "A" bytes memory are reclaimed from the memcg, some of them may be
>    freed, some of them may be just demoted from DRAM to PMEM.  The total
>    number is "A".
>
> For me, a) looks more reasonable.
>

We can use a DEMOTE flag to control the demotion behavior for
memory.reclaim.  If the flag is not set (the default), then
no_demotion of scan_control can be set to 1, similar to
reclaim_pages().

The question is then whether we want to rename memory.reclaim to
something more general.  I think this name is fine if reclaim-based
demotion is an accepted concept.
