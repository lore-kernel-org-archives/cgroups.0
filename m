From: Wei Xu <weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH resend] memcg: introduce per-memcg reclaim interface
Date: Thu, 7 Apr 2022 15:12:19 -0700
Message-ID: <CAAPL-u_aAbDOmATSA8ZvjnfBk_7EoXvLoh0etM0fB0aY1845VQ@mail.gmail.com>
References: <20220331084151.2600229-1-yosryahmed@google.com>
 <YkcEMdsi9G5y8mX4@dhcp22.suse.cz> <CAAPL-u_i-Mp-Bo7LtP_4aJscY=1JHG_y1H_-A7N_HRAgtz+arg@mail.gmail.com>
 <87y20nzyw4.fsf@yhuang6-desk2.ccr.corp.intel.com> <CAAPL-u8wjtBRE7KZyZjoQ0eTJecnW35uEXAE3KU0M+AvL=5-ug@mail.gmail.com>
 <87o81fujdc.fsf@yhuang6-desk2.ccr.corp.intel.com> <CAAPL-u_6XqQYtLAMNFvEo+0XU2VR=XYm0T9btL=g6rVVW2h93w@mail.gmail.com>
 <87bkxfudrk.fsf@yhuang6-desk2.ccr.corp.intel.com> <215bd7332aee0ed1092bad4d826a42854ebfd04a.camel@linux.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=62GjerdaAck66OudlovFMoMWV8LkosnjVIBtISAsTok=;
        b=m2dekUbSBaWg3wdckQk3GkcVHt/A/a6ywrsRC7Zr+OHQ+BkUTgjlNU1vXv6zm/3iaY
         xxadAcipHmqh0C7F0D9EU7NFc5YAb9FZkVSzEL4+O/jx8yrcYGqW9GM2yIaEnMiFbDZr
         Dmeep7sExLjsu4JxhO4DuuelqA5rbJ/3cOSonPHCwi4EREyhTBEYbgVQhFVpUUAxAx2w
         Ut/XMTm8M2y818f4j0tTkICVsLLaYMNiaqyjeMNKx7ad+ovCX2uYckpoN2pt5vcpYAeT
         9tJny/n/6viFNEbAyrkzNAxLHvA8tlWWvcytzOJR1OO7iJWyOtRt4oRyF8WK5s9ke1jL
         DBSg==
In-Reply-To: <215bd7332aee0ed1092bad4d826a42854ebfd04a.camel-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: "Huang, Ying" <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:DOCUMENTATION" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Thu, Apr 7, 2022 at 2:26 PM Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
>
> On Wed, 2022-04-06 at 10:49 +0800, Huang, Ying wrote:
> >
> > > > If so,
> > > >
> > > > # echo A > memory.reclaim
> > > >
> > > > means
> > > >
> > > > a) "A" bytes memory are freed from the memcg, regardless demoting is
> > > >    used or not.
> > > >
> > > > or
> > > >
> > > > b) "A" bytes memory are reclaimed from the memcg, some of them may be
> > > >    freed, some of them may be just demoted from DRAM to PMEM.  The total
> > > >    number is "A".
> > > >
> > > > For me, a) looks more reasonable.
> > > >
> > >
> > > We can use a DEMOTE flag to control the demotion behavior for
> > > memory.reclaim.  If the flag is not set (the default), then
> > > no_demotion of scan_control can be set to 1, similar to
> > > reclaim_pages().
> >
> > If we have to use a flag to control the behavior, I think it's better to
> > have a separate interface (e.g. memory.demote).  But do we really need b)?
> >
> > > The question is then whether we want to rename memory.reclaim to
> > > something more general.  I think this name is fine if reclaim-based
> > > demotion is an accepted concept.
> >
>
> memory.demote will work for 2 level of memory tiers.  But when we have 3 level
> of memory (e.g. high bandwidth memory, DRAM and PMEM),
> it gets ambiguous again of wheter we sould demote from high bandwidth memory
> or DRAM.
>
> Will something like this be more general?
>
> echo X > memory_[dram,pmem,hbm].reclaim
>
> So echo X > memory_dram.reclaim
> means that we want to free up X bytes from DRAM for the mem cgroup.
>
> echo demote > memory_dram.reclaim_policy
>
> This means that we prefer demotion for reclaim instead
> of swapping to disk.
>

(resending in plain-text, sorry).

memory.demote can work with any level of memory tiers if a nodemask
argument (or a tier argument if there is a more-explicitly defined,
userspace visible tiering representation) is provided.  The semantics
can be to demote X bytes from these nodes to their next tier.

memory_dram/memory_pmem assumes the hardware for a particular memory
tier, which is undesirable.  For example, it is entirely possible that
a slow memory tier is implemented by a lower-cost/lower-performance
DDR device connected via CXL.mem, not by PMEM.  It is better for this
interface to speak in either the NUMA node abstraction or a new tier
abstraction.

It is also desirable to make this interface stateless, i.e. not to
require the setting of memory_dram.reclaim_policy.  Any policy can be
specified as arguments to the request itself and should only affect
that particular request.

Wei
