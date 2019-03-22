From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/6] mm: memcontrol: replace node summing with
 memcg_page_state()
Date: Thu, 21 Mar 2019 18:54:53 -0700
Message-ID: <20190321185453.6458679180e1e41893e7312b@linux-foundation.org>
References: <20190228163020.24100-1-hannes@cmpxchg.org>
        <20190228163020.24100-4-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190228163020.24100-4-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>, Roman Gushchin <guro@fb.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Thu, 28 Feb 2019 11:30:17 -0500 Johannes Weiner <hannes@cmpxchg.org> wrote:

> Instead of adding up the node counters, use memcg_page_state() to get
> the memcg state directly. This is a bit cheaper and more stream-lined.
> 
> ...
>
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -746,10 +746,13 @@ static unsigned long mem_cgroup_nr_lru_pages(struct mem_cgroup *memcg,
>  			unsigned int lru_mask)
>  {
>  	unsigned long nr = 0;
> -	int nid;
> +	enum lru_list lru;
>  
> -	for_each_node_state(nid, N_MEMORY)
> -		nr += mem_cgroup_node_nr_lru_pages(memcg, nid, lru_mask);
> +	for_each_lru(lru) {
> +		if (!(BIT(lru) & lru_mask))
> +			continue;
> +		nr += memcg_page_state(memcg, NR_LRU_BASE + lru);
> +	}

Might be able to use for_each_set_bit(&lru_mnask) here, but it's much
of a muchness.

