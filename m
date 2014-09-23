From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [patch] mm: memcontrol: lockless page counters
Date: Tue, 23 Sep 2014 13:05:25 -0400
Message-ID: <20140923170525.GA28460@cmpxchg.org>
References: <1411132928-16143-1-git-send-email-hannes@cmpxchg.org>
 <20140922144158.GC20398@esperanza>
 <20140922185736.GB6630@cmpxchg.org>
 <20140923110634.GH18526@esperanza>
 <20140923132801.GA14302@cmpxchg.org>
 <20140923152150.GL18526@esperanza>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20140923152150.GL18526@esperanza>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: linux-mm@kvack.org, Michal Hocko <mhocko@suse.cz>, Greg Thelen <gthelen@google.com>, Dave Hansen <dave@sr71.net>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 07:21:50PM +0400, Vladimir Davydov wrote:
> On Tue, Sep 23, 2014 at 09:28:01AM -0400, Johannes Weiner wrote:
> > On Tue, Sep 23, 2014 at 03:06:34PM +0400, Vladimir Davydov wrote:
> > > On Mon, Sep 22, 2014 at 02:57:36PM -0400, Johannes Weiner wrote:
> > > > On Mon, Sep 22, 2014 at 06:41:58PM +0400, Vladimir Davydov wrote:
> > > > > On Fri, Sep 19, 2014 at 09:22:08AM -0400, Johannes Weiner wrote:
> > > > > > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > > > > > index 19df5d857411..bf8fb1a05597 100644
> > > > > > --- a/include/linux/memcontrol.h
> > > > > > +++ b/include/linux/memcontrol.h
> > > > > > @@ -54,6 +54,38 @@ struct mem_cgroup_reclaim_cookie {
> > > > > >  };
> > > > > >  
> > > > > >  #ifdef CONFIG_MEMCG
> > > > > > +
> > > > > > +struct page_counter {
> > > > > 
> > > > > I'd place it in a separate file, say
> > > > > 
> > > > > 	include/linux/page_counter.h
> > > > > 	mm/page_counter.c
> > > > > 
> > > > > just to keep mm/memcontrol.c clean.
> > > > 
> > > > The page counters are the very core of the memory controller and, as I
> > > > said to Michal, I want to integrate the hugetlb controller into memcg
> > > > as well, at which point there won't be any outside users anymore.  So
> > > > I think this is the right place for it.
> > > 
> > > Hmm, there might be memcg users out there that don't want to pay for
> > > hugetlb accounting. Or is the overhead supposed to be negligible?
> > 
> > Yes.  But if it gets in the way, it creates pressure to optimize it.
> 
> There always will be an overhead no matter how we optimize it.
> 
> I think we should only merge them if it could really help simplify the
> code, for instance if they were dependant on each other. Anyway, I'm not
> an expert in the hugetlb cgroup, so I can't judge whether it's good or
> not. I believe you should raise this topic separately and see if others
> agree with you.

It's not a dependency, it's that there is a lot of redundancy in the
code because they do pretty much the same thing, and ongoing breakage
by stringing such a foreign object along.  Those two things have been
a problem with memcg from the beginning and created a lot of grief.

But I agree that it's a separate topic.  The only question for now is
whether the page counter should be in its own file.  They are pretty
much half of what memory does (account & limit, track & reclaim), so
they are not misplaced in memcontrol.c, and there is one measly user
outside of memcg proper, which is not hurt by having to compile memcg
into the kernel.

> > That's the same reason why I've been trying to integrate memcg into
> > the rest of the VM for over two years now - aside from resulting in
> > much more unified code, it forces us to compete, and it increases our
> > testing exposure by several orders of magnitude.
> > 
> > The only reason we are discussing lockless page counters right now is
> > because we got rid of "memcg specialness" and exposed res_counters to
> > the rest of the world; and boy did that instantly raise the bar on us.
> > 
> > > Anyway, I still don't think it's a good idea to keep all the definitions
> > > in the same file. memcontrol.c is already huge. Adding more code to it
> > > is not desirable, especially if it can naturally live in a separate
> > > file. And since the page_counter is independent of the memcg core and
> > > *looks* generic, I believe we should keep it separately.
> > 
> > It's less code than what I just deleted, and half of it seems
> > redundant when integrated into memcg.  This code would benefit a lot
> > from being part of memcg, and memcg could reduce its public API.
> 
> I think I understand. You are afraid that other users of the
> page_counter will show up one day, and you won't be able to modify its
> API freely. That's reasonable. But we can solve it while still keeping
> page_counter separately. For example, put the header to mm/ and state
> clearly that it's for memcontrol.c and nobody is allowed to use it w/o a
> special permission.
> 
> My point is that it's easier to maintain the code divided in logical
> parts. And page_counter seems to be such a logical part.

It's not about freely changing it, it's that there is no user outside
of memory controlling proper, and there is none in sight.

What makes memcontrol.c hard to deal with is that different things are
interspersed.  The page_counter is in its own little section in there,
and the compiler can optimize and inline the important fastpaths.

> Coming to think about placing page_counter.h to mm/, another question
> springs into my mind. Why do you force kmem.tcp code to use the
> page_counter instead of the res_counter? Nobody seems to use it and it
> should pass away sooner or later. May be it's worth leaving kmem.tcp
> using res_counter? I think we could isolate kmem.tcp under a separate
> config option depending on the RES_COUNTER, and mark them both as
> deprecated somehow.

What we usually do is keep changing deprecated or unused code with
minimal/compile-only testing.  Eventually somebody will notice that
something major broke while doing this but that noone has complained
in months or even years, at which point we remove it.

I'm curious why you reach the conclusion that we should string *more*
code along for unused interfaces, rather than less?

> > > > > > +int page_counter_charge(struct page_counter *counter, unsigned long nr_pages,
> > > > > > +			struct page_counter **fail);
> > > > > > +int page_counter_uncharge(struct page_counter *counter, unsigned long nr_pages);
> > > > > > +int page_counter_limit(struct page_counter *counter, unsigned long limit);
> > > > > 
> > > > > Hmm, why not page_counter_set_limit?
> > > > 
> > > > Limit is used as a verb here, "to limit".  Getters and setters are
> > > > usually wrappers around unusual/complex data structure access,
> > > 
> > > Not necessarily. Look at percpu_counter_read e.g. It's a one-line
> > > getter, which we could easily live w/o, but still it's there.
> > 
> > It abstracts an unusual and error-prone access to a counter value,
> > i.e. reading an unsigned quantity out of a signed variable.
> 
> Wait, percpu_counter_read retval has type s64 and it returns
> percpu_counter->count, which is also s64. So it's a 100% equivalent of
> plain reading of percpu_counter->count.

My bad, I read page_counter instead of percpu_counter.  Nonetheless, I
did add page_counter_read().

> > > > but this function does a lot more, so I'm not fond of _set_limit().
> > > 
> > > Nevertheless, everything it does can be perfectly described in one
> > > sentence "it tries to set the new value of the limit", so it does
> > > function as a setter. And if there's a setter, there must be a getter
> > > IMO.
> > 
> > That's oversimplifying things.  Setting a limit requires enforcing a
> > whole bunch of rules and synchronization, whereas reading a limit is
> > accessing an unsigned long.
> 
> Let's look at percpu_counter once again (excuse me for sticking to it,
> but it seems to be a good example): percpu_counter_set requires
> enforcing a whole bunch of rules and synchronization, whereas reading
> percpu_counter value is accessing an s64. Nevertheless, they're
> *semantically* a getter and a setter. The same is fair for the
> page_counter IMO.
> 
> I don't want to enforce you to introduce the getter, it's not that
> important to me. Just reasoning.

