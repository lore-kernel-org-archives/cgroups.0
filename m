From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH mm v5 RESEND 4/4] mm: automatically penalize tasks with
 high swap use
Date: Tue, 26 May 2020 11:33:09 -0400
Message-ID: <20200526153309.GD848026@cmpxchg.org>
References: <20200521002411.3963032-1-kuba@kernel.org>
 <20200521002411.3963032-5-kuba@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KVe4F8UgxCDjeBkRy/htdbjafevBT7vloPhWAUIoZSQ=;
        b=wYcdu/SC1qTHS6RI1MxhlU/qTMWLEdH3Qeo6CTfkpmbrKNV4VYpO2vqtFCSR0e/hbW
         4fAd2qNJmJ8z9BELunQZ/u+nlpHbzm1ScmtxhZGYcKZOYqedbagfjlK982OyBsWibKkk
         00DhRgWVbJr9zNelJyVBM6xFIshMDCzeGF7zFzabevHf22FZ9gQte/yk7xkd0l2nHw08
         tLY3iSjfuKJJEsC6ZW8YzsnySD5Id6eXHiPT0NBJZMLpoUzo1n4bOuU/mvYFzWurSmi8
         lZM2hYgISl+B5JSEQr5KDYrBxRJb8LTiW6YCcFuOJ+pJIzmiMXKkwETIhV+pL2659O+v
         gXlQ==
Content-Disposition: inline
In-Reply-To: <20200521002411.3963032-5-kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org

Hi Jakub,

the patch looks mostly good to me, but there are a couple of things
that should be cleaned up before merging:

On Wed, May 20, 2020 at 05:24:11PM -0700, Jakub Kicinski wrote:
> Add a memory.swap.high knob, which can be used to protect the system
> from SWAP exhaustion. The mechanism used for penalizing is similar
> to memory.high penalty (sleep on return to user space), but with
> a less steep slope.

The last part is no longer true after incorporating Michal's feedback.

