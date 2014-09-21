From: Vladimir Davydov <vdavydov@parallels.com>
Subject: Re: [patch 0/3] mm: memcontrol: eliminate charge reparenting
Date: Sun, 21 Sep 2014 19:50:43 +0400
Message-ID: <20140921155043.GC32416@esperanza>
References: <1411243235-24680-1-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1411243235-24680-1-git-send-email-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, Michal Hocko <mhocko@suse.cz>, Greg Thelen <gthelen@google.com>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Hi Johannes,

On Sat, Sep 20, 2014 at 04:00:32PM -0400, Johannes Weiner wrote:
> The decoupling of css from the user-visible cgroup, word-sized per-cpu
> css reference counters, and css iterators that include offlined groups
> means we can take per-charge css references, continue to reclaim from
> offlined groups, and so get rid of the error-prone charge reparenting.

I haven't reviewed this set yet, but I agree that zapping user memory
reparenting sounds like a sane idea, because reparenting won't let the
css go in most cases anyway due to swap and kmem charges.

However, I think we must reparent list_lru items, otherwise per-memcg
arrays (kmem_caches, list_lrus) will grow uncontrollably due to dead
css's, which is unacceptable. Note it isn't the same as the user memory
reparenting, because we don't need to reparent kmem_cache objects or
charges - they can stay where they are pinning the css till they are
freed, because the memcg_cache_id, which I want to free on offline, is
not used for kmem allocations/frees after css offline. Actually we only
need to empty the list_lru corresponding to the dead memory cgroup,
which is relatively easy to implement. This is what patch 13 of the "Per
memcg slab shrinkers" patch set, which I sent recently, does (see
https://lkml.org/lkml/2014/9/21/64).

What do you think about it?

Thanks,
Vladimir

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
