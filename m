From: Vladimir Davydov <vdavydov.dev@gmail.com>
Subject: Re: [PATCH 0/5] mm: reparent slab memory on cgroup removal
Date: Thu, 18 Apr 2019 11:15:38 +0300
Message-ID: <20190418081538.prspe27lqudvvu3u@esperanza>
References: <20190417215434.25897-1-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=N323ote5HssxsLbgpRKGomemLtnlwkK3ixDMsYVRR2E=;
        b=WMYdzWgQaP+pXUvSIR0Au7VkGGsnRl6OCThTg4EgOhwD8wOevcHwx+wJU11rkan+k9
         mCfqu5ph/kf5FsMAwMRbizVoepAdM6+vYV8m+xe3GqrGQZLrsB5esZVa91DzWZxaG6Ps
         CQI0D1agoPwX01DUSe5CHaLm8J7aoOzub6m+L+4eXpRxTVNMFl63TopOk4asM/HDoQlS
         SIgpzsz5OVI5ASSTTtdc2vJHlGZOiKZr3LDH9KGpW+udXkX4/irjjCCJYf3woOXsCdc+
         bYiVHodrDUaDggrr7a987OZYleMblygMql7e4P6dBn4GyZqk4Q+uLeM0JfRQKuTgb1Yr
         1exA==
Content-Disposition: inline
In-Reply-To: <20190417215434.25897-1-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guroan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Rik van Riel <riel@surriel.com>, david@fromorbit.com, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, cgroups@vger.kernel.org, Roman Gushchin <guro@fb.com>

Hello Roman,

On Wed, Apr 17, 2019 at 02:54:29PM -0700, Roman Gushchin wrote:
> There is however a significant problem with reparenting of slab memory:
> there is no list of charged pages. Some of them are in shrinker lists,
> but not all. Introducing of a new list is really not an option.

True, introducing a list of charged pages would negatively affect
SL[AU]B performance since we would need to protect it with some kind
of lock.

> 
> But fortunately there is a way forward: every slab page has a stable pointer
> to the corresponding kmem_cache. So the idea is to reparent kmem_caches
> instead of slab pages.
> 
> It's actually simpler and cheaper, but requires some underlying changes:
> 1) Make kmem_caches to hold a single reference to the memory cgroup,
>    instead of a separate reference per every slab page.
> 2) Stop setting page->mem_cgroup pointer for memcg slab pages and use
>    page->kmem_cache->memcg indirection instead. It's used only on
>    slab page release, so it shouldn't be a big issue.
> 3) Introduce a refcounter for non-root slab caches. It's required to
>    be able to destroy kmem_caches when they become empty and release
>    the associated memory cgroup.

Which means an unconditional atomic inc/dec on charge/uncharge paths
AFAIU. Note, we have per cpu batching so charging a kmem page in cgroup
v2 doesn't require an atomic variable modification. I guess you could
use some sort of per cpu ref counting though.

Anyway, releasing mem_cgroup objects, but leaving kmem_cache objects
dangling looks kinda awkward to me. It would be great if we could
release both, but I assume it's hardly possible due to SL[AU]B
complexity.

What about reusing dead cgroups instead? Yeah, it would be kinda unfair,
because a fresh cgroup would get a legacy of objects left from previous
owners, but still, if we delete a cgroup, the workload must be dead and
so apart from a few long-lived objects, there should mostly be cached
objects charged to it, which should be easily released on memory
pressure. Sorry if somebody's asked this question before - I must have
missed that.

Thanks,
Vladimir
