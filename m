From: Roman Gushchin <guro@fb.com>
Subject: Re: [RFC] mm: memory.low heirarchical behavior
Date: Thu, 5 Apr 2018 14:54:57 +0100
Message-ID: <20180405135450.GA5396@castle.DHCP.thefacebook.com>
References: <20180320223353.5673-1-guro@fb.com>
 <20180321182308.GA28232@cmpxchg.org>
 <20180321190801.GA22452@castle.DHCP.thefacebook.com>
 <20180404170700.GA2161@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=20tkoYlH5SsD37y2K4OMG3MQOrbK8LJFyl9a8/z0fYk=;
 b=TCxVhLziVpAvlxxCD2yOKr8d0L5Sdd97moK8UFFliSvtG1Ldz2ouCd23EurXtgj39Q66
 kbo+RuBKCISlzEca5jZRGI1/Uq2SrTNuRpaROG3sWFpB3AYjIbiym2fsVla2uIZDhLGQ
 t34Qw2lLhYF6FUzRTbxu7NV+AK2Byt8UAtw= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=20tkoYlH5SsD37y2K4OMG3MQOrbK8LJFyl9a8/z0fYk=;
 b=T1foTL+8mReQ1PwAovtETaAYHrFyzwq/xik7YSrfl3iR+UeBJbqGTbWxtCCSlUQ1DTjnxRQCmu3huD6YKgmk5tQFa5ND2et0CXB2/6WSoUiwaU608WR8wsG/rf7aTT2L63Wo/qoj3L4CTqDVMjHFtJoOdG0hND+0mmdKpEWKz6s=
