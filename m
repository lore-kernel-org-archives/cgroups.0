From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v10 1/8] hugetlb_cgroup: Add hugetlb_cgroup reservation
 counter
Date: Wed, 29 Jan 2020 13:09:03 -0800 (PST)
Message-ID: <alpine.DEB.2.21.2001291303230.175731@chino.kir.corp.google.com>
References: <20200115012651.228058-1-almasrymina@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=36D3DxD07HLlQ4b5Xg920trzYAA/7vy/BzURBWhUFgg=;
        b=Rq4yUVm3lH4Kea7XC63SC0hAfC4KN/ukMQIMSIsqcWlzuSD+uk1QEfCwVPBRNohzZU
         ruWbIUCyQlR9Qjwkd7QUCMwJor25JyzrECBr8tSJJNwci0TMotKq7wRRfjf92IYCAsy1
         Bu1FC/lWm1X4mtf/w96iHAujur/gOIQGY13AqGfLfNdZ10vZAArBSoMOEw7PBQLp+esz
         hBBFoKW6kPDaq7sn282Tu8pbKQijPFb3Gztrz5dApC/WUjMhZ7mbtNHafOzolOJjM4jO
         jVFVtGPkFo0806VVOjCwPr23yNMLeAVsg8yWzo0/1Bp7We7b4cmUgaLxWX6dmU0L3Wb3
         NDxw==
In-Reply-To: <20200115012651.228058-1-almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org

On Tue, 14 Jan 2020, Mina Almasry wrote:

> These counters will track hugetlb reservations rather than hugetlb
> memory faulted in. This patch only adds the counter, following patches
> add the charging and uncharging of the counter.
> 
> This is patch 1 of an 8 patch series.
> 
> Problem:
> Currently tasks attempting to reserve more hugetlb memory than is available get
> a failure at mmap/shmget time. This is thanks to Hugetlbfs Reservations [1].
> However, if a task attempts to reserve hugetlb memory only more than its
> hugetlb_cgroup limit allows, the kernel will allow the mmap/shmget call,
> but will SIGBUS the task when it attempts to fault the memory in.
> 
> We have users hitting their hugetlb_cgroup limits and thus we've been
> looking at this failure mode. We'd like to improve this behavior such that users
> violating the hugetlb_cgroup limits get an error on mmap/shmget time, rather
> than getting SIGBUS'd when they try to fault the excess memory in. This
> gives the user an opportunity to fallback more gracefully to
> non-hugetlbfs memory for example.
> 
> The underlying problem is that today's hugetlb_cgroup accounting happens
> at hugetlb memory *fault* time, rather than at *reservation* time.
> Thus, enforcing the hugetlb_cgroup limit only happens at fault time, and
> the offending task gets SIGBUS'd.
> 
> Proposed Solution:
> A new page counter named
> 'hugetlb.xMB.reservation_[limit|usage|max_usage]_in_bytes'. This counter has
> slightly different semantics than
> 'hugetlb.xMB.[limit|usage|max_usage]_in_bytes':
> 

Changelog looks like it needs to be updated with the new resv naming.

