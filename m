From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH v3] mm: vmpressure: don't count proactive reclaim in
 vmpressure
Date: Fri, 1 Jul 2022 16:09:47 -0700
Message-ID: <20220701160947.e4902e5b0484ed084db5d41f@linux-foundation.org>
References: <20220630083044.997474-1-yosryahmed@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656716988;
        bh=4nB0U7nhrm6VCb6tiMM+/XZLx4kueqSVr4+hr+wiTWE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rmqt7SRzy8UX3MGyyYcpwqkGOOwD33znN26rtMMJE+WjxrfG547paZYOkVmgLGK9q
         TyB8p5PrTf2zhjjJ5CluZBO1gEbEy5bjSrvfrE1fuoPBqUQYBA+TsHzmrG10wW8xM9
         Q9oNEUhltPuJzvreon2BKDVDd1L6udVESo8+Wnf4=
In-Reply-To: <20220630083044.997474-1-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, David Hildenbrand <david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>, Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Xu <peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Thu, 30 Jun 2022 08:30:44 +0000 Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:

> vmpressure is used in cgroup v1 to notify userspace of reclaim
> efficiency events, and is also used in both cgroup v1 and v2 as a signal
> for memory pressure for networking, see
> mem_cgroup_under_socket_pressure().
> 
> Proactive reclaim intends to probe memcgs for cold memory, without
> affecting their performance. Hence, reclaim caused by writing to
> memory.reclaim should not trigger vmpressure.
> 
> ...
>
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2319,6 +2319,7 @@ static unsigned long reclaim_high(struct mem_cgroup *memcg,
>  				  gfp_t gfp_mask)
>  {
>  	unsigned long nr_reclaimed = 0;
> +	unsigned int reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
>  
>  	do {
>  		unsigned long pflags;
> @@ -2331,7 +2332,8 @@ static unsigned long reclaim_high(struct mem_cgroup *memcg,
>  
>  		psi_memstall_enter(&pflags);
>  		nr_reclaimed += try_to_free_mem_cgroup_pages(memcg, nr_pages,
> -							     gfp_mask, true);
> +							     gfp_mask,
> +							     reclaim_options);

It's a bit irksome to create all these unneeded local variables.  Why
not simply add the constant arg to the try_to_free_mem_cgroup_pages()
call?

>  		psi_memstall_leave(&pflags);
>  	} while ((memcg = parent_mem_cgroup(memcg)) &&
>  		 !mem_cgroup_is_root(memcg));
> @@ -2576,7 +2578,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	struct page_counter *counter;
>  	unsigned long nr_reclaimed;
>  	bool passed_oom = false;
> -	bool may_swap = true;
> +	unsigned int reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
>  	bool drained = false;
>  	unsigned long pflags;
>  
> @@ -2593,7 +2595,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  		mem_over_limit = mem_cgroup_from_counter(counter, memory);
>  	} else {
>  		mem_over_limit = mem_cgroup_from_counter(counter, memsw);
> -		may_swap = false;
> +		reclaim_options &= ~MEMCG_RECLAIM_MAY_SWAP;

	reclaim_options = 0

would be clearer?


