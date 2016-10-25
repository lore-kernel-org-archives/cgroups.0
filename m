From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] mm: memcontrol: do not recurse in direct reclaim
Date: Tue, 25 Oct 2016 10:10:50 -0400
Message-ID: <20161025141050.GA13019@cmpxchg.org>
References: <20161024203005.5547-1-hannes@cmpxchg.org>
 <20161025090747.GD31137@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
	; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
	Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=6O7TowjhUk3ipoinM92mwv8qtOv2t9JF3QoGXs8/UgM=; b=cWHDQQF7M/oWLjWPxCTBfPc/EF
	JLYPgQFcnkPcQLllw496PM0j86j14T2aSXFNvAShSaIRR5QL098OT+D3hvOoSzhhJQABGCGrpl599
	27laiD99SiltFsOBEgIVm49DrDyrMoRxvx4/ug3rHF0MvswOlmCpVN0z0tOOvTEUhqY8=;
Content-Disposition: inline
In-Reply-To: <20161025090747.GD31137@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Tejun Heo <tj@kernel.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Tue, Oct 25, 2016 at 11:07:47AM +0200, Michal Hocko wrote:
> Acked-by: Michal Hocko <mhocko@suse.com>

Thank you.

> I would prefer to have the PF_MEMALLOC condition in a check on its own
> with a short explanation that we really do not want to recurse to the
> reclaim due to stack overflows.

Okay, fair enough. I also added why we prefer temporarily breaching
the limit over failing the allocation. How is this?

From 9034d2e6a21036774df9a8e021511720cf432c82 Mon Sep 17 00:00:00 2001
From: Johannes Weiner <hannes@cmpxchg.org>
Date: Mon, 24 Oct 2016 16:01:55 -0400
Subject: [PATCH] mm: memcontrol: do not recurse in direct reclaim

On 4.0, we saw a stack corruption from a page fault entering direct
memory cgroup reclaim, calling into btrfs_releasepage(), which then
tried to allocate an extent and recursed back into a kmem charge ad
nauseam:

[...]
[<ffffffff8136590c>] btrfs_releasepage+0x2c/0x30
[<ffffffff811559a2>] try_to_release_page+0x32/0x50
[<ffffffff81168cea>] shrink_page_list+0x6da/0x7a0
[<ffffffff811693b5>] shrink_inactive_list+0x1e5/0x510
[<ffffffff8116a0a5>] shrink_lruvec+0x605/0x7f0
[<ffffffff8116a37e>] shrink_zone+0xee/0x320
[<ffffffff8116a934>] do_try_to_free_pages+0x174/0x440
[<ffffffff8116adf7>] try_to_free_mem_cgroup_pages+0xa7/0x130
[<ffffffff811b738b>] try_charge+0x17b/0x830
[<ffffffff811bb5b0>] memcg_charge_kmem+0x40/0x80
[<ffffffff811a96a9>] new_slab+0x2d9/0x5a0
[<ffffffff817b2547>] __slab_alloc+0x2fd/0x44f
[<ffffffff811a9b03>] kmem_cache_alloc+0x193/0x1e0
[<ffffffff813801e1>] alloc_extent_state+0x21/0xc0
[<ffffffff813820c5>] __clear_extent_bit+0x2b5/0x400
[<ffffffff81386d03>] try_release_extent_mapping+0x1a3/0x220
[<ffffffff813658a1>] __btrfs_releasepage+0x31/0x70
[<ffffffff8136590c>] btrfs_releasepage+0x2c/0x30
[<ffffffff811559a2>] try_to_release_page+0x32/0x50
[<ffffffff81168cea>] shrink_page_list+0x6da/0x7a0
[<ffffffff811693b5>] shrink_inactive_list+0x1e5/0x510
[<ffffffff8116a0a5>] shrink_lruvec+0x605/0x7f0
[<ffffffff8116a37e>] shrink_zone+0xee/0x320
[<ffffffff8116a934>] do_try_to_free_pages+0x174/0x440
[<ffffffff8116adf7>] try_to_free_mem_cgroup_pages+0xa7/0x130
[<ffffffff811b738b>] try_charge+0x17b/0x830
[<ffffffff811bbfd5>] mem_cgroup_try_charge+0x65/0x1c0
[<ffffffff8118338f>] handle_mm_fault+0x117f/0x1510
[<ffffffff81041cf7>] __do_page_fault+0x177/0x420
[<ffffffff81041fac>] do_page_fault+0xc/0x10
[<ffffffff817c0182>] page_fault+0x22/0x30

On later kernels, kmem charging is opt-in rather than opt-out, and
that particular kmem allocation in btrfs_releasepage() is no longer
being charged and won't recurse and overrun the stack anymore. But
it's not impossible for an accounted allocation to happen from the
memcg direct reclaim context, and we needed to reproduce this crash
many times before we even got a useful stack trace out of it.

Like other direct reclaimers, mark tasks in memcg reclaim PF_MEMALLOC
to avoid recursing into any other form of direct reclaim. Then let
recursive charges from PF_MEMALLOC contexts bypass the cgroup limit.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
---
 mm/memcontrol.c | 9 +++++++++
 mm/vmscan.c     | 2 ++
 2 files changed, 11 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ae052b5e3315..0f870ba43942 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1917,6 +1917,15 @@ static int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
 		     current->flags & PF_EXITING))
 		goto force;
 
+	/*
+	 * Prevent unbounded recursion when reclaim operations need to
+	 * allocate memory. This might exceed the limits temporarily,
+	 * but we prefer facilitating memory reclaim and getting back
+	 * under the limit over triggering OOM kills in these cases.
+	 */
+	if (unlikely(current->flags & PF_MEMALLOC))
+		goto force;
+
 	if (unlikely(task_in_memcg_oom(current)))
 		goto nomem;
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 744f926af442..76fda2268148 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3043,7 +3043,9 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 					    sc.gfp_mask,
 					    sc.reclaim_idx);
 
+	current->flags |= PF_MEMALLOC;
 	nr_reclaimed = do_try_to_free_pages(zonelist, &sc);
+	current->flags &= ~PF_MEMALLOC;
 
 	trace_mm_vmscan_memcg_reclaim_end(nr_reclaimed);
 
-- 
2.10.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
