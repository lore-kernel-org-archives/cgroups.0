From: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Subject: Re: [PATCH] mm, memcg: reclaim more aggressively before high
 allocator throttling
Date: Wed, 20 May 2020 21:26:50 +0100
Message-ID: <20200520202650.GB558281@chrisdown.name>
References: <20200520143712.GA749486@chrisdown.name>
 <20200520160756.GE6462@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pyAjRlnWUUT1mywco3FJeiLGJZLmkRz0VQZk3yUWI70=;
        b=PGibgYQ1AtG2afha5buPGXZKWooA7vXxvQmNmO1Idq+C1zDslsESBmlsaVApchVa1L
         glQJr13dgRd6TvmwuLCmKqJbXvyxIQU3mUqKj5WsYxSaRPgBreBPMdk+Dj13fIlUFGXk
         IeF+KqfHBc9dvaXAutyupqPzuLkHNVKW3WeOo=
Content-Disposition: inline
In-Reply-To: <20200520160756.GE6462-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Michal Hocko writes:
>Let me try to understand the actual problem. The high memory reclaim has
>a target which is proportional to the amount of charged memory. For most
>requests that would be SWAP_CLUSTER_MAX though (resp. N times that where
>N is the number of memcgs in excess up the hierarchy). I can see to be
>insufficient if the memcg is already in a large excess but if the
>reclaim can make a forward progress this should just work fine because
>each charging context should reclaim at least the contributed amount.
>
>Do you have any insight on why this doesn't work in your situation?
>Especially with such a large inactive file list I would be really
>surprised if the reclaim was not able to make a forward progress.

Reclaim can fail for any number of reasons, which is why we have retries 
sprinkled all over for it already. It doesn't seem hard to believe that it 
might just fail for transient reasons and drive us deeper into the hole as a 
result.

In this case, a.) the application is producing tons of dirty pages, and b.) we 
have really heavy systemwide I/O contention on the affected machines. This high 
load is one of the reasons that direct and kswapd reclaim cannot keep up, and 
thus nr_pages can become a number of orders of magnitude larger than 
SWAP_CLUSTER_MAX. This is trivially reproducible on these machines, it's not an 
edge case.

Putting a trace_printk("%d\n", __LINE__) at non-successful reclaim in 
shrink_page_list shows that what's happening is always (and I really mean 
always) the "dirty page and you're not kswapd" check, as expected:

	if (PageDirty(page)) {
		/*
		 * Only kswapd can writeback filesystem pages
		 * to avoid risk of stack overflow. But avoid
		 * injecting inefficient single-page IO into
		 * flusher writeback as much as possible: only
		 * write pages when we've encountered many
		 * dirty pages, and when we've already scanned
		 * the rest of the LRU for clean pages and see
		 * the same dirty pages again (PageReclaim).
		 */
		if (page_is_file_lru(page) &&
			(!current_is_kswapd() || !PageReclaim(page) ||
			!test_bit(PGDAT_DIRTY, &pgdat->flags))) {
			/*
			 * Immediately reclaim when written back.
			 * Similar in principal to deactivate_page()
			 * except we already have the page isolated
			 * and know it's dirty
			 */
			inc_node_page_state(page, NR_VMSCAN_IMMEDIATE);
			SetPageReclaim(page);

			goto activate_locked;
		}

>Now to your patch. I do not like it much to be honest.
>MEM_CGROUP_RECLAIM_RETRIES is quite arbitrary and I neither like it in
>memory_high_write because the that is an interruptible context so there
>shouldn't be a good reason to give up after $FOO number of failed
>attempts. try_charge and memory_max_write are slightly different because
>we are invoking OOM killer based on the number of failed attempts.

As Johannes mentioned, the very intent of memory.high is to have it managed 
using a userspace OOM killer, which monitors PSI. As such, I'm not sure this 
distinction means much.