> - While usage_in_bytes tracks all *faulted* hugetlb memory,
> reservation_usage_in_bytes tracks all *reserved* hugetlb memory and
> hugetlb memory faulted in without a prior reservation.
> 
> - If a task attempts to reserve more memory than limit_in_bytes allows,
> the kernel will allow it to do so. But if a task attempts to reserve
> more memory than reservation_limit_in_bytes, the kernel will fail this
> reservation.
> 
> This proposal is implemented in this patch series, with tests to verify
> functionality and show the usage.
> 
> Alternatives considered:
> 1. A new cgroup, instead of only a new page_counter attached to
>    the existing hugetlb_cgroup. Adding a new cgroup seemed like a lot of code
>    duplication with hugetlb_cgroup. Keeping hugetlb related page counters under
>    hugetlb_cgroup seemed cleaner as well.
> 
> 2. Instead of adding a new counter, we considered adding a sysctl that modifies
>    the behavior of hugetlb.xMB.[limit|usage]_in_bytes, to do accounting at
>    reservation time rather than fault time. Adding a new page_counter seems
>    better as userspace could, if it wants, choose to enforce different cgroups
>    differently: one via limit_in_bytes, and another via
>    reservation_limit_in_bytes. This could be very useful if you're
>    transitioning how hugetlb memory is partitioned on your system one
>    cgroup at a time, for example. Also, someone may find usage for both
>    limit_in_bytes and reservation_limit_in_bytes concurrently, and this
>    approach gives them the option to do so.
> 
> Testing:
> - Added tests passing.
> - Used libhugetlbfs for regression testing.
> 
> [1]: https://www.kernel.org/doc/html/latest/vm/hugetlbfs_reserv.html
> 
> Signed-off-by: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> 
> ---
> Changes in v10:
> - Renamed reservation_* to resv.*
> 
> ---
>  include/linux/hugetlb.h |   4 +-
>  mm/hugetlb_cgroup.c     | 115 +++++++++++++++++++++++++++++++++++-----
>  2 files changed, 104 insertions(+), 15 deletions(-)
> 
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index 1e897e4168ac1..dea6143aa0685 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -432,8 +432,8 @@ struct hstate {
>  	unsigned int surplus_huge_pages_node[MAX_NUMNODES];
>  #ifdef CONFIG_CGROUP_HUGETLB
>  	/* cgroup control files */
> -	struct cftype cgroup_files_dfl[5];
> -	struct cftype cgroup_files_legacy[5];
> +	struct cftype cgroup_files_dfl[7];
> +	struct cftype cgroup_files_legacy[9];
>  #endif
>  	char name[HSTATE_NAME_LEN];
>  };
> diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
> index e434b05416c68..209f9b9604d34 100644
> --- a/mm/hugetlb_cgroup.c
> +++ b/mm/hugetlb_cgroup.c
> @@ -36,6 +36,11 @@ struct hugetlb_cgroup {
>  	 */
>  	struct page_counter hugepage[HUGE_MAX_HSTATE];
> 
> +	/*
> +	 * the counter to account for hugepage reservations from hugetlb.
> +	 */
> +	struct page_counter reserved_hugepage[HUGE_MAX_HSTATE];
> +
>  	atomic_long_t events[HUGE_MAX_HSTATE][HUGETLB_NR_MEMORY_EVENTS];
>  	atomic_long_t events_local[HUGE_MAX_HSTATE][HUGETLB_NR_MEMORY_EVENTS];
> 
> @@ -55,6 +60,14 @@ struct hugetlb_cgroup {
> 
>  static struct hugetlb_cgroup *root_h_cgroup __read_mostly;
> 
> +static inline struct page_counter *
> +hugetlb_cgroup_get_counter(struct hugetlb_cgroup *h_cg, int idx, bool reserved)
> +{
> +	if (reserved)
> +		return &h_cg->reserved_hugepage[idx];
> +	return &h_cg->hugepage[idx];
> +}
> +
>  static inline
>  struct hugetlb_cgroup *hugetlb_cgroup_from_css(struct cgroup_subsys_state *s)
>  {

Small nit: hugetlb_cgroup_get_counter(), to me, implies incrementing a 
reference count, perhaps a better name would be in order.  No strong 
preference.

> @@ -295,28 +308,42 @@ void hugetlb_cgroup_uncharge_cgroup(int idx, unsigned long nr_pages,
> 
>  enum {
>  	RES_USAGE,
> +	RES_RESERVATION_USAGE,
>  	RES_LIMIT,
> +	RES_RESERVATION_LIMIT,
>  	RES_MAX_USAGE,
> +	RES_RESERVATION_MAX_USAGE,
>  	RES_FAILCNT,
> +	RES_RESERVATION_FAILCNT,
>  };
> 
>  static u64 hugetlb_cgroup_read_u64(struct cgroup_subsys_state *css,
>  				   struct cftype *cft)
>  {
>  	struct page_counter *counter;
> +	struct page_counter *reserved_counter;
>  	struct hugetlb_cgroup *h_cg = hugetlb_cgroup_from_css(css);
> 
>  	counter = &h_cg->hugepage[MEMFILE_IDX(cft->private)];
> +	reserved_counter = &h_cg->reserved_hugepage[MEMFILE_IDX(cft->private)];
> 
>  	switch (MEMFILE_ATTR(cft->private)) {
>  	case RES_USAGE:
>  		return (u64)page_counter_read(counter) * PAGE_SIZE;
> +	case RES_RESERVATION_USAGE:
> +		return (u64)page_counter_read(reserved_counter) * PAGE_SIZE;
>  	case RES_LIMIT:
>  		return (u64)counter->max * PAGE_SIZE;
> +	case RES_RESERVATION_LIMIT:
> +		return (u64)reserved_counter->max * PAGE_SIZE;
>  	case RES_MAX_USAGE:
>  		return (u64)counter->watermark * PAGE_SIZE;
> +	case RES_RESERVATION_MAX_USAGE:
> +		return (u64)reserved_counter->watermark * PAGE_SIZE;
>  	case RES_FAILCNT:
>  		return counter->failcnt;
> +	case RES_RESERVATION_FAILCNT:
> +		return reserved_counter->failcnt;
>  	default:
>  		BUG();
>  	}
> @@ -338,10 +365,16 @@ static int hugetlb_cgroup_read_u64_max(struct seq_file *seq, void *v)
>  			   1 << huge_page_order(&hstates[idx]));
> 
>  	switch (MEMFILE_ATTR(cft->private)) {
> +	case RES_RESERVATION_USAGE:
> +		counter = &h_cg->reserved_hugepage[idx];
> +		/* Fall through. */
>  	case RES_USAGE:
>  		val = (u64)page_counter_read(counter);
>  		seq_printf(seq, "%llu\n", val * PAGE_SIZE);
>  		break;
> +	case RES_RESERVATION_LIMIT:
> +		counter = &h_cg->reserved_hugepage[idx];
> +		/* Fall through. */
>  	case RES_LIMIT:
>  		val = (u64)counter->max;
>  		if (val == limit)
> @@ -365,6 +398,7 @@ static ssize_t hugetlb_cgroup_write(struct kernfs_open_file *of,
>  	int ret, idx;
>  	unsigned long nr_pages;
>  	struct hugetlb_cgroup *h_cg = hugetlb_cgroup_from_css(of_css(of));
> +	bool reserved = false;
> 
>  	if (hugetlb_cgroup_is_root(h_cg)) /* Can't set limit on root */
>  		return -EINVAL;
> @@ -378,9 +412,14 @@ static ssize_t hugetlb_cgroup_write(struct kernfs_open_file *of,
>  	nr_pages = round_down(nr_pages, 1 << huge_page_order(&hstates[idx]));
> 
>  	switch (MEMFILE_ATTR(of_cft(of)->private)) {
> +	case RES_RESERVATION_LIMIT:
> +		reserved = true;
> +		/* Fall through. */
>  	case RES_LIMIT:
>  		mutex_lock(&hugetlb_limit_mutex);
> -		ret = page_counter_set_max(&h_cg->hugepage[idx], nr_pages);
> +		ret = page_counter_set_max(hugetlb_cgroup_get_counter(h_cg, idx,
> +								      reserved),
> +					   nr_pages);
>  		mutex_unlock(&hugetlb_limit_mutex);
>  		break;
>  	default:
> @@ -406,18 +445,26 @@ static ssize_t hugetlb_cgroup_reset(struct kernfs_open_file *of,
>  				    char *buf, size_t nbytes, loff_t off)
>  {
>  	int ret = 0;
> -	struct page_counter *counter;
> +	struct page_counter *counter, *reserved_counter;
>  	struct hugetlb_cgroup *h_cg = hugetlb_cgroup_from_css(of_css(of));
> 
>  	counter = &h_cg->hugepage[MEMFILE_IDX(of_cft(of)->private)];
> +	reserved_counter =
> +		&h_cg->reserved_hugepage[MEMFILE_IDX(of_cft(of)->private)];
> 
>  	switch (MEMFILE_ATTR(of_cft(of)->private)) {
>  	case RES_MAX_USAGE:
>  		page_counter_reset_watermark(counter);
>  		break;
> +	case RES_RESERVATION_MAX_USAGE:
> +		page_counter_reset_watermark(reserved_counter);
> +		break;
>  	case RES_FAILCNT:
>  		counter->failcnt = 0;
>  		break;
> +	case RES_RESERVATION_FAILCNT:
> +		reserved_counter->failcnt = 0;
> +		break;
>  	default:
>  		ret = -EINVAL;
>  		break;
> @@ -472,7 +519,7 @@ static void __init __hugetlb_cgroup_file_dfl_init(int idx)
>  	struct hstate *h = &hstates[idx];
> 
>  	/* format the size */
> -	mem_fmt(buf, 32, huge_page_size(h));
> +	mem_fmt(buf, sizeof(buf), huge_page_size(h));
> 
>  	/* Add the limit file */
>  	cft = &h->cgroup_files_dfl[0];
> @@ -482,15 +529,30 @@ static void __init __hugetlb_cgroup_file_dfl_init(int idx)
>  	cft->write = hugetlb_cgroup_write_dfl;
>  	cft->flags = CFTYPE_NOT_ON_ROOT;
> 
> -	/* Add the current usage file */
> +	/* Add the reservation limit file */
>  	cft = &h->cgroup_files_dfl[1];
> +	snprintf(cft->name, MAX_CFTYPE_NAME, "%s.resv.max", buf);
> +	cft->private = MEMFILE_PRIVATE(idx, RES_RESERVATION_LIMIT);
> +	cft->seq_show = hugetlb_cgroup_read_u64_max;
> +	cft->write = hugetlb_cgroup_write_dfl;
> +	cft->flags = CFTYPE_NOT_ON_ROOT;
> +
> +	/* Add the current usage file */
> +	cft = &h->cgroup_files_dfl[2];
>  	snprintf(cft->name, MAX_CFTYPE_NAME, "%s.current", buf);
>  	cft->private = MEMFILE_PRIVATE(idx, RES_USAGE);
>  	cft->seq_show = hugetlb_cgroup_read_u64_max;
>  	cft->flags = CFTYPE_NOT_ON_ROOT;
> 
> +	/* Add the current reservation usage file */
> +	cft = &h->cgroup_files_dfl[3];
> +	snprintf(cft->name, MAX_CFTYPE_NAME, "%s.resv.current", buf);
> +	cft->private = MEMFILE_PRIVATE(idx, RES_RESERVATION_USAGE);
> +	cft->seq_show = hugetlb_cgroup_read_u64_max;
> +	cft->flags = CFTYPE_NOT_ON_ROOT;
> +
>  	/* Add the events file */
> -	cft = &h->cgroup_files_dfl[2];
> +	cft = &h->cgroup_files_dfl[4];
>  	snprintf(cft->name, MAX_CFTYPE_NAME, "%s.events", buf);
>  	cft->private = MEMFILE_PRIVATE(idx, 0);
>  	cft->seq_show = hugetlb_events_show;

Any cleanup to __hugetlb_cgroup_file_dfl_init() and 
__hugetlb_cgroup_file_legacy_init() that is possible would be great in a 
follow-up patch :)

Other than that, this looks very straight forward.

Acked-by: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
