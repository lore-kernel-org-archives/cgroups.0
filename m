From: Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v3] mm: Add nodes= arg to memory.reclaim
Date: Tue, 13 Dec 2022 15:03:19 +0100
Message-ID: <Y5iGJ/9PMmSCwqLj@dhcp22.suse.cz>
References: <20221202223533.1785418-1-almasrymina@google.com>
 <Y5bsmpCyeryu3Zz1@dhcp22.suse.cz>
 <CAHS8izM-XdLgFrQ1k13X-4YrK=JGayRXV_G3c3Qh4NLKP7cH_g@mail.gmail.com>
 <87k02volwe.fsf@yhuang6-desk2.ccr.corp.intel.com>
 <Y5h+gHBneexFQcR3@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1670940200; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XKy/NcC13yXOmU25oapyqo2lixJpYFXoptQAq2pSWKk=;
        b=OXYUAfMi2KkrqhWQhsIVfKCRYnn9puhrGfj1DKpChL2k4O+RB+uq/EZhyif4+UQRAMXvNh
        PM2zJr7QsmnppAyzVtHWA6+e2xcA1xU5R6hRRo3HDFKfJZYSdkZ/SkyYWM4bRPZYMh2VoW
        AzNkVq0gLDdu0r4il93PtD7Xrdo8wZw=
Content-Disposition: inline
In-Reply-To: <Y5h+gHBneexFQcR3@cmpxchg.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Huang, Ying" <ying.huang@intel.com>, Mina Almasry <almasrymina@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Jonathan Corbet <corbet@lwn.net>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <songmuchun@bytedance.com>, Andrew Morton <akpm@linux-foundation.org>, Yang Shi <yang.shi@linux.alibaba.com>, Yosry Ahmed <yosryahmed@google.com>, weixugc@google.com, fvdl@google.com, bagasdotme@gmail.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

On Tue 13-12-22 14:30:40, Johannes Weiner wrote:
> On Tue, Dec 13, 2022 at 02:30:57PM +0800, Huang, Ying wrote:
[...]
> > After these discussion, I think the solution maybe use different
> > interfaces for "proactive demote" and "proactive reclaim".  That is,
> > reconsider "memory.demote".  In this way, we will always uncharge the
> > cgroup for "memory.reclaim".  This avoid the possible confusion there.
> > And, because demotion is considered aging, we don't need to disable
> > demotion for "memory.reclaim", just don't count it.
> 
> Hm, so in summary:
> 
> 1) memory.reclaim would demote and reclaim like today, but it would
>    change to only count reclaimed pages against the goal.
> 
> 2) memory.demote would only demote.
> 
>    a) What if the demotion targets are full? Would it reclaim or fail?
> 
> 3) Would memory.reclaim and memory.demote still need nodemasks? Would
>    they return -EINVAL if a) memory.reclaim gets passed only toptier
>    nodes or b) memory.demote gets passed any lasttier nodes?

I would also add
4) Do we want to allow to control the demotion path (e.g. which node to
   demote from and to) and how to achieve that?
5) Is the demotion api restricted to multi-tier systems or any numa
   configuration allowed as well?

-- 
Michal Hocko
SUSE Labs
