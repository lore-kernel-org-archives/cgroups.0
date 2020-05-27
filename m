From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH mm v5 RESEND 4/4] mm: automatically penalize tasks with
 high swap use
Date: Wed, 27 May 2020 11:51:45 -0400
Message-ID: <20200527155145.GA42293@cmpxchg.org>
References: <20200521002411.3963032-1-kuba@kernel.org>
 <20200521002411.3963032-5-kuba@kernel.org>
 <20200526153309.GD848026@cmpxchg.org>
 <20200526131157.79c17940@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rdavmOiaMpGhs7wGJxDamxnJAYZBuYUhq0aVlsOCRyA=;
        b=gkwcO4FhZgIhYZsPq0f06YlHsoXzZTZD4TVMFnSEJkWPeA9sHjZUXP6LqDRXrFByd3
         bpkQeH86yIluEzmWNr4jcXijjYwxnwPkG6/eNLkx9SqCD4gTIdChRNBbAOO3TrdVhR4a
         XD5KwE9LvRhJPfvYJIaUtCMjIIaJ15va4wLU8VeM0JpBtqDJKbphSy7WWmuhvJGt0edS
         sWuJlI2k79/88yc9j1dy9VpBs/vk6JSegkfvqmRkjZ4qkZnzIv6fra1YCa4B/t+Vy0A0
         La7L5qUCLlpEhE5HT95drazFP1fL+jFlnNTHluO7f4pD776bkG2cWledK26hTkqE5rdW
         +9dg==
Content-Disposition: inline
In-Reply-To: <20200526131157.79c17940-CbGlpYbfshD2+ikPA6JUzBDio8TIggjEF6tAq0aKN46Iz3nRy94yXOTW4wlIGRCZ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org

On Tue, May 26, 2020 at 01:11:57PM -0700, Jakub Kicinski wrote:
> On Tue, 26 May 2020 11:33:09 -0400 Johannes Weiner wrote:
> > On Wed, May 20, 2020 at 05:24:11PM -0700, Jakub Kicinski wrote:
> > > +	penalty_jiffies += calculate_high_delay(memcg, nr_pages,
> > > +						swap_find_max_overage(memcg));
> > > +
> > >  	/*
> > >  	 * Clamp the max delay per usermode return so as to still keep the
> > >  	 * application moving forwards and also permit diagnostics, albeit
> > > @@ -2585,12 +2608,25 @@ static int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
> > >  	 * reclaim, the cost of mismatch is negligible.
> > >  	 */
> > >  	do {
> > > -		if (page_counter_is_above_high(&memcg->memory)) {
> > > -			/* Don't bother a random interrupted task */
> > > -			if (in_interrupt()) {
> > > +		bool mem_high, swap_high;
> > > +
> > > +		mem_high = page_counter_is_above_high(&memcg->memory);
> > > +		swap_high = page_counter_is_above_high(&memcg->swap);  
> > 
> > Please open-code these checks instead - we don't really do getters and
> > predicates for these, and only have the setters because they are more
> > complicated operations.
> 
> I added this helper because the calculation doesn't fit into 80 chars. 
> 
> In particular reclaim_high will need a temporary variable or IMHO
> questionable line split.
> 
> static void reclaim_high(struct mem_cgroup *memcg,
> 			 unsigned int nr_pages,
> 			 gfp_t gfp_mask)
> {
> 	do {
> 		if (!page_counter_is_above_high(&memcg->memory))
> 			continue;
> 		memcg_memory_event(memcg, MEMCG_HIGH);
> 		try_to_free_mem_cgroup_pages(memcg, nr_pages, gfp_mask, true);
> 	} while ((memcg = parent_mem_cgroup(memcg)) &&
> 		 !mem_cgroup_is_root(memcg));
> }
> 
> What's your preference? Mine is a helper, but I'm probably not
> sensitive enough to the ontology here :)

		if (page_counter_read(&memcg->memory) <
		    READ_ONCE(memcg->memory.high))
			continue;

should work fine. It's the same formatting in mem_cgroup_swap_full():

		if (page_counter_read(&memcg->swap) * 2 >=
		    READ_ONCE(memcg->swap.max))
