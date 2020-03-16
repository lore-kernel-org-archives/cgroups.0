From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 4/6] mm, memcg: Prevent memory.min load/store tearing
Date: Mon, 16 Mar 2020 15:58:25 +0100
Message-ID: <20200316145825.GP11482@dhcp22.suse.cz>
References: <cover.1584034301.git.chris@chrisdown.name>
 <e809b4e6b0c1626dac6945970de06409a180ee65.1584034301.git.chris@chrisdown.name>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <e809b4e6b0c1626dac6945970de06409a180ee65.1584034301.git.chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Thu 12-03-20 17:33:07, Chris Down wrote:
> This can be set concurrently with reads, which may cause the wrong value
> to be propagated.
> 
> Signed-off-by: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
> Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
> Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: kernel-team-b10kYP2dOMg@public.gmane.org

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

> ---
>  mm/memcontrol.c   |  4 ++--
>  mm/page_counter.c | 10 ++++++----
>  2 files changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index c85a304fa4a1..e0ed790a2a8c 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -6261,7 +6261,7 @@ enum mem_cgroup_protection mem_cgroup_protected(struct mem_cgroup *root,
>  	if (!usage)
>  		return MEMCG_PROT_NONE;
>  
> -	emin = memcg->memory.min;
> +	emin = READ_ONCE(memcg->memory.min);
>  	elow = READ_ONCE(memcg->memory.low);
>  
>  	parent = parent_mem_cgroup(memcg);
> @@ -6277,7 +6277,7 @@ enum mem_cgroup_protection mem_cgroup_protected(struct mem_cgroup *root,
>  	if (emin && parent_emin) {
>  		unsigned long min_usage, siblings_min_usage;
>  
> -		min_usage = min(usage, memcg->memory.min);
> +		min_usage = min(usage, READ_ONCE(memcg->memory.min));
>  		siblings_min_usage = atomic_long_read(
>  			&parent->memory.children_min_usage);
>  
> diff --git a/mm/page_counter.c b/mm/page_counter.c
> index 18b7f779f2e2..ae471c7d255f 100644
> --- a/mm/page_counter.c
> +++ b/mm/page_counter.c
> @@ -17,14 +17,16 @@ static void propagate_protected_usage(struct page_counter *c,
>  				      unsigned long usage)
>  {
>  	unsigned long protected, old_protected;
> -	unsigned long low;
> +	unsigned long low, min;
>  	long delta;
>  
>  	if (!c->parent)
>  		return;
>  
> -	if (c->min || atomic_long_read(&c->min_usage)) {
> -		if (usage <= c->min)
> +	min = READ_ONCE(c->min);
> +
> +	if (min || atomic_long_read(&c->min_usage)) {
> +		if (usage <= min)
>  			protected = usage;
>  		else
>  			protected = 0;
> @@ -217,7 +219,7 @@ void page_counter_set_min(struct page_counter *counter, unsigned long nr_pages)
>  {
>  	struct page_counter *c;
>  
> -	counter->min = nr_pages;
> +	WRITE_ONCE(counter->min, nr_pages);
>  
>  	for (c = counter; c; c = c->parent)
>  		propagate_protected_usage(c, atomic_long_read(&c->usage));
> -- 
> 2.25.1
> 

-- 
Michal Hocko
SUSE Labs
