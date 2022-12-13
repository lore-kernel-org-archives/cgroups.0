From: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3] mm: Add nodes= arg to memory.reclaim
Date: Tue, 13 Dec 2022 11:29:45 -0800
Message-ID: <CAHS8izOuT_-p-N1xPApi+BPJQ+P--2YVSUeiWBROGvGinN0vcg@mail.gmail.com>
References: <20221202223533.1785418-1-almasrymina@google.com>
 <Y5bsmpCyeryu3Zz1@dhcp22.suse.cz> <CAHS8izM-XdLgFrQ1k13X-4YrK=JGayRXV_G3c3Qh4NLKP7cH_g@mail.gmail.com>
 <87k02volwe.fsf@yhuang6-desk2.ccr.corp.intel.com> <Y5h+gHBneexFQcR3@cmpxchg.org>
 <Y5iGJ/9PMmSCwqLj@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=neDu/yrL/JSqlqVsfpnzJOzopkIFlG1Zhb0kcbvbZxE=;
        b=Co3Pb7L35N5xF9xIoLlMGqZks/LFNr4reOf6gCRzOWPQh4D6Vm5kabu8s/xMDPyKTQ
         ErT7zPGS59EnPAPdgJyQICedLFv7aA4I93fBmhAP2ADL50Q9eHAlOZlo25vtmjegw/ry
         HAU2435Dz4h3vUBsm3VLQvKKEmtJOKX/r2zbudg7uWWZR1p0L7HQ6EaBhfUEYyiQowii
         HOgtFY9O2bc1hIO+pd9BTsFuike7L+HqcurRV/1SHITmYxuIlaDBiwdqdX9oEVuyPSVy
         gSxOOgREz2nB1WeQKwxcAlyv2Gup+c5xEjA/7k1NVdA37rZLc/Jyc9dG7iRjCzzmXeEi
         bpFg==
In-Reply-To: <Y5iGJ/9PMmSCwqLj-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "Huang, Ying" <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, fvdl-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, bagasdotme-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Tue, Dec 13, 2022 at 6:03 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
>
> On Tue 13-12-22 14:30:40, Johannes Weiner wrote:
> > On Tue, Dec 13, 2022 at 02:30:57PM +0800, Huang, Ying wrote:
> [...]
> > > After these discussion, I think the solution maybe use different
> > > interfaces for "proactive demote" and "proactive reclaim".  That is,
> > > reconsider "memory.demote".  In this way, we will always uncharge the
> > > cgroup for "memory.reclaim".  This avoid the possible confusion there.
> > > And, because demotion is considered aging, we don't need to disable
> > > demotion for "memory.reclaim", just don't count it.
> >
> > Hm, so in summary:
> >
> > 1) memory.reclaim would demote and reclaim like today, but it would
> >    change to only count reclaimed pages against the goal.
> >
> > 2) memory.demote would only demote.
> >

If the above 2 points are agreeable then yes, this sounds good to me
and does address our use case.

> >    a) What if the demotion targets are full? Would it reclaim or fail?
> >

Wei will chime in if he disagrees, but I think we _require_ that it
fails, not falls back to reclaim. The interface is asking for
demotion, and is called memory.demote. For such an interface to fall
back to reclaim would be very confusing to userspace and may trigger
reclaim on a high priority job that we want to shield from proactive
reclaim.

> > 3) Would memory.reclaim and memory.demote still need nodemasks?

memory.demote will need a nodemask, for sure. Today the nodemask would
be useful if there is a specific node in the top tier that is
overloaded and we want to reduce the pressure by demoting. In the
future there will be N tiers and the nodemask says which tier to
demote from.

I don't think memory.reclaim would need a nodemask anymore? At least I
no longer see the use for it for us.

> >    Would
> >    they return -EINVAL if a) memory.reclaim gets passed only toptier
> >    nodes or b) memory.demote gets passed any lasttier nodes?
>

Honestly it would be great if memory.reclaim can force reclaim from a
top tier nodes. It breaks the aginig pipeline, yes, but if the user is
specifically asking for that because they decided in their usecase
it's a good idea then the kernel should comply IMO. Not a strict
requirement for us. Wei will chime in if he disagrees.

memory.demote returning -EINVAL for lasttier nodes makes sense to me.

> I would also add
> 4) Do we want to allow to control the demotion path (e.g. which node to
>    demote from and to) and how to achieve that?

We care deeply about specifying which node to demote _from_. That
would be some node that is approaching pressure and we're looking for
proactive saving from. So far I haven't seen any reason to control
which nodes to demote _to_. The kernel deciding that based on the
aging pipeline and the node distances sounds good to me. Obviously
someone else may find that useful.

> 5) Is the demotion api restricted to multi-tier systems or any numa
>    configuration allowed as well?
>

demotion will of course not work on single tiered systems. The
interface may return some failure on such systems or not be available
at all.

> --
> Michal Hocko
> SUSE Labs