> That is not to say that the knob itself is equivalent to memory.high.
> The objective is more to protect the system from potentially buggy
> tasks consuming a lot of swap and impacting other tasks, or even
> bringing the whole system to stand still with complete SWAP
> exhaustion. Hopefully without the need to find per-task hard
> limits.
> 
> Slowing misbehaving tasks down gradually allows user space oom
> killers or other protection mechanisms to react. oomd and earlyoom
> already do killing based on swap exhaustion, and memory.swap.high
> protection will help implement such userspace oom policies more
> reliably.
> 
> We can use one counter for number of pages allocated under
> pressure to save struct task space and avoid two separate
> hierarchy walks on the hot path. The exact overage is
> calculated on return to user space, anyway.
> 
> Take the new high limit into account when determining if swap
> is "full". Borrowing the explanation from Johannes:
> 
>   The idea behind "swap full" is that as long as the workload has plenty
>   of swap space available and it's not changing its memory contents, it
>   makes sense to generously hold on to copies of data in the swap
>   device, even after the swapin. A later reclaim cycle can drop the page
>   without any IO. Trading disk space for IO.
> 
>   But the only two ways to reclaim a swap slot is when they're faulted
>   in and the references go away, or by scanning the virtual address space
>   like swapoff does - which is very expensive (one could argue it's too
>   expensive even for swapoff, it's often more practical to just reboot).
> 
>   So at some point in the fill level, we have to start freeing up swap
>   slots on fault/swapin. Otherwise we could eventually run out of swap
>   slots while they're filled with copies of data that is also in RAM.
> 
>   We don't want to OOM a workload because its available swap space is
>   filled with redundant cache.
> 
> Signed-off-by: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> --
> v4:
>  - add a comment on using a single counter for both mem and swap pages
> v3:
>  - count events for all groups over limit
>  - add doc for high events
>  - remove the magic scaling factor
>  - improve commit message
> v2:
>  - add docs
>  - improve commit message
> ---
>  Documentation/admin-guide/cgroup-v2.rst | 20 ++++++
>  include/linux/memcontrol.h              |  1 +
>  mm/memcontrol.c                         | 84 +++++++++++++++++++++++--
>  3 files changed, 99 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> index fed4e1d2a343..1536deb2f28e 100644
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -1373,6 +1373,22 @@ PAGE_SIZE multiple when read back.
>  	The total amount of swap currently being used by the cgroup
>  	and its descendants.
>  
> +  memory.swap.high
> +	A read-write single value file which exists on non-root
> +	cgroups.  The default is "max".
> +
> +	Swap usage throttle limit.  If a cgroup's swap usage exceeds
> +	this limit, all its further allocations will be throttled to
> +	allow userspace to implement custom out-of-memory procedures.
> +
> +	This limit marks a point of no return for the cgroup. It is NOT
> +	designed to manage the amount of swapping a workload does
> +	during regular operation. Compare to memory.swap.max, which
> +	prohibits swapping past a set amount, but lets the cgroup
> +	continue unimpeded as long as other memory can be reclaimed.
> +
> +	Healthy workloads are not expected to reach this limit.
> +
>    memory.swap.max
>  	A read-write single value file which exists on non-root
>  	cgroups.  The default is "max".
> @@ -1386,6 +1402,10 @@ PAGE_SIZE multiple when read back.
>  	otherwise, a value change in this file generates a file
>  	modified event.
>  
> +	  high
> +		The number of times the cgroup's swap usage was over
> +		the high threshold.
> +
>  	  max
>  		The number of times the cgroup's swap usage was about
>  		to go over the max boundary and swap allocation
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index d726867d8af9..865afda5b6f0 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -42,6 +42,7 @@ enum memcg_memory_event {
>  	MEMCG_MAX,
>  	MEMCG_OOM,
>  	MEMCG_OOM_KILL,
> +	MEMCG_SWAP_HIGH,
>  	MEMCG_SWAP_MAX,
>  	MEMCG_SWAP_FAIL,
>  	MEMCG_NR_MEMORY_EVENTS,
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index d4b7bc80aa38..a92ddaecd28e 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2334,6 +2334,22 @@ static u64 mem_find_max_overage(struct mem_cgroup *memcg)
>  	return max_overage;
>  }
>  
> +static u64 swap_find_max_overage(struct mem_cgroup *memcg)
> +{
> +	u64 overage, max_overage = 0;
> +
> +	do {
> +		overage = calculate_overage(page_counter_read(&memcg->swap),
> +					    READ_ONCE(memcg->swap.high));
> +		if (overage)
> +			memcg_memory_event(memcg, MEMCG_SWAP_HIGH);
> +		max_overage = max(overage, max_overage);
> +	} while ((memcg = parent_mem_cgroup(memcg)) &&
> +		 !mem_cgroup_is_root(memcg));
> +
> +	return max_overage;
> +}
> +
>  /*
>   * Get the number of jiffies that we should penalise a mischievous cgroup which
>   * is exceeding its memory.high by checking both it and its ancestors.
> @@ -2395,6 +2411,13 @@ void mem_cgroup_handle_over_high(void)
>  	penalty_jiffies = calculate_high_delay(memcg, nr_pages,
>  					       mem_find_max_overage(memcg));
>  
> +	/*
> +	 * Make the swap curve more gradual, swap can be considered "cheaper",
> +	 * and is allocated in larger chunks. We want the delays to be gradual.
> +	 */

This comment is also out-of-date, as the same curve is being applied.

> +	penalty_jiffies += calculate_high_delay(memcg, nr_pages,
> +						swap_find_max_overage(memcg));
> +
>  	/*
>  	 * Clamp the max delay per usermode return so as to still keep the
>  	 * application moving forwards and also permit diagnostics, albeit
> @@ -2585,12 +2608,25 @@ static int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	 * reclaim, the cost of mismatch is negligible.
>  	 */
>  	do {
> -		if (page_counter_is_above_high(&memcg->memory)) {
> -			/* Don't bother a random interrupted task */
> -			if (in_interrupt()) {
> +		bool mem_high, swap_high;
> +
> +		mem_high = page_counter_is_above_high(&memcg->memory);
> +		swap_high = page_counter_is_above_high(&memcg->swap);

Please open-code these checks instead - we don't really do getters and
predicates for these, and only have the setters because they are more
complicated operations.

> +		if (mem_high || swap_high) {
> +			/* Use one counter for number of pages allocated
> +			 * under pressure to save struct task space and
> +			 * avoid two separate hierarchy walks.
> +			 /*
>  			current->memcg_nr_pages_over_high += batch;

That comment style is leaking out of the networking code ;-) Please
use the customary style in this code base, /*\n *...

As for one counter instead of two: I'm not sure that question arises
in the reader. There have also been some questions recently what the
counter actually means. How about the following:

			/*
			 * The allocating tasks in this cgroup will need to do
			 * reclaim or be throttled to prevent further growth
			 * of the memory or swap footprints.
			 *
			 * Target some best-effort fairness between the tasks,
			 * and distribute reclaim work and delay penalties
			 * based on how much each task is actually allocating.
			 */

Otherwise, the patch looks good to me.

