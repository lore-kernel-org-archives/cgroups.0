From: Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH 1/2] mm: memcontrol: remove mem_cgroup_kmem_disabled
Date: Tue, 30 Aug 2022 08:44:57 +0200
Message-ID: <Yw2x6T3xchjpzX7j@dhcp22.suse.cz>
References: <20220830055949.12640-1-ryncsn@gmail.com>
 <20220830055949.12640-2-ryncsn@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1661841897; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aqwnetj8xbUKp5QppMH6N1q9Y/Y7o7+y1Plx+97UHPo=;
        b=HdWK9N8YSyfzISyC1zORz7jOWzLnPpeT8qKNYhP08SyMyCS/7i/QILKBq6O1dwotIJOHl2
        mI34yRsJHN4QT79t3hxHFsnK35Vtajheuv5CeJ/t4XhboAuFlz4WBBiaSUfpDyJvRuZPhN
        /mlH4FOLyd5WRp/ArheHZ/Gk6E1XNmE=
Content-Disposition: inline
In-Reply-To: <20220830055949.12640-2-ryncsn@gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kairui Song <kasong@tencent.com>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <songmuchun@bytedance.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org

On Tue 30-08-22 13:59:48, Kairui Song wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> There are currently two helpers for checking if cgroup kmem
> accounting is enabled:
> 
> - mem_cgroup_kmem_disabled
> - memcg_kmem_enabled

Yes, this is a bit confusing indeed!

> mem_cgroup_kmem_disabled is a simple helper that returns true if
> cgroup.memory=nokmem is specified, otherwise returns false.
> 
> memcg_kmem_enabled is a bit different, it returns true if
> cgroup.memory=nokmem is not specified and there is at least one
> non-root cgroup ever created. And once there is any non-root memcg
> created, it won't go back to return false again.
> 
> This may help improve performance for some corner use cases where
> the user enables memory cgroup and kmem accounting globally but never
> create any cgroup.
> 
> Considering that corner case is rare, especially nowadays cgroup is
> widely used as a standard way to organize services.

Is it really that rare? Most configurations would use a default setup, so
both MEMCG enabled and without nokmem on cmd line yet the memory
controller is not enabled in their setups.

> And the "once
> enabled never disable" behavior is kind of strange. This commit simplifies
> the behavior of memcg_kmem_enabled, making it simply the opposite of
> mem_cgroup_kmem_disabled, always true if cgroup.memory=nokmem is
> not specified. So mem_cgroup_kmem_disabled can be dropped.
> 
> This simplifies the code, and besides, memcg_kmem_enabled makes use
> of static key so it has a lower overhead.

I agree that this is slightly confusing and undocumented. The first step
would be finding out why we need both outside of the memcg proper.

E.g. it doesn't make much sense to me that count_objcg_event uses the
command line variant when it should be using the dynamic (and more
optimized no branch) variant.

On the other hand pcpu_alloc_chunk seems to be different because it can
be called before the controller is enabled but maybe we do not need to
waste memory before that? Similarly new_kmalloc_cache. I suspect these
are mostly to simplify the code and reduce special casing.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  include/linux/memcontrol.h |  8 +-------
>  mm/memcontrol.c            | 17 +++++++----------
>  mm/percpu.c                |  2 +-
>  mm/slab_common.c           |  2 +-
>  4 files changed, 10 insertions(+), 19 deletions(-)

I do not think that saving 9 LOC and sacrifice optimization that might
be useful is a good justification.

-- 
Michal Hocko
SUSE Labs
