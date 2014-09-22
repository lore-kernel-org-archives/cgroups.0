From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [patch] mm: memcontrol: lockless page counters
Date: Mon, 22 Sep 2014 14:57:36 -0400
Message-ID: <20140922185736.GB6630@cmpxchg.org>
References: <1411132928-16143-1-git-send-email-hannes@cmpxchg.org>
 <20140922144158.GC20398@esperanza>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20140922144158.GC20398@esperanza>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: linux-mm@kvack.org, Michal Hocko <mhocko@suse.cz>, Greg Thelen <gthelen@google.com>, Dave Hansen <dave@sr71.net>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Hi Vladimir,

On Mon, Sep 22, 2014 at 06:41:58PM +0400, Vladimir Davydov wrote:
> On Fri, Sep 19, 2014 at 09:22:08AM -0400, Johannes Weiner wrote:
> > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > index 19df5d857411..bf8fb1a05597 100644
> > --- a/include/linux/memcontrol.h
> > +++ b/include/linux/memcontrol.h
> > @@ -54,6 +54,38 @@ struct mem_cgroup_reclaim_cookie {
> >  };
> >  
> >  #ifdef CONFIG_MEMCG
> > +
> > +struct page_counter {
> 
> I'd place it in a separate file, say
> 
> 	include/linux/page_counter.h
> 	mm/page_counter.c
> 
> just to keep mm/memcontrol.c clean.

The page counters are the very core of the memory controller and, as I
said to Michal, I want to integrate the hugetlb controller into memcg
as well, at which point there won't be any outside users anymore.  So
I think this is the right place for it.

> > +	atomic_long_t count;
> > +	unsigned long limit;
> > +	struct page_counter *parent;
> > +
> > +	/* legacy */
> > +	unsigned long watermark;
> > +	unsigned long limited;
> 
> IMHO, failcnt would fit better.

I never liked the failcnt name, but also have to admit that "limited"
is crap.  Let's leave it at failcnt for now.

> > +int page_counter_cancel(struct page_counter *counter, unsigned long nr_pages);
> 
> When I first saw this function, I couldn't realize by looking at its
> name what it's intended to do. I think
> 
> 	page_counter_cancel_local_charge()
> 
> would fit better.

It's a fairly unwieldy name.  How about page_counter_sub()?  local_sub()?

> > +int page_counter_charge(struct page_counter *counter, unsigned long nr_pages,
> > +			struct page_counter **fail);
> > +int page_counter_uncharge(struct page_counter *counter, unsigned long nr_pages);
> > +int page_counter_limit(struct page_counter *counter, unsigned long limit);
> 
> Hmm, why not page_counter_set_limit?

Limit is used as a verb here, "to limit".  Getters and setters are
usually wrappers around unusual/complex data structure access, but
this function does a lot more, so I'm not fond of _set_limit().

> > @@ -1218,34 +1217,26 @@ static inline void memcg_memory_allocated_add(struct cg_proto *prot,
> >  					      unsigned long amt,
> >  					      int *parent_status)
> >  {
> > -	struct res_counter *fail;
> > -	int ret;
> > +	page_counter_charge(&prot->memory_allocated, amt, NULL);
> >  
> > -	ret = res_counter_charge_nofail(&prot->memory_allocated,
> > -					amt << PAGE_SHIFT, &fail);
> > -	if (ret < 0)
> > +	if (atomic_long_read(&prot->memory_allocated.count) >
> > +	    prot->memory_allocated.limit)
> 
> I don't like your equivalent of res_counter_charge_nofail.
> 
> Passing NULL to page_counter_charge might be useful if one doesn't have
> a back-off strategy, but still want to fail on hitting the limit. With
> your interface the user must pass something to the function then, which
> isn't convenient.
> 
> Besides, it depends on the internal implementation of the page_counter
> struct. I'd encapsulate this.

Thinking about this more, I don't like my version either; not because
of how @fail must always be passed, but because of how it changes the
behavior.  I changed the API to

void page_counter_charge(struct page_counter *counter, unsigned long nr_pages);
int page_counter_try_charge(struct page_counter *counter, unsigned long nr_pages,
                            struct page_counter **fail);

We could make @fail optional in the try_charge(), but all callsites
pass it at this time, so for now I kept it mandatory for simplicity.

What do you think?

> > @@ -975,15 +975,8 @@ config CGROUP_CPUACCT
> >  	  Provides a simple Resource Controller for monitoring the
> >  	  total CPU consumed by the tasks in a cgroup.
> >  
> > -config RESOURCE_COUNTERS
> > -	bool "Resource counters"
> > -	help
> > -	  This option enables controller independent resource accounting
> > -	  infrastructure that works with cgroups.
> > -
> >  config MEMCG
> >  	bool "Memory Resource Controller for Control Groups"
> > -	depends on RESOURCE_COUNTERS
> >  	select EVENTFD
> >  	help
> >  	  Provides a memory resource controller that manages both anonymous
> > @@ -1051,7 +1044,7 @@ config MEMCG_KMEM
> >  
> >  config CGROUP_HUGETLB
> >  	bool "HugeTLB Resource Controller for Control Groups"
> > -	depends on RESOURCE_COUNTERS && HUGETLB_PAGE
> > +	depends on MEMCG && HUGETLB_PAGE
> 
> So now the hugetlb controller depends on memcg only because it needs the
> page_counter, which is supposed to be a kind of independent. Is that OK?

As mentioned before, I want to integrate the hugetlb controller into
memcg anyway, so this should be fine, and it keeps things simpler.

> > @@ -222,61 +220,73 @@ void hugetlb_cgroup_uncharge_page(int idx, unsigned long nr_pages,
> >  	if (unlikely(!h_cg))
> >  		return;
> >  	set_hugetlb_cgroup(page, NULL);
> > -	res_counter_uncharge(&h_cg->hugepage[idx], csize);
> > +	page_counter_uncharge(&h_cg->hugepage[idx], nr_pages);
> >  	return;
> >  }
> >  
> >  void hugetlb_cgroup_uncharge_cgroup(int idx, unsigned long nr_pages,
> >  				    struct hugetlb_cgroup *h_cg)
> >  {
> > -	unsigned long csize = nr_pages * PAGE_SIZE;
> > -
> >  	if (hugetlb_cgroup_disabled() || !h_cg)
> >  		return;
> >  
> >  	if (huge_page_order(&hstates[idx]) < HUGETLB_CGROUP_MIN_ORDER)
> >  		return;
> >  
> > -	res_counter_uncharge(&h_cg->hugepage[idx], csize);
> > +	page_counter_uncharge(&h_cg->hugepage[idx], nr_pages);
> >  	return;
> >  }
> >  
> > +enum {
> > +	RES_USAGE,
> > +	RES_LIMIT,
> > +	RES_MAX_USAGE,
> > +	RES_FAILCNT,
> > +};
> > +
> >  static u64 hugetlb_cgroup_read_u64(struct cgroup_subsys_state *css,
> >  				   struct cftype *cft)
> >  {
> > -	int idx, name;
> > +	struct page_counter *counter;
> >  	struct hugetlb_cgroup *h_cg = hugetlb_cgroup_from_css(css);
> >  
> > -	idx = MEMFILE_IDX(cft->private);
> > -	name = MEMFILE_ATTR(cft->private);
> > +	counter = &h_cg->hugepage[MEMFILE_IDX(cft->private)];
> >  
> > -	return res_counter_read_u64(&h_cg->hugepage[idx], name);
> > +	switch (MEMFILE_ATTR(cft->private)) {
> > +	case RES_USAGE:
> > +		return (u64)atomic_long_read(&counter->count) * PAGE_SIZE;
> 
> page_counter_read?
> 
> > +	case RES_LIMIT:
> > +		return (u64)counter->limit * PAGE_SIZE;
> 
> page_counter_get_limit?
> 
> > +	case RES_MAX_USAGE:
> > +		return (u64)counter->watermark * PAGE_SIZE;
> 
> page_counter_read_watermark?

I added page_counter_read() to abstract away the fact that we use a
signed counter internally, but it still returns the number of pages as
unsigned long.

The entire counter API is based on pages now, and only the userspace
interface translates back and forth into bytes, so that's where the
translation should be located.

> >  static ssize_t hugetlb_cgroup_write(struct kernfs_open_file *of,
> >  				    char *buf, size_t nbytes, loff_t off)
> >  {
> > -	int idx, name, ret;
> > -	unsigned long long val;
> > +	int ret, idx;
> > +	unsigned long nr_pages;
> >  	struct hugetlb_cgroup *h_cg = hugetlb_cgroup_from_css(of_css(of));
> >  
> > +	if (hugetlb_cgroup_is_root(h_cg)) /* Can't set limit on root */
> > +		return -EINVAL;
> > +
> >  	buf = strstrip(buf);
> > +	ret = page_counter_memparse(buf, &nr_pages);
> > +	if (ret)
> > +		return ret;
> > +
> >  	idx = MEMFILE_IDX(of_cft(of)->private);
> > -	name = MEMFILE_ATTR(of_cft(of)->private);
> >  
> > -	switch (name) {
> > +	switch (MEMFILE_ATTR(of_cft(of)->private)) {
> >  	case RES_LIMIT:
> > -		if (hugetlb_cgroup_is_root(h_cg)) {
> > -			/* Can't set limit on root */
> > -			ret = -EINVAL;
> > -			break;
> > -		}
> > -		/* This function does all necessary parse...reuse it */
> > -		ret = res_counter_memparse_write_strategy(buf, &val);
> > -		if (ret)
> > -			break;
> > -		val = ALIGN(val, 1ULL << huge_page_shift(&hstates[idx]));
> > -		ret = res_counter_set_limit(&h_cg->hugepage[idx], val);
> > +		nr_pages = ALIGN(nr_pages, huge_page_shift(&hstates[idx]));
> 
> This is incorrect. Here we should have something like:
>
> 	nr_pages = ALIGN(nr_pages, 1UL << huge_page_order(&hstates[idx]));

Good catch, thanks.

> > @@ -288,18 +298,18 @@ static ssize_t hugetlb_cgroup_write(struct kernfs_open_file *of,
> >  static ssize_t hugetlb_cgroup_reset(struct kernfs_open_file *of,
> >  				    char *buf, size_t nbytes, loff_t off)
> >  {
> > -	int idx, name, ret = 0;
> > +	int ret = 0;
> > +	struct page_counter *counter;
> >  	struct hugetlb_cgroup *h_cg = hugetlb_cgroup_from_css(of_css(of));
> >  
> > -	idx = MEMFILE_IDX(of_cft(of)->private);
> > -	name = MEMFILE_ATTR(of_cft(of)->private);
> > +	counter = &h_cg->hugepage[MEMFILE_IDX(of_cft(of)->private)];
> >  
> > -	switch (name) {
> > +	switch (MEMFILE_ATTR(of_cft(of)->private)) {
> >  	case RES_MAX_USAGE:
> > -		res_counter_reset_max(&h_cg->hugepage[idx]);
> > +		counter->watermark = atomic_long_read(&counter->count);
> 
> page_counter_reset_watermark?

Yes, that operation deserves a wrapper.

> >  		break;
> >  	case RES_FAILCNT:
> > -		res_counter_reset_failcnt(&h_cg->hugepage[idx]);
> > +		counter->limited = 0;
> 
> page_counter_reset_failcnt?

That would be more obscure than counter->failcnt = 0, I think.

> > @@ -66,6 +65,117 @@
> >  
> >  #include <trace/events/vmscan.h>
> >  
> > +int page_counter_cancel(struct page_counter *counter, unsigned long nr_pages)
> > +{
> > +	long new;
> > +
> > +	new = atomic_long_sub_return(nr_pages, &counter->count);
> > +
> > +	if (WARN_ON(unlikely(new < 0)))
> 
> Max value on 32 bit is ULONG_MAX, right? Then the WARN_ON is incorrect.

Since this is a page counter, this would overflow at 8 petabyte on 32
bit.  So even though the maximum is ULONG_MAX, in practice we should
never even reach LONG_MAX, and ULONG_MAX was only chosen for backward
compatibility with the default unlimited value.

This is actually not the only place that assumes we never go negative;
the userspace read functions' u64 cast of a long would sign-extend any
negative value and return ludicrous numbers.

But thinking longer about this, it's probably not worth to have these
gotchas in the code just to maintain the default unlimited value.  I
changed PAGE_COUNTER_MAX to LONG_MAX and LONG_MAX / PAGE_SIZE, resp.

> > +		atomic_long_set(&counter->count, 0);
> > +
> > +	return new > 1;
> 
> Nobody outside page_counter internals uses this retval. Why is it public
> then?

kmemcg still uses this for the pinning trick, but I'll update the
patch that removes it to also change the interface.

> BTW, why not new > 0?

That's a plain bug - probably a left-over from rephrasing this
underflow test several times.  Thanks for catching.

> > +int page_counter_charge(struct page_counter *counter, unsigned long nr_pages,
> > +			struct page_counter **fail)
> > +{
> > +	struct page_counter *c;
> > +
> > +	for (c = counter; c; c = c->parent) {
> > +		for (;;) {
> > +			unsigned long count;
> > +			unsigned long new;
> > +
> > +			count = atomic_long_read(&c->count);
> > +
> > +			new = count + nr_pages;
> > +			if (new > c->limit) {
> > +				c->limited++;
> > +				if (fail) {
> 
> So we increase 'limited' even if ain't limited. Sounds weird.

The old code actually did that too, but I removed it now in the
transition to separate charge and try_charge functions.

> > +int page_counter_limit(struct page_counter *counter, unsigned long limit)
> > +{
> > +	for (;;) {
> > +		unsigned long count;
> > +		unsigned long old;
> > +
> > +		count = atomic_long_read(&counter->count);
> > +
> > +		old = xchg(&counter->limit, limit);
> > +
> > +		if (atomic_long_read(&counter->count) != count) {
> > +			counter->limit = old;
> 
> I wonder what can happen if two threads execute this function
> concurrently... or may be it's not supposed to be smp-safe?

memcg already holds the set_limit_mutex here.  I updated the tcp and
hugetlb controllers accordingly to take limit locks as well.

> > @@ -1490,12 +1605,23 @@ int mem_cgroup_inactive_anon_is_low(struct lruvec *lruvec)
> >   */
> >  static unsigned long mem_cgroup_margin(struct mem_cgroup *memcg)
> >  {
> > -	unsigned long long margin;
> 
> Why is it still ULL?

Hm?  This is a removal.  Too many longs...

> > @@ -4155,13 +4255,13 @@ static int memcg_propagate_kmem(struct mem_cgroup *memcg)
> >  	 * after this point, because it has at least one child already.
> >  	 */
> >  	if (memcg_kmem_is_active(parent))
> > -		ret = __memcg_activate_kmem(memcg, RES_COUNTER_MAX);
> > +		ret = __memcg_activate_kmem(memcg, ULONG_MAX);
> 
> PAGE_COUNTER_MAX?

Good catch, thanks.  That was a left-over from several iterations of
trying to find a value that's suitable for both 32 bit and 64 bit.

> > @@ -60,20 +60,17 @@ static int tcp_update_limit(struct mem_cgroup *memcg, u64 val)
> >  	if (!cg_proto)
> >  		return -EINVAL;
> >  
> > -	if (val > RES_COUNTER_MAX)
> > -		val = RES_COUNTER_MAX;
> > -
> > -	ret = res_counter_set_limit(&cg_proto->memory_allocated, val);
> > +	ret = page_counter_limit(&cg_proto->memory_allocated, nr_pages);
> >  	if (ret)
> >  		return ret;
> >  
> >  	for (i = 0; i < 3; i++)
> > -		cg_proto->sysctl_mem[i] = min_t(long, val >> PAGE_SHIFT,
> > +		cg_proto->sysctl_mem[i] = min_t(long, nr_pages,
> >  						sysctl_tcp_mem[i]);
> >  
> > -	if (val == RES_COUNTER_MAX)
> > +	if (nr_pages == ULONG_MAX / PAGE_SIZE)
> 
> PAGE_COUNTER_MAX?

Same.

> > @@ -126,43 +130,35 @@ static ssize_t tcp_cgroup_write(struct kernfs_open_file *of,
> >  	return ret ?: nbytes;
> >  }
> >  
> > -static u64 tcp_read_stat(struct mem_cgroup *memcg, int type, u64 default_val)
> > -{
> > -	struct cg_proto *cg_proto;
> > -
> > -	cg_proto = tcp_prot.proto_cgroup(memcg);
> > -	if (!cg_proto)
> > -		return default_val;
> > -
> > -	return res_counter_read_u64(&cg_proto->memory_allocated, type);
> > -}
> > -
> > -static u64 tcp_read_usage(struct mem_cgroup *memcg)
> > -{
> > -	struct cg_proto *cg_proto;
> > -
> > -	cg_proto = tcp_prot.proto_cgroup(memcg);
> > -	if (!cg_proto)
> > -		return atomic_long_read(&tcp_memory_allocated) << PAGE_SHIFT;
> > -
> > -	return res_counter_read_u64(&cg_proto->memory_allocated, RES_USAGE);
> > -}
> > -
> >  static u64 tcp_cgroup_read(struct cgroup_subsys_state *css, struct cftype *cft)
> >  {
> >  	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
> > +	struct cg_proto *cg_proto = tcp_prot.proto_cgroup(memcg);
> >  	u64 val;
> >  
> >  	switch (cft->private) {
> >  	case RES_LIMIT:
> > -		val = tcp_read_stat(memcg, RES_LIMIT, RES_COUNTER_MAX);
> > +		if (!cg_proto)
> > +			return PAGE_COUNTER_MAX;
> > +		val = cg_proto->memory_allocated.limit;
> > +		val *= PAGE_SIZE;
> >  		break;
> >  	case RES_USAGE:
> > -		val = tcp_read_usage(memcg);
> > +		if (!cg_proto)
> > +			return atomic_long_read(&tcp_memory_allocated);
> 
> Forgot << PAGE_SHIFT?

Yes, indeed.

Thanks for your thorough review, Vladimir!

Here is the delta patch:

---
From 3601538347af756b9bfe05142ab21b5ae44f8cdd Mon Sep 17 00:00:00 2001
From: Johannes Weiner <hannes@cmpxchg.org>
Date: Mon, 22 Sep 2014 13:54:24 -0400
Subject: [patch] mm: memcontrol: lockless page counters fix

- renamed limited to failcnt again [vladimir]
- base page counter range on on LONG_MAX [vladimir]
- page_counter_read() [vladimir]
- page_counter_sub() [vladimir]
- rework the nofail charging [vladimir]
- page_counter_reset_watermark() [vladimir]
- fixed hugepage limit page alignment [vladimir]
- fixed page_counter_sub() return value [vladimir]
- fixed kmem's idea of unlimited [vladimir]
- fixed tcp memcontrol's idea of unlimited [vladimir]
- fixed tcp memcontrol's usage reporting [vladimir]
- serialize page_counter_limit() callsites [vladimir]
---
 include/linux/memcontrol.h |  24 ++++++---
 include/net/sock.h         |   8 +--
 mm/hugetlb_cgroup.c        |  22 ++++----
 mm/memcontrol.c            | 123 +++++++++++++++++++++++++--------------------
 net/ipv4/tcp_memcontrol.c  |  18 ++++---
 5 files changed, 115 insertions(+), 80 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index bf8fb1a05597..a8b939376a5d 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -62,13 +62,13 @@ struct page_counter {
 
 	/* legacy */
 	unsigned long watermark;
-	unsigned long limited;
+	unsigned long failcnt;
 };
 
 #if BITS_PER_LONG == 32
-#define PAGE_COUNTER_MAX ULONG_MAX
+#define PAGE_COUNTER_MAX LONG_MAX
 #else
-#define PAGE_COUNTER_MAX (ULONG_MAX / PAGE_SIZE)
+#define PAGE_COUNTER_MAX (LONG_MAX / PAGE_SIZE)
 #endif
 
 static inline void page_counter_init(struct page_counter *counter,
@@ -79,13 +79,25 @@ static inline void page_counter_init(struct page_counter *counter,
 	counter->parent = parent;
 }
 
-int page_counter_cancel(struct page_counter *counter, unsigned long nr_pages);
-int page_counter_charge(struct page_counter *counter, unsigned long nr_pages,
-			struct page_counter **fail);
+static inline unsigned long page_counter_read(struct page_counter *counter)
+{
+	return atomic_long_read(&counter->count);
+}
+
+int page_counter_sub(struct page_counter *counter, unsigned long nr_pages);
+void page_counter_charge(struct page_counter *counter, unsigned long nr_pages);
+int page_counter_try_charge(struct page_counter *counter,
+			    unsigned long nr_pages,
+			    struct page_counter **fail);
 int page_counter_uncharge(struct page_counter *counter, unsigned long nr_pages);
 int page_counter_limit(struct page_counter *counter, unsigned long limit);
 int page_counter_memparse(const char *buf, unsigned long *nr_pages);
 
+static inline void page_counter_reset_watermark(struct page_counter *counter)
+{
+	counter->watermark = page_counter_read(counter);
+}
+
 int mem_cgroup_try_charge(struct page *page, struct mm_struct *mm,
 			  gfp_t gfp_mask, struct mem_cgroup **memcgp);
 void mem_cgroup_commit_charge(struct page *page, struct mem_cgroup *memcg,
diff --git a/include/net/sock.h b/include/net/sock.h
index f41749982668..9aa435de3ef1 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1217,9 +1217,9 @@ static inline void memcg_memory_allocated_add(struct cg_proto *prot,
 					      unsigned long amt,
 					      int *parent_status)
 {
-	page_counter_charge(&prot->memory_allocated, amt, NULL);
+	page_counter_charge(&prot->memory_allocated, amt);
 
-	if (atomic_long_read(&prot->memory_allocated.count) >
+	if (page_counter_read(&prot->memory_allocated) >
 	    prot->memory_allocated.limit)
 		*parent_status = OVER_LIMIT;
 }
@@ -1236,7 +1236,7 @@ sk_memory_allocated(const struct sock *sk)
 	struct proto *prot = sk->sk_prot;
 
 	if (mem_cgroup_sockets_enabled && sk->sk_cgrp)
-		return atomic_long_read(&sk->sk_cgrp->memory_allocated.count);
+		return page_counter_read(&sk->sk_cgrp->memory_allocated);
 
 	return atomic_long_read(prot->memory_allocated);
 }
@@ -1250,7 +1250,7 @@ sk_memory_allocated_add(struct sock *sk, int amt, int *parent_status)
 		memcg_memory_allocated_add(sk->sk_cgrp, amt, parent_status);
 		/* update the root cgroup regardless */
 		atomic_long_add_return(amt, prot->memory_allocated);
-		return atomic_long_read(&sk->sk_cgrp->memory_allocated.count);
+		return page_counter_read(&sk->sk_cgrp->memory_allocated);
 	}
 
 	return atomic_long_add_return(amt, prot->memory_allocated);
diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
index e619b6b62f1f..abd1e8dc7b46 100644
--- a/mm/hugetlb_cgroup.c
+++ b/mm/hugetlb_cgroup.c
@@ -61,7 +61,7 @@ static inline bool hugetlb_cgroup_have_usage(struct hugetlb_cgroup *h_cg)
 	int idx;
 
 	for (idx = 0; idx < hugetlb_max_hstate; idx++) {
-		if (atomic_long_read(&h_cg->hugepage[idx].count))
+		if (page_counter_read(&h_cg->hugepage[idx]))
 			return true;
 	}
 	return false;
@@ -127,11 +127,11 @@ static void hugetlb_cgroup_move_parent(int idx, struct hugetlb_cgroup *h_cg,
 	if (!parent) {
 		parent = root_h_cgroup;
 		/* root has no limit */
-		page_counter_charge(&parent->hugepage[idx], nr_pages, NULL);
+		page_counter_charge(&parent->hugepage[idx], nr_pages);
 	}
 	counter = &h_cg->hugepage[idx];
 	/* Take the pages off the local counter */
-	page_counter_cancel(counter, nr_pages);
+	page_counter_sub(counter, nr_pages);
 
 	set_hugetlb_cgroup(page, parent);
 out:
@@ -186,7 +186,7 @@ again:
 	}
 	rcu_read_unlock();
 
-	ret = page_counter_charge(&h_cg->hugepage[idx], nr_pages, &counter);
+	ret = page_counter_try_charge(&h_cg->hugepage[idx], nr_pages, &counter);
 	css_put(&h_cg->css);
 done:
 	*ptr = h_cg;
@@ -254,18 +254,20 @@ static u64 hugetlb_cgroup_read_u64(struct cgroup_subsys_state *css,
 
 	switch (MEMFILE_ATTR(cft->private)) {
 	case RES_USAGE:
-		return (u64)atomic_long_read(&counter->count) * PAGE_SIZE;
+		return (u64)page_counter_read(counter) * PAGE_SIZE;
 	case RES_LIMIT:
 		return (u64)counter->limit * PAGE_SIZE;
 	case RES_MAX_USAGE:
 		return (u64)counter->watermark * PAGE_SIZE;
 	case RES_FAILCNT:
-		return counter->limited;
+		return counter->failcnt;
 	default:
 		BUG();
 	}
 }
 
+static DEFINE_MUTEX(hugetlb_limit_mutex);
+
 static ssize_t hugetlb_cgroup_write(struct kernfs_open_file *of,
 				    char *buf, size_t nbytes, loff_t off)
 {
@@ -285,8 +287,10 @@ static ssize_t hugetlb_cgroup_write(struct kernfs_open_file *of,
 
 	switch (MEMFILE_ATTR(of_cft(of)->private)) {
 	case RES_LIMIT:
-		nr_pages = ALIGN(nr_pages, huge_page_shift(&hstates[idx]));
+		nr_pages = ALIGN(nr_pages, 1UL<<huge_page_order(&hstates[idx]));
+		mutex_lock(&hugetlb_limit_mutex);
 		ret = page_counter_limit(&h_cg->hugepage[idx], nr_pages);
+		mutex_unlock(&hugetlb_limit_mutex);
 		break;
 	default:
 		ret = -EINVAL;
@@ -306,10 +310,10 @@ static ssize_t hugetlb_cgroup_reset(struct kernfs_open_file *of,
 
 	switch (MEMFILE_ATTR(of_cft(of)->private)) {
 	case RES_MAX_USAGE:
-		counter->watermark = atomic_long_read(&counter->count);
+		page_counter_reset_watermark(counter);
 		break;
 	case RES_FAILCNT:
-		counter->limited = 0;
+		counter->failcnt = 0;
 		break;
 	default:
 		ret = -EINVAL;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index dfd3b15a57e8..9dec20b3c928 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -65,7 +65,7 @@
 
 #include <trace/events/vmscan.h>
 
-int page_counter_cancel(struct page_counter *counter, unsigned long nr_pages)
+int page_counter_sub(struct page_counter *counter, unsigned long nr_pages)
 {
 	long new;
 
@@ -74,28 +74,41 @@ int page_counter_cancel(struct page_counter *counter, unsigned long nr_pages)
 	if (WARN_ON(unlikely(new < 0)))
 		atomic_long_set(&counter->count, 0);
 
-	return new > 1;
+	return new > 0;
 }
 
-int page_counter_charge(struct page_counter *counter, unsigned long nr_pages,
-			struct page_counter **fail)
+void page_counter_charge(struct page_counter *counter, unsigned long nr_pages)
+{
+	struct page_counter *c;
+
+	for (c = counter; c; c = c->parent) {
+		long new;
+
+		new = atomic_long_add_return(nr_pages, &c->count);
+
+		if (new > c->watermark)
+			c->watermark = new;
+	}
+}
+
+int page_counter_try_charge(struct page_counter *counter,
+			    unsigned long nr_pages,
+			    struct page_counter **fail)
 {
 	struct page_counter *c;
 
 	for (c = counter; c; c = c->parent) {
 		for (;;) {
-			unsigned long count;
-			unsigned long new;
+			long count;
+			long new;
 
 			count = atomic_long_read(&c->count);
 
 			new = count + nr_pages;
 			if (new > c->limit) {
-				c->limited++;
-				if (fail) {
-					*fail = c;
-					goto failed;
-				}
+				c->failcnt++;
+				*fail = c;
+				goto failed;
 			}
 
 			if (atomic_long_cmpxchg(&c->count, count, new) != count)
@@ -111,7 +124,7 @@ int page_counter_charge(struct page_counter *counter, unsigned long nr_pages,
 
 failed:
 	for (c = counter; c != *fail; c = c->parent)
-		page_counter_cancel(c, nr_pages);
+		page_counter_sub(c, nr_pages);
 
 	return -ENOMEM;
 }
@@ -124,7 +137,7 @@ int page_counter_uncharge(struct page_counter *counter, unsigned long nr_pages)
 	for (c = counter; c; c = c->parent) {
 		int remainder;
 
-		remainder = page_counter_cancel(c, nr_pages);
+		remainder = page_counter_sub(c, nr_pages);
 		if (c == counter && !remainder)
 			ret = 0;
 	}
@@ -135,8 +148,8 @@ int page_counter_uncharge(struct page_counter *counter, unsigned long nr_pages)
 int page_counter_limit(struct page_counter *counter, unsigned long limit)
 {
 	for (;;) {
-		unsigned long count;
 		unsigned long old;
+		long count;
 
 		count = atomic_long_read(&counter->count);
 
@@ -751,7 +764,7 @@ static void disarm_kmem_keys(struct mem_cgroup *memcg)
 	 * This check can't live in kmem destruction function,
 	 * since the charges will outlive the cgroup
 	 */
-	WARN_ON(atomic_long_read(&memcg->kmem.count));
+	WARN_ON(page_counter_read(&memcg->kmem));
 }
 #else
 static void disarm_kmem_keys(struct mem_cgroup *memcg)
@@ -858,7 +871,7 @@ static void mem_cgroup_remove_exceeded(struct mem_cgroup_per_zone *mz,
 
 static unsigned long soft_limit_excess(struct mem_cgroup *memcg)
 {
-	unsigned long nr_pages = atomic_long_read(&memcg->memory.count);
+	unsigned long nr_pages = page_counter_read(&memcg->memory);
 	unsigned long soft_limit = ACCESS_ONCE(memcg->soft_limit);
 	unsigned long excess = 0;
 
@@ -1609,13 +1622,13 @@ static unsigned long mem_cgroup_margin(struct mem_cgroup *memcg)
 	unsigned long count;
 	unsigned long limit;
 
-	count = atomic_long_read(&memcg->memory.count);
+	count = page_counter_read(&memcg->memory);
 	limit = ACCESS_ONCE(memcg->memory.limit);
 	if (count < limit)
 		margin = limit - count;
 
 	if (do_swap_account) {
-		count = atomic_long_read(&memcg->memsw.count);
+		count = page_counter_read(&memcg->memsw);
 		limit = ACCESS_ONCE(memcg->memsw.limit);
 		if (count < limit)
 			margin = min(margin, limit - count);
@@ -1763,14 +1776,14 @@ void mem_cgroup_print_oom_info(struct mem_cgroup *memcg, struct task_struct *p)
 	rcu_read_unlock();
 
 	pr_info("memory: usage %llukB, limit %llukB, failcnt %lu\n",
-		K((u64)atomic_long_read(&memcg->memory.count)),
-		K((u64)memcg->memory.limit), memcg->memory.limited);
+		K((u64)page_counter_read(&memcg->memory)),
+		K((u64)memcg->memory.limit), memcg->memory.failcnt);
 	pr_info("memory+swap: usage %llukB, limit %llukB, failcnt %lu\n",
-		K((u64)atomic_long_read(&memcg->memsw.count)),
-		K((u64)memcg->memsw.limit), memcg->memsw.limited);
+		K((u64)page_counter_read(&memcg->memsw)),
+		K((u64)memcg->memsw.limit), memcg->memsw.failcnt);
 	pr_info("kmem: usage %llukB, limit %llukB, failcnt %lu\n",
-		K((u64)atomic_long_read(&memcg->kmem.count)),
-		K((u64)memcg->kmem.limit), memcg->kmem.limited);
+		K((u64)page_counter_read(&memcg->kmem)),
+		K((u64)memcg->kmem.limit), memcg->kmem.failcnt);
 
 	for_each_mem_cgroup_tree(iter, memcg) {
 		pr_info("Memory cgroup stats for ");
@@ -2604,10 +2617,10 @@ retry:
 	if (consume_stock(memcg, nr_pages))
 		goto done;
 
-	if (!page_counter_charge(&memcg->memory, batch, &counter)) {
+	if (!page_counter_try_charge(&memcg->memory, batch, &counter)) {
 		if (!do_swap_account)
 			goto done_restock;
-		if (!page_counter_charge(&memcg->memsw, batch, &counter))
+		if (!page_counter_try_charge(&memcg->memsw, batch, &counter))
 			goto done_restock;
 		page_counter_uncharge(&memcg->memory, batch);
 		mem_over_limit = mem_cgroup_from_counter(counter, memsw);
@@ -2877,7 +2890,7 @@ static int memcg_charge_kmem(struct mem_cgroup *memcg, gfp_t gfp,
 	struct page_counter *counter;
 	int ret = 0;
 
-	ret = page_counter_charge(&memcg->kmem, nr_pages, &counter);
+	ret = page_counter_try_charge(&memcg->kmem, nr_pages, &counter);
 	if (ret < 0)
 		return ret;
 
@@ -2898,9 +2911,9 @@ static int memcg_charge_kmem(struct mem_cgroup *memcg, gfp_t gfp,
 		 * when the allocation triggers should have been already
 		 * directed to the root cgroup in memcontrol.h
 		 */
-		page_counter_charge(&memcg->memory, nr_pages, NULL);
+		page_counter_charge(&memcg->memory, nr_pages);
 		if (do_swap_account)
-			page_counter_charge(&memcg->memsw, nr_pages, NULL);
+			page_counter_charge(&memcg->memsw, nr_pages);
 		ret = 0;
 	} else if (ret)
 		page_counter_uncharge(&memcg->kmem, nr_pages);
@@ -3558,9 +3571,9 @@ static int mem_cgroup_move_parent(struct page *page,
 				pc, child, parent);
 	if (!ret) {
 		/* Take charge off the local counters */
-		page_counter_cancel(&child->memory, nr_pages);
+		page_counter_sub(&child->memory, nr_pages);
 		if (do_swap_account)
-			page_counter_cancel(&child->memsw, nr_pages);
+			page_counter_sub(&child->memsw, nr_pages);
 	}
 
 	if (nr_pages > 1)
@@ -3665,7 +3678,7 @@ void mem_cgroup_print_bad_page(struct page *page)
 }
 #endif
 
-static DEFINE_MUTEX(set_limit_mutex);
+static DEFINE_MUTEX(memcg_limit_mutex);
 
 static int mem_cgroup_resize_limit(struct mem_cgroup *memcg,
 				   unsigned long limit)
@@ -3684,7 +3697,7 @@ static int mem_cgroup_resize_limit(struct mem_cgroup *memcg,
 	retry_count = MEM_CGROUP_RECLAIM_RETRIES *
 		      mem_cgroup_count_children(memcg);
 
-	oldusage = atomic_long_read(&memcg->memory.count);
+	oldusage = page_counter_read(&memcg->memory);
 
 	do {
 		if (signal_pending(current)) {
@@ -3692,23 +3705,23 @@ static int mem_cgroup_resize_limit(struct mem_cgroup *memcg,
 			break;
 		}
 
-		mutex_lock(&set_limit_mutex);
+		mutex_lock(&memcg_limit_mutex);
 		if (limit > memcg->memsw.limit) {
-			mutex_unlock(&set_limit_mutex);
+			mutex_unlock(&memcg_limit_mutex);
 			ret = -EINVAL;
 			break;
 		}
 		if (limit > memcg->memory.limit)
 			enlarge = true;
 		ret = page_counter_limit(&memcg->memory, limit);
-		mutex_unlock(&set_limit_mutex);
+		mutex_unlock(&memcg_limit_mutex);
 
 		if (!ret)
 			break;
 
 		try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL, true);
 
-		curusage = atomic_long_read(&memcg->memory.count);
+		curusage = page_counter_read(&memcg->memory);
 		/* Usage is reduced ? */
 		if (curusage >= oldusage)
 			retry_count--;
@@ -3735,7 +3748,7 @@ static int mem_cgroup_resize_memsw_limit(struct mem_cgroup *memcg,
 	retry_count = MEM_CGROUP_RECLAIM_RETRIES *
 		      mem_cgroup_count_children(memcg);
 
-	oldusage = atomic_long_read(&memcg->memsw.count);
+	oldusage = page_counter_read(&memcg->memsw);
 
 	do {
 		if (signal_pending(current)) {
@@ -3743,23 +3756,23 @@ static int mem_cgroup_resize_memsw_limit(struct mem_cgroup *memcg,
 			break;
 		}
 
-		mutex_lock(&set_limit_mutex);
+		mutex_lock(&memcg_limit_mutex);
 		if (limit < memcg->memory.limit) {
-			mutex_unlock(&set_limit_mutex);
+			mutex_unlock(&memcg_limit_mutex);
 			ret = -EINVAL;
 			break;
 		}
 		if (limit > memcg->memsw.limit)
 			enlarge = true;
 		ret = page_counter_limit(&memcg->memsw, limit);
-		mutex_unlock(&set_limit_mutex);
+		mutex_unlock(&memcg_limit_mutex);
 
 		if (!ret)
 			break;
 
 		try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL, false);
 
-		curusage = atomic_long_read(&memcg->memsw.count);
+		curusage = page_counter_read(&memcg->memsw);
 		/* Usage is reduced ? */
 		if (curusage >= oldusage)
 			retry_count--;
@@ -3960,8 +3973,8 @@ static void mem_cgroup_reparent_charges(struct mem_cgroup *memcg)
 		 * right after the check. RES_USAGE should be safe as we always
 		 * charge before adding to the LRU.
 		 */
-	} while (atomic_long_read(&memcg->memory.count) -
-		 atomic_long_read(&memcg->kmem.count) > 0);
+	} while (page_counter_read(&memcg->memory) -
+		 page_counter_read(&memcg->kmem) > 0);
 }
 
 /*
@@ -4001,7 +4014,7 @@ static int mem_cgroup_force_empty(struct mem_cgroup *memcg)
 	/* we call try-to-free pages for make this cgroup empty */
 	lru_add_drain_all();
 	/* try to free all pages in this cgroup */
-	while (nr_retries && atomic_long_read(&memcg->memory.count)) {
+	while (nr_retries && page_counter_read(&memcg->memory)) {
 		int progress;
 
 		if (signal_pending(current))
@@ -4098,9 +4111,9 @@ static inline u64 mem_cgroup_usage(struct mem_cgroup *memcg, bool swap)
 			val += tree_stat(memcg, MEM_CGROUP_STAT_SWAP);
 	} else {
 		if (!swap)
-			val = atomic_long_read(&memcg->memory.count);
+			val = page_counter_read(&memcg->memory);
 		else
-			val = atomic_long_read(&memcg->memsw.count);
+			val = page_counter_read(&memcg->memsw);
 	}
 	return val << PAGE_SHIFT;
 }
@@ -4139,13 +4152,13 @@ static u64 mem_cgroup_read_u64(struct cgroup_subsys_state *css,
 			return mem_cgroup_usage(memcg, false);
 		if (counter == &memcg->memsw)
 			return mem_cgroup_usage(memcg, true);
-		return (u64)atomic_long_read(&counter->count) * PAGE_SIZE;
+		return (u64)page_counter_read(counter) * PAGE_SIZE;
 	case RES_LIMIT:
 		return (u64)counter->limit * PAGE_SIZE;
 	case RES_MAX_USAGE:
 		return (u64)counter->watermark * PAGE_SIZE;
 	case RES_FAILCNT:
-		return counter->limited;
+		return counter->failcnt;
 	case RES_SOFT_LIMIT:
 		return (u64)memcg->soft_limit * PAGE_SIZE;
 	default:
@@ -4234,10 +4247,12 @@ static int memcg_update_kmem_limit(struct mem_cgroup *memcg,
 {
 	int ret;
 
+	mutex_lock(&memcg_limit_mutex);
 	if (!memcg_kmem_is_active(memcg))
 		ret = memcg_activate_kmem(memcg, limit);
 	else
 		ret = page_counter_limit(&memcg->kmem, limit);
+	mutex_unlock(&memcg_limit_mutex);
 	return ret;
 }
 
@@ -4255,7 +4270,7 @@ static int memcg_propagate_kmem(struct mem_cgroup *memcg)
 	 * after this point, because it has at least one child already.
 	 */
 	if (memcg_kmem_is_active(parent))
-		ret = __memcg_activate_kmem(memcg, ULONG_MAX);
+		ret = __memcg_activate_kmem(memcg, PAGE_COUNTER_MAX);
 	mutex_unlock(&activate_kmem_mutex);
 	return ret;
 }
@@ -4331,10 +4346,10 @@ static ssize_t mem_cgroup_reset(struct kernfs_open_file *of, char *buf,
 
 	switch (MEMFILE_ATTR(of_cft(of)->private)) {
 	case RES_MAX_USAGE:
-		counter->watermark = atomic_long_read(&counter->count);
+		page_counter_reset_watermark(counter);
 		break;
 	case RES_FAILCNT:
-		counter->limited = 0;
+		counter->failcnt = 0;
 		break;
 	default:
 		BUG();
@@ -4934,7 +4949,7 @@ static void kmem_cgroup_css_offline(struct mem_cgroup *memcg)
 
 	memcg_kmem_mark_dead(memcg);
 
-	if (atomic_long_read(&memcg->kmem.count))
+	if (page_counter_read(&memcg->kmem))
 		return;
 
 	if (memcg_kmem_test_and_clear_dead(memcg))
@@ -5603,7 +5618,7 @@ static void mem_cgroup_css_free(struct cgroup_subsys_state *css)
 	 * call_rcu()
 	 *   offline_css()
 	 *     reparent_charges()
-	 *                           page_counter_charge()
+	 *                           page_counter_try_charge()
 	 *                           css_put()
 	 *                             css_free()
 	 *                           pc->mem_cgroup = dead memcg
diff --git a/net/ipv4/tcp_memcontrol.c b/net/ipv4/tcp_memcontrol.c
index 9a448bdb19e9..272327134a1b 100644
--- a/net/ipv4/tcp_memcontrol.c
+++ b/net/ipv4/tcp_memcontrol.c
@@ -68,7 +68,7 @@ static int tcp_update_limit(struct mem_cgroup *memcg, unsigned long nr_pages)
 		cg_proto->sysctl_mem[i] = min_t(long, nr_pages,
 						sysctl_tcp_mem[i]);
 
-	if (nr_pages == ULONG_MAX / PAGE_SIZE)
+	if (nr_pages == PAGE_COUNTER_MAX)
 		clear_bit(MEMCG_SOCK_ACTIVE, &cg_proto->flags);
 	else {
 		/*
@@ -106,6 +106,8 @@ enum {
 	RES_FAILCNT,
 };
 
+static DEFINE_MUTEX(tcp_limit_mutex);
+
 static ssize_t tcp_cgroup_write(struct kernfs_open_file *of,
 				char *buf, size_t nbytes, loff_t off)
 {
@@ -121,7 +123,9 @@ static ssize_t tcp_cgroup_write(struct kernfs_open_file *of,
 		ret = page_counter_memparse(buf, &nr_pages);
 		if (ret)
 			break;
+		mutex_lock(&tcp_limit_mutex);
 		ret = tcp_update_limit(memcg, nr_pages);
+		mutex_unlock(&tcp_limit_mutex);
 		break;
 	default:
 		ret = -EINVAL;
@@ -145,14 +149,15 @@ static u64 tcp_cgroup_read(struct cgroup_subsys_state *css, struct cftype *cft)
 		break;
 	case RES_USAGE:
 		if (!cg_proto)
-			return atomic_long_read(&tcp_memory_allocated);
-		val = atomic_long_read(&cg_proto->memory_allocated.count);
+			val = atomic_long_read(&tcp_memory_allocated);
+		else
+			val = page_counter_read(&cg_proto->memory_allocated);
 		val *= PAGE_SIZE;
 		break;
 	case RES_FAILCNT:
 		if (!cg_proto)
 			return 0;
-		val = cg_proto->memory_allocated.limited;
+		val = cg_proto->memory_allocated.failcnt;
 		break;
 	case RES_MAX_USAGE:
 		if (!cg_proto)
@@ -179,11 +184,10 @@ static ssize_t tcp_cgroup_reset(struct kernfs_open_file *of,
 
 	switch (of_cft(of)->private) {
 	case RES_MAX_USAGE:
-		cg_proto->memory_allocated.watermark =
-			atomic_long_read(&cg_proto->memory_allocated.count);
+		page_counter_reset_watermark(&cg_proto->memory_allocated);
 		break;
 	case RES_FAILCNT:
-		cg_proto->memory_allocated.limited = 0;
+		cg_proto->memory_allocated.failcnt = 0;
 		break;
 	}
 
-- 
2.1.0


--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
