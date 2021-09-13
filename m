From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH memcg] memcg: prohibit unconditional exceeding the limit
 of dying tasks
Date: Mon, 13 Sep 2021 12:55:21 +0200
Message-ID: <YT8uGUMQ7K+/0gyA@dhcp22.suse.cz>
References: <5b06a490-55bc-a6a0-6c85-690254f86fad@virtuozzo.com>
 <YT8RjxShvfEVe4YU@dhcp22.suse.cz>
 <7af26106-388c-6f99-e018-669a8f0cf9b5@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1631530522; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=V1UGM9JLTi4/yHsh8pdylCNFEn0IEPb6s7+Trsqo/UA=;
        b=exLocUfD64t8HpX7hoYhSAtzG0u1WHBku4YnVDStTcJJ9WDBF6FG7HHpdl5z8GvPbJuFbJ
        +w2i7+TST/X8vrdm47iBmGkuT7HZA1nOJQjt1yOLFcnPKY2zb8aaRAfnEO5bS5skR2pRrA
        9p158A0kh7iTmexl7FkWO7DNJW+nkDI=
Content-Disposition: inline
In-Reply-To: <7af26106-388c-6f99-e018-669a8f0cf9b5-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon 13-09-21 13:35:00, Vasily Averin wrote:
> On 9/13/21 11:53 AM, Michal Hocko wrote:
> > On Fri 10-09-21 15:39:28, Vasily Averin wrote:
> >> The kernel currently allows dying tasks to exceed the memcg limits.
> >> The allocation is expected to be the last one and the occupied memory
> >> will be freed soon.
> >> This is not always true because it can be part of the huge vmalloc
> >> allocation. Allowed once, they will repeat over and over again.
> >> Moreover lifetime of the allocated object can differ from
> >> In addition the lifetime of the dying task.
> >> Multiple such allocations running concurrently can not only overuse
> >> the memcg limit, but can lead to a global out of memory and,
> >> in the worst case, cause the host to panic.
> >>
> >> Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
> >> ---
> >>  mm/memcontrol.c | 23 +++++------------------
> >>  1 file changed, 5 insertions(+), 18 deletions(-)
> >>
> >> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> >> index 389b5766e74f..67195fcfbddf 100644
> >> --- a/mm/memcontrol.c
> >> +++ b/mm/memcontrol.c
> >> @@ -1834,6 +1834,9 @@ static enum oom_status mem_cgroup_oom(struct mem_cgroup *memcg, gfp_t mask, int
> >>  		return OOM_ASYNC;
> >>  	}
> >>  
> >> +	if (should_force_charge())
> >> +		return OOM_SKIPPED;
> > 
> > mem_cgroup_out_of_memory already check for the bypass, now you are
> > duplicating that check with a different answer to the caller. This is
> > really messy. One of the two has to go away.
> 
> In this case mem_cgroup_out_of_memory() takes locks and mutexes but doing nothing
> useful and its success causes try_charge_memcg() to repeat the loop unnecessarily.
> 
> I cannot change mem_cgroup_out_of_memory internals, because it is used in other places too.The check inside mem_cgroup_out_of_memory is required because situation can be changed after
> check added into mem_cgroup_oom().
> 
> Though I got your argument, and will think how to improve the patch.
> Anyway we'll need to do something with name of should_force_charge() function
> that will NOT lead to forced charge.

Here is what I would do.

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 702a81dfe72d..58269721d438 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2588,6 +2588,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	struct page_counter *counter;
 	enum oom_status oom_status;
 	unsigned long nr_reclaimed;
+	bool passed_oom = false;
 	bool may_swap = true;
 	bool drained = false;
 	unsigned long pflags;
@@ -2622,15 +2623,6 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	if (gfp_mask & __GFP_ATOMIC)
 		goto force;
 
-	/*
-	 * Unlike in global OOM situations, memcg is not in a physical
-	 * memory shortage.  Allow dying and OOM-killed tasks to
-	 * bypass the last charges so that they can exit quickly and
-	 * free their memory.
-	 */
-	if (unlikely(should_force_charge()))
-		goto force;
-
 	/*
 	 * Prevent unbounded recursion when reclaim operations need to
 	 * allocate memory. This might exceed the limits temporarily,
@@ -2688,8 +2680,9 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	if (gfp_mask & __GFP_RETRY_MAYFAIL)
 		goto nomem;
 
-	if (fatal_signal_pending(current))
-		goto force;
+	/* Avoid endless loop for tasks bypassed by the oom killer */
+	if (passed_oom && should_force_charge())
+		goto nomem;
 
 	/*
 	 * keep retrying as long as the memcg oom killer is able to make
@@ -2698,14 +2691,10 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	 */
 	oom_status = mem_cgroup_oom(mem_over_limit, gfp_mask,
 		       get_order(nr_pages * PAGE_SIZE));
-	switch (oom_status) {
-	case OOM_SUCCESS:
+	if (oom_status == OOM_SUCCESS) {
+		passed_oom = true;
 		nr_retries = MAX_RECLAIM_RETRIES;
 		goto retry;
-	case OOM_FAILED:
-		goto force;
-	default:
-		goto nomem;
 	}
 nomem:
 	if (!(gfp_mask & __GFP_NOFAIL))
-- 
Michal Hocko
SUSE Labs
