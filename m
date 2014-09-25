From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [patch] mm: memcontrol: do not iterate uninitialized memcgs
Date: Thu, 25 Sep 2014 09:43:42 -0400
Message-ID: <20140925134342.GB22508@cmpxchg.org>
References: <1411612278-4707-1-git-send-email-hannes@cmpxchg.org>
 <20140925025758.GA6903@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20140925025758.GA6903@mtj.dyndns.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.cz>, Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 10:57:58PM -0400, Tejun Heo wrote:
> Hello,
> 
> On Wed, Sep 24, 2014 at 10:31:18PM -0400, Johannes Weiner wrote:
> ..
> > not meet the ordering requirements for memcg, and so we still may see
> > partially initialized memcgs from the iterators.
> 
> It's mainly the other way around - a fully initialized css may not
> show up in an iteration, but given that there's no memory ordering or
> synchronization around the flag, anything can happen.

Oh sure, I'm just more worried about leaking invalid memcgs rather
than temporarily skipping over a fully initialized one.  But I updated
the changelog to mention both possibilities.

> > +		if (next_css == &root->css ||
> > +		    css_tryget_online(next_css)) {
> > +			struct mem_cgroup *memcg;
> > +
> > +			memcg = mem_cgroup_from_css(next_css);
> > +			if (memcg->initialized) {
> > +				/*
> > +				 * Make sure the caller's accesses to
> > +				 * the memcg members are issued after
> > +				 * we see this flag set.
> 
> I usually prefer if the comment points to the exact location that the
> matching memory barriers live.  Sometimes it's difficult to locate the
> partner barrier even w/ the functional explanation.

That makes sense, updated.

> > +				 */
> > +				smp_rmb();
> > +				return memcg;
> 
> In an unlikely event this rmb becomes an issue, a self-pointing
> pointer which is set/read using smp_store_release() and
> smp_load_acquire() respectively can do with plain barrier() on the
> reader side on archs which don't need data dependency barrier
> (basically everything except alpha).  Not sure whether that'd be more
> or less readable than this tho.

So as far as I understand memory-barriers.txt we do not even need a
data dependency here to use store_release and load_acquire:

mem_cgroup_css_online():
<initialize memcg>
smp_store_release(&memcg->initialized, 1);

mem_cgroup_iter():
<look up maybe-initialized memcg>
if (smp_load_acquire(&memcg->initialized))
  return memcg;

So while I doubt that the smp_rmb() will become a problem in this
path, it would be neat to annotate the state flag around which we
synchronize like this, rather than have an anonymous barrier.

Peter, would you know if this is correct, or whether these primitives
actually do require a data dependency?

Thanks!

Updated patch:

---
From 1cd659f42f399adc58522d478f54587c8c4dd5cc Mon Sep 17 00:00:00 2001
From: Johannes Weiner <hannes@cmpxchg.org>
Date: Wed, 24 Sep 2014 22:00:20 -0400
Subject: [patch] mm: memcontrol: do not iterate uninitialized memcgs

The cgroup iterators yield css objects that have not yet gone through
css_online(), but they are not complete memcgs at this point and so
the memcg iterators should not return them.  d8ad30559715 ("mm/memcg:
iteration skip memcgs not yet fully initialized") set out to implement
exactly this, but it uses CSS_ONLINE, a cgroup-internal flag that does
not meet the ordering requirements for memcg, and so the iterator may
skip over initialized groups, or return partially initialized memcgs.

The cgroup core can not reasonably provide a clear answer on whether
the object around the css has been fully initialized, as that depends
on controller-specific locking and lifetime rules.  Thus, introduce a
memcg-specific flag that is set after the memcg has been initialized
in css_online(), and read before mem_cgroup_iter() callers access the
memcg members.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: <stable@vger.kernel.org>	[3.12+]
---
 mm/memcontrol.c | 36 +++++++++++++++++++++++++++++++-----
 1 file changed, 31 insertions(+), 5 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 306b6470784c..23976fd885fd 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -292,6 +292,9 @@ struct mem_cgroup {
 	/* vmpressure notifications */
 	struct vmpressure vmpressure;
 
+	/* css_online() has been completed */
+	int initialized;
+
 	/*
 	 * the counter to account for mem+swap usage.
 	 */
@@ -1090,10 +1093,21 @@ skip_node:
 	 * skipping css reference should be safe.
 	 */
 	if (next_css) {
-		if ((next_css == &root->css) ||
-		    ((next_css->flags & CSS_ONLINE) &&
-		     css_tryget_online(next_css)))
-			return mem_cgroup_from_css(next_css);
+		struct mem_cgroup *memcg = mem_cgroup_from_css(next_css);
+
+		if (next_css == &root->css)
+			return memcg;
+
+		if (css_tryget_online(next_css)) {
+			/*
+			 * Make sure the memcg is initialized:
+			 * mem_cgroup_css_online() orders the the
+			 * initialization against setting the flag.
+			 */
+			if (smp_load_acquire(&memcg->initialized))
+				return memcg;
+			css_put(next_css);
+		}
 
 		prev_css = next_css;
 		goto skip_node;
@@ -5413,6 +5427,7 @@ mem_cgroup_css_online(struct cgroup_subsys_state *css)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
 	struct mem_cgroup *parent = mem_cgroup_from_css(css->parent);
+	int ret;
 
 	if (css->id > MEM_CGROUP_ID_MAX)
 		return -ENOSPC;
@@ -5449,7 +5464,18 @@ mem_cgroup_css_online(struct cgroup_subsys_state *css)
 	}
 	mutex_unlock(&memcg_create_mutex);
 
-	return memcg_init_kmem(memcg, &memory_cgrp_subsys);
+	ret = memcg_init_kmem(memcg, &memory_cgrp_subsys);
+	if (ret)
+		return ret;
+
+	/*
+	 * Make sure the memcg is initialized: mem_cgroup_iter()
+	 * orders reading memcg->initialized against its callers
+	 * reading the memcg members.
+	 */
+	smp_store_release(&memcg->initialized, 1);
+
+	return 0;
 }
 
 /*
-- 
2.1.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
