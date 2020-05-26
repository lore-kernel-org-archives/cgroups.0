From: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH mm v5 RESEND 4/4] mm: automatically penalize tasks with
 high swap use
Date: Tue, 26 May 2020 13:11:57 -0700
Message-ID: <20200526131157.79c17940@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <20200521002411.3963032-1-kuba@kernel.org>
        <20200521002411.3963032-5-kuba@kernel.org>
        <20200526153309.GD848026@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590523919;
        bh=Lq/Sk1VoyMw9A5M35dRRIZ1osxdCzotsU9LLXg5dNDk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PN71YNbUpE9ADDgbIAYUJrWEu8Zu0Qp8ZjEl2B6L5sMWRZLy/2Y/JHJyzXPc1Ftta
         I1bmCvzqvfSF0NirOuDchDW4LIuK8FQqsvzZImXe8eQ6CgwfRKtHWYAGt5X16UcIOT
         P+AzyGV4PDKJd9jXussMUOrl8yxurNg+wySvOszw=
In-Reply-To: <20200526153309.GD848026-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org

On Tue, 26 May 2020 11:33:09 -0400 Johannes Weiner wrote:
> On Wed, May 20, 2020 at 05:24:11PM -0700, Jakub Kicinski wrote:
> > Add a memory.swap.high knob, which can be used to protect the system
> > from SWAP exhaustion. The mechanism used for penalizing is similar
> > to memory.high penalty (sleep on return to user space), but with
> > a less steep slope.  
> 
> The last part is no longer true after incorporating Michal's feedback.
>
> > +	/*
> > +	 * Make the swap curve more gradual, swap can be considered "cheaper",
> > +	 * and is allocated in larger chunks. We want the delays to be gradual.
> > +	 */  
> 
> This comment is also out-of-date, as the same curve is being applied.

Indeed :S
 
> > +	penalty_jiffies += calculate_high_delay(memcg, nr_pages,
> > +						swap_find_max_overage(memcg));
> > +
> >  	/*
> >  	 * Clamp the max delay per usermode return so as to still keep the
> >  	 * application moving forwards and also permit diagnostics, albeit
> > @@ -2585,12 +2608,25 @@ static int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
> >  	 * reclaim, the cost of mismatch is negligible.
> >  	 */
> >  	do {
> > -		if (page_counter_is_above_high(&memcg->memory)) {
> > -			/* Don't bother a random interrupted task */
> > -			if (in_interrupt()) {
> > +		bool mem_high, swap_high;
> > +
> > +		mem_high = page_counter_is_above_high(&memcg->memory);
> > +		swap_high = page_counter_is_above_high(&memcg->swap);  
> 
> Please open-code these checks instead - we don't really do getters and
> predicates for these, and only have the setters because they are more
> complicated operations.

I added this helper because the calculation doesn't fit into 80 chars. 

In particular reclaim_high will need a temporary variable or IMHO
questionable line split.

static void reclaim_high(struct mem_cgroup *memcg,
			 unsigned int nr_pages,
			 gfp_t gfp_mask)
{
	do {
		if (!page_counter_is_above_high(&memcg->memory))
			continue;
		memcg_memory_event(memcg, MEMCG_HIGH);
		try_to_free_mem_cgroup_pages(memcg, nr_pages, gfp_mask, true);
	} while ((memcg = parent_mem_cgroup(memcg)) &&
		 !mem_cgroup_is_root(memcg));
}

What's your preference? Mine is a helper, but I'm probably not
sensitive enough to the ontology here :)

> > +		if (mem_high || swap_high) {
> > +			/* Use one counter for number of pages allocated
> > +			 * under pressure to save struct task space and
> > +			 * avoid two separate hierarchy walks.
> > +			 /*
> >  			current->memcg_nr_pages_over_high += batch;  
> 
> That comment style is leaking out of the networking code ;-) Please
> use the customary style in this code base, /*\n *...
> 
> As for one counter instead of two: I'm not sure that question arises
> in the reader. There have also been some questions recently what the
> counter actually means. How about the following:
> 
> 			/*
> 			 * The allocating tasks in this cgroup will need to do
> 			 * reclaim or be throttled to prevent further growth
> 			 * of the memory or swap footprints.
> 			 *
> 			 * Target some best-effort fairness between the tasks,
> 			 * and distribute reclaim work and delay penalties
> 			 * based on how much each task is actually allocating.
> 			 */

sounds good!

> Otherwise, the patch looks good to me.

Thanks!
