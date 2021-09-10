From: Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH memcg] memcg: prohibit unconditional exceeding the limit
 of dying tasks
Date: Fri, 10 Sep 2021 16:55:26 +0200
Message-ID: <YTtx3toUOMLXk4GZ@dhcp22.suse.cz>
References: <5b06a490-55bc-a6a0-6c85-690254f86fad@virtuozzo.com>
 <099aa0db-045a-e5b8-6df7-b7c3fc4d3caa@i-love.sakura.ne.jp>
 <4a407474-ff7a-9e4f-d314-ab85f0eeaadf@virtuozzo.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1631285730; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+I/RKyAZdBWnkeMlKqYdgK786I94mbT861DCEwjnivU=;
        b=iGS3pLMze+lTPJhBlasZr9bVa4g7NW57UckT4cRZ55LS2Hw2TJduxe9gy2IZBOyMjE7ESl
        bh8JVvw24sutkXOH1Kx1aKew708anymj55P6qFBjGvEUhN1QfOOgTRuljZdEHgTXd7l6F1
        hzv3VW98ejTQsu6YOPPwP2cvjzEsJo4=
Content-Disposition: inline
In-Reply-To: <4a407474-ff7a-9e4f-d314-ab85f0eeaadf@virtuozzo.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs@virtuozzo.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>

On Fri 10-09-21 16:20:58, Vasily Averin wrote:
> On 9/10/21 4:04 PM, Tetsuo Handa wrote:
> > On 2021/09/10 21:39, Vasily Averin wrote:
> >> The kernel currently allows dying tasks to exceed the memcg limits.
> >> The allocation is expected to be the last one and the occupied memory
> >> will be freed soon.
> >> This is not always true because it can be part of the huge vmalloc
> >> allocation. Allowed once, they will repeat over and over again.
> >> Moreover lifetime of the allocated object can differ from
> >> In addition the lifetime of the dying task.
> > 
> > Can't we add fatal_signal_pending(current) test to vmalloc() loop?

We can and we should.

> 1) this has been done in the past but has been reverted later.

The reason for that should be addressed IIRC.

> 2) any vmalloc changes will affect non-memcg allocations too.
>  If we're doing memcg-related checks it's better to do it in one place.

I think those two things are just orthogonal. Bailing out from vmalloc
early sounds reasonable to me on its own. Allocating a large thing that
is likely to go away with the allocating context is just a waste of
resources and potential reason to disruptions to others.

> 3) it is not vmalloc-only issue. Huge number of  kmalloc page allocations 
> from N concurrent threads will lead to the same problem. 

Agreed. I do not think it is viable to sprinkle fatal_signal_pending or
similar checks all over the code. This should better be limited to
allocators and the charging function.

Our assumption that is described in the code simply doesn't hold and it
is close to impossible to check all charging paths to bail out properly
so I think we should just remove that optimistic attitude and do not
force charges unless that is absolutely necessary (e.g. __GFP_NOFAIL) or
impractical (e.g. atomic allocations) and bound.

I didn't get to review the patch yet. This is a tricky area with many
unobvious corner cases. I will try find some time next week.

Thanks!
-- 
Michal Hocko
SUSE Labs