You can always find such comparisons, but the only thing that counts
is the engineering merit, which I don't see for the page limit.

percpu_counter_read() is more obvious, because it's an API that is
expected to be widely used, and the "counter" is actually a complex
data structure.  That accessor might choose to do postprocessing like
underflow or percpu-variance correction at some point, and then it can
change callers all over the tree in a single place.

None of this really applies to the page counter limit, however.

> > > > > >  		break;
> > > > > >  	case RES_FAILCNT:
> > > > > > -		res_counter_reset_failcnt(&h_cg->hugepage[idx]);
> > > > > > +		counter->limited = 0;
> > > > > 
> > > > > page_counter_reset_failcnt?
> > > > 
> > > > That would be more obscure than counter->failcnt = 0, I think.
> > > 
> > > There's one thing that bothers me about this patch. Before, all the
> > > functions operating on res_counter were mutually smp-safe, now they
> > > aren't. E.g. if the failcnt reset races with the falcnt increment from
> > > page_counter_try_charge, the reset might be skipped. You only use the
> > > atomic type for the counter, but my guess is that failcnt and watermark
> > > should be atomic too, at least if we're not going to get rid of them
> > > soon. Otherwise, it should be clearly stated that failcnt and watermark
> > > are racy.
> > 
> > It's fair enough that the raciness should be documented, but both
> > counters are such roundabout metrics to begin with that it really
> > doesn't matter.  What's the difference between a failcnt of 590 and
> > 600 in practical terms?  And what does it matter if the counter
> > watermark is off by a few pages when there are per-cpu caches on top
> > of the counters, and the majority of workloads peg the watermark to
> > the limit during startup anyway?
> 
> Suppose failcnt=42000. The user resets it and gets 42001 instead of 0.
> That's a huge difference.