Content-Disposition: inline
In-Reply-To: <20180404170700.GA2161@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Apr 04, 2018 at 01:07:00PM -0400, Johannes Weiner wrote:
> On Wed, Mar 21, 2018 at 07:08:06PM +0000, Roman Gushchin wrote:
> > > On Tue, Mar 20, 2018 at 10:33:53PM +0000, Roman Gushchin wrote:
> > > > This patch aims to address an issue in current memory.low semantics,
> > > > which makes it hard to use it in a hierarchy, where some leaf memory
> > > > cgroups are more valuable than others.
> > > > 
> > > > For example, there are memcgs A, A/B, A/C, A/D and A/E:
> > > > 
> > > >   A      A/memory.low = 2G, A/memory.current = 6G
> > > >  //\\
> > > > BC  DE   B/memory.low = 3G  B/memory.usage = 2G
> > > >          C/memory.low = 1G  C/memory.usage = 2G
> > > >          D/memory.low = 0   D/memory.usage = 2G
> > > > 	 E/memory.low = 10G E/memory.usage = 0
> > > > 
> > > > If we apply memory pressure, B, C and D are reclaimed at
> > > > the same pace while A's usage exceeds 2G.
> > > > This is obviously wrong, as B's usage is fully below B's memory.low,
> > > > and C has 1G of protection as well.
> > > > Also, A is pushed to the size, which is less than A's 2G memory.low,
> > > > which is also wrong.
> > > > 
> > > > A simple bash script (provided below) can be used to reproduce
> > > > the problem. Current results are:
> > > >   A:    1430097920
> > > >   A/B:  711929856
> > > >   A/C:  717426688
> > > >   A/D:  741376
> > > >   A/E:  0
> > > 
> > > Yes, this is a problem. And the behavior with your patch looks much
> > > preferable over the status quo.
> > > 
> > > > To address the issue a concept of effective memory.low is introduced.
> > > > Effective memory.low is always equal or less than original memory.low.
> > > > In a case, when there is no memory.low overcommittment (and also for
> > > > top-level cgroups), these two values are equal.
> > > > Otherwise it's a part of parent's effective memory.low, calculated as
> > > > a cgroup's memory.low usage divided by sum of sibling's memory.low
> > > > usages (under memory.low usage I mean the size of actually protected
> > > > memory: memory.current if memory.current < memory.low, 0 otherwise).
> > > 
> > > This hurts my brain.
> > > 
> > > Why is memory.current == memory.low (which should fully protect
> > > memory.current) a low usage of 0?
> > > 
> > > Why is memory.current > memory.low not a low usage of memory.low?
> > > 
> > > I.e. shouldn't this be low_usage = min(memory.current, memory.low)?
> > 
> > This is really the non-trivial part.
> > 
> > Let's look at an example:
> > memcg A   (memory.current = 4G, memory.low = 2G)
> > memcg A/B (memory.current = 2G, memory.low = 2G)
> > memcg A/C (memory.current = 2G, memory.low = 1G)
> > 
> > If we'll calculate effective memory.low using your definition
> > before any reclaim, we end up with the following:
> > A/B  2G * 2G / (2G + 1G) = 4/3G
> > A/C  2G * 1G / (2G + 1G) = 2/3G
> > 
> > Looks good, but both cgroups are below their effective limits.
> > When memory pressure is applied, both are reclaimed at the same pace.
> > While both B and C are getting smaller and smaller, their weights
> > and effective low limits are getting closer and closer, but
> > still below their usages. This ends up when both cgroups will
> > have size of 1G, which is obviously wrong.
> > 
> > Fundamentally the problem is that memory.low doesn't define
> > the reclaim speed, just yes or no. So, if there are children cgroups,
> > some of which are below their memory.low, and some above (as in the example),
> > it's crucially important to reclaim unprotected memory first.
> > 
> > This is exactly what my code does: as soon as memory.current is larger
> > than memory.low, we don't treat cgroup's memory as protected at all,
> > so it doesn't affect effective limits of sibling cgroups.
> 
> Okay, that explanation makes sense to me. Once you're in excess, your
> memory is generally unprotected wrt your siblings until you're reigned
> in again.
> 
> It should still be usage <= low rather than usage < low, right? Since
> you're protected up to and including what that number says.
> 
> > > > @@ -1726,6 +1756,7 @@ static void drain_stock(struct memcg_stock_pcp *stock)
> > > >  		page_counter_uncharge(&old->memory, stock->nr_pages);
> > > >  		if (do_memsw_account())
> > > >  			page_counter_uncharge(&old->memsw, stock->nr_pages);
> > > > +		memcg_update_low(old);
> > > >  		css_put_many(&old->css, stock->nr_pages);
> > > >  		stock->nr_pages = 0;
> > > 
> > > The function is called every time the page counter changes and walks
> > > up the hierarchy exactly the same. That is a good sign that the low
> > > usage tracking should really be part of the page counter code itself.
> > 
> > I thought about it, but the problem is that page counters are used for
> > accounting swap, kmem, tcpmem (for v1), where low limit calculations are
> > not applicable. I've no idea, how to add them nicely and without excessive
> > overhead.
> > Also, good news are that it's possible to avoid any tracking until
> > a user actually overcommits memory.low guarantees. I plan to implement
> > this optimization in a separate patch.
> 
> Hm, I'm not too worried about swap (not a sensitive path) or the other
> users (per-cpu batched). It just adds a branch. How about the below?
> 
> diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
> index c15ab80ad32d..95bdbca86751 100644
> --- a/include/linux/page_counter.h
> +++ b/include/linux/page_counter.h
> @@ -9,8 +9,13 @@
>  struct page_counter {
>  	atomic_long_t count;
>  	unsigned long limit;
> +	unsigned long protected;
>  	struct page_counter *parent;
>  
> +	/* Hierarchical, proportional protection */
> +	atomic_long_t protected_count;
> +	atomic_long_t children_protected_count;
> +

I followed your approach, but without introducing the new "protected" term.
It looks cute in the usage tracking part, but a bit weird in mem_cgroup_low(),
and it's not clear how to reuse it for memory.min. I think, we shouldn't
introduce a new term without strict necessity.

Also, I moved the low field from memcg to page_counter, what made
the code simpler and cleaner.

Does it look good to you?

Thanks!

--

From 70175f8370216ccf63454863977ad16c920a6e6b Mon Sep 17 00:00:00 2001
From: Roman Gushchin <guro@fb.com>
Date: Fri, 16 Mar 2018 14:20:15 +0000
Subject: [PATCH] mm: memory.low hierarchical behavior

This patch aims to address an issue in current memory.low semantics,
which makes it hard to use it in a hierarchy, where some leaf memory
cgroups are more valuable than others.

For example, there are memcgs A, A/B, A/C, A/D and A/E:

  A      A/memory.low = 2G, A/memory.current = 6G
 //\\
BC  DE   B/memory.low = 3G  B/memory.current = 2G
         C/memory.low = 1G  C/memory.current = 2G
         D/memory.low = 0   D/memory.current = 2G
	 E/memory.low = 10G E/memory.current = 0

If we apply memory pressure, B, C and D are reclaimed at
the same pace while A's usage exceeds 2G.
This is obviously wrong, as B's usage is fully below B's memory.low,
and C has 1G of protection as well.
Also, A is pushed to the size, which is less than A's 2G memory.low,
which is also wrong.

A simple bash script (provided below) can be used to reproduce
the problem. Current results are:
  A:    1430097920
  A/B:  711929856
  A/C:  717426688
  A/D:  741376
  A/E:  0

To address the issue a concept of effective memory.low is introduced.
Effective memory.low is always equal or less than original memory.low.
In a case, when there is no memory.low overcommittment (and also for
top-level cgroups), these two values are equal.
Otherwise it's a part of parent's effective memory.low, calculated as
a cgroup's memory.low usage divided by sum of sibling's memory.low
usages (under memory.low usage I mean the size of actually protected
memory: memory.current if memory.current < memory.low, 0 otherwise).
It's necessary to track the actual usage, because otherwise an empty
cgroup with memory.low set (A/E in my example) will affect actual
memory distribution, which makes no sense. To avoid traversing
the cgroup tree twice, page_counters code is reused.

Calculating effective memory.low can be done in the reclaim path,
as we conveniently traversing the cgroup tree from top to bottom and
check memory.low on each level. So, it's a perfect place to calculate
effective memory low and save it to use it for children cgroups.

This also eliminates a need to traverse the cgroup tree from bottom
to top each time to check if parent's guarantee is not exceeded.

Setting/resetting effective memory.low is intentionally racy, but
it's fine and shouldn't lead to any significant differences in
actual memory distribution.

With this patch applied results are matching the expectations:
  A:    2140094464
  A/B:  1424838656
  A/C:  714326016
  A/D:  929792
  A/E:  0

Test script:
  #!/bin/bash

  CGPATH="/sys/fs/cgroup"

  truncate /file1 --size 2G
  truncate /file2 --size 2G
  truncate /file3 --size 2G
  truncate /file4 --size 50G

  mkdir "${CGPATH}/A"
  echo "+memory" > "${CGPATH}/A/cgroup.subtree_control"
  mkdir "${CGPATH}/A/B" "${CGPATH}/A/C" "${CGPATH}/A/D" "${CGPATH}/A/E"

  echo 2G > "${CGPATH}/A/memory.low"
  echo 3G > "${CGPATH}/A/B/memory.low"
  echo 1G > "${CGPATH}/A/C/memory.low"
  echo 0 > "${CGPATH}/A/D/memory.low"
  echo 10G > "${CGPATH}/A/E/memory.low"

  echo $$ > "${CGPATH}/A/B/cgroup.procs" && vmtouch -qt /file1
  echo $$ > "${CGPATH}/A/C/cgroup.procs" && vmtouch -qt /file2
  echo $$ > "${CGPATH}/A/D/cgroup.procs" && vmtouch -qt /file3
  echo $$ > "${CGPATH}/cgroup.procs" && vmtouch -qt /file4

  echo "A:   " `cat "${CGPATH}/A/memory.current"`
  echo "A/B: " `cat "${CGPATH}/A/B/memory.current"`
  echo "A/C: " `cat "${CGPATH}/A/C/memory.current"`
  echo "A/D: " `cat "${CGPATH}/A/D/memory.current"`
  echo "A/E: " `cat "${CGPATH}/A/E/memory.current"`

  rmdir "${CGPATH}/A/B" "${CGPATH}/A/C" "${CGPATH}/A/D" "${CGPATH}/A/E"
  rmdir "${CGPATH}/A"
  rm /file1 /file2 /file3 /file4

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
 include/linux/memcontrol.h   |   3 +-
 include/linux/page_counter.h |   7 +++
 mm/memcontrol.c              | 110 +++++++++++++++++++++++++++++++------------
 mm/page_counter.c            |  32 +++++++++++++
 4 files changed, 121 insertions(+), 31 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 44422e1d3def..f1e62cf24ebf 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -178,8 +178,7 @@ struct mem_cgroup {
 	struct page_counter kmem;
 	struct page_counter tcpmem;
 
-	/* Normal memory consumption range */
-	unsigned long low;
+	/* Upper bound of normal memory consumption range */
 	unsigned long high;
 
 	/* Range enforcement for interrupt charges */
diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
index c15ab80ad32d..e916595fb700 100644
--- a/include/linux/page_counter.h
+++ b/include/linux/page_counter.h
@@ -9,8 +9,14 @@
 struct page_counter {
 	atomic_long_t count;
 	unsigned long limit;
+	unsigned long low;
 	struct page_counter *parent;
 
+	/* effective memory.low and memory.low usage tracking */
+	unsigned long elow;
+	atomic_long_t low_usage;
+	atomic_long_t children_low_usage;
+
 	/* legacy */
 	unsigned long watermark;
 	unsigned long failcnt;
@@ -44,6 +50,7 @@ void page_counter_uncharge(struct page_counter *counter, unsigned long nr_pages)
 int page_counter_limit(struct page_counter *counter, unsigned long limit);
 int page_counter_memparse(const char *buf, const char *max,
 			  unsigned long *nr_pages);
+void page_counter_set_low(struct page_counter *counter, unsigned long nr_pages);
 
 static inline void page_counter_reset_watermark(struct page_counter *counter)
 {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 636f3dc7b53a..8f6132625974 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4499,7 +4499,7 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
 	}
 	spin_unlock(&memcg->event_list_lock);
 
-	memcg->low = 0;
+	page_counter_set_low(&memcg->memory, 0);
 
 	memcg_offline_kmem(memcg);
 	wb_memcg_offline(memcg);
@@ -4553,7 +4553,7 @@ static void mem_cgroup_css_reset(struct cgroup_subsys_state *css)
 	page_counter_limit(&memcg->memsw, PAGE_COUNTER_MAX);
 	page_counter_limit(&memcg->kmem, PAGE_COUNTER_MAX);
 	page_counter_limit(&memcg->tcpmem, PAGE_COUNTER_MAX);
-	memcg->low = 0;
+	page_counter_set_low(&memcg->memory, 0);
 	memcg->high = PAGE_COUNTER_MAX;
 	memcg->soft_limit = PAGE_COUNTER_MAX;
 	memcg_wb_domain_size_changed(memcg);
@@ -5293,7 +5293,7 @@ static u64 memory_current_read(struct cgroup_subsys_state *css,
 static int memory_low_show(struct seq_file *m, void *v)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(seq_css(m));
-	unsigned long low = READ_ONCE(memcg->low);
+	unsigned long low = READ_ONCE(memcg->memory.low);
 
 	if (low == PAGE_COUNTER_MAX)
 		seq_puts(m, "max\n");
@@ -5315,7 +5315,7 @@ static ssize_t memory_low_write(struct kernfs_open_file *of,
 	if (err)
 		return err;
 
-	memcg->low = low;
+	page_counter_set_low(&memcg->memory, low);
 
 	return nbytes;
 }
@@ -5612,36 +5612,69 @@ struct cgroup_subsys memory_cgrp_subsys = {
  * @root: the top ancestor of the sub-tree being checked
  * @memcg: the memory cgroup to check
  *
- * Returns %true if memory consumption of @memcg, and that of all
- * ancestors up to (but not including) @root, is below the normal range.
+ * Returns %true if memory consumption of @memcg is below the normal range.
  *
- * @root is exclusive; it is never low when looked at directly and isn't
- * checked when traversing the hierarchy.
+ * @root is exclusive; it is never low when looked at directly
  *
- * Excluding @root enables using memory.low to prioritize memory usage
- * between cgroups within a subtree of the hierarchy that is limited by
- * memory.high or memory.max.
+ * To provide a proper hierarchical behavior, effective memory.low value
+ * is used.
  *
- * For example, given cgroup A with children B and C:
+ * Effective memory.low is always equal or less than the original memory.low.
+ * If there is no memory.low overcommittment (which is always true for
+ * top-level memory cgroups), these two values are equal.
+ * Otherwise, it's a part of parent's effective memory.low,
+ * calculated as a cgroup's memory.low usage divided by sum of sibling's
+ * memory.low usages, where memory.low usage is the size of actually
+ * protected memory.
  *
- *    A
- *   / \
- *  B   C
+ *                                             low_usage
+ * elow = min( memory.low, parent->elow * ------------------ ),
+ *                                        siblings_low_usage
  *
- * and
+ *             | memory.current, if memory.current < memory.low
+ * low_usage = |
+	       | 0, otherwise.
  *
- *  1. A/memory.current > A/memory.high
- *  2. A/B/memory.current < A/B/memory.low
- *  3. A/C/memory.current >= A/C/memory.low
  *
- * As 'A' is high, i.e. triggers reclaim from 'A', and 'B' is low, we
- * should reclaim from 'C' until 'A' is no longer high or until we can
- * no longer reclaim from 'C'.  If 'A', i.e. @root, isn't excluded by
- * mem_cgroup_low when reclaming from 'A', then 'B' won't be considered
- * low and we will reclaim indiscriminately from both 'B' and 'C'.
+ * Such definition of the effective memory.low provides the expected
+ * hierarchical behavior: parent's memory.low value is limiting
+ * children, unprotected memory is reclaimed first and cgroups,
+ * which are not using their guarantee do not affect actual memory
+ * distribution.
+ *
+ * For example, if there are memcgs A, A/B, A/C, A/D and A/E:
+ *
+ *     A      A/memory.low = 2G, A/memory.current = 6G
+ *    //\\
+ *   BC  DE   B/memory.low = 3G  B/memory.current = 2G
+ *            C/memory.low = 1G  C/memory.current = 2G
+ *            D/memory.low = 0   D/memory.current = 2G
+ *            E/memory.low = 10G E/memory.current = 0
+ *
+ * and the memory pressure is applied, the following memory distribution
+ * is expected (approximately):
+ *
+ *     A/memory.current = 2G
+ *
+ *     B/memory.current = 1.3G
+ *     C/memory.current = 0.6G
+ *     D/memory.current = 0
+ *     E/memory.current = 0
+ *
+ * These calculations require constant tracking of the actual low usages
+ * (see propagate_protected()), as well as recursive calculation of
+ * effective memory.low values. But as we do call mem_cgroup_low()
+ * path for each memory cgroup top-down from the reclaim,
+ * it's possible to optimize this part, and save calculated elow
+ * for next usage. This part is intentionally racy, but it's ok,
+ * as memory.low is a best-effort mechanism.
  */
 bool mem_cgroup_low(struct mem_cgroup *root, struct mem_cgroup *memcg)
 {
+	unsigned long usage, low_usage, siblings_low_usage;
+	unsigned long elow, parent_elow;
+	struct mem_cgroup *parent;
+
 	if (mem_cgroup_disabled())
 		return false;
 
@@ -5650,12 +5683,31 @@ bool mem_cgroup_low(struct mem_cgroup *root, struct mem_cgroup *memcg)
 	if (memcg == root)
 		return false;
 
-	for (; memcg != root; memcg = parent_mem_cgroup(memcg)) {
-		if (page_counter_read(&memcg->memory) >= memcg->low)
-			return false;
-	}
+	elow = memcg->memory.low;
+	usage = page_counter_read(&memcg->memory);
 
-	return true;
+	parent = parent_mem_cgroup(memcg);
+	if (parent == root)
+		goto exit;
+
+	parent_elow = READ_ONCE(parent->memory.elow);
+	elow = min(elow, parent_elow);
+
+	if (!elow || !parent_elow)
+		goto exit;
+
+	low_usage = min(usage, memcg->memory.low);
+	siblings_low_usage = atomic_long_read(
+		&parent->memory.children_low_usage);
+	if (!low_usage || !siblings_low_usage)
+		goto exit;
+
+	elow = min(elow, parent_elow * low_usage / siblings_low_usage);
+
+exit:
+	memcg->memory.elow = elow;
+
+	return usage < elow;
 }
 
 /**
diff --git a/mm/page_counter.c b/mm/page_counter.c
index 2a8df3ad60a4..1cba033957d4 100644
--- a/mm/page_counter.c
+++ b/mm/page_counter.c
@@ -13,6 +13,34 @@
 #include <linux/bug.h>
 #include <asm/page.h>
 
+static void propagate_low_usage(struct page_counter *c, unsigned long usage)
+{
+	unsigned long low_usage, old;
+	long delta;
+
+	if (!c->parent)
+		return;
+
+	if (!c->low && !atomic_long_read(&c->low_usage))
+		return;
+
+	if (usage <= c->low)
+		low_usage = usage;
+	else
+		low_usage = 0;
+
+	old = atomic_long_xchg(&c->low_usage, low_usage);
+	delta = low_usage - old;
+	if (delta)
+		atomic_long_add(delta, &c->parent->children_low_usage);
+}
+
+void page_counter_set_low(struct page_counter *c, unsigned long nr_pages)
+{
+	c->low = nr_pages;
+	propagate_low_usage(c, atomic_long_read(&c->count));
+}
+
 /**
  * page_counter_cancel - take pages out of the local counter
  * @counter: counter
@@ -23,6 +51,7 @@ void page_counter_cancel(struct page_counter *counter, unsigned long nr_pages)
 	long new;
 
 	new = atomic_long_sub_return(nr_pages, &counter->count);
+	propagate_low_usage(counter, new);
 	/* More uncharges than charges? */
 	WARN_ON_ONCE(new < 0);
 }
@@ -42,6 +71,7 @@ void page_counter_charge(struct page_counter *counter, unsigned long nr_pages)
 		long new;
 
 		new = atomic_long_add_return(nr_pages, &c->count);
+		propagate_low_usage(counter, new);
 		/*
 		 * This is indeed racy, but we can live with some
 		 * inaccuracy in the watermark.
@@ -85,6 +115,7 @@ bool page_counter_try_charge(struct page_counter *counter,
 		new = atomic_long_add_return(nr_pages, &c->count);
 		if (new > c->limit) {
 			atomic_long_sub(nr_pages, &c->count);
+			propagate_low_usage(counter, new);
 			/*
 			 * This is racy, but we can live with some
 			 * inaccuracy in the failcnt.
@@ -93,6 +124,7 @@ bool page_counter_try_charge(struct page_counter *counter,
 			*fail = c;
 			goto failed;
 		}
+		propagate_low_usage(counter, new);
 		/*
 		 * Just like with failcnt, we can live with some
 		 * inaccuracy in the watermark.
-- 
2.14.3

