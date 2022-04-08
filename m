From: Wei Xu <weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH resend] memcg: introduce per-memcg reclaim interface
Date: Thu, 7 Apr 2022 21:10:33 -0700
Message-ID: <CAAPL-u9hVKx=tgSK7DWLxcbpjJ6oRLyyS=3gqXV9VfKcFmELUQ@mail.gmail.com>
References: <20220331084151.2600229-1-yosryahmed@google.com>
 <YkcEMdsi9G5y8mX4@dhcp22.suse.cz> <CAAPL-u_i-Mp-Bo7LtP_4aJscY=1JHG_y1H_-A7N_HRAgtz+arg@mail.gmail.com>
 <87y20nzyw4.fsf@yhuang6-desk2.ccr.corp.intel.com> <CAAPL-u8wjtBRE7KZyZjoQ0eTJecnW35uEXAE3KU0M+AvL=5-ug@mail.gmail.com>
 <87o81fujdc.fsf@yhuang6-desk2.ccr.corp.intel.com> <CAAPL-u_6XqQYtLAMNFvEo+0XU2VR=XYm0T9btL=g6rVVW2h93w@mail.gmail.com>
 <87bkxfudrk.fsf@yhuang6-desk2.ccr.corp.intel.com> <215bd7332aee0ed1092bad4d826a42854ebfd04a.camel@linux.intel.com>
 <CAAPL-u_aAbDOmATSA8ZvjnfBk_7EoXvLoh0etM0fB0aY1845VQ@mail.gmail.com>
 <df6110a09cacc80ee1cbe905a71273a5f3953e16.camel@linux.intel.com>
 <CAAPL-u-oF5HQ26w1czNCmA5VadXOfC54GbGpSppva86YEkefyA@mail.gmail.com> <87y20gtgpf.fsf@yhuang6-desk2.ccr.corp.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kLJsh09usQM6KN7slbu+hDyAz10KLaAr5TuAGBF1ET8=;
        b=gBo+/HbruUwOBKndO6LMcDu/iJv+/tOrAmtZhCfGRubv6KuCygoW0XzqGPxgTnIjUE
         YsTDHr2rrSBBP4YfBA072r25eyCoMDp623Z9qh4T2KJ/8B9Rst7np2vKyRSlZ6aWzWJ9
         ZrVqZ0kipXK2bXR/XkFovvZKgn4UZJfIehQfiXfSUyIkHnZs4TO8t80L0fJfGBfxdQ0e
         Ks3hUVwCWQARQLa89WDBX16qmbJeFLC3C+MqOnQu4ghjjxCkOQcnGZUWk62YF7TAP13I
         8FRV6jbqN0tq1xYnyrUCZVi227qm1C7BkKEQywopeprRzWbJ2f0+P4RyC2+AILgu8SD8
         MUKg==
In-Reply-To: <87y20gtgpf.fsf-fFUE1NP8JkzwuUmzmnQr+vooFf0ArEBIu+b9c/7xato@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Huang, Ying" <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:DOCUMENTATION" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Thu, Apr 7, 2022 at 8:08 PM Huang, Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>
> Wei Xu <weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> writes:
>
> > On Thu, Apr 7, 2022 at 4:11 PM Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
> >>
> >> On Thu, 2022-04-07 at 15:12 -0700, Wei Xu wrote:
> >>
> >> >
> >> > (resending in plain-text, sorry).
> >> >
> >> > memory.demote can work with any level of memory tiers if a nodemask
> >> > argument (or a tier argument if there is a more-explicitly defined,
> >> > userspace visible tiering representation) is provided.  The semantics
> >> > can be to demote X bytes from these nodes to their next tier.
> >> >
> >>
> >> We do need some kind of userspace visible tiering representation.
> >> Will be nice if I can tell the memory type, nodemask of nodes in tier Y with
> >>
> >> cat memory.tier_Y
> >>
> >>
> >> > memory_dram/memory_pmem assumes the hardware for a particular memory
> >> > tier, which is undesirable.  For example, it is entirely possible that
> >> > a slow memory tier is implemented by a lower-cost/lower-performance
> >> > DDR device connected via CXL.mem, not by PMEM.  It is better for this
> >> > interface to speak in either the NUMA node abstraction or a new tier
> >> > abstraction.
> >>
> >> Just from the perspective of memory.reclaim and memory.demote, I think
> >> they could work with nodemask.  For ease of management,
> >> some kind of abstraction of tier information like nodemask, memory type
> >> and expected performance should be readily accessible by user space.
> >>
> >
> > I agree.  The tier information should be provided at the system level.
> > One suggestion is to have a new directory "/sys/devices/system/tier/"
> > for tiers, e.g.:
> >
> > /sys/devices/system/tier/tier0/memlist: all memory nodes in tier 0.
> > /sys/devices/system/tier/tier1/memlist: all memory nodes in tier 1.
>
> I think that it may be sufficient to make tier an attribute of "node".
> Some thing like,
>
> /sys/devices/system/node/nodeX/memory_tier
>

This works. If we want additional information about each tier, we can
then add a tier-specific subtree.

In addition, it would be good to also expose the demotion target nodes
(node_demotion[]) via sysfs, e.g.:

/sys/devices/system/node/nodeX/demotion_path

which returns node_demotion[X].

> Best Regards,
> Huang, Ying
>
> > We can discuss this tier representation in a new thread.
> >
> >> Tim
> >>
> >> >
> >> > It is also desirable to make this interface stateless, i.e. not to
> >> > require the setting of memory_dram.reclaim_policy.  Any policy can be
> >> > specified as arguments to the request itself and should only affect
> >> > that particular request.
> >> >
> >> > Wei
> >>
>
