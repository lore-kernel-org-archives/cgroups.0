From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v3 3/4] mm: treat memory.low value inclusive
Date: Fri, 6 Apr 2018 13:21:38 +0100
Message-ID: <20180406122132.GA7185@castle>
References: <20180405185921.4942-1-guro@fb.com>
 <20180405185921.4942-3-guro@fb.com>
 <20180405194526.GC27918@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=pPtDANZSiHG9yF4YVpKebRQ2IKfNPZmH1lePnuLIOFM=;
 b=k17xki9I+MTEYp/m+m7OXvFeAfQEiieRRsleo99AMpEYLnaKzVMXIcJeHFfOfxViyzky
 zsVqidMUrgAi0j7A4epsyvGpUogDXOa2H6L8nQNYTR+zLGCExCm+3Sn7AB4t+TD6Y6tQ
 WB8rl3E3j47hhmp83w2COvwVs3WGOmvCi04= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=pPtDANZSiHG9yF4YVpKebRQ2IKfNPZmH1lePnuLIOFM=;
 b=ecgm9sWem44V2LoWzj65dA+KBreiubR00GB3COmKjYnlWZozYoHElaRPeoJBiGbCGKhrSedXbj9jaYKEZx2PBHIFzAXUOZ5KenlNwZopnUaBQlIVTGoBJ7rnAVvIqtqy33vG4vkrTibHSTRrXBrYnaxVyhcKTPkd/oEAbGhX360=
Content-Disposition: inline
In-Reply-To: <20180405194526.GC27918@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Apr 05, 2018 at 03:45:26PM -0400, Johannes Weiner wrote:
> On Thu, Apr 05, 2018 at 07:59:20PM +0100, Roman Gushchin wrote:
> > If memcg's usage is equal to the memory.low value, avoid reclaiming
> > from this cgroup while there is a surplus of reclaimable memory.
> > 
> > This sounds more logical and also matches memory.high and memory.max
> > behavior: both are inclusive.
> 
> I was trying to figure out why we did it this way in the first place
> and found this patch:
> 
> commit 4e54dede38b45052a941bcf709f7d29f2e18174d
> Author: Michal Hocko <mhocko@suse.cz>
> Date:   Fri Feb 27 15:51:46 2015 -0800
> 
>     memcg: fix low limit calculation
>     
>     A memcg is considered low limited even when the current usage is equal to
>     the low limit.  This leads to interesting side effects e.g.
>     groups/hierarchies with no memory accounted are considered protected and
>     so the reclaim will emit MEMCG_LOW event when encountering them.
>     
>     Another and much bigger issue was reported by Joonsoo Kim.  He has hit a
>     NULL ptr dereference with the legacy cgroup API which even doesn't have
>     low limit exposed.  The limit is 0 by default but the initial check fails
>     for memcg with 0 consumption and parent_mem_cgroup() would return NULL if
>     use_hierarchy is 0 and so page_counter_read would try to dereference NULL.
>     
>     I suppose that the current implementation is just an overlook because the
>     documentation in Documentation/cgroups/unified-hierarchy.txt says:
>     
>       "The memory.low boundary on the other hand is a top-down allocated
>       reserve.  A cgroup enjoys reclaim protection when it and all its
>       ancestors are below their low boundaries"
>     
>     Fix the usage and the low limit comparision in mem_cgroup_low accordingly.
>     
> > @@ -5709,7 +5709,7 @@ bool mem_cgroup_low(struct mem_cgroup *root, struct mem_cgroup *memcg)
> >  	elow = min(elow, parent_elow * low_usage / siblings_low_usage);
> >  exit:
> >  	memcg->memory.elow = elow;
> > -	return usage < elow;
> > +	return usage <= elow;
> 
> So I think this needs to be usage && usage <= elow to not emit
> MEMCG_LOW events in case usage == elow == 0.

Perfect catch! Thanks, Johannes!

Updated version below.

--

From 466c35c36cae392cfee5e54a2884792972e789ee Mon Sep 17 00:00:00 2001
From: Roman Gushchin <guro@fb.com>
Date: Thu, 5 Apr 2018 19:31:35 +0100
Subject: [PATCH v4 3/4] mm: treat memory.low value inclusive

If memcg's usage is equal to the memory.low value, avoid reclaiming
from this cgroup while there is a surplus of reclaimable memory.

This sounds more logical and also matches memory.high and memory.max
behavior: both are inclusive.

Empty cgroups are not considered protected, so MEMCG_LOW events
are not emitted for empty cgroups, if there is no more reclaimable
memory in the system.

Signed-off-by: Roman Gushchin <guro@fb.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: kernel-team@fb.com
Cc: linux-mm@kvack.org
Cc: cgroups@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 mm/memcontrol.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 78cf21f2a943..3d039fa1a8f5 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5608,14 +5608,14 @@ struct cgroup_subsys memory_cgrp_subsys = {
 };
 
 /**
- * mem_cgroup_low - check if memory consumption is below the normal range
+ * mem_cgroup_low - check if memory consumption is in the normal range
  * @root: the top ancestor of the sub-tree being checked
  * @memcg: the memory cgroup to check
  *
  * WARNING: This function is not stateless! It can only be used as part
  *          of a top-down tree iteration, not for isolated queries.
  *
- * Returns %true if memory consumption of @memcg is below the normal range.
+ * Returns %true if memory consumption of @memcg is in the normal range.
  *
  * @root is exclusive; it is never low when looked at directly
  *
@@ -5709,7 +5709,7 @@ bool mem_cgroup_low(struct mem_cgroup *root, struct mem_cgroup *memcg)
 	elow = min(elow, parent_elow * low_usage / siblings_low_usage);
 exit:
 	memcg->memory.elow = elow;
-	return usage < elow;
+	return usage && usage <= elow;
 }
 
 /**
-- 
2.14.3

