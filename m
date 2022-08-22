From: Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH 3/3] memcg: increase MEMCG_CHARGE_BATCH to 64
Date: Mon, 22 Aug 2022 17:22:39 +0200
Message-ID: <YwOfP/6PtS8BxNhz@dhcp22.suse.cz>
References: <20220822001737.4120417-1-shakeelb@google.com>
 <20220822001737.4120417-4-shakeelb@google.com>
 <YwNe3HBxzF+fWb2n@dhcp22.suse.cz>
 <CALvZod5YGVSTvsg25P6goqyGEY21eVnahsXcs2BGsp6OXxLwsg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1661181760; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IOL95PlZNCLCsOY6utFi2W/Xy/Ym149lDYmmjkIy+6w=;
        b=IyPmTXekZSgWSkO6Ocsaaa4F+Y02G7+M18vOfVuoh4O3uhBJCD8ZH+1cqZlJvU4jdFniPV
        9+6meGNjoDCFPRwnCdenjrggEsrFSguaiYkCMCf7WB5JEZeWwxuWtvsr/QLy/Rh9Ra7NOj
        1bM9pHRZwOq3dMJhfmvKE6DStQ+y0DI=
Content-Disposition: inline
In-Reply-To: <CALvZod5YGVSTvsg25P6goqyGEY21eVnahsXcs2BGsp6OXxLwsg@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <songmuchun@bytedance.com>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, Eric Dumazet <edumazet@google.com>, Soheil Hassas Yeganeh <soheil@google.com>, Feng Tang <feng.tang@intel.com>, Oliver Sang <oliver.sang@intel.com>, Andrew Morton <akpm@linux-foundation.org>, lkp@lists.01.org, Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

On Mon 22-08-22 08:09:01, Shakeel Butt wrote:
> On Mon, Aug 22, 2022 at 3:47 AM Michal Hocko <mhocko@suse.com> wrote:
> >
> [...]
> >
> > > To evaluate the impact of this optimization, on a 72 CPUs machine, we
> > > ran the following workload in a three level of cgroup hierarchy with top
> > > level having min and low setup appropriately. More specifically
> > > memory.min equal to size of netperf binary and memory.low double of
> > > that.
> >
> > a similar feedback to the test case description as with other patches.
> 
> What more info should I add to the description? Why did I set up min
> and low or something else?

I do see why you wanted to keep the test consistent over those three
patches. I would just drop the reference to the protection configuration
because it likely doesn't make much of an impact, does it? It is the
multi cpu setup and false sharing that makes the real difference. Or am
I wrong in assuming that?

-- 
Michal Hocko
SUSE Labs