I guess that's true, but I still have a really hard time caring.  Who
resets this in the middle of ongoing execution?  Who resets this at
all instead of just comparing before/after snapshots, like with all
other mm stats?  And is anybody even using these pointless metrics?

I'm inclined to just put stop_machine() into the reset functions...

> > > > > > +int page_counter_limit(struct page_counter *counter, unsigned long limit)
> > > > > > +{
> > > > > > +	for (;;) {
> > > > > > +		unsigned long count;
> > > > > > +		unsigned long old;
> > > > > > +
> > > > > > +		count = atomic_long_read(&counter->count);
> > > > > > +
> > > > > > +		old = xchg(&counter->limit, limit);
> > > > > > +
> > > > > > +		if (atomic_long_read(&counter->count) != count) {
> > > > > > +			counter->limit = old;
> > > > > 
> > > > > I wonder what can happen if two threads execute this function
> > > > > concurrently... or may be it's not supposed to be smp-safe?
> > > > 
> > > > memcg already holds the set_limit_mutex here.  I updated the tcp and
> > > > hugetlb controllers accordingly to take limit locks as well.
> > > 
> > > I would prefer page_counter to handle it internally, because we won't
> > > need the set_limit_mutex once memsw is converted to plain swap
> > > accounting.
> > >
> > > Besides, memcg_update_kmem_limit doesn't take it. Any chance to
> > > achieve that w/o spinlocks, using only atomic variables?
> > 
> > We still need it to serialize concurrent access to the memory limit,
> > and I updated the patch to have kmem take it as well.  It's such a
> > cold path that using a lockless scheme and worrying about coherency
> > between updates is not worth it, I think.
> 
> OK, it's not that important actually. Please state explicitly in the
> comment to the function definition that it needs external
> synchronization then.

Yeah, I documented everything now.

How about the following update?  Don't be thrown by the
page_counter_cancel(), I went back to it until we find something more
suitable.  But as long as it's documented and has only 1.5 callsites,
it shouldn't matter all that much TBH.

Thanks for your invaluable feedback so far, and sorry if the original
patch was hard to review.  I'll try to break it up, to me it's usually
easier to verify new functions by looking at the callers in the same
patch, but I can probably remove the res_counter in a follow-up patch.

---
From f90a203fd445a7f76c7b273294d4a8f117691d05 Mon Sep 17 00:00:00 2001
From: Johannes Weiner <hannes@cmpxchg.org>
Date: Tue, 23 Sep 2014 11:48:48 -0400
Subject: [patch] mm: memcontrol: lockless page counters fix 2

- page_counter_sub -> page_counter_cancel [johannes]
- document page counter API [vladimir]
- WARN_ON_ONCE and revert on counter underflow [kame]
- convert page_counter_try_charge() from CAS to FAA [vladimir]
---
 include/linux/memcontrol.h |   2 +-
 mm/hugetlb_cgroup.c        |   2 +-
 mm/memcontrol.c            | 100 +++++++++++++++++++++++++++++++++------------
 3 files changed, 76 insertions(+), 28 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index a8b939376a5d..1bda77dff591 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -84,7 +84,7 @@ static inline unsigned long page_counter_read(struct page_counter *counter)
 	return atomic_long_read(&counter->count);
 }
 
-int page_counter_sub(struct page_counter *counter, unsigned long nr_pages);
+int page_counter_cancel(struct page_counter *counter, unsigned long nr_pages);
 void page_counter_charge(struct page_counter *counter, unsigned long nr_pages);
 int page_counter_try_charge(struct page_counter *counter,
 			    unsigned long nr_pages,
diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
index abd1e8dc7b46..aae47a24ec0e 100644
--- a/mm/hugetlb_cgroup.c
+++ b/mm/hugetlb_cgroup.c
@@ -131,7 +131,7 @@ static void hugetlb_cgroup_move_parent(int idx, struct hugetlb_cgroup *h_cg,
 	}
 	counter = &h_cg->hugepage[idx];
 	/* Take the pages off the local counter */
-	page_counter_sub(counter, nr_pages);
+	page_counter_cancel(counter, nr_pages);
 
 	set_hugetlb_cgroup(page, parent);
 out:
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ec2210965686..70839678d805 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -65,18 +65,32 @@
 
 #include <trace/events/vmscan.h>
 
-int page_counter_sub(struct page_counter *counter, unsigned long nr_pages)
+/**
+ * page_counter_cancel - take pages out of the local counter
+ * @counter: counter
+ * @nr_pages: number of pages to cancel
+ *
+ * Returns whether there are remaining pages in the counter.
+ */
+int page_counter_cancel(struct page_counter *counter, unsigned long nr_pages)
 {
 	long new;
 
 	new = atomic_long_sub_return(nr_pages, &counter->count);
 
-	if (WARN_ON(unlikely(new < 0)))
-		atomic_long_set(&counter->count, 0);
+	if (WARN_ON_ONCE(unlikely(new < 0)))
+		atomic_long_add(nr_pages, &counter->count);
 
 	return new > 0;
 }
 
+/**
+ * page_counter_charge - hierarchically charge pages
+ * @counter: counter
+ * @nr_pages: number of pages to charge
+ *
+ * NOTE: This may exceed the configured counter limits.
+ */
 void page_counter_charge(struct page_counter *counter, unsigned long nr_pages)
 {
 	struct page_counter *c;
@@ -91,6 +105,15 @@ void page_counter_charge(struct page_counter *counter, unsigned long nr_pages)
 	}
 }
 
+/**
+ * page_counter_try_charge - try to hierarchically charge pages
+ * @counter: counter
+ * @nr_pages: number of pages to charge
+ * @fail: points first counter to hit its limit, if any
+ *
+ * Returns 0 on success, or -ENOMEM and @fail if the counter or one of
+ * its ancestors has hit its limit.
+ */
 int page_counter_try_charge(struct page_counter *counter,
 			    unsigned long nr_pages,
 			    struct page_counter **fail)
@@ -98,37 +121,44 @@ int page_counter_try_charge(struct page_counter *counter,
 	struct page_counter *c;
 
 	for (c = counter; c; c = c->parent) {
-		for (;;) {
-			long count;
-			long new;
-
-			count = atomic_long_read(&c->count);
-
-			new = count + nr_pages;
-			if (new > c->limit) {
-				c->failcnt++;
-				*fail = c;
-				goto failed;
-			}
-
-			if (atomic_long_cmpxchg(&c->count, count, new) != count)
-				continue;
-
-			if (new > c->watermark)
-				c->watermark = new;
+		long new;
 
-			break;
+		new = atomic_long_add_return(nr_pages, &c->count);
+		if (new > c->limit) {
+			atomic_long_sub(nr_pages, &c->count);
+			/*
+			 * This is racy, but the failcnt is only a
+			 * ballpark metric anyway.
+			 */
+			c->failcnt++;
+			*fail = c;
+			goto failed;
 		}
+		/*
+		 * This is racy, but with the per-cpu caches on top
+		 * this is a ballpark metric as well, and with lazy
+		 * cache reclaim, the majority of workloads peg the
+		 * watermark to the group limit soon after launch.
+		 */
+		if (new > c->watermark)
+			c->watermark = new;
 	}
 	return 0;
 
 failed:
 	for (c = counter; c != *fail; c = c->parent)
-		page_counter_sub(c, nr_pages);
+		page_counter_cancel(c, nr_pages);
 
 	return -ENOMEM;
 }
 
+/**
+ * page_counter_uncharge - hierarchically uncharge pages
+ * @counter: counter
+ * @nr_pages: number of pages to uncharge
+ *
+ * Returns whether there are remaining charges in @counter.
+ */
 int page_counter_uncharge(struct page_counter *counter, unsigned long nr_pages)
 {
 	struct page_counter *c;
@@ -137,7 +167,7 @@ int page_counter_uncharge(struct page_counter *counter, unsigned long nr_pages)
 	for (c = counter; c; c = c->parent) {
 		int remainder;
 
-		remainder = page_counter_sub(c, nr_pages);
+		remainder = page_counter_cancel(c, nr_pages);
 		if (c == counter && !remainder)
 			ret = 0;
 	}
@@ -145,6 +175,16 @@ int page_counter_uncharge(struct page_counter *counter, unsigned long nr_pages)
 	return ret;
 }
 
+/**
+ * page_counter_limit - limit the number of pages allowed
+ * @counter: counter
+ * @limit: limit to set
+ *
+ * Returns 0 on success, -EBUSY if the current number of pages on the
+ * counter already exceeds the specified limit.
+ *
+ * The caller must serialize invocations on the same counter.
+ */
 int page_counter_limit(struct page_counter *counter, unsigned long limit)
 {
 	for (;;) {
@@ -169,6 +209,14 @@ int page_counter_limit(struct page_counter *counter, unsigned long limit)
 	}
 }
 
+/**
+ * page_counter_memparse - memparse() for page counter limits
+ * @buf: string to parse
+ * @nr_pages: returns the result in number of pages
+ *
+ * Returns -EINVAL, or 0 and @nr_pages on success.  @nr_pages will be
+ * limited to %PAGE_COUNTER_MAX.
+ */
 int page_counter_memparse(const char *buf, unsigned long *nr_pages)
 {
 	char unlimited[] = "-1";
@@ -3572,9 +3620,9 @@ static int mem_cgroup_move_parent(struct page *page,
 				pc, child, parent);
 	if (!ret) {
 		/* Take charge off the local counters */
-		page_counter_sub(&child->memory, nr_pages);
+		page_counter_cancel(&child->memory, nr_pages);
 		if (do_swap_account)
-			page_counter_sub(&child->memsw, nr_pages);
+			page_counter_cancel(&child->memsw, nr_pages);
 	}
 
 	if (nr_pages > 1)
-- 
2.1.0


--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
