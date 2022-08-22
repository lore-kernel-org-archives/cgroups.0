From: Soheil Hassas Yeganeh <soheil@google.com>
Subject: Re: [PATCH 2/3] mm: page_counter: rearrange struct page_counter fields
Date: Mon, 22 Aug 2022 09:06:41 -0400
Message-ID: <CACSApvbuKfR8r4OHZ-QHTFaWiSSK8NrHWxmM5TvirFSz7F0GGg@mail.gmail.com>
References: <20220822001737.4120417-1-shakeelb@google.com> <20220822001737.4120417-3-shakeelb@google.com>
 <CACSApvYU5gfbDv9dyaypu1oOPB58eT1inX9EX6gV5b2q3+qr6Q@mail.gmail.com> <CALvZod4r5_vcL4ZcSpR_DdLc_2sppnPTv1DXmFchCULWLu3Riw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=OO/3V/9VOGJvCqjEz1HGxPMCQzQjuOzsv8kdhtCYLqw=;
        b=WKfZw4BbbkDUPDHSI/rvUL2ko1UJNDsiGtR2Rh5cY+gXY86FXqXUlpI3YCUa9Zlr95
         doiBj3WMDGjs5d9/HQhF2bOBYcP49NedwUoBAK6EYdEyPHE7KendVPC6BrVHwbnyfcFx
         K+TNRUSQDBEpAZbQ8LtznwcZXmtdHu37gf0Y5rCMZPXi2aA6DfSlyaTVvJgn8ZQx8fga
         2wOnHBR9ICzQ9My0jtClp2igz/nWW5MJG8Z6aaYBSzs9i858RCTtLmJ5IKhzrKaqimLm
         73w91RWcyTLNjvo9LpSWcYRRwOEjB0IneBYAi+bJ5zDoBzHL2JTVWOgzkGwR/6YxNqIU
         rQtw==
In-Reply-To: <CALvZod4r5_vcL4ZcSpR_DdLc_2sppnPTv1DXmFchCULWLu3Riw@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <songmuchun@bytedance.com>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Eric Dumazet <edumazet@google.com>, Feng Tang <feng.tang@intel.com>, Oliver Sang <oliver.sang@intel.com>, Andrew Morton <akpm@linux-foundation.org>, lkp@lists.01.org, Cgroups <cgroups@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, netdev <netdev@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Mon, Aug 22, 2022 at 12:55 AM Shakeel Butt <shakeelb@google.com> wrote:
>
> On Sun, Aug 21, 2022 at 5:24 PM Soheil Hassas Yeganeh <soheil@google.com> wrote:
> >
> > On Sun, Aug 21, 2022 at 8:18 PM Shakeel Butt <shakeelb@google.com> wrote:
> > >
> > > With memcg v2 enabled, memcg->memory.usage is a very hot member for
> > > the workloads doing memcg charging on multiple CPUs concurrently.
> > > Particularly the network intensive workloads. In addition, there is a
> > > false cache sharing between memory.usage and memory.high on the charge
> > > path. This patch moves the usage into a separate cacheline and move all
> > > the read most fields into separate cacheline.
> > >
> > > To evaluate the impact of this optimization, on a 72 CPUs machine, we
> > > ran the following workload in a three level of cgroup hierarchy with top
> > > level having min and low setup appropriately. More specifically
> > > memory.min equal to size of netperf binary and memory.low double of
> > > that.
> > >
> > >  $ netserver -6
> > >  # 36 instances of netperf with following params
> > >  $ netperf -6 -H ::1 -l 60 -t TCP_SENDFILE -- -m 10K
> > >
> > > Results (average throughput of netperf):
> > > Without (6.0-rc1)       10482.7 Mbps
> > > With patch              12413.7 Mbps (18.4% improvement)
> > >
> > > With the patch, the throughput improved by 18.4%.
> >
> > Shakeel, for my understanding: is this on top of the gains from the
> > previous patch?
> >
>
> No, this is independent of the previous patch. The cover letter has
> the numbers for all three optimizations applied together.

Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
