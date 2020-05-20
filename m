From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH] mm, memcg: unify reclaim retry limits with page
 allocator
Date: Wed, 20 May 2020 16:40:37 -0700
Message-ID: <20200520164037.e3598bc902e39415f4c263e7@linux-foundation.org>
References: <20200520163142.GA808793@chrisdown.name>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590018038;
        bh=yJQr4N2gMImcjIgh4e+Nb6eX8prUZSgWAz7fgEAtjn8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uUzCdsJ4dPUOGOhbWC7K6acCbXeqRHR+0qzMhgjEOxgVke9kEnBa7JF5kx3vHFzK1
         2JDsO09C77U5VjEP7YTXkaq7ElxS7VohANm9CztE2bI+QoaSzLs8/SxR/44jb4IDIo
         fHiF99y61RmpcSRtu67jCykydgbedxtWxWl3l/8Y=
In-Reply-To: <20200520163142.GA808793-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Wed, 20 May 2020 17:31:42 +0100 Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org> wrote:

> Reclaim retries have been set to 5 since the beginning of time in
> 66e1707bc346 ("Memory controller: add per cgroup LRU and reclaim").
> However, we now have a generally agreed-upon standard for page reclaim:
> MAX_RECLAIM_RETRIES (currently 16), added many years later in
> 0a0337e0d1d1 ("mm, oom: rework oom detection").
> 
> In the absence of a compelling reason to declare an OOM earlier in memcg
> context than page allocator context, it seems reasonable to supplant
> MEM_CGROUP_RECLAIM_RETRIES with MAX_RECLAIM_RETRIES, making the page
> allocator and memcg internals more similar in semantics when reclaim
> fails to produce results, avoiding premature OOMs or throttling.
> 
> ...
>
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -73,9 +73,6 @@ EXPORT_SYMBOL(memory_cgrp_subsys);
>  
>  struct mem_cgroup *root_mem_cgroup __read_mostly;
>  
> -/* The number of times we should retry reclaim failures before giving up. */

hm, what tree is this against?

> -#define MEM_CGROUP_RECLAIM_RETRIES	5
> -
>  /* Socket memory accounting disabled? */
>  static bool cgroup_memory_nosocket;
>  
> @@ -2386,7 +2383,7 @@ void mem_cgroup_handle_over_high(void)
>  	unsigned long pflags;
>  	unsigned long nr_reclaimed;
>  	unsigned int nr_pages = current->memcg_nr_pages_over_high;
> -	int nr_retries = MEM_CGROUP_RECLAIM_RETRIES;
> +	int nr_retries = MAX_RECLAIM_RETRIES;

I can't seem to find a tree in which mem_cgroup_handle_over_high() has
a local `nr_retries'.


